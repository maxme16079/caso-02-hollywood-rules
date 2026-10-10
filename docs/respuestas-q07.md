# Caso 2: Hollywood Rules
## Respuestas a la pregunta 7 (literales a, b y g)

**Curso:** Analítica de los Negocios (BA-2630)
**Profesor:** Juan Nicolás Velásquez Rey
**Equipo:** Maximo van Fulpen, Helen Sofía Castiblanco, Camilo Hernández
**Autora de esta sección:** Helen Sofía Castiblanco
**Fecha:** 9 de octubre de 2026

Cálculos en `R/02_regla_del_25.R`. Por indicación del profesor solo se
responden los literales a, b y g, que usan regresión lineal simple y R².

## 7) La regla de que el estreno es el 25 % del total

**a.** Se estimó una regresión lineal simple de la taquilla total en EE. UU.
sobre la taquilla del fin de semana de estreno, con las 75 películas.

**Tabla 5.** Regresión de la taquilla total en EE. UU. sobre la taquilla de estreno

| Término | Coeficiente | Error estándar | t | p-valor | IC 95 % |
|---|---|---|---|---|---|
| Intercepto (USD) | 5.108.220 | 4.502.660 | 1,13 | 0,260 | -3,9 M a 14,1 M |
| Taquilla de estreno | 3,1206 | 0,2181 | 14,31 | < 0,001 | 2,686 a 3,555 |

taquilla EE. UU. = 5.108.220 + 3,1206 x estreno

La pendiente dice que cada dólar adicional recaudado en el fin de semana de
estreno se asocia en promedio con 3,12 dólares más de taquilla total en EE. UU.
Dicho de otra forma, un estreno 10 millones más alto se asocia con unos 31,2
millones más de taquilla total. El intercepto no es significativamente distinto
de cero (p = 0,26) y no tiene una lectura útil, porque ninguna película estrena
con cero dólares.

![](output/figures/q7_total_vs_estreno.png)

**Figura 4.** Taquilla total en EE. UU. contra taquilla de estreno, con la recta estimada y la regla del 25 %

**b.** Si el estreno fuera el 25 % del total, la taquilla total sería el estreno
dividido entre 0,25, o sea 4 veces el estreno:

total = estreno / 0,25 = 4 x estreno

Así que la pendiente de la regresión tendría que ser **4**, con un intercepto
de cero. La pendiente estimada es 3,12, menor que 4, y todo su intervalo del
95 % (2,69 a 3,56) queda por debajo de ese valor. En la gráfica se ve que la
línea roja de la regla pasa por encima de la mayoría de las películas, sobre
todo de las de estreno grande. Una pendiente de 3,12 quiere decir que, en el
margen, el estreno pesa más del 25 % del total, cerca del 32 % (1 / 3,12).

**c. a f.** Se omiten por indicación del profesor.

**g.** El R² de la regresión es **0,737**. El 73,7 % de la variación de la
taquilla total en EE. UU. entre películas se explica por la variación de la
taquilla del fin de semana de estreno. El 26,3 % restante no lo explica el
estreno y corresponde a otros factores, por ejemplo lo que pasa después del
primer fin de semana, como la crítica, el voz a voz o la competencia en
cartelera.

**Tabla 6.** Ajuste de la regresión simple

| Medida | Valor |
|---|---|
| Observaciones | 75 |
| R² | 0,737 |
| R² ajustado | 0,734 |
| Error estándar de la regresión (USD) | 20.788.800 |
| Estadístico F (1, 73) | 204,8 |
| p-valor de F | < 0,001 |

Para Meyer la lectura es directa. El primer fin de semana define casi tres
cuartas partes de lo que va a pasar con una película en EE. UU., así que es la
señal más temprana y más confiable que tiene un inversionista para saber cómo
va cada película del portafolio.
