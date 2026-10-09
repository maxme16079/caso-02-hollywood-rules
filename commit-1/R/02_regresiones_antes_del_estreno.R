# Caso 2 - Hollywood Rules
# Preguntas 5 a 7: regresiones con lo que se sabe antes de producir y antes
# del fin de semana de estreno, y la regla del 25 %

source("R/00_setup.R")

grafica_coef <- function(modelo, etiquetas, escala = 1, titulo, subtitulo, eje) {
  tabla_coef(modelo) |>
    filter(termino != "(Intercept)") |>
    mutate(across(c(coef, ic95_inf, ic95_sup), \(x) x * escala[termino]),
           termino = factor(etiquetas[termino], levels = rev(etiquetas[termino]))) |>
    ggplot(aes(x = coef, y = termino)) +
    geom_vline(xintercept = 0, color = "grey50") +
    geom_errorbar(aes(xmin = ic95_inf, xmax = ic95_sup), width = 0.2,
                  orientation = "y", color = gris) +
    geom_point(size = 2.8, color = azul) +
    labs(title = titulo, subtitle = subtitulo, x = eje, y = NULL, caption = fuente) +
    tema_hw
}

#### Pregunta 5: taquilla en EE. UU. con lo que se sabe antes de producir ####

m5_completo <- lm(us_gross ~ budget + comedy + r_rated + sequel + known_story,
                  data = hollywood)

e5 <- eliminacion_atras(hollywood, "us_gross", vars_preproduccion)
m5_final <- e5$modelo

write_csv(tabla_coef(m5_completo), "output/tables/q5a_modelo_completo.csv")
write_csv(e5$pasos, "output/tables/q5b_pasos_eliminacion.csv")
write_csv(tabla_coef(m5_final), "output/tables/q5b_modelo_final.csv")

g5 <- grafica_coef(
  m5_final,
  etiquetas = c(budget = "Presupuesto (por cada USD 10 M)", comedy = "Comedia",
                sequel = "Secuela"),
  escala = c(budget = 1e7, comedy = 1, sequel = 1) / 1e6,
  titulo = "Antes de producir, pesan el presupuesto, la secuela y la comedia",
  subtitulo = "Modelo final de la pregunta 5. Efecto sobre la taquilla en EE. UU. con IC del 95 %",
  eje = "Cambio en la taquilla total en EE. UU. (USD millones)"
)
guardar(g5, "q5_coeficientes_modelo_final.png", ancho = 8, alto = 3.8)

#### Pregunta 6: taquilla del fin de semana de estreno ####

m6_completo <- lm(reformulate(c(vars_preproduccion, vars_estreno), "opening"),
                  data = hollywood)
e6 <- eliminacion_atras(hollywood, "opening", c(vars_preproduccion, vars_estreno))
m6_final <- e6$modelo

write_csv(tabla_coef(m6_completo), "output/tables/q6a_modelo_completo.csv")
write_csv(e6$pasos, "output/tables/q6b_pasos_eliminacion.csv")
write_csv(tabla_coef(m6_final), "output/tables/q6b_modelo_final.csv")

coef_salas <- tabla_coef(m6_final) |> filter(termino == "theatres")
q6d <- tibble(cambio_salas = 100,
              estimacion = 100 * coef_salas$coef,
              ic95_inf = 100 * coef_salas$ic95_inf,
              ic95_sup = 100 * coef_salas$ic95_sup)
write_csv(q6d, "output/tables/q6d_cien_salas_mas.csv")

etiquetas6 <- c(budget = "Presupuesto (por cada USD 10 M)", sequel = "Secuela",
                summer = "Estreno en verano", theatres = "Salas (por cada 100)")
escala6 <- c(budget = 1e7, sequel = 1, summer = 1, theatres = 100) / 1e6
g6 <- grafica_coef(
  m6_final, etiquetas = etiquetas6[names(coef(m6_final))[-1]],
  escala = escala6[names(coef(m6_final))[-1]],
  titulo = "El estreno lo mueven las salas, la secuela y el presupuesto",
  subtitulo = "Modelo final de la pregunta 6. Efecto sobre la taquilla de estreno, con IC del 95 %",
  eje = "Cambio en la taquilla del fin de semana de estreno (USD millones)"
)
guardar(g6, "q6_coeficientes_modelo_final.png", ancho = 8, alto = 3.8)

