# ============================================================
#  Mapa Coroplético – Cobertura 5G por UF (2022–2025)
#  Fonte: base_unificada_municipios.csv
#  Separador: ;   Decimal: .
#  OBS: colunas de cobertura estão em proporção (0–1),
#       por isso multiplicamos por 100 para obter percentual.
# ============================================================

# ── 1. Pacotes ───────────────────────────────────────────────
pkgs <- c("tidyverse", "geobr", "sf", "patchwork", "showtext", "sysfonts")
installed <- rownames(installed.packages())
to_install <- pkgs[!pkgs %in% installed]
if (length(to_install) > 0) install.packages(to_install, repos = "https://cran.r-project.org")

library(tidyverse)
library(geobr)
library(sf)
library(patchwork)
library(showtext)
library(sysfonts)

# ── 2. Fontes ────────────────────────────────────────────────
base_family <- tryCatch({
  font_add_google("Inter", "inter")
  showtext_auto()
  "inter"
}, error = function(e) "sans")

# ── 3. Leitura ───────────────────────────────────────────────
message("Lendo base_unificada_municipios.csv ...")
mun_raw <- read_delim(
  "base_unificada_municipios.csv",
  delim  = ";",
  locale = locale(decimal_mark = ".", grouping_mark = ",", encoding = "UTF-8"),
  show_col_types = FALSE
)

# ── 4. Padroniza nomes de colunas ────────────────────────────
colnames(mun_raw) <- colnames(mun_raw) |>
  str_to_lower() |>
  str_replace_all("á|à|ã|â", "a") |>
  str_replace_all("é|ê",      "e") |>
  str_replace_all("í",        "i") |>
  str_replace_all("ó|ô|õ",   "o") |>
  str_replace_all("ú",        "u") |>
  str_replace_all("ç",        "c") |>
  str_replace_all("[^a-z0-9_]", "_") |>
  str_replace_all("_+", "_") |>
  str_remove("^_") |>
  str_remove("_$")

# ── 5. Filtra 5G e converte proporção → percentual ───────────
df_5g <- mun_raw |>
  filter(str_detect(tecnologia, regex("5G", ignore_case = TRUE))) |>
  mutate(
    ano           = as.integer(format(as.Date(periodo), "%Y")),
    pct_moradores = moradores_cobertos * 100
  ) |>
  filter(ano %in% 2022:2025)

if (nrow(df_5g) == 0) stop("Nenhum registro 5G encontrado para 2022-2025.")

message(sprintf(
  "Registros 5G: %d | pct_moradores: min=%.1f  mediana=%.1f  max=%.1f",
  nrow(df_5g),
  min(df_5g$pct_moradores,    na.rm = TRUE),
  median(df_5g$pct_moradores, na.rm = TRUE),
  max(df_5g$pct_moradores,    na.rm = TRUE)
))

# ── 6. Agrega por UF × Ano ───────────────────────────────────
uf_ano <- df_5g |>
  group_by(uf, ano) |>
  summarise(cobertura = mean(pct_moradores, na.rm = TRUE), .groups = "drop")

# ── 7. Geometria dos estados ─────────────────────────────────
message("Baixando geometria dos estados ...")
estados_sf <- read_state(year = 2020, showProgress = FALSE) |>
  select(abbrev_state, geom) |>
  rename(uf = abbrev_state)

# ── 8. Paleta amarelo → laranja escuro (10 tons, intervalos de 10pp) ──
paleta <- c(
  "#FFFDE0",  # 0–10%
  "#FFF3A3",  # 10–20%
  "#FFE566",  # 20–30%
  "#FFD000",  # 30–40%
  "#FFB300",  # 40–50%
  "#FF8C00",  # 50–60%
  "#FF5E00",  # 60–70%
  "#E03000",  # 70–80%
  "#AA1C00",  # 80–90%
  "#6B0A00"   # 90–100%
)
breaks <- c(0, 10, 20, 30, 40, 50, 60, 70, 80, 90, 100)
labels <- c("0-10%","10-20%","20-30%","30-40%","40-50%",
            "50-60%","60-70%","70-80%","80-90%","90-100%")

