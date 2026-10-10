# Caso 2 - Hollywood Rules
# Carga de datos, variables derivadas y funciones comunes a todo el caso
# Autor: Maximo van Fulpen

library(tidyverse)
library(readxl)

options(scipen = 999)

ruta <- "data/Hollywood.xls"

hollywood <- read_excel(ruta, sheet = "Exhibit 1") |>
  rename(movie = 1, opening = 2, us_gross = 3, non_us_gross = 4, budget = 5,
         theatres = 6, known_story = 7, sequel = 8, origin_us = 9, genre = 10,
         summer = 11, holiday = 12, christmas = 13, mpaa = 14, r_rated = 15,
         critics = 16, oscar_nom = 17, oscar_won = 18) |>
  mutate(
    comedy = as.integer(genre == "Comedy"),
    roi_us = (us_gross - budget) / budget
  )

stopifnot(nrow(hollywood) == 75, !anyNA(hollywood))

tabla_coef <- function(modelo) {
  ic <- confint(modelo)
  summary(modelo)$coefficients |>
    as_tibble(rownames = "termino") |>
    rename(coef = 2, error_est = 3, t = 4, p_valor = 5) |>
    mutate(ic95_inf = ic[, 1], ic95_sup = ic[, 2])
}

ajuste <- function(modelo, nombre) {
  s <- summary(modelo)
  n <- nobs(modelo)
  tibble(modelo = nombre, n = n, r2 = s$r.squared,
         r2_ajustado = s$adj.r.squared, error_est_residual = s$sigma,
         f = s$fstatistic[1],
         p_valor_f = pf(s$fstatistic[1], s$fstatistic[2], s$fstatistic[3],
                        lower.tail = FALSE))
}

gris <- "grey70"
rojo <- "#C0392B"
azul <- "#1F77B4"

tema_hw <- theme_minimal(base_size = 11) +
  theme(plot.title = element_text(face = "bold"),
        plot.caption = element_text(color = "grey45", size = 8),
        panel.grid.minor = element_blank())

fuente <- "Fuente: Hollywood Rules (Kellogg, 2012), Exhibit 1. 75 películas de 2006."

millones <- scales::label_dollar(scale = 1e-6, suffix = " M", accuracy = 1)

guardar <- function(grafica, nombre, ancho = 8, alto = 4.5) {
  ggsave(file.path("output/figures", nombre), grafica,
         width = ancho, height = alto, dpi = 300, bg = "white")
}

dir.create("output/figures", showWarnings = FALSE, recursive = TRUE)
dir.create("output/tables", showWarnings = FALSE, recursive = TRUE)
