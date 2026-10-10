# Caso 2: Hollywood Rules
## Respuestas a las preguntas 1 a 4

**Curso:** Analítica de los Negocios (BA-2630)
**Profesor:** Juan Nicolás Velásquez Rey
**Equipo:** Maximo van Fulpen, Helen Sofía Castiblanco, Camilo Hernández
**Autor de esta sección:** Maximo van Fulpen
**Fecha:** 9 de octubre de 2026

Los cálculos están en `R/01_descriptivos_y_pruebas.R` y la carga de datos en
`R/00_setup.R`. Los datos son 75 películas de 2006 con presupuesto entre USD 20
y 100 millones y sin datos faltantes.

## 1) Panorama inicial de los datos

**Tabla 2.** Mínimo, promedio y máximo de las variables principales (75 películas)

| Variable | Mínimo | Promedio | Máximo |
|---|---|---|---|
| Taquilla de estreno (USD) | 4.120.497 | 17.468.466 | 68.033.544 |
| Taquilla total EE. UU. (USD) | 13.090.630 | 59.620.651 | 198.000.317 |
| Taquilla fuera de EE. UU. (USD) | 0 | 59.560.983 | 456.235.122 |
| Salas en el estreno | 852 | 2.766 | 3.964 |

El estreno más flojo fue *One Night with the King* y el más fuerte fue *Ice
Age: The Meltdown*. Esa misma película tuvo la mayor taquilla internacional y
el mayor número de salas. *Happy Feet* fue la de mayor taquilla en EE. UU. y
*Flyboys* la de menor. El cero fuera de EE. UU. corresponde a *ATL*, que no se
estrenó en el exterior.

La taquilla internacional tiene el mismo promedio que la de EE. UU. con 59,6
millones cada una. Su máximo es más del doble, así que es la fuente de ingresos
más dispersa. Eso coincide con lo que cuenta el caso de *Troy* y *Alexander*.

Hay 23 comedias y 15 películas calificadas R. La comedia es el género más
frecuente y le sigue el drama con 19 películas. La clasificación más común es
PG-13 con 37 películas.

## 2) ¿Rinde el negocio un 12 % al año?

**a.** El ROI en EE. UU. de cada película es la taquilla total en EE. UU. menos
el presupuesto, dividido entre el presupuesto. La tabla con las 75 películas
está en el anexo (Tabla A1). El mejor ROI es el de *The Devil Wears Prada* con
256 %. El peor es el de *Arthur and the Invisibles*, que perdió el 82 % de su
presupuesto.

**b.** El ROI medio es 29,3 % con una desviación estándar de 68,7 %. La
desviación de la población no se conoce, así que el intervalo usa la t de
Student con 74 grados de libertad. El intervalo del 95 % para el ROI medio va
de 13,5 % a 45,1 %.

**Tabla 3.** ROI en EE. UU. de las 75 películas

| Medida | Valor |
|---|---|
| ROI medio | 29,3 % |
| ROI mediano | 16,7 % |
| Desviación estándar | 68,7 % |
| Error estándar de la media | 7,9 % |
| IC 95 % de la media | 13,5 % a 45,1 % |
| t contra 12 % (74 gl) | 2,18 |
| p valor de una cola | 0,016 |
| Películas con ROI negativo | 29 de 75 |

**c.** El caso pide mostrar que el ROI es mayor que el 12 %, así que la prueba
es de una cola. La hipótesis nula es que el ROI medio es menor o igual a 0,12 y
la alternativa es que es mayor.

El estadístico t es 2,18 y el p valor es 0,016. Se rechaza la hipótesis nula al
5 %. El ROI medio en EE. UU. es significativamente mayor que el 12 % que cita
Michael London. El intervalo de la parte b lleva a la misma conclusión porque
deja el 12 % por fuera.

Hay dos advertencias para Meyer. La mediana es 16,7 % y está muy por debajo de
la media, porque unos pocos éxitos suben el promedio. Además 29 de las 75
películas no recuperan su presupuesto solo con la taquilla de EE. UU.