# ── 9. Função de mapa por ano ────────────────────────────────
mapa_ano <- function(ano_sel, sf_base, dados_uf, pal, bks, lbs, fam = "sans") {
  
  sf_plot <- sf_base |>
    left_join(filter(dados_uf, ano == ano_sel), by = "uf") |>
    mutate(
      faixa = cut(cobertura, breaks = bks, labels = lbs,
                  include.lowest = TRUE, right = FALSE),
      faixa = fct_na_value_to_level(faixa, "Sem dados")
    )
  
  cores <- c(setNames(pal, lbs), "Sem dados" = "#CCCCCC")
  
  ggplot(sf_plot) +
    geom_sf(aes(fill = faixa, geometry = geom), color = "white", linewidth = 0.25) +
    scale_fill_manual(values = cores, drop = FALSE, na.value = "#CCCCCC") +
    labs(title = as.character(ano_sel)) +
    coord_sf(xlim = c(-74, -28), ylim = c(-34, 6), expand = FALSE) +
    theme_void(base_family = fam) +
    theme(
      plot.title      = element_text(size = 20, face = "bold", hjust = 0.5,
                                     margin = margin(b = 5)),
      legend.position = "none",
      plot.background = element_rect(fill = "#F5F5F5", color = NA),
      plot.margin     = margin(6, 6, 6, 6)
    )
}

# ── 10. Gera os quatro mapas — ordem: 2022, 2023, 2025, 2024 ─
message("Gerando mapas ...")
anos_ordem <- c(2022, 2023, 2025, 2024)
mapas <- map(anos_ordem, mapa_ano,
             sf_base  = estados_sf,
             dados_uf = uf_ano,
             pal      = paleta,
             bks      = breaks,
             lbs      = labels,
             fam      = base_family)

# ── 11. Legenda vertical ─────────────────────────────────────
leg_df <- tibble(
  faixa = factor(labels, levels = rev(labels)),
  x = 1,
  y = rev(seq_along(labels))
)

legenda_plot <- ggplot(leg_df, aes(x, y, fill = faixa)) +
  geom_tile(width = 0.55, height = 0.75, color = "white", linewidth = 0.4) +
  geom_text(aes(label = faixa), x = 1.38, hjust = 0,
            size = 3.5, family = base_family, color = "gray20") +
  scale_fill_manual(values = setNames(paleta, labels)) +
  scale_x_continuous(expand = expansion(add = c(0.2, 1.5))) +
  scale_y_continuous(expand = expansion(add = 0.6)) +
  annotate("text", x = 1, y = max(leg_df$y) + 1,
           label = "% Moradores\ncobertos", fontface = "bold",
           size = 3.8, family = base_family, color = "gray15", hjust = 0.5) +
  theme_void(base_family = base_family) +
  theme(legend.position = "none",
        plot.background = element_rect(fill = "#F5F5F5", color = NA))

# ── 12. PRINT: resumo por UF × ano ──────────────────────────
cat("\n=================================================\n")
cat("  RESUMO: Cobertura 5G média por UF e ano\n")
cat("=================================================\n")
print(
  uf_ano |>
    mutate(cobertura = round(cobertura, 1)) |>
    pivot_wider(names_from = ano, values_from = cobertura) |>
    arrange(uf),
  n = Inf
)
cat("=================================================\n\n")

# ── 13. Composição final ─────────────────────────────────────
painel <- (mapas[[1]] | mapas[[2]] | mapas[[3]] | mapas[[4]] | legenda_plot) +
  plot_layout(widths = c(1, 1, 1, 1, 0.42)) +
  plot_annotation(
    title    = "Cobertura 5G por Unidade da Federação — 2022 a 2025",
    subtitle = "Percentual médio de moradores cobertos por tecnologia 5G em cada estado",
    caption  = "Fonte: Anatel / base_unificada_municipios.csv  |  Elaboração própria",
    theme = theme(
      plot.title      = element_text(size = 23, face = "bold", family = base_family,
                                     hjust = 0.5, margin = margin(b = 5)),
      plot.subtitle   = element_text(size = 13, color = "gray35", family = base_family,
                                     hjust = 0.5, margin = margin(b = 12)),
      plot.caption    = element_text(size = 9,  color = "gray50", family = base_family,
                                     hjust = 1,  margin = margin(t = 8)),
      plot.background = element_rect(fill = "#F5F5F5", color = NA),
      plot.margin     = margin(22, 22, 14, 22)
    )
  )

# ── 14. Exporta ──────────────────────────────────────────────
ggsave(
  filename = "mapa_5g_coropletico.png",
  plot     = painel,
  width    = 22,
  height   = 10,
  dpi      = 200,
  bg       = "#F5F5F5"
)

message("Concluido! Arquivo salvo: mapa_5g_coropletico.png")