#### Pregunta 7: la regla de que el estreno es el 25 % del total ####

m7 <- lm(us_gross ~ opening, data = hollywood)
write_csv(tabla_coef(m7), "output/tables/q7a_regresion_simple.csv")

b7 <- coef(summary(m7))["opening", ]
t7 <- (b7["Estimate"] - 4) / b7["Std. Error"]
p7 <- 2 * pt(-abs(t7), df = df.residual(m7))

aux <- lm(residuals(m7)^2 ~ hollywood$opening)
bp_estadistico <- nobs(m7) * summary(aux)$r.squared
bp_p <- pchisq(bp_estadistico, df = 1, lower.tail = FALSE)

X <- model.matrix(m7)
e <- residuals(m7)
pan <- solve(crossprod(X))
v_robusta <- pan %*% crossprod(X * e) %*% pan * nrow(X) / (nrow(X) - ncol(X))
ee_robusto <- sqrt(diag(v_robusta))["opening"]
t7_robusto <- (b7["Estimate"] - 4) / ee_robusto
p7_robusto <- 2 * pt(-abs(t7_robusto), df = df.residual(m7))

residuos_tercios <- hollywood |>
  mutate(residuo = residuals(m7),
         tercio = ntile(opening, 3)) |>
  group_by(tercio) |>
  summarise(estreno_min = min(opening), estreno_max = max(opening),
            desv_residuo = sd(residuo), .groups = "drop")
write_csv(residuos_tercios, "output/tables/q7d_residuos_por_tercio.csv")

m7_log <- lm(log(us_gross) ~ log(opening), data = hollywood)
write_csv(tabla_coef(m7_log), "output/tables/q7e_regresion_log_log.csv")

aux_log <- lm(residuals(m7_log)^2 ~ log(hollywood$opening))
bp_log_estadistico <- nobs(m7_log) * summary(aux_log)$r.squared
bp_log_p <- pchisq(bp_log_estadistico, df = 1, lower.tail = FALSE)

bl <- coef(summary(m7_log))
t_pend <- (bl[2, "Estimate"] - 1) / bl[2, "Std. Error"]
t_int <- (bl[1, "Estimate"] - log(4)) / bl[1, "Std. Error"]
sce_libre <- sum(residuals(m7_log)^2)
sce_restringido <- sum((log(hollywood$us_gross) - log(hollywood$opening) - log(4))^2)
f_conjunta <- ((sce_restringido - sce_libre) / 2) / (sce_libre / df.residual(m7_log))
p_conjunta <- pf(f_conjunta, 2, df.residual(m7_log), lower.tail = FALSE)

m7_prop <- lm(log(us_gross / opening) ~ 1, data = hollywood)
c_prop <- coef(m7_prop)[1]
ic_prop <- confint(m7_prop)[1, ]
t_prop <- (c_prop - log(4)) / coef(summary(m7_prop))[1, "Std. Error"]
p_prop <- 2 * pt(-abs(t_prop), df = df.residual(m7_prop))

q7_multiplicador <- tibble(
  multiplicador = exp(c_prop), mult_ic95_inf = exp(ic_prop[1]),
  mult_ic95_sup = exp(ic_prop[2]),
  participacion_estreno = 1 / exp(c_prop),
  part_ic95_inf = 1 / exp(ic_prop[2]), part_ic95_sup = 1 / exp(ic_prop[1]),
  t_vs_ln4 = t_prop, p_valor = p_prop
)
write_csv(q7_multiplicador, "output/tables/q7f_multiplicador_estreno.csv")

participacion <- hollywood$opening / hollywood$us_gross

q7 <- tibble(
  prueba = c("7c pendiente = 4 (modelo lineal)",
             "7d pendiente = 4 con error robusto HC1",
             "7d Breusch-Pagan modelo lineal",
             "7d Breusch-Pagan modelo log-log",
             "7f pendiente = 1 (log-log)",
             "7f intercepto = ln(4) (log-log)",
             "7f conjunta pendiente = 1 e intercepto = ln(4)",
             "7f multiplicador = 4 con pendiente 1 impuesta"),
  estimado = c(b7["Estimate"], b7["Estimate"], NA, NA, bl[2, "Estimate"],
               bl[1, "Estimate"], NA, exp(c_prop)),
  valor_hipotesis = c(4, 4, NA, NA, 1, log(4), NA, 4),
  estadistico = c(t7, t7_robusto, bp_estadistico, bp_log_estadistico, t_pend,
                  t_int, f_conjunta, t_prop),
  distribucion = c("t(73)", "t(73)", "chi2(1)", "chi2(1)", "t(73)", "t(73)",
                   "F(2, 73)", "t(74)"),
  p_valor = c(p7, p7_robusto, bp_p, bp_log_p,
              2 * pt(-abs(t_pend), 73), 2 * pt(-abs(t_int), 73), p_conjunta,
              p_prop)
)
write_csv(q7, "output/tables/q7_pruebas_regla_25.csv")

