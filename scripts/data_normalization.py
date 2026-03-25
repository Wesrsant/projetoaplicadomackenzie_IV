import pandas as pd
import glob
import os
import sys

def processar_base_telecom(pasta_database="database"):
    """
    Consolida e normaliza as bases de dados da ANATEL (Municípios e Setores).
    Gera arquivos unificados com compactação GZIP e exibe relatório completo de normalização.
    """
    padrao_municipios = os.path.join(pasta_database, "Cobertura_*_Municipios.csv")
    padrao_setores = os.path.join(pasta_database, "Cobertura_*_Setores.csv")
    
    def carregar_e_limpar(lista_arquivos, nome_grupo):
        dfs = []
        total = len(lista_arquivos)
        
        if total == 0:
            return pd.DataFrame(), 0, 0, 0, 0, 0
            
        linhas_originais = 0
        celulas_num_padronizadas = 0
        registros_tempo_normalizados = 0
        arquivos_encoding_corrigido = 0

        for i, arquivo in enumerate(lista_arquivos, 1):
            porcentagem = (i / total) * 100
            nome_arquivo = os.path.basename(arquivo)
            
            sys.stdout.write(f"\rProcessando {nome_grupo} [{i}/{total}] - {porcentagem:.1f}% : {nome_arquivo}")
            sys.stdout.flush()
            
            # Tratamento de Encoding
            try:
                df = pd.read_csv(arquivo, sep=';', encoding='utf-8-sig', low_memory=False)
                arquivos_encoding_corrigido += 1
            except UnicodeDecodeError:
                df = pd.read_csv(arquivo, sep=';', encoding='latin1', low_memory=False)
            
            linhas_originais += len(df)
            df.columns = df.columns.str.strip()
            
            # Normalização Temporal
            if 'Período' in df.columns:
                registros_tempo_normalizados += len(df['Período'].dropna())
                df['Período'] = pd.to_datetime(df['Período'], format='%m-%Y', errors='coerce')
            
            # Normalização Numérica
            cols_numericas = df.select_dtypes(include=['object', 'str']).columns
            for col in cols_numericas:
                if '%' in col or 'Cobertura' in col or 'Área' in col:
                    # Conta quantas células tinham vírgula antes de substituir
                    celulas_num_padronizadas += df[col].astype(str).str.contains(',').sum()
                    df[col] = df[col].astype(str).str.replace(',', '.')
                    df[col] = pd.to_numeric(df[col], errors='coerce')
            
            dfs.append(df)
        
        print() 
        if not dfs:
            return pd.DataFrame(), 0, 0, 0, 0, 0
            
        df_consolidado = pd.concat(dfs, ignore_index=True)
        
        linhas_antes_drop = len(df_consolidado)
        df_consolidado = df_consolidado.drop_duplicates()
        linhas_removidas = linhas_antes_drop - len(df_consolidado)
        
        return df_consolidado, linhas_originais, linhas_removidas, arquivos_encoding_corrigido, registros_tempo_normalizados, celulas_num_padronizadas

    print("Iniciando processamento das bases de dados...")
    
    df_muni, orig_muni, rem_muni, enc_muni, tempo_muni, num_muni = carregar_e_limpar(glob.glob(padrao_municipios), "Municípios")
    df_set, orig_set, rem_set, enc_set, tempo_set, num_set = carregar_e_limpar(glob.glob(padrao_setores), "Setores")

    print("Aplicando tratamento de valores nulos...")
    nulos_muni = df_muni.isna().sum().sum()
    df_muni = df_muni.fillna(0)
    
    nulos_set = df_set.isna().sum().sum()
    df_set = df_set.fillna(0)

    if not os.path.exists("output"):
        os.makedirs("output")
        
    print("Compactando e exportando base unificada de Municípios...")
    df_muni.to_csv("output/base_unificada_municipios.csv.gz", index=False, sep=';', encoding='utf-8-sig', compression='gzip')
    
    print("Compactando e exportando base unificada de Setores...")
    df_set.to_csv("output/base_unificada_setores.csv.gz", index=False, sep=';', encoding='utf-8-sig', compression='gzip')
    
    print("\n" + "="*70)
    print("RELATÓRIO TÉCNICO DE EFETIVIDADE DA LIMPEZA E NORMALIZAÇÃO")
    print("="*70)
    print(f"[MUNICÍPIOS]")
    print(f"  • Linhas processadas (Bruto): {orig_muni}")
    print(f"  • Arquivos com Encoding/Caracteres corrigidos (UTF-8): {enc_muni}")
    print(f"  • Registros temporais padronizados para Datetime: {tempo_muni}")
    print(f"  • Células numéricas formatadas (vírgula para ponto e float): {num_muni}")
    print(f"  • Linhas duplicadas removidas: {rem_muni}")
    print(f"  • Células nulas normalizadas (Imputação de 0): {nulos_muni}")
    print(f"  • Volume final consolidado: {len(df_muni)} linhas\n")
    
    print(f"[SETORES]")
    print(f"  • Linhas processadas (Bruto): {orig_set}")
    print(f"  • Arquivos com Encoding/Caracteres corrigidos (UTF-8): {enc_set}")
    print(f"  • Registros temporais padronizados para Datetime: {tempo_set}")
    print(f"  • Células numéricas formatadas (vírgula para ponto e float): {num_set}")
    print(f"  • Linhas duplicadas removidas: {rem_set}")
    print(f"  • Células nulas normalizadas (Imputação de 0): {nulos_set}")
    print(f"  • Volume final consolidado: {len(df_set)} linhas")
    print("="*70)
    print("Processamento e compactação concluídos com sucesso!\n")

if __name__ == "__main__":
    processar_base_telecom()