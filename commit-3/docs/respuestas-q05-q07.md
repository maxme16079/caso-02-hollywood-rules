# Caso 1 — Web Analytics at Quality Alloys, Inc.
## Parte 2, segunda sección. Respuestas a las preguntas 5 a 7

**Curso:** Analítica de los Negocios (BA-2630) · **Profesor:** Juan Nicolás Velásquez Rey
**Equipo:** Máximo Van Fulpen · Helen Sofía Castiblanco · Camilo Hernández
**Autor de esta sección:** Helen Sofía Castiblanco
**Fecha:** 2 de septiembre de 2026

Cálculos en `R/02_relaciones.R`. La partición en periodos se documenta en
`docs/respuestas-q01-q04.md` y se define en `R/00_setup.R`.

---

## 5) Ingresos contra libras vendidas

`output/figures/q5_ingresos_vs_libras.png`

**r = 0,8689.** Relación positiva y fuerte, como dictaba la intuición: la
facturación es esencialmente precio por cantidad, así que las dos variables
miden casi lo mismo. Que no sea 1,0 se explica por los cambios de precio y de
mezcla de producto entre semanas. La relación se sostiene dentro de los cuatro
periodos por separado (r entre 0,834 y 0,962,
`output/tables/q7_correlaciones_por_periodo.csv`), lo que confirma que es
estructural y no un efecto de agregación.

## 6) Ingresos contra visitas

`output/figures/q6_ingresos_vs_visitas.png`

**r = −0,0594.** Prácticamente cero, y con signo negativo. Era lo esperado
después de la pregunta 4: la nube de puntos no tiene pendiente. Las semanas de
más tráfico no son las de más ingresos.

Separando por periodo (`output/figures/q6_ingresos_vs_visitas_por_periodo.png`),
la correlación tampoco aparece: +0,200 en *initial*, +0,132 en *pre*, −0,030 en
*promotion* y +0,162 en *post*. Ninguna es significativa ni consistente en
signo. No es que la agregación esté escondiendo una relación: no hay relación
lineal en ningún tramo.

## 7) Síntesis de las relaciones entre variables

Matriz completa en `output/tables/q7_matriz_correlaciones.csv` y mapa de calor
en `output/figures/q7_matriz_correlaciones.png`.

| Pareja | r |
|---|---|
| Revenue – Lbs. Sold | 0,8689 |
| Revenue – Profit | 0,8872 |
| Revenue – Avg. Time on Site | 0,2380 |
| Revenue – Bounce Rate | −0,1557 |
| Inquiries – Visits | 0,1022 |
| Revenue – Visits | −0,0594 |
| Revenue – Unique Visits | −0,0692 |
| Revenue – Pageviews | 0,0354 |

**Implicación central: en el periodo analizado, el número de visitas al sitio no
sirve para explicar ni para predecir los ingresos de QA.** Un modelo de
regresión de ingresos sobre visitas explicaría el 0,35 % de la varianza
(r² = 0,0035). En términos de negocio: cada visita adicional no vale nada
medible en facturación.

Tres advertencias sobre esa lectura:

1. **Correlación cero no es prueba de que el sitio no sirva.** Es prueba de que
   *el conteo de visitas* no se traduce en ingresos. El sitio no tiene carrito de
   compras, así que la conversión es indirecta: visita → solicitud de cotización
   → llamada del comercial → orden, con rezago de semanas. Una correlación
   semanal contemporánea no puede capturar esa cadena.
2. **La correlación mide relación lineal.** Podría existir una relación no
   lineal, o un efecto de umbral, que r no detecta.
3. **Correlación no implica causalidad**, ni en un sentido ni en el otro. Aquí lo
   que hay es una variable omitida que mueve ambas series: la recesión.

Las correlaciones que sí informan son otras. `Avg. Time on Site` correlaciona
más con ingresos (0,238) que las visitas, y `Bounce Rate` lo hace en negativo
(−0,156). Débiles las dos, pero apuntan en la dirección correcta: importa el
tráfico que se queda, no el que entra. Y `Inquiries – Visits` = 0,102 muestra
que ni siquiera el paso intermedio del embudo responde al volumen de tráfico.

