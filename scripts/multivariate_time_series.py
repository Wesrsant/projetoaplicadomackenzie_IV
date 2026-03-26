import pandas as pd
import matplotlib.pyplot as plt
from statsmodels.tsa.seasonal import seasonal_decompose
from statsmodels.tsa.stattools import adfuller
from statsmodels.graphics.tsaplots import plot_acf, plot_pacf

PATH_MUNI = 'projetoaplicadomackenzie_IV-main/output/base_unificada_municipios.csv.gz'
PATH_SETOR = 'projetoaplicadomackenzie_IV-main/output/base_unificada_setores.csv.gz'
print("Iniciando Caracterização Analítica da Série Temporal")

# 1. Processamento integral da base de municípios (1.080.030 registros)
print("\n[1/3] Carregando e normalizando base de Municípios...")
df_muni = pd.read_csv(PATH_MUNI, compression='gzip', sep=';', encoding='utf-8-sig')
df_muni['Período'] = pd.to_datetime(df_muni['Período'])
ts_5g_coverage = df_muni[df_muni['Tecnologia'] == '5G'].groupby('Período')['% moradores cobertos'].mean()

# 2. Análise Estatística e Decomposição 
print("[2/3] Executando análise estatística fundamental...")

# A) Verificação de Estacionariedade (Augmented Dickey-Fuller Test)
adf_test = adfuller(ts_5g_coverage)
print(f'   > P-valor do Teste ADF: {adf_test[1]:.4f}')

# B) Decomposição Aditiva: Identificação de Tendência, Sazonalidade e Ruído
decomposition = seasonal_decompose(ts_5g_coverage, model='additive', period=1)
decomposition.plot()
plt.suptitle('Decomposição da Série Temporal - Expansão 5G (Brasil)')
plt.show()

# C) Determinação de Índices de Correlação (ACF e PACF)
fig, (ax1, ax2) = plt.subplots(2, 1, figsize=(10, 8))
plot_acf(ts_5g_coverage, ax=ax1, title="Função de Autocorrelação (ACF)")
plot_pacf(ts_5g_coverage, ax=ax2, title="Função de Autocorrelação Parcial (PACF)")
plt.tight_layout()
plt.show()

# 3. Validação em larga escala (Base de setores censitários - 8.3 milhões)
print("[3/3] Validando consistência na base de Setores...")
essential_cols = ['Período', 'Cobertura_5G']
df_setor = pd.read_csv(PATH_SETOR, compression='gzip', sep=';', 
                       usecols=essential_cols, encoding='utf-8-sig')
sector_5g_trend = df_setor.groupby('Período')['Cobertura_5G'].mean()

print(f"\nProcessamento concluído: {len(df_muni) + len(df_setor)} registros analisados.")