# Caso 2 - Hollywood Rules
# Pregunta 8: taquilla total con todo lo que se sabe despues del estreno, y el
# valor de las criticas para una pelicula como Flags of Our Fathers

source("R/00_setup.R")

#### Pregunta 8: modelo despues del fin de semana de estreno ####

vars_q8 <- c(vars_preproduccion, vars_estreno, vars_post_estreno)
m8_completo <- lm(reformulate(vars_q8, "us_gross"), data = hollywood)

e8 <- eliminacion_atras(hollywood, "us_gross", vars_q8)
m8_final <- e8$modelo

write_csv(tabla_coef(m8_completo), "output/tables/q8a_modelo_completo.csv")
write_csv(e8$pasos, "output/tables/q8b_pasos_eliminacion.csv")
write_csv(tabla_coef(m8_final), "output/tables/q8b_modelo_final.csv")
write_csv(bind_rows(ajuste(m8_completo, "q8a completo"),
                    ajuste(m8_final, "q8b final")),
          "output/tables/q8_ajuste_modelos.csv")

flags <- hollywood |> filter(movie == "Flags of Our Fathers")
pred_flags <- predict(m8_final, newdata = flags, interval = "prediction",
                      level = 0.95)
conf_flags <- predict(m8_final, newdata = flags, interval = "confidence",
                      level = 0.95)

q8c <- tibble(
  pelicula = flags$movie,
  estimacion_puntual = pred_flags[1, "fit"],
  ip95_inf = pred_flags[1, "lwr"], ip95_sup = pred_flags[1, "upr"],
  ic95_media_inf = conf_flags[1, "lwr"], ic95_media_sup = conf_flags[1, "upr"],
  taquilla_real = flags$us_gross,
  critica = flags$critics, estreno = flags$opening, presupuesto = flags$budget
)
write_csv(q8c, "output/tables/q8c_prediccion_flags.csv")

coef_critica <- tabla_coef(m8_final) |> filter(termino == "critics")
flags_89 <- flags |> mutate(critics = 89)
pred_89 <- predict(m8_final, newdata = flags_89, interval = "confidence")

q8d <- tibble(
  cambio_critica = 10,
  aumento_taquilla = 10 * coef_critica$coef,
  ic95_inf = 10 * coef_critica$ic95_inf,
  ic95_sup = 10 * coef_critica$ic95_sup,
  taquilla_con_79 = pred_flags[1, "fit"],
  taquilla_con_89 = pred_89[1, "fit"],
  ingreso_distribuidor_70 = 0.70 * 10 * coef_critica$coef,
  ingreso_distribuidor_50 = 0.50 * 10 * coef_critica$coef,
  ingreso_distribuidor_50_ic_inf = 0.50 * 10 * coef_critica$ic95_inf
)
write_csv(q8d, "output/tables/q8d_valor_diez_puntos_critica.csv")

datos_g8 <- hollywood |>
  mutate(prediccion = fitted(m8_final),
         es_flags = movie == "Flags of Our Fathers")

g8 <- ggplot(datos_g8, aes(x = prediccion, y = us_gross)) +
  geom_abline(intercept = 0, slope = 1, color = "grey50", linetype = "dashed") +
  geom_point(data = filter(datos_g8, !es_flags), color = gris, size = 1.8) +
  geom_errorbar(data = filter(datos_g8, es_flags),
                aes(ymin = q8c$ip95_inf, ymax = q8c$ip95_sup),
                width = 3e6, color = rojo, linewidth = 0.6) +
  geom_point(data = filter(datos_g8, es_flags), color = rojo, size = 3) +
  annotate("text", x = q8c$estimacion_puntual + 4e6, y = q8c$ip95_inf,
           label = "Flags of Our Fathers\ncon su intervalo de predicción del 95 %",
           color = rojo, hjust = 0, vjust = 0, size = 3.2) +
  scale_x_continuous(labels = millones) +
  scale_y_continuous(labels = millones) +
  labs(title = "Con el estreno y la crítica, el modelo explica la mayor parte de la taquilla",
       subtitle = "Pregunta 8. Taquilla real contra la que predice el modelo final. Sobre la diagonal, el modelo acierta",
       x = "Taquilla total en EE. UU. que predice el modelo",
       y = "Taquilla total real en EE. UU.", caption = fuente) +
  tema_hw
guardar(g8, "q8_real_vs_predicho.png")

otras <- setdiff(names(coef(m8_final))[-1], "critics")
parcial <- hollywood |>
  mutate(resid_y = residuals(lm(reformulate(otras, "us_gross"), data = hollywood)),
         resid_x = residuals(lm(reformulate(otras, "critics"), data = hollywood)),
         es_flags = movie == "Flags of Our Fathers")

g8d <- ggplot(parcial, aes(x = resid_x, y = resid_y)) +
  geom_hline(yintercept = 0, color = "grey80") +
  geom_point(aes(color = es_flags), size = 1.8) +
  geom_smooth(method = "lm", formula = y ~ x, se = TRUE, color = azul,
              fill = azul, alpha = 0.12) +
  scale_color_manual(values = c(`FALSE` = gris, `TRUE` = rojo), guide = "none") +
  scale_y_continuous(labels = millones) +
  labs(title = "Mejor crítica, más taquilla, aun con el mismo estreno",
       subtitle = paste0("Pregunta 8d. ",
                         "Cada punto adicional vale ",
                         format(round(coef_critica$coef / 1e3), big.mark = ".", decimal.mark = ","),
                         " mil dólares. En rojo, Flags of Our Fathers"),
       x = "Nota de la crítica, descontado el efecto de las demás variables",
       y = "Taquilla EE. UU., descontado lo demás", caption = fuente) +
  tema_hw
guardar(g8d, "q8d_efecto_parcial_critica.png")

cat("Pregunta 8 lista\n")