El rendimiento promedio es bueno pero se logra con un portafolio y no con una
película suelta. Ese es el argumento de los acuerdos de slate financing. El ROI
tampoco descuenta la publicidad, que según el caso promedia USD 34,5 millones,
ni la parte de la taquilla que se queda el exhibidor. Por eso sobrestima el
retorno real.

![](output/figures/q2_distribucion_roi.png)

**Figura 1.** Distribución del ROI en EE. UU. con el 12 % de referencia

## 3) Comedias contra el resto de géneros

Se usó la prueba t de Welch para dos muestras independientes, que no supone
varianzas iguales. La versión con varianza combinada lleva a las mismas
conclusiones.

**Tabla 4.** Comedias contra el resto de géneros (prueba t de Welch)

| Variable | Comedias (23) | Otros géneros (52) | Diferencia | p valor |
|---|---|---|---|---|
| Taquilla EE. UU. (USD M) | 68,7 | 55,6 | 13,2 | 0,176 |
| ROI EE. UU. | 54,0 % | 18,4 % | 35,7 pp | 0,047 |
| Presupuesto (USD M) | 47,1 | 50,2 | -3,1 | 0,592 |

**a.** La hipótesis nula es que la taquilla media de las comedias es igual a la
del resto. Las comedias recaudan en promedio 13,2 millones más, pero el p valor
es 0,176 y no se rechaza la hipótesis nula. El intervalo del 95 % para la
diferencia incluye el cero. No hay evidencia de que la comedia recaude distinto.

**b.** En ROI el resultado cambia. Las comedias rinden 54,0 % y el resto 18,4 %.
La diferencia es de 35,7 puntos porcentuales con un p valor de 0,047, así que
es significativa al 5 % pero no al 1 %. El intervalo del 95 % va de 0,4 a 70,9
puntos.

Griffith sospechaba que las comedias recaudaban más porque costaban más. Los
datos no apoyan esa idea, porque su presupuesto es casi igual al del resto con
47,1 contra 50,2 millones y un p valor de 0,59.

El ROI divide la taquilla entre el presupuesto y así quita la variación que
viene del tamaño de cada producción. Con menos ruido la ventaja de la comedia se
vuelve detectable. Para un inversionista que pone dinero en cada película la
variable que importa es el ROI, y ahí la comedia sale ganando.

![](output/figures/q3_comedia_vs_resto.png)

**Figura 2.** Taquilla, presupuesto y ROI de las comedias frente al resto. La barra es la media

## 4) Películas R contra el resto

**Tabla 5.** Películas R contra el resto (prueba t de Welch)

| Variable | R (15) | Otras (60) | Diferencia | p valor |
|---|---|---|---|---|
| Taquilla EE. UU. (USD M) | 53,3 | 61,2 | -7,9 | 0,398 |
| ROI EE. UU. | 20,9 % | 31,4 % | -10,5 pp | 0,570 |

**a.** La hipótesis nula es que la taquilla media de las películas R es igual a
la del resto. Las 15 películas R recaudan en promedio 53,3 millones en EE. UU. y
las otras 60 recaudan 61,2 millones. La diferencia es de 7,9 millones a favor
del resto con un p valor de 0,398, así que no se rechaza la hipótesis nula.
Tampoco hay diferencia en ROI, con 20,9 % contra 31,4 % y un p valor de 0,57.

La creencia de que las películas R rinden mejor no se sostiene. La diferencia
incluso va en la dirección contraria, lo que coincide con el caso cuando cuenta
que en 2006 las películas PG y PG-13 dominaron las taquillas más altas.

Con solo 15 películas R la prueba tiene poca potencia. Por eso la conclusión
correcta es que no hay evidencia de que las películas R rindan mejor, y no que
rindan igual.

![](output/figures/q4_r_vs_resto.png)

**Figura 3.** Taquilla en EE. UU. de las películas R frente al resto
