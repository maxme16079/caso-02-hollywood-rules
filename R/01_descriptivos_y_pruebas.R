# Caso 2 - Hollywood Rules
# Preguntas 1 a 4: panorama de los datos, ROI y pruebas de hipotesis
# Autor: Maximo van Fulpen

source("R/00_setup.R")

#### Pregunta 1: minimo, promedio y maximo ####

q1 <- hollywood |>
  select(opening, us_gross, non_us_gross, theatres) |>
  pivot_longer(everything(), names_to = "variable") |>
  group_by(variable = factor(variable, levels = c("opening", "us_gross",
                                                  "non_us_gross", "theatres"))) |>
  summarise(minimo = min(value), promedio = mean(value), maximo = max(value),
            .groups = "drop")
write_csv(q1, "output/tables/q1_min_promedio_max.csv")

q1_extremos <- map_dfr(c("opening", "us_gross", "non_us_gross", "theatres"), \(v) {
  bind_rows(
    hollywood |> slice_min(.data[[v]], n = 1, with_ties = FALSE) |>
      transmute(variable = v, extremo = "minimo", movie, valor = .data[[v]]),
    hollywood |> slice_max(.data[[v]], n = 1, with_ties = FALSE) |>
      transmute(variable = v, extremo = "maximo", movie, valor = .data[[v]])
  )
})
write_csv(q1_extremos, "output/tables/q1_extremos.csv")

q1_conteos <- tibble(
  grupo = c("Comedias", "Calificadas R", "Total"),
  peliculas = c(sum(hollywood$comedy), sum(hollywood$r_rated), nrow(hollywood))
)
write_csv(q1_conteos, "output/tables/q1_conteos.csv")

write_csv(count(hollywood, genre, sort = TRUE), "output/tables/q1_generos.csv")
write_csv(count(hollywood, mpaa), "output/tables/q1_clasificacion_mpaa.csv")

#### Pregunta 2: ROI en EE. UU. ####

hollywood |>
  select(movie, us_gross, budget, roi_us) |>
  arrange(desc(roi_us)) |>
  write_csv("output/tables/q2a_roi_por_pelicula.csv")

ic_roi <- t.test(hollywood$roi_us, conf.level = 0.95)

prueba_12 <- t.test(hollywood$roi_us, mu = 0.12, alternative = "greater")

q2 <- tibble(
  n = nrow(hollywood),
  media_roi = mean(hollywood$roi_us),
  mediana_roi = median(hollywood$roi_us),
  desv_est = sd(hollywood$roi_us),
  error_est = sd(hollywood$roi_us) / sqrt(nrow(hollywood)),
  ic95_inf = ic_roi$conf.int[1],
  ic95_sup = ic_roi$conf.int[2],
  t_vs_12 = unname(prueba_12$statistic),
  gl = unname(prueba_12$parameter),
  p_valor_una_cola = prueba_12$p.value,
  peliculas_roi_negativo = sum(hollywood$roi_us < 0)
)
write_csv(q2, "output/tables/q2_ic_y_prueba_roi.csv")

g2 <- ggplot(hollywood, aes(x = roi_us)) +
  annotate("rect", xmin = q2$ic95_inf, xmax = q2$ic95_sup, ymin = -Inf,
           ymax = Inf, fill = azul, alpha = 0.15) +
  geom_histogram(binwidth = 0.25, boundary = 0, fill = gris, color = "white") +
  geom_vline(xintercept = q2$media_roi, color = azul, linewidth = 0.9) +
  geom_vline(xintercept = 0.12, color = rojo, linewidth = 0.9, linetype = "dashed") +
  annotate("text", x = q2$ic95_sup + 0.03, y = Inf, vjust = 1.5, hjust = 0,
           color = azul, size = 3.3,
           label = paste0("Media 29,3 %\nIC 95 %: 13,5 % a 45,1 %")) +
  annotate("text", x = 0.09, y = Inf, vjust = 1.5, hjust = 1, color = rojo,
           size = 3.3, label = "12 % de\nMichael London") +
  scale_x_continuous(labels = scales::label_percent()) +
  labs(title = "El ROI promedio en EE. UU. supera el 12 % que cita London",
       subtitle = "Todo el IC del 95 % queda a la derecha del 12 %. Aun así, 29 de las 75 películas no recuperan su presupuesto",
       x = "ROI en EE. UU. = (taquilla EE. UU. - presupuesto) / presupuesto",
       y = "Películas", caption = fuente) +
  tema_hw
