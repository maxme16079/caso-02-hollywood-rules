# Caso 2: Hollywood Rules
## Respuestas a la pregunta 7 (literales a, b y g)

**Curso:** Analítica de los Negocios (BA-2630)
**Profesor:** Juan Nicolás Velásquez Rey
**Equipo:** Maximo van Fulpen, Helen Sofía Castiblanco, Camilo Hernández
**Autora de esta sección:** Helen Sofía Castiblanco
**Fecha:** 9 de octubre de 2026

Los cálculos están en `R/02_regla_del_25.R`. Por indicación del profesor se
responden los literales a, b y g, que usan regresión lineal simple y R².

## 7) La regla de que el estreno es el 25 % del total

**a.** Se estimó una regresión lineal simple de la taquilla total en EE. UU.
sobre la taquilla del fin de semana de estreno con las 75 películas.

**Tabla 6.** Regresión de la taquilla total en EE. UU. sobre la taquilla de estreno

| Término | Coeficiente | Error estándar | t | p valor | IC 95 % |
|---|---|---|---|---|---|
| Intercepto (USD) | 5.108.220 | 4.502.660 | 1,13 | 0,260 | -3,9 M a 14,1 M |
| Taquilla de estreno | 3,1206 | 0,2181 | 14,31 | < 0,001 | 2,686 a 3,555 |

La recta estimada es taquilla total = 5.108.220 + 3,1206 x estreno.

Cada dólar adicional en el fin de semana de estreno se asocia en promedio con
3,12 dólares más de taquilla total en EE. UU. Un estreno 10 millones más alto se
asocia con unos 31,2 millones más en el total.

El intercepto no es significativamente distinto de cero con un p valor de 0,26.
Tampoco tiene una lectura útil, porque ninguna película estrena con cero
dólares.

![](output/figures/q7_total_vs_estreno.png)

**Figura 4.** Taquilla total en EE. UU. contra taquilla de estreno, con la recta estimada y la regla del 25 %

**b.** Si el estreno fuera el 25 % del total, la taquilla total sería el estreno
dividido entre 0,25. Eso es lo mismo que 4 veces el estreno. La pendiente
tendría que ser 4 y el intercepto tendría que ser cero.

La pendiente estimada es 3,12 y todo su intervalo del 95 % queda por debajo de
4. En la gráfica la línea roja de la regla pasa por encima de la mayoría de las
películas, sobre todo de las que tuvieron un estreno grande.

Con una pendiente de 3,12 el estreno equivale en el margen a cerca del 32 % del
total, que es 1 dividido entre 3,12. El estreno pesa más de lo que dice la
regla.

**c a f.** Se omiten por indicación del profesor.

**g.** El R² de la regresión es 0,737. El 73,7 % de la variación de la
taquilla total en EE. UU. se explica por la variación de la taquilla del fin de
semana de estreno.

El 26,3 % restante corresponde a otros factores. Entre ellos están los que
actúan después del primer fin de semana, como la crítica, el voz a voz y la
competencia en cartelera.

**Tabla 7.** Ajuste de la regresión simple

| Medida | Valor |
|---|---|
| Observaciones | 75 |
| R² | 0,737 |
| R² ajustado | 0,734 |
| Error estándar de la regresión (USD) | 20.788.800 |
| Estadístico F (1, 73) | 204,8 |
| p valor de F | < 0,001 |

Para Meyer la lectura es directa. El primer fin de semana anticipa casi tres
cuartas partes de lo que va a recaudar una película en EE. UU. Es la señal más
temprana y más confiable para saber cómo va cada película del portafolio.
