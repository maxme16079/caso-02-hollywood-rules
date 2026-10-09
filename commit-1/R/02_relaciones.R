# Caso 1 - Web Analytics at Quality Alloys, Inc.
# Preguntas 5 a 7: relaciones entre variables
# Autor: Helen Sofia Castiblanco

source("R/00_setup.R")

# ---- Pregunta 5: ingresos contra libras vendidas ----
cor_revenue_lbs <- cor(qa$revenue, qa$lbs_sold)

g5 <- ggplot(qa, aes(x = lbs_sold, y = revenue)) +
  geom_point(color = "grey40", size = 2) +
  geom_smooth(method = "lm", se = FALSE, color = "#1f6feb", linewidth = 0.7) +
  scale_x_continuous(labels = scales::comma) +
  scale_y_continuous(labels = scales::comma) +
  labs(title = "Ingresos contra libras vendidas",
       subtitle = paste0("66 semanas. Coeficiente de correlacion r = ",
                         round(cor_revenue_lbs, 4)),
       x = "Libras vendidas por semana", y = "Ingresos por semana (USD)") +
  tema_qa
guardar(g5, "q5_ingresos_vs_libras.png", ancho = 7, alto = 5)

# ---- Pregunta 6: ingresos contra visitas ----
cor_revenue_visits <- cor(qa$revenue, qa$visits)

g6 <- ggplot(qa, aes(x = visits, y = revenue)) +
  geom_point(color = "grey40", size = 2) +
  geom_smooth(method = "lm", se = FALSE, color = "#1f6feb", linewidth = 0.7) +
  scale_x_continuous(labels = scales::comma) +
  scale_y_continuous(labels = scales::comma) +
  labs(title = "Ingresos contra visitas al sitio web",
       subtitle = paste0("66 semanas. Coeficiente de correlacion r = ",
                         round(cor_revenue_visits, 4)),
       x = "Visitas por semana", y = "Ingresos por semana (USD)") +
  tema_qa
guardar(g6, "q6_ingresos_vs_visitas.png", ancho = 7, alto = 5)

# El mismo grafico separado por periodo, para ver si la relacion cambia de
# signo dentro de cada tramo
g6b <- ggplot(qa, aes(x = visits, y = revenue)) +
  geom_point(color = "grey40", size = 1.8) +
  geom_smooth(method = "lm", se = FALSE, color = "#1f6feb", linewidth = 0.7) +
  facet_wrap(~ periodo, scales = "free") +
  scale_x_continuous(labels = scales::comma) +
  scale_y_continuous(labels = scales::comma) +
  labs(title = "Ingresos contra visitas, por periodo",
       subtitle = "La relacion no se sostiene dentro de ningun periodo",
       x = "Visitas por semana", y = "Ingresos por semana (USD)") +
  tema_qa
guardar(g6b, "q6_ingresos_vs_visitas_por_periodo.png", ancho = 9, alto = 6)

# ---- Pregunta 7: matriz de correlaciones ----
variables <- qa |>
  select(visits, unique_visits, pageviews, pages_visit, avg_time, bounce_rate,
         pct_new, revenue, profit, lbs_sold, inquiries)

matriz_cor <- cor(variables)

matriz_cor |>
  as_tibble(rownames = "variable") |>
  write_csv("output/tables/q7_matriz_correlaciones.csv")

# Correlaciones dentro de cada periodo para las dos parejas de interes
cor_por_periodo <- qa |>
  group_by(periodo) |>
  summarise(r_revenue_visits = cor(revenue, visits),
            r_revenue_lbs = cor(revenue, lbs_sold),
            r_profit_visits = cor(profit, visits),
            r_inquiries_visits = cor(inquiries, visits),
            .groups = "drop")

write_csv(cor_por_periodo, "output/tables/q7_correlaciones_por_periodo.csv")

# Mapa de calor de la matriz, en escala divergente porque hay signos opuestos
g7 <- matriz_cor |>
  as_tibble(rownames = "var_x") |>
  pivot_longer(cols = -var_x, names_to = "var_y", values_to = "r") |>
  ggplot(aes(x = var_x, y = var_y, fill = r)) +
  geom_tile(color = "white") +
  geom_text(aes(label = round(r, 2)), size = 2.6) +
  scale_fill_gradient2(low = "#b2182b", mid = "grey95", high = "#1f6feb",
                       midpoint = 0, limits = c(-1, 1)) +
  labs(title = "Matriz de correlaciones de las variables semanales",
       subtitle = "66 semanas, mayo 2008 a agosto 2009",
       x = NULL, y = NULL, fill = "r") +
  tema_qa +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))
guardar(g7, "q7_matriz_correlaciones.png", ancho = 8, alto = 7)

cat("r(revenue, lbs_sold) =", round(cor_revenue_lbs, 4), "\n")
cat("r(revenue, visits)   =", round(cor_revenue_visits, 4), "\n")
print(cor_por_periodo)
print(round(matriz_cor[c("revenue", "profit", "lbs_sold", "inquiries"), c("visits", "unique_visits", "pageviews", "avg_time", "bounce_rate")], 4))