guardar(g2, "q2_distribucion_roi.png")

#### Pregunta 3: comedias contra el resto ####

comparar <- function(variable, grupo, etiqueta) {
  f <- reformulate(grupo, variable)
  w <- t.test(f, data = hollywood)
  c <- t.test(f, data = hollywood, var.equal = TRUE)
  medias <- hollywood |> group_by(.data[[grupo]]) |>
    summarise(n = n(), media = mean(.data[[variable]]), .groups = "drop")
  tibble(comparacion = etiqueta, variable = variable,
         n_grupo = medias$n[2], media_grupo = medias$media[2],
         n_resto = medias$n[1], media_resto = medias$media[1],
         diferencia = medias$media[2] - medias$media[1],
         t_welch = -unname(w$statistic), gl_welch = unname(w$parameter),
         p_welch = w$p.value,
         ic95_inf = -w$conf.int[2], ic95_sup = -w$conf.int[1],
         p_varianza_combinada = c$p.value)
}

q3 <- bind_rows(
  comparar("us_gross", "comedy", "Comedia vs resto"),
  comparar("roi_us", "comedy", "Comedia vs resto"),
  comparar("budget", "comedy", "Comedia vs resto")
)
write_csv(q3, "output/tables/q3_comedia_vs_resto.csv")

datos_g3 <- hollywood |>
  mutate(grupo = if_else(comedy == 1, "Comedias (23)", "Otros géneros (52)")) |>
  select(grupo, `Taquilla EE. UU. (USD M)` = us_gross, `Presupuesto (USD M)` = budget,
         `ROI EE. UU. (%)` = roi_us) |>
  mutate(across(c(`Taquilla EE. UU. (USD M)`, `Presupuesto (USD M)`), \(x) x / 1e6),
         `ROI EE. UU. (%)` = `ROI EE. UU. (%)` * 100) |>
  pivot_longer(-grupo) |>
  mutate(name = factor(name, levels = c("Taquilla EE. UU. (USD M)",
                                        "Presupuesto (USD M)", "ROI EE. UU. (%)")))

g3 <- ggplot(datos_g3, aes(x = grupo, y = value, color = grupo)) +
  geom_jitter(width = 0.15, alpha = 0.55, size = 1.6) +
  stat_summary(fun = mean, geom = "crossbar", width = 0.5, linewidth = 0.5) +
  facet_wrap(~ name, scales = "free_y") +
  scale_color_manual(values = c("Comedias (23)" = rojo, "Otros géneros (52)" = "grey55"),
                     guide = "none") +
  labs(title = "Por cada dólar invertido, las comedias rinden más que el resto",
       subtitle = "Presupuestos parecidos. Taquilla: diferencia no significativa (p = 0,18). ROI: significativa al 5 % (p = 0,047)",
       x = NULL, y = NULL, caption = fuente) +
  tema_hw
guardar(g3, "q3_comedia_vs_resto.png", ancho = 9, alto = 4.8)

#### Pregunta 4: peliculas R contra el resto ####

q4 <- bind_rows(
  comparar("us_gross", "r_rated", "R vs resto"),
  comparar("roi_us", "r_rated", "R vs resto")
)
write_csv(q4, "output/tables/q4_r_vs_resto.csv")

g4 <- hollywood |>
  mutate(grupo = if_else(r_rated == 1, "Calificadas R (15)", "Otras clasificaciones (60)")) |>
  ggplot(aes(x = grupo, y = us_gross, color = grupo)) +
  geom_jitter(width = 0.15, alpha = 0.6, size = 1.8) +
  stat_summary(fun = mean, geom = "crossbar", width = 0.5, linewidth = 0.5) +
  scale_color_manual(values = c("Calificadas R (15)" = rojo,
                                "Otras clasificaciones (60)" = "grey55"),
                     guide = "none") +
  scale_y_continuous(labels = millones) +
  labs(title = "Las películas R no recaudan más que las demás",
       subtitle = "Media 53,3 M contra 61,2 M. La diferencia no es significativa (p = 0,40). La barra es la media",
       x = NULL, y = "Taquilla total en EE. UU.", caption = fuente) +
  tema_hw
guardar(g4, "q4_r_vs_resto.png", ancho = 7, alto = 4.5)

cat("Preguntas 1 a 4 listas\n")
