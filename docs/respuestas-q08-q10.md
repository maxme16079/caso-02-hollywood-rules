# Caso 2: Hollywood Rules
## Parte 2, tercera sección. Respuestas a las preguntas 8 a 10

**Curso:** Analítica de los Negocios (BA-2630)
**Profesor:** Juan Nicolás Velásquez Rey
**Equipo:** Maximo van Fulpen, Helen Sofía Castiblanco, Camilo Hernández
**Autor de esta sección:** Camilo Hernández
**Fecha:** 7 de octubre de 2026

Cálculos en `R/03_despues_del_estreno.R` (pregunta 8) y
variables usa el mismo procedimiento de las preguntas 5 y 6: una variable a la
vez, la de mayor p-valor, hasta que todas son significativas al 10 %.

## 8) Taquilla total con todo lo que se sabe después del estreno

**a.** El modelo junta las once variables de los tres momentos: las cinco de
preproducción (presupuesto, comedia, R, secuela, historia conocida), las cuatro
del estreno (verano, festivo, Navidad, salas), la taquilla del estreno y la nota
de la crítica. No entran los Oscar, que se conocen meses después del estreno, ni
la taquilla fuera de EE. UU., que se acumula al mismo tiempo que lo que se
quiere predecir.

Con las once variables el R² es 0,838 y el R² ajustado 0,810. Solo cuatro son
significativas al 10 %: presupuesto (p = 0,020), R (0,092), estreno (< 0,001) y
crítica (< 0,001).

**b.** La eliminación saca siete variables en este orden: festivo (p = 0,862),
salas (0,736), Navidad (0,618), secuela (0,617), historia conocida (0,580),
verano (0,495) y comedia (0,190). Modelo final:

| Variable | Coeficiente | IC 95 % | p-valor |
|---|---|---|---|
| Intercepto | -30.038.070 | -44,3 M a -15,8 M | < 0,001 |
| Presupuesto | 0,2586 | 0,069 a 0,448 | 0,008 |
| R | -11.141.788 | -21,4 M a -0,8 M | 0,034 |
| Estreno | 2,8200 | 2,439 a 3,201 | < 0,001 |
| Crítica | 590.794 | 316.346 a 865.242 | < 0,001 |

R² = 0,830, R² ajustado = 0,821, prueba F p < 0,001

taquilla EE. UU. = -30.038.070 + 0,2586 presupuesto - 11.141.788 R + 2,82 estreno + 590.794 crítica

Las salas y la secuela, que eran decisivas para el estreno en la pregunta 6,
desaparecen aquí. Su efecto sobre el total pasa por el estreno, que ya está en
el modelo. Una vez se sabe cuánto hizo la película el primer fin de semana,
saber que era secuela no agrega información.

**c.** *Flags of Our Fathers* está en los datos: presupuesto de 90 millones,
calificada R, estreno de 10.245.190 dólares y crítica de 79. Con esas
características el modelo predice:

Estimación puntual: 57,7 millones. Intervalo de predicción del 95 %: de 21,5 a 93,8 millones.

Recaudó 33,6 millones, dentro del intervalo pero muy por debajo de la
estimación.

Si Meyer culpa a los críticos, la respuesta de Griffith es que los datos dicen
lo contrario. La película sacó 79 puntos, casi 30 por encima del promedio de la
muestra (50,6). Según el modelo eso le sumó unos 16,8 millones de taquilla
frente a una película con crítica promedio. El problema fue el estreno: abrió
con 10,2 millones, el 11 % de su presupuesto, cuando en la muestra el estreno es
en promedio el 40 % del presupuesto. Además se estrenó en 1.876 salas, muy por
debajo del promedio de 2.766, y la clasificación R le resta 11,1 millones.

![](output/figures/q8_real_vs_predicho.png)

**d.** Como el modelo es lineal, diez puntos más de crítica valen lo mismo para
cualquier película: 10 x 590.794.

Diez puntos más (de 79 a 89) se asocian con 5,9 millones más de taquilla en EE. UU.
(IC 95 % de 3,2 a 8,7 millones). Para una película como *Flags of Our Fathers*
la taquilla esperada pasa de 57,7 a 63,6 millones.

Pero Griffith no recibe la taquilla. Según el caso, el distribuidor arranca con
el 70 % y cede diez puntos al exhibidor cada dos semanas, así que a lo largo de
la temporada se queda con algo entre el 50 % y el 70 %:

