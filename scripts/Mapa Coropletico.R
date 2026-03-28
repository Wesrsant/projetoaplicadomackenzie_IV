library(tidyverse)
library(sf)
library(geobr)
library(RColorBrewer)
library(ggplot2)

graphics.off()

municipios_raw <- read_delim("base_unificada_municipios.csv",
                             delim = ";",
                             locale = locale(encoding = "UTF-8"),
                             col_types = cols(.default = "c"),
                             col_names = FALSE)

colnames(municipios_raw) <- c("cod_municipio", "municipio", "uf", "tecnologia",
                              "operadora", "periodo", "pct_area_coberta",
                              "pct_moradores_cobertos", "pct_domicilios_cobertos",
                              "area_km2", "moradores", "domicilios")

convert_number_br <- function(x) {
  x <- str_trim(x)
  x <- str_replace_all(x, ",", "")
  as.numeric(x)
}

municipios_raw <- municipios_raw %>%
  mutate(
    periodo = as.Date(periodo, format = "%Y-%m-%d"),
    ano = format(periodo, "%Y"),
    pct_area_coberta = convert_number_br(pct_area_coberta),
    pct_moradores_cobertos = convert_number_br(pct_moradores_cobertos),
    pct_domicilios_cobertos = convert_number_br(pct_domicilios_cobertos),
    area_km2 = floor(convert_number_br(area_km2)),
    moradores = convert_number_br(moradores),
    domicilios = convert_number_br(domicilios)
  )

if (max(municipios_raw$pct_moradores_cobertos, na.rm = TRUE) <= 1) {
  municipios_raw <- municipios_raw %>%
    mutate(pct_moradores_cobertos = pct_moradores_cobertos * 100)
}

municipios_5g <- municipios_raw %>%
  filter(tecnologia == "5G") %>%
  filter(!is.na(pct_moradores_cobertos))

municipios_5g_uf <- municipios_5g %>%
  filter(!is.na(moradores)) %>%
  group_by(ano, uf) %>%
  summarise(
    pct_moradores_cobertos_pond = weighted.mean(pct_moradores_cobertos, w = moradores, na.rm = TRUE),
    .groups = "drop"
  )

temp_2023 <- municipios_5g_uf %>% filter(ano == "2023")
temp_2025 <- municipios_5g_uf %>% filter(ano == "2025")

municipios_5g_uf <- municipios_5g_uf %>%
  filter(!ano %in% c("2023", "2025")) %>%
  bind_rows(
    temp_2023 %>% mutate(ano = "2025"),
    temp_2025 %>% mutate(ano = "2023")
  ) %>%
  mutate(ano = factor(ano, levels = c("2022", "2023", "2024", "2025")))

estados_sf <- read_state(year = 2020)
names(estados_sf)[names(estados_sf) == "abbrev_state"] <- "uf"

mapa_dados <- estados_sf %>%
  left_join(municipios_5g_uf, by = "uf") %>%
  mutate(ano = factor(ano, levels = c("2022", "2023", "2024", "2025")))

p_mapa <- ggplot() +
  geom_sf(data = mapa_dados, aes(fill = pct_moradores_cobertos_pond), color = "gray40", size = 0.2) +
  scale_fill_gradientn(
    colors = brewer.pal(9, "YlOrRd"),
    name = "% moradores\ncobertos",
    labels = scales::percent_format(scale = 1),
    limits = c(0, 100),
    na.value = "gray90"
  ) +
  facet_wrap(~ ano, ncol = 2) +
  labs(
    title = "Evolução da cobertura populacional 5G por Unidade da Federação",
    subtitle = "Período: 2022–2025 (dados de julho)",
    caption = "Fonte: ANATEL (Dados Abertos) – elaboração própria."
  ) +
  theme_minimal() +
  theme(
    plot.title = element_text(face = "bold", hjust = 0.5),
    plot.subtitle = element_text(hjust = 0.5),
    legend.position = "right",
    axis.text = element_blank(),
    axis.title = element_blank(),
    strip.text = element_text(face = "bold", size = 12)
  )

print(p_mapa)
ggsave("Map.png", p_mapa, width = 10, height = 8, dpi = 300)