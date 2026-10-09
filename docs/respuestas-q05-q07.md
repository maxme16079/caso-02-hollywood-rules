# Caso 2: Hollywood Rules
## Parte 2, segunda sección. Respuestas a las preguntas 5 a 7

**Curso:** Analítica de los Negocios (BA-2630)
**Profesor:** Juan Nicolás Velásquez Rey
**Equipo:** Maximo van Fulpen, Helen Sofía Castiblanco, Camilo Hernández
**Autora de esta sección:** Helen Sofía Castiblanco
**Fecha:** 7 de octubre de 2026

Cálculos en `R/02_regresiones_antes_del_estreno.R`. La eliminación de variables
de las partes (b) se hace con la función `eliminacion_atras()` de
reestima, hasta que todas son significativas al 10 %. Se quita de a una porque
los p-valores cambian cada vez que sale una variable.

## 5) Taquilla en EE. UU. con lo que se sabe antes de producir

**a.** El enunciado nombra cuatro creencias: presupuesto, género (comedia o no),
clasificación (R o no) y familiaridad con la historia. La familiaridad la miden
dos variables del caso, secuela e historia conocida, así que el modelo tiene
cinco regresores:

taquilla EE. UU. = β0 + β1 presupuesto + β2 comedia + β3 R + β4 secuela + β5 historia conocida + ε

| Variable | Coeficiente | p-valor |
|---|---|---|
| Intercepto | 12.225.020 | 0,249 |
| Presupuesto | 0,897 | < 0,001 |
| Comedia | 14.758.022 | 0,103 |
| R | -4.156.467 | 0,688 |
| Secuela | 29.166.707 | 0,025 |
| Historia conocida | -9.977.764 | 0,230 |

R² = 0,355, R² ajustado = 0,309, n = 75

**b.** Primero sale R (p = 0,688) y después historia conocida (p = 0,211 al
reestimar). Al quitar esas dos, la comedia baja de 0,103 a 0,049 y se queda.
Modelo final:

| Variable | Coeficiente | IC 95 % | p-valor |
|---|---|---|---|
| Intercepto | 7.130.031 | -12,2 M a 26,4 M | 0,464 |
| Presupuesto | 0,892 | 0,563 a 1,221 | < 0,001 |
| Comedia | 16.814.807 | 0,07 M a 33,6 M | 0,049 |
| Secuela | 31.666.730 | 6,7 M a 56,7 M | 0,014 |

R² = 0,339, R² ajustado = 0,311, prueba F p < 0,001

taquilla EE. UU. = 7.130.031 + 0,892 presupuesto + 16.814.807 comedia + 31.666.730 secuela

Cada dólar adicional de presupuesto se asocia con 89 centavos más de taquilla en
EE. UU. Antes de producir, el modelo explica apenas un tercio de la variación de
la taquilla. El resto depende de cosas que todavía no se saben.

**c.** Manteniendo fijos el presupuesto y el género, las secuelas recaudan más:
en promedio 31,7 millones más que una película que no lo es, con un intervalo
del 95 % de 6,7 a 56,7 millones. Es la lección que Meyer aprendió a la mala con
*Spider-Man 3*, *Shrek the Third* y *Pirates of the Caribbean*.

![](output/figures/q5_coeficientes_modelo_final.png)

## 6) Taquilla del fin de semana de estreno

**a.** Se suman a los cinco factores de preproducción los cuatro del estreno:
verano, festivo, Navidad y número de salas. Con las nueve variables el R²
ajustado es 0,458. Solo presupuesto, secuela, salas y verano salen
significativos al 10 % en ese modelo completo.

**b.** La eliminación saca seis variables en este orden: festivo (p = 0,967), R
(0,812), comedia (0,644), Navidad (0,211), historia conocida (0,169) y verano,
que en el último paso tiene p = 0,110. Modelo final:

| Variable | Coeficiente | IC 95 % | p-valor |
|---|---|---|---|
| Intercepto | -10.357.245 | -18,5 M a -2,3 M | 0,013 |
| Presupuesto | 0,1138 | 0,0305 a 0,1971 | 0,008 |
| Secuela | 9.095.872 | 2,7 M a 15,5 M | 0,006 |
| Salas | 7.681 | 4.767 a 10.595 | < 0,001 |

R² = 0,479, R² ajustado = 0,456, prueba F p < 0,001

estreno = -10.357.245 + 0,1138 presupuesto + 9.095.872 secuela + 7.681 salas

Llama la atención que ninguna de las variables de fecha sobrevive. Una vez
se controla por las salas, estrenar en verano, en festivo o en Navidad no cambia
la taquilla del primer fin de semana. Una explicación es que los estudios ya
programan sus apuestas grandes en esas fechas y les dan más salas, así que el
efecto de la fecha queda absorbido por las salas.

**c.** Interpretación de cada pendiente, manteniendo fijas las demás variables:

