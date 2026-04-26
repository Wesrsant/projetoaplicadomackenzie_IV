# ODS 9: Indústria, Inovação e Infraestrutura
# ANÁLISE DE SÉRIES TEMPORAIS DA EXPANSÃO DA CONECTIVIDADE MÓVEL NO BRASIL (2022-2025)

Este repositório contém o desenvolvimento do **Projeto Aplicado IV** do curso de Tecnologia em Ciência de Dados da Universidade Presbiteriana Mackenzie. O projeto utiliza análise de séries temporais para monitorar e prever a evolução da infraestrutura de telecomunicações no Brasil, alinhando-se ao **ODS 9 - Indústria, Inovação e Infraestrutura**.

## 📖 Visão Geral
O projeto foca na transição tecnológica das redes móveis e na redução do abismo digital. Através de dados históricos da ANATEL, buscamos entender como a conectividade se expande pelo território nacional e quais padrões temporais regem essa evolução, com foco especial na implementação da tecnologia 5G.

## 🎯 Objetivo do Projeto

### Objetivo Geral
Realizar uma análise técnica da evolução das redes móveis utilizando séries temporais para apoiar a tomada de decisão no contexto da expansão da conectividade e do ODS 9.

### Objetivos Específicos
* Coletar, tratar e explorar dados públicos da ANATEL relacionados à infraestrutura móvel (2G, 3G, 4G e 5G).
* Aplicar técnicas de análise para identificar padrões históricos, sazonalidades e tendências de crescimento.
* Desenvolver visualizações que facilitem a interpretação dos dados e a comunicação dos resultados.
* Avaliar a evolução da cobertura em relação à população atendida, identificando desigualdades no acesso.

## 📊 Dataset Utilizado
Os dados são provenientes do portal de Dados Abertos da **ANATEL**, especificamente o conjunto de dados de **Cobertura da Telefonia Móvel**.