q7_participacion <- tibble(
  media = mean(participacion), mediana = median(participacion),
  minimo = min(participacion), maximo = max(participacion),
  implicita_log_log = 1 / exp(predict(m7_log, newdata = tibble(opening = mean(hollywood$opening))) -
                                log(mean(hollywood$opening)))
)
write_csv(q7_participacion, "output/tables/q7_participacion_estreno.csv")

write_csv(bind_rows(ajuste(m5_final, "q5 final"), ajuste(m6_final, "q6 final"),
                    ajuste(m7, "q7a lineal simple"), ajuste(m7_log, "q7e log-log")),
          "output/tables/q5_q7_ajuste_modelos.csv")

g7a <- ggplot(hollywood, aes(x = opening, y = us_gross)) +
  geom_abline(intercept = 0, slope = 4, color = rojo, linetype = "dashed",
              linewidth = 0.8) +
  geom_point(color = "grey55", size = 1.8) +
  geom_smooth(method = "lm", formula = y ~ x, se = FALSE, color = azul,
              linewidth = 0.9) +
  annotate("text", x = 3.0e7, y = 4 * 3.0e7, label = "Regla del 25 %: total = 4 x estreno",
           color = rojo, hjust = 1.15, size = 3.3) +
  annotate("text", x = 6.8e7, y = coef(m7)[1] + coef(m7)[2] * 6.8e7 - 4e7,
           label = "Recta estimada: pendiente 3,12", color = azul,
           hjust = 1, vjust = 2, size = 3.3) +
  scale_x_continuous(labels = millones) +
  scale_y_continuous(labels = millones) +
  labs(title = "La recta estimada queda por debajo de la regla del 25 %",
       subtitle = "Pregunta 7a a 7c. Cada punto es una película. La pendiente estimada es 3,12, no 4",
       x = "Taquilla del fin de semana de estreno", y = "Taquilla total en EE. UU.",
       caption = fuente) +
  tema_hw
guardar(g7a, "q7a_total_vs_estreno.png")

g7d <- tibble(estreno = hollywood$opening, residuo = residuals(m7)) |>
  ggplot(aes(x = estreno, y = residuo)) +
  geom_hline(yintercept = 0, color = "grey50") +
  geom_point(color = rojo, alpha = 0.7, size = 1.8) +
  scale_x_continuous(labels = millones) +
  scale_y_continuous(labels = millones) +
  labs(title = "Los errores crecen con el tamaño del estreno",
       subtitle = "Pregunta 7d. Residuos de la regresión simple. La forma de embudo es heterocedasticidad",
       x = "Taquilla del fin de semana de estreno", y = "Residuo",
       caption = fuente) +
  tema_hw
guardar(g7d, "q7d_residuos_regresion_simple.png")

g7e <- ggplot(hollywood, aes(x = opening, y = us_gross)) +
  geom_abline(intercept = log10(4), slope = 1, color = rojo, linetype = "dashed",
              linewidth = 0.8) +
  geom_point(color = "grey55", size = 1.8) +
  geom_smooth(method = "lm", formula = y ~ x, se = TRUE, color = azul,
              fill = azul, alpha = 0.12, linewidth = 0.9) +
  scale_x_log10(labels = millones) +
  scale_y_log10(labels = millones) +
  labs(title = "En escala logarítmica, la regla del 25 % queda por encima de los datos",
       subtitle = "Pregunta 7e y 7f. Pendiente 0,98 (compatible con 1), pero el total es 3,3 veces el estreno, no 4",
       x = "Taquilla del fin de semana de estreno (escala log)",
       y = "Taquilla total en EE. UU. (escala log)", caption = fuente) +
  tema_hw
guardar(g7e, "q7e_log_log.png")

cat("Preguntas 5 a 7 listas\n")