- **Presupuesto:** cada dólar adicional de presupuesto se asocia con 0,11 dólares
  más de taquilla en el estreno. Diez millones más de presupuesto equivalen a
  unos 1,14 millones más en el primer fin de semana.
- **Secuela:** una secuela abre en promedio con 9,1 millones más que una
  película que no lo es, con el mismo presupuesto y el mismo número de salas.
- **Salas:** cada sala adicional se asocia con 7.681 dólares más de taquilla en
  el estreno.

El intercepto no tiene lectura útil, porque ninguna película se estrena con cero
salas ni con presupuesto cero.

**d.** Si las salas aumentan en cien, el cambio esperado en la taquilla del
estreno es 100 x 7.681:

Estimación puntual: 768.101 dólares. IC del 95 %: de 476.688 a 1.059.515 dólares.

![](output/figures/q6_coeficientes_modelo_final.png)

## 7) La regla de que el estreno es el 25 % del total

**a.** Regresión simple:

taquilla EE. UU. = 5.108.220 + 3,1206 estreno

La pendiente tiene error estándar de 0,2181 (p < 0,001) y el R² es 0,737.

**b.** Si el estreno fuera el 25 % del total, el total sería 4 veces el estreno.
La pendiente tendría que ser 4, y el intercepto cero.

**c.** H0: β1 = 4 contra H1: β1 ≠ 4.
t = (3,1206 - 4) / 0,2181 = -4,03, con 73 grados de libertad y p = 0,0001.
Según esta regresión se rechaza la regla: la pendiente es menor que 4.

**d.** La prueba anterior tiene un problema serio. Los errores de la regresión
no tienen varianza constante. Crecen con el tamaño del estreno, como se ve en
la forma de embudo de los residuos. La desviación estándar de los residuos es
17,5 millones en el tercio de estrenos más pequeños, 15,0 en el del medio y 27,9
en el de los más grandes. La prueba de Breusch-Pagan lo confirma al 10 %
(estadístico 3,55, p = 0,060). Con heterocedasticidad los errores estándar de
mínimos cuadrados no son confiables, y con ellos tampoco la t de la parte (c).

Esto no es casualidad. La regla misma dice que el total es *proporcional* al
estreno, y en una relación proporcional el error también crece con la escala:
equivocarse en 20 % con una película de 200 millones es mucho más que con una
de 20. Además, unas pocas películas grandes pesan mucho en la recta, y la prueba
de (c) solo mira la pendiente, sin exigir el intercepto cero que la regla
también implica. Con errores robustos a heterocedasticidad (HC1) la conclusión
se mantiene (t = -3,20, p = 0,002), pero el modelo sigue mal planteado para la
pregunta.

![](output/figures/q7a_total_vs_estreno.png)

![](output/figures/q7d_residuos_regresion_simple.png)

**e.** Si la regla dice total = 4 x estreno, tomando logaritmos queda
ln(total) = ln(4) + 1 x ln(estreno). Por eso el modelo adecuado es log-log:

ln(taquilla EE. UU.) = 1,576 + 0,9766 ln(estreno)

En logaritmos la varianza se estabiliza (Breusch-Pagan p = 0,169) y el R² es
0,751. La pendiente se lee como elasticidad: un estreno 1 % más alto se asocia
con un total 0,98 % más alto.

**f.** La regla implica dos cosas: pendiente 1 e intercepto ln(4) = 1,386.

- Pendiente = 1: t = -0,36, p = 0,723. No se rechaza.
- Intercepto = 1,386: t = 0,17, p = 0,862. No se rechaza.
- Las dos a la vez (prueba F): F = 13,50 con (2, 73) grados de libertad,
  p < 0,001. Se rechaza.

No es una contradicción. En logaritmos el estreno vale cerca de 16,5, lejos del
cero, así que el intercepto y la pendiente están muy correlacionados y cada uno
por separado queda con un error estándar enorme. La prueba conjunta es la que
responde la pregunta.

Como la pendiente no se distingue de 1, se puede imponer y estimar solo el
multiplicador. El total en EE. UU. es 3,29 veces el estreno (IC 95 % de 3,05
a 3,54), no 4. Dicho de otra forma, el fin de semana de estreno aporta el
30,4 % del total (IC 95 % de 28,2 % a 32,8 %), y el 25 % queda por fuera del
intervalo (t = -5,22, p < 0,001).

La parte proporcional de la sabiduría popular es cierta, y la cifra no. El
estreno pesa todavía más de lo que dice la regla. En los datos crudos el estreno
es en promedio el 31,9 % del total de cada película, lo que confirma el
resultado.

![](output/figures/q7e_log_log.png)

**g.** El 73,7 % de la variación de la taquilla total en EE. UU. se explica por
la variación de la taquilla del estreno (R² de la regresión simple). En el
modelo log-log, el 75,1 % de la variación del logaritmo del total.