| Escenario | Taquilla adicional | Al distribuidor (70 %) | Al distribuidor (50 %) |
|---|---|---|---|
| Estimación puntual | 5,9 M | 4,1 M | 3,0 M |
| Extremo bajo del IC 95 % | 3,2 M | 2,2 M | 1,6 M |

Recomendación: no pagar más de unos 3 millones por los diez puntos, y si se
quiere tener margen de seguridad, no más de 1,6 millones, que es lo que se
recupera aun en el escenario pesimista. Hay tres advertencias. El modelo mide
asociación, no causalidad: no garantiza que comprar puntos produzca la taquilla.
La cifra es ingreso bruto, sin descontar copias ni publicidad. Y la única forma
legítima de "influir" en la crítica es mejorar la película (guion, montaje,
funciones de prensa), porque pagar por reseñas es una falta ética que además
pondría en riesgo la reputación del estudio.

![](output/figures/q8d_efecto_parcial_critica.png)

## 9) ¿La crítica pesa menos en las comedias?

**a.** Al modelo final de la pregunta 8 se le agregan la dummy de comedia y su
interacción con la crítica. La dummy deja que las comedias tengan su propio
nivel y la interacción les da su propia pendiente de crítica. Si se pusiera solo
la interacción, absorbería cualquier diferencia de nivel y quedaría sesgada.

taquilla = β0 + β1 presupuesto + β2 R + β3 estreno + β4 crítica + β5 comedia + β6 (comedia x crítica) + ε

| Variable | Coeficiente | p-valor |
|---|---|---|
| Crítica | 684.020 | < 0,001 |
| Comedia | 16.674.724 | 0,251 |
| Comedia x crítica | -228.179 | 0,443 |

La teoría de Griffith es que la crítica pesa menos en las comedias, o sea que β6
es negativo. Como la teoría tiene dirección, la prueba es de una cola:

- H0: β6 ≥ 0
- H1: β6 < 0

t = -0,77 con 68 grados de libertad, p = 0,221. No se rechaza H0.

El signo va en la dirección que dice Griffith. Cada punto de crítica vale
684.020 dólares en las películas que no son comedia y 455.840 en las comedias.
Pero la diferencia de 228.179 tiene un error estándar de 295.577, más grande que
la diferencia misma. Con solo 23 comedias no hay datos para distinguirla del
azar. Tampoco mejora el modelo: la prueba F de las dos variables nuevas juntas
da p = 0,317, y el R² ajustado apenas se mueve (de 0,821 a 0,822).

La teoría de Griffith no se puede probar con estos datos. Lo correcto es
decir que no hay evidencia a favor, no que sea falsa.

![](output/figures/q9_critica_por_genero.png)

## 10) Estrellas contra presupuesto

**a.** Hoy el presupuesto tiene un coeficiente de 0,259 en el modelo de la
pregunta 9 (IC 95 % de 0,069 a 0,449, p = 0,008). Griffith dice que ese efecto no
es del presupuesto en sí sino de las estrellas que el presupuesto paga. Si se
agrega la variable "star power" (número de estrellas de primera línea), para que
tenga razón tienen que cumplirse dos cosas:

1. El coeficiente de star power debe ser positivo y significativo. Más
   estrellas, más taquilla, con el presupuesto fijo.
2. El coeficiente del presupuesto debe caer de forma importante, hacia cero,
   y dejar de ser significativo. Así, con el número de estrellas fijo, gastar más
   no agrega taquilla.

La lógica es la del sesgo por variable omitida. Hoy las estrellas no están en el
modelo, pero están correlacionadas positivamente con el presupuesto (cuestan 15
millones o más cada una) y, según Griffith, afectan positivamente la taquilla.
Entonces el coeficiente actual del presupuesto está inflado: recoge el efecto de
las estrellas que no se observan. Al incluirlas ese efecto se separa.

Si el coeficiente del presupuesto se mantiene parecido a 0,259 y significativo,
el presupuesto tiene efecto propio (efectos especiales, publicidad, producción)
y Griffith estaría equivocado. Una advertencia: si estrellas y presupuesto están
muy correlacionados, los dos errores estándar se inflan y el presupuesto puede
perder significancia sin que su coeficiente cambie mucho. Por eso hay que mirar
que el coeficiente caiga, no solo que su p-valor suba.
