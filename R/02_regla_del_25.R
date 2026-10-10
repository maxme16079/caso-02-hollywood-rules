# Caso 2 - Hollywood Rules
# Pregunta 7 (literales a, b y g): regresion simple de la taquilla total en
# EE. UU. sobre la taquilla del fin de semana de estreno y la regla del 25 %

source("R/00_setup.R")

#### Pregunta 7a: regresion lineal simple ####

m7 <- lm(us_gross ~ opening, data = hollywood)
write_csv(tabla_coef(m7), "output/tables/q7a_regresion_simple.csv")

#### Pregunta 7b: pendiente que implica la regla del 25 % ####

# Si el estreno es el 25 % del total, total = estreno / 0,25 = 4 x estreno
q7b <- tibble(pendiente_regla = 1 / 0.25,
              intercepto_regla = 0,
              pendiente_estimada = coef(m7)[["opening"]],
              participacion_implicita = 1 / coef(m7)[["opening"]])
write_csv(q7b, "output/tables/q7b_pendiente_regla.csv")

#### Pregunta 7g: proporcion de la variacion explicada ####

write_csv(ajuste(m7, "q7 lineal simple"), "output/tables/q7g_ajuste.csv")

g7 <- ggplot(hollywood, aes(x = opening, y = us_gross)) +
  geom_abline(intercept = 0, slope = 4, color = rojo, linetype = "dashed",
              linewidth = 0.8) +
  geom_point(color = "grey55", size = 1.8) +
  geom_smooth(method = "lm", formula = y ~ x, se = FALSE, color = azul,
              linewidth = 0.9) +
  annotate("text", x = 3.0e7, y = 4 * 3.0e7, label = "Regla del 25 %: total = 4 x estreno",
           color = rojo, hjust = 1.15, size = 3.3) +
  annotate("text", x = 6.8e7, y = coef(m7)[1] + coef(m7)[2] * 6.8e7 - 7e7,
           label = "Recta estimada: pendiente 3,12", color = azul,
           hjust = 1, vjust = 2, size = 3.3) +
  scale_x_continuous(labels = millones) +
  scale_y_continuous(labels = millones) +
  labs(title = "La recta estimada queda por debajo de la regla del 25 %",
       subtitle = "Cada punto es una película. Pendiente estimada 3,12 contra 4 de la regla. R² = 0,74",
       x = "Taquilla del fin de semana de estreno", y = "Taquilla total en EE. UU.",
       caption = fuente) +
  tema_hw
guardar(g7, "q7_total_vs_estreno.png")

cat("Pregunta 7 lista\n")
