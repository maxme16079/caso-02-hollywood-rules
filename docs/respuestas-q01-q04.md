# Caso 2: Hollywood Rules
## Parte 2, primera sección. Respuestas a las preguntas 1 a 4

**Curso:** Analítica de los Negocios (BA-2630)
**Profesor:** Juan Nicolás Velásquez Rey
**Equipo:** Maximo van Fulpen, Helen Sofía Castiblanco, Camilo Hernández
**Autor de esta sección:** Maximo van Fulpen
**Fecha:** 7 de octubre de 2026

Cálculos en `R/01_descriptivos_y_pruebas.R`. La carga de datos y las variables
derivadas (la dummy de comedia y el ROI) están en `R/00_setup.R`. Los datos son
las 75 películas de 2006 con presupuesto conocido entre USD 20 y 100 millones,
sin datos faltantes.

## 1) Panorama inicial de los datos

| Variable | Mínimo | Promedio | Máximo |
|---|---|---|---|
| Taquilla de estreno (USD) | 4.120.497 | 17.468.466 | 68.033.544 |
| Taquilla total EE. UU. (USD) | 13.090.630 | 59.620.651 | 198.000.317 |
| Taquilla fuera de EE. UU. (USD) | 0 | 59.560.983 | 456.235.122 |
| Salas en el estreno | 852 | 2.766 | 3.964 |

El estreno más flojo fue *One Night with the King* y el más fuerte *Ice Age: The
Meltdown*, que también tuvo la mayor taquilla internacional y el mayor número de
salas. *Happy Feet* fue la de mayor taquilla en EE. UU. y *Flyboys* la menor. El
mínimo de cero fuera de EE. UU. es *ATL*, que no se estrenó en el exterior.

La taquilla internacional promedia lo mismo que la de EE. UU. (59,6 millones
contra 59,6 millones) pero su máximo es más del doble. Es la fuente de ingresos
más dispersa, lo que coincide con lo que dice el caso de *Troy* o *Alexander*.

En los datos hay 23 comedias y 15 películas calificadas R. La comedia es el
género más frecuente, seguida del drama con 19. La clasificación más común es
PG-13 con 37 películas.

## 2) ¿Rinde el negocio un 12 % al año?

**a.** El ROI en EE. UU. de cada película se calculó como
(taquilla total EE. UU. - presupuesto) / presupuesto. La tabla completa está en
`q2a_roi_por_pelicula.csv`. El mejor es *The Devil Wears Prada* con 256 %, y el
peor *Arthur and the Invisibles* con -82 %.

**b.** El ROI medio es 29,3 % con desviación estándar de 68,7 %. Como la
desviación poblacional no se conoce, el intervalo usa la t de Student con 74
grados de libertad:

IC del 95 % para el ROI medio: de 13,5 % a 45,1 %.

**c.** Se plantea una prueba de una cola, porque lo que se quiere mostrar es que
el ROI supera el 12 %:

- H0: μ ≤ 0,12
- H1: μ > 0,12

t = (0,2929 - 0,12) / 0,0794 = 2,18, con p = 0,016. Se rechaza H0 al 5 %:
el ROI medio en EE. UU. es significativamente mayor que el 12 % de Michael London.
Lo confirma el intervalo de la parte (b), que deja el 12 % por fuera.

Dos advertencias para Meyer. Primero, la mediana es 16,7 %, bastante menor que la
media, porque unos pocos éxitos jalan el promedio. Segundo, 29 de las 75
películas no recuperan su presupuesto solo con la taquilla de EE. UU. El
rendimiento promedio es bueno, pero se gana con un portafolio, no con una
película. Es justamente el argumento de los *slate financing deals*. Además el
ROI ignora la publicidad, que según el caso promedia USD 34,5 millones, y el
reparto de la taquilla con los exhibidores, así que sobrestima el retorno real.

![](output/figures/q2_distribucion_roi.png)

## 3) Comedias contra el resto de géneros

Se usó la prueba t de Welch para dos muestras independientes, que no supone
varianzas iguales. La versión con varianza combinada lleva a las mismas
conclusiones (está en la tabla).

| Variable | Comedias (23) | Otros géneros (52) | Diferencia | p-valor |
|---|---|---|---|---|
| Taquilla EE. UU. (USD M) | 68,7 | 55,6 | 13,2 | 0,176 |
| ROI EE. UU. | 54,0 % | 18,4 % | 35,7 pp | 0,047 |
| Presupuesto (USD M) | 47,1 | 50,2 | -3,1 | 0,592 |

**a.** H0: la taquilla media de las comedias es igual a la del resto. Las
comedias recaudan en promedio 13,2 millones más, pero con p = 0,176 no se puede
rechazar H0. El intervalo del 95 % para la diferencia va de -6,1 a 32,4
millones e incluye el cero. No hay evidencia de que la comedia recaude distinto.

**b.** En ROI la historia cambia. Las comedias rinden 54,0 % contra 18,4 % del
resto, una diferencia de 35,7 puntos porcentuales con p = 0,047. La diferencia
es significativa al 5 % (no al 1 %). El intervalo del 95 % va de 0,4 a 70,9
puntos.

La sospecha de Griffith era que el mayor ingreso venía con una mayor inversión.
Los datos no la apoyan: las comedias cuestan casi lo mismo que el resto (47,1
contra 50,2 millones, p = 0,59). Lo que pasa es que el ROI divide por el
presupuesto y así elimina la parte de la variación de la taquilla que viene del
tamaño de cada producción. Con menos ruido, la misma ventaja de la comedia se
vuelve detectable. Para un inversionista que pone plata por película, la
variable relevante es el ROI, y ahí la comedia sale ganando.

![](output/figures/q3_comedia_vs_resto.png)

## 4) Películas R contra el resto

**a.** H0: la taquilla media de las películas R es igual a la del resto.

Las 15 películas R recaudan en promedio 53,3 millones en EE. UU. y las 60 de
otras clasificaciones 61,2 millones. La diferencia de -7,9 millones tiene
p = 0,398 (t de Welch), así que no se rechaza H0. Tampoco hay diferencia en
ROI (20,9 % contra 31,4 %, p = 0,57).

La creencia de que las R rinden mejor no se sostiene. Si algo, el signo va al
revés, en línea con lo que el caso cuenta del mercado en 2006, donde las PG y
PG-13 dominaron las taquillas más altas. Con solo 15 películas R la prueba tiene
poca potencia, así que la conclusión correcta es que no hay evidencia de que
las R rindan mejor, no que rindan igual.

![](output/figures/q4_r_vs_resto.png)
