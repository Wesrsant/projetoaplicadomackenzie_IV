# ODS 9: Indústria, Inovação e Infraestrutura
# ANÁLISE DE SÉRIES TEMPORAIS DA EXPANSÃO DA CONECTIVIDADE MÓVEL NO BRASIL (2022-2025)

Este repositório contém o desenvolvimento do **Projeto Aplicado IV** do curso de Tecnologia em Ciência de Dados da Universidade Presbiteriana Mackenzie. O projeto utiliza análise de séries temporais para monitorar e prever a evolução da infraestrutura de telecomunicações no Brasil, alinhando-se ao **ODS 9 - Indústria, Inovação e Infraestrutura**.

## 📖 Visão Geral
O projeto foca na transição tecnológica das redes móveis e na redução do abismo digital. Através de dados históricos da ANATEL, buscamos entender como a conectividade se expande pelo território nacional e quais padrões temporais regem essa evolução, com foco especial na implementação da tecnologia 5G.

## 🎯 Objetivo do Projeto

### Objetivo Geral
Realizar uma análise preditiva da expansão da cobertura móvel no Brasil, utilizando modelos de séries temporais para estimar a maturidade da rede 5G e o ciclo de vida das tecnologias legadas.

### Objetivos Específicos
* Identificar padrões de crescimento na cobertura municipal e por setor censitário.
* Comparar a velocidade de implementação do 5G em relação ao histórico do 4G.
* Fornecer insights sobre áreas com déficit de infraestrutura digital para apoio a decisões estratégicas.

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
├── database/           # Arquivos CSV brutos e processados da Anatel
├── docs/               # Relatórios técnicos e documentação em PDF
├── notebooks/          # Jupyter Notebooks (EDA, Pré-processamento e Modelagem)
├── .gitignore          # Arquivos e pastas ignorados pelo controle de versão
└── README.md           # Documentação principal do repositório

### 🛠️ Configuração de Dados (Git LFS)
Este projeto utiliza **Git LFS** para gerenciar os arquivos CSV da ANATEL.
Caso os arquivos na pasta `/database` apareçam como ponteiros de texto (apenas algumas linhas com IDs), execute o comando abaixo no terminal para baixar os dados reais:
```bash
git lfs pull

## 🔬 Premissas e Metodologia Inicial

### **Abordagem Metodológica**


### **Premissas Técnicas**

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


---

## 📚 Referências

ANATEL. **Cobertura da Telefonia Móvel**. Portal de Dados Abertos do Governo Federal, 2025. Disponível em: [https://dados.gov.br/dados/conjuntos-dados/cobertura_movel](https://dados.gov.br/dados/conjuntos-dados/cobertura_movel) 

BANCO MUNDIAL. **Digital Dividends: World Development Report**. Washington, DC: World Bank Group, 2024. Disponível em: [https://www.worldbank.org/en/publication/wdr2016](https://www.worldbank.org/en/publication/wdr2016) 

CETIC.BR. **Pesquisa TIC Domicílios 2024: Painel de Indicadores**. São Paulo: Comitê Gestor da Internet no Brasil, 2024. Disponível em: [https://cetic.br/pt/pesquisa/domicilios/](https://cetic.br/pt/pesquisa/domicilios/) 

ONU. **Objetivo 9: Indústria, Inovação e Infraestrutura**. Estratégia ODS, 2026. Disponível em: [https://brasil.un.org/pt-br/sdgs/9](https://brasil.un.org/pt-br/sdgs/9) 


---

> **Nota**: Este projeto está em desenvolvimento progressivo. O README será atualizado conforme o avanço das entregas e implementações.
