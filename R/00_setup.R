# Caso 2 - Hollywood Rules
# Carga de datos, variables derivadas y funciones comunes a todo el caso
# Autor: Maximo van Fulpen

library(tidyverse)
library(readxl)

options(scipen = 999)

ruta <- "data/Hollywood.xls"

# La hoja Exhibit 1 trae las 75 peliculas de 2006 con presupuesto conocido
# entre USD 20 y 100 millones. La primera hoja es solo el copyright.
# Los nombres originales tienen espacios y una tilde invertida en Critics,
# asi que se renombran en el mismo orden de la Tabla 1 del caso
hollywood <- read_excel(ruta, sheet = "Exhibit 1") |>
  rename(movie = 1, opening = 2, us_gross = 3, non_us_gross = 4, budget = 5,
         theatres = 6, known_story = 7, sequel = 8, origin_us = 9, genre = 10,
         summer = 11, holiday = 12, christmas = 13, mpaa = 14, r_rated = 15,
         critics = 16, oscar_nom = 17, oscar_won = 18) |>
  mutate(
    # Dummy de comedia contra cualquier otro genero (preguntas 3, 5, 8 y 9)
    comedy = as.integer(genre == "Comedy"),
    # ROI en Estados Unidos tal como lo define la pregunta 2a, sin descontar
    roi_us = (us_gross - budget) / budget
  )

stopifnot(nrow(hollywood) == 75, !anyNA(hollywood))

# Variables candidatas por momento de decision, siguiendo la estructura del
# caso. Lo que se sabe antes de producir, lo que se agrega antes del estreno y
# lo que se agrega despues del primer fin de semana
vars_preproduccion <- c("budget", "comedy", "r_rated", "sequel", "known_story")
vars_estreno <- c("summer", "holiday", "christmas", "theatres")
vars_post_estreno <- c("opening", "critics")

# Eliminacion hacia atras: se quita la variable con el p-valor mas alto, se
# reestima y se repite hasta que todas sean significativas al nivel alfa. Se
# quita una a la vez porque los p-valores cambian al sacar cada variable
eliminacion_atras <- function(datos, respuesta, candidatas, alfa = 0.10) {
  vars <- candidatas
  pasos <- tibble(paso = integer(), variable_quitada = character(),
                  p_valor = numeric())
  repeat {
    modelo <- lm(reformulate(vars, respuesta), data = datos)
    p <- summary(modelo)$coefficients[-1, 4, drop = FALSE]
    peor <- which.max(p[, 1])
    if (p[peor, 1] <= alfa) break
    pasos <- add_row(pasos, paso = nrow(pasos) + 1L,
                     variable_quitada = rownames(p)[peor], p_valor = p[peor, 1])
    vars <- setdiff(vars, rownames(p)[peor])
  }
  list(modelo = modelo, pasos = pasos)
}

# Tabla de coeficientes con intervalo de confianza del 95 %, para guardar en csv
tabla_coef <- function(modelo) {
  ic <- confint(modelo)
  summary(modelo)$coefficients |>
    as_tibble(rownames = "termino") |>
    rename(coef = 2, error_est = 3, t = 4, p_valor = 5) |>
    mutate(ic95_inf = ic[, 1], ic95_sup = ic[, 2])
}

# Resumen de una linea de cada modelo: n, R2, R2 ajustado y prueba F
ajuste <- function(modelo, nombre) {
  s <- summary(modelo)
  n <- nobs(modelo)
  tibble(modelo = nombre, n = n, r2 = s$r.squared,
         r2_ajustado = s$adj.r.squared, error_est_residual = s$sigma,
         f = s$fstatistic[1],
         p_valor_f = pf(s$fstatistic[1], s$fstatistic[2], s$fstatistic[3],
                        lower.tail = FALSE))
}

# Paleta del curso: todo en gris menos lo que importa
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
