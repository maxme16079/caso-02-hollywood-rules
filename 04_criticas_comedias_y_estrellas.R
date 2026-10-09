# Caso 2 - Hollywood Rules
# Preguntas 9 y 10: si la critica pesa menos en las comedias, y que tendria
# que pasar para que las estrellas expliquen la taquilla mejor que el

source("R/00_setup.R")

e8 <- eliminacion_atras(hollywood, "us_gross",
                        c(vars_preproduccion, vars_estreno, vars_post_estreno))
m8_final <- e8$modelo
vars_m8 <- names(coef(m8_final))[-1]

#### Pregunta 9: la critica en comedias contra el resto ####

m9 <- lm(reformulate(c(vars_m8, "comedy", "comedy:critics"), "us_gross"),
         data = hollywood)
write_csv(tabla_coef(m9), "output/tables/q9_modelo_interaccion.csv")

b9 <- coef(summary(m9))["critics:comedy", ]
p9_una_cola <- pt(b9["t value"], df = df.residual(m9))

v9 <- vcov(m9)
pend_resto <- coef(m9)["critics"]
pend_comedia <- coef(m9)["critics"] + coef(m9)["critics:comedy"]
ee_resto <- sqrt(v9["critics", "critics"])
ee_comedia <- sqrt(v9["critics", "critics"] + v9["critics:comedy", "critics:comedy"] +
                     2 * v9["critics", "critics:comedy"])

q9 <- tibble(
  grupo = c("Otros generos", "Comedias", "Diferencia (comedia - resto)"),
  pendiente_critica = c(pend_resto, pend_comedia, b9["Estimate"]),
  error_est = c(ee_resto, ee_comedia, b9["Std. Error"]),
  t = pendiente_critica / error_est,
  p_valor = c(2 * pt(-abs(t[1:2]), df.residual(m9)), p9_una_cola),
  prueba = c("dos colas, pendiente = 0", "dos colas, pendiente = 0",
             "una cola, H1: diferencia < 0")
)
write_csv(q9, "output/tables/q9_pendiente_critica_por_grupo.csv")

anova_9 <- anova(m8_final, m9)
write_csv(as_tibble(anova_9, rownames = "modelo") |>
            mutate(modelo = c("q8 final", "q8 final + comedia + comedia x critica")),
          "output/tables/q9_prueba_f_contra_q8.csv")
write_csv(bind_rows(ajuste(m8_final, "q8 final"), ajuste(m9, "q9 interaccion")),
          "output/tables/q9_ajuste_modelos.csv")

promedios <- hollywood |> summarise(across(all_of(setdiff(vars_m8, "critics")), mean))
rejilla <- expand_grid(critics = seq(min(hollywood$critics), max(hollywood$critics),
                                     length.out = 50),
                       comedy = c(0, 1)) |>
  bind_cols(promedios[rep(1, 100), ])
rejilla <- rejilla |>
  bind_cols(as_tibble(predict(m9, newdata = rejilla, interval = "confidence"))) |>
  mutate(grupo = if_else(comedy == 1, "Comedias", "Otros géneros"))

puntos <- hollywood |>
  mutate(ajustada = us_gross - as.matrix(hollywood[setdiff(vars_m8, "critics")]) %*%
           coef(m9)[setdiff(vars_m8, "critics")] +
           sum(unlist(promedios) * coef(m9)[setdiff(vars_m8, "critics")]),
         grupo = if_else(comedy == 1, "Comedias", "Otros géneros"))

g9 <- ggplot(rejilla, aes(x = critics, y = fit, color = grupo, fill = grupo)) +
  geom_ribbon(aes(ymin = lwr, ymax = upr), alpha = 0.10, color = NA) +
  geom_point(data = puntos, aes(y = ajustada), alpha = 0.55, size = 1.6) +
  geom_line(linewidth = 1) +
  scale_color_manual(values = c(Comedias = rojo, `Otros géneros` = "grey45")) +
  scale_fill_manual(values = c(Comedias = rojo, `Otros géneros` = "grey45")) +
  scale_y_continuous(labels = millones) +
  labs(title = "La crítica pesa parecido en comedias y en el resto",
       subtitle = "Pregunta 9. Taquilla ajustada por presupuesto, clasificación R y estreno. Las rectas no se distinguen",
       x = "Nota de la crítica (Metacritic, 0 a 100)",
       y = "Taquilla total en EE. UU., ajustada", color = NULL, fill = NULL,
       caption = fuente) +
  tema_hw +
  theme(legend.position = "top")
guardar(g9, "q9_critica_por_genero.png")

#### Pregunta 10: estrellas contra presupuesto ####

q10 <- tabla_coef(m9) |>
  filter(termino == "budget") |>
  mutate(lectura = "Dolares de taquilla en EE. UU. por cada dolar adicional de presupuesto")
write_csv(q10, "output/tables/q10_coeficiente_presupuesto_actual.csv")

cat("Preguntas 9 y 10 listas\n")