* **Fonte oficial:** [Portal Dados.gov - ANATEL](https://dados.gov.br/dados/conjuntos-dados/cobertura_movel)
* **Repositório do Projeto:** [GitHub - Wesrsant](https://github.com/Wesrsant/projetoaplicadomackenzie_IV)
* **Período:** Recorte anual (Mês de Julho) de 2022 a 2025.
* **Sensibilidade:** Não há dados sensíveis (Dados públicos agregados e sem identificação de usuários).

### Estrutura dos Dados
1. **Grupo Municípios (`_Municipios.csv`):** Visão consolidada por cidades, contendo indicadores de % de moradores e domicílios cobertos (aprox. 270 mil linhas/arquivo).
2. **Grupo Setores (`_Setores.csv`):** Granularidade técnica por setor censitário, permitindo análises geográficas de alta precisão (aprox. 2 milhões de linhas/arquivo).

## 🌍 Alinhamento com o ODS 9

### 🚀 Inovação
Fomento ao desenvolvimento de novas tecnologias que dependem de conectividade de alta velocidade e baixa latência (5G).

### 🏗️ Infraestrutura
Monitoramento do alcance da infraestrutura de comunicação em regiões remotas e centros urbanos, visando a universalização do acesso.

### 🏭 Indústria
Suporte à digitalização industrial (Indústria 4.0) através da previsão de disponibilidade de rede estável para processos automatizados.

## 📂 Estrutura de Pastas
```text
├── database/        # Arquivos CSV originais da ANATEL (sem unificação) 
├── docs/            # Relatórios técnicos e documentação em PDF 
├── output/          # Bases unificadas e otimizadas em formato GZIP (.csv.gz)
├── scripts/         # Scripts com as análises descritas no Pipeline
├── .gitignore       # Configuração de arquivos e pastas ignorados pelo Git
├── requirements.txt # Lista de dependências Python para reprodução do projeto
└── README.md        # Documentação principal e guia do repositório

```
## 🛠️ Implementação Técnica e Metodologia

O projeto segue uma metodologia estruturada para garantir a reprodutibilidade e o rigor estatístico:

### 1. Normalização e Higienização de Dados
* **Pipeline de Normalização**: Processamento automatizado das bases de Municípios e Setores Censitários.
* **Limpeza com Regex**: Remoção de caracteres invisíveis, espaços e símbolos de percentagem, garantindo a conversão forçada para tipos numéricos (Float).
* **Tratamento de Nulos**: Imputação estratégica com valor zero para manter a integridade dos cálculos matemáticos.

### 2. Análise Exploratória (EDA) e Diagnóstico
* **Validação de Granularidade**: Cruzamento de tendências entre a visão macro (municípios) e a visão micro (setores) para assegurar a consistência dos dados. A análise estatística utiliza o teste Augmented Dickey-Fuller (ADF) para validar a estacionariedade e a técnica de Decomposição Aditiva para isolar a tendência de crescimento tecnológico.
* **Benchmark Tecnológico**: Comparação entre a maturidade do 4G e a rampa de adoção do 5G.
* **Diagnóstico de Séries Temporais**: Teste de Estacionariedade (Augmented Dickey-Fuller) e análise de correlações (ACF/PACF).

### 3. Modelagem Preditiva e Projeção
* **Cenário Conservador**: Utilização de modelos de Holt-Winters para capturar a tendência linear de expansão.
* **Cenário Acelerado (Proxy de Salto)**: Simulação baseada no comportamento histórico de adoção do 4G para prever o potencial real do 5G.

### 4. Governança e Relatórios
* **Resumos Executivos Automáticos**: Ao final de cada etapa do código, é gerado um relatório textual no console ("Output da análise"), consolidando métricas de qualidade, crescimento anual (YoY) e conclusões críticas.

## ⚡ Otimização e Performance
Para viabilizar o processamento de milhões de registros (especialmente na base de Setores) sem comprometer o armazenamento:
* **Compactação Gzip**: Os ficheiros unificados são guardados no formato `.csv.gz`, o que reduz drasticamente o tamanho em disco e facilita o versionamento no GitHub.
* **Eficiência de Memória**: Utilização de parâmetros como `low_memory=False` e seleção seletiva de colunas durante o carregamento inicial para acelerar o processamento.

## 👥 Equipe de Desenvolvimento

**Membros do Grupo:**
- **Gustavo Castro Sangali** - RA: 10414952
- **Gustavo José Fermiano** - RA: 104409293
- **Kelly Haro Vasconcellos** - RA: 10441014  
- **Wesley Rodrigo dos Santos** - RA: 10433408

## 📅 Cronograma de Execução

O projeto será desenvolvido em **4 etapas principais**:

- **📋 Etapa 1** - Organização inicial: Formação do grupo, definição do tema, estruturação do repositório *- Fev'25*
- **🔬 Etapa 2** - Referencial Teórico e Cronograma :  *- Mar'25*
- **⚙️ Etapa 3** - Implementação Parcial: *- Abr'25*
- **📊 Etapa 4** - Implementação e Entrega Final: *- Mai'25*

## 📈 Entregas Esperadas

Como resultado do projeto, esperamos desenvolver:
- Pipeline robusto de tratamento de Big Data para telecomunicações.
- Dashboards de visualização da evolução espacial e temporal da rede 5G.
- Modelo preditivo para suporte a decisões estratégicas de infraestrutura digital.
---

## 📚 Referências

ANATEL. **Cobertura da Telefonia Móvel**. Portal de Dados Abertos do Governo Federal, 2025. Disponível em: [https://dados.gov.br/dados/conjuntos-dados/cobertura_movel](https://dados.gov.br/dados/conjuntos-dados/cobertura_movel) 

BANCO MUNDIAL. **Digital Dividends: World Development Report**. Washington, DC: World Bank Group, 2024. Disponível em: [https://www.worldbank.org/en/publication/wdr2016](https://www.worldbank.org/en/publication/wdr2016) 

CETIC.BR. **Pesquisa TIC Domicílios 2024: Painel de Indicadores**. São Paulo: Comitê Gestor da Internet no Brasil, 2024. Disponível em: [https://cetic.br/pt/pesquisa/domicilios/](https://cetic.br/pt/pesquisa/domicilios/) 

ONU. **Objetivo 9: Indústria, Inovação e Infraestrutura**. Estratégia ODS, 2026. Disponível em: [https://brasil.un.org/pt-br/sdgs/9](https://brasil.un.org/pt-br/sdgs/9) 


---

> **Nota**: Este projeto está em desenvolvimento progressivo. O README será atualizado conforme o avanço das entregas e implementações.
