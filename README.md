# Caso 2 — Hollywood Rules

Análisis del caso *Hollywood Rules* (Karl Schmedders, Charlotte Snyder y Ute
Schaedel, Kellogg School of Management) para el curso **Analítica de los
Negocios (BA-2630)**, Pontificia Universidad Javeriana, periodo 2026-3.
Profesor: Juan Nicolás Velásquez Rey.

## Equipo y reparto

| Integrante | Preguntas | Archivos |
|---|---|---|
| Maximo van Fulpen | 1 a 4 | `R/00_setup.R`, `R/01_descriptivos_y_pruebas.R`, `docs/respuestas-q01-q04.md` |
| Helen Sofía Castiblanco | 5 a 7 + resumen ejecutivo | `R/02_regresiones_antes_del_estreno.R`, `docs/respuestas-q05-q07.md`, `docs/resumen-ejecutivo.md` |
| Camilo Hernández | 8 a 10 | `R/03_despues_del_estreno.R`, `R/04_criticas_comedias_y_estrellas.R`, `docs/respuestas-q08-q10.md` |

Cada integrante trabaja en archivos distintos, así que no hay conflictos de
merge. El reparto sigue las cuatro partes del caso: *Set the Stage* y la prueba
de comedias y películas R (Maximo), las regresiones antes de producir y antes
del estreno (Sofía), y las regresiones después del estreno (Camilo).

## Entregable

**Parte 1 — Resumen ejecutivo** dirigido a Kim Meyer
→ [`docs/resumen-ejecutivo.md`](docs/resumen-ejecutivo.md)

**Parte 2 — Respuestas numeradas** a las diez preguntas de la sección *Analysis*:

- [`docs/respuestas-q01-q04.md`](docs/respuestas-q01-q04.md) — preguntas 1 a 4
- [`docs/respuestas-q05-q07.md`](docs/respuestas-q05-q07.md) — preguntas 5 a 7
- [`docs/respuestas-q08-q10.md`](docs/respuestas-q08-q10.md) — preguntas 8 a 10

**Nota de uso de IA**, exigida por el syllabus
→ [`docs/nota-ia.md`](docs/nota-ia.md)

Los tres documentos en PDF quedan en `output/entrega/`.

## Estructura

```
caso-02-hollywood-rules/
├── data/
│   └── Hollywood.xls                      datos del caso, hoja Exhibit 1
├── R/
│   ├── 00_setup.R                         carga, variables derivadas y funciones comunes
│   ├── 01_descriptivos_y_pruebas.R        preguntas 1 a 4
│   ├── 02_regresiones_antes_del_estreno.R preguntas 5 a 7
│   ├── 03_despues_del_estreno.R           pregunta 8
│   ├── 04_criticas_comedias_y_estrellas.R preguntas 9 y 10
│   ├── 98_generar_documentos.R            markdown → Word → PDF
│   └── 99_unir_respuestas.R               arma el documento único de la parte 2
├── docs/                                  respuestas, resumen ejecutivo y nota de IA
└── output/
    ├── figures/                           gráficas en png
    ├── tables/                            tablas en csv
    └── entrega/                           los PDF que se entregan
```

## Cómo reproducir

Requiere R 4.x con `tidyverse`, `readxl`, `scales`, `officer` y `flextable`, y
Microsoft Word para el paso a PDF. Desde la raíz del repositorio:

```r
source("R/01_descriptivos_y_pruebas.R")
source("R/02_regresiones_antes_del_estreno.R")
source("R/03_despues_del_estreno.R")
source("R/04_criticas_comedias_y_estrellas.R")
source("R/99_unir_respuestas.R")
source("R/98_generar_documentos.R")
```

Cada script de análisis hace `source("R/00_setup.R")` por su cuenta, así que se
pueden correr en cualquier orden.

## Decisiones de método

- **Pruebas de dos grupos:** t de Welch, que no supone varianzas iguales. La
  versión con varianza combinada se reporta como control y no cambia ninguna
  conclusión.
- **Selección de variables:** eliminación hacia atrás al 10 %, quitando una
  variable a la vez (la de mayor p-valor) y reestimando
  (`eliminacion_atras()` en `R/00_setup.R`).
- **Pregunta 7:** la regresión simple tiene heterocedasticidad, así que el
  modelo sólido es log-log. La regla del 25 % se evalúa con la prueba conjunta
  de pendiente 1 e intercepto ln(4), y con el multiplicador estimado imponiendo
  pendiente 1.
- **Pregunta 8:** no entran los Oscar ni la taquilla internacional, porque no se
  conocen después del fin de semana de estreno.

## Hallazgos principales

- ROI medio en EE. UU. de **29,3 %** (IC 95 % de 13,5 % a 45,1 %), mayor que el
  12 % de la industria (p = 0,016). Pero 29 de las 75 películas no recuperan su
  presupuesto en EE. UU.
- Las comedias no recaudan más (p = 0,18) pero sí rinden más por dólar: ROI de
  54 % contra 18 % (p = 0,047). Las películas R no rinden mejor (p = 0,40).
- Antes de producir pesan presupuesto, secuela (+31,7 millones) y comedia. Para
  el estreno pesan presupuesto, secuela y salas (+0,77 millones por cada 100
  salas). Las fechas de estreno no son significativas.
- El estreno es el **30,4 %** de la taquilla total (IC 95 % de 28,2 % a 32,8 %),
  no el 25 % de la regla.
- Con estreno y crítica el modelo explica el 83 % de la taquilla. Cada punto de
  crítica vale 591 mil dólares. No hay evidencia de que la crítica pese menos en
  las comedias (p = 0,22).

## Nota sobre los datos

`data/Hollywood.xls` es material del caso, © 2012 Kellogg School of Management,
Northwestern University. Se incluye únicamente para poder reproducir el análisis
del curso.
