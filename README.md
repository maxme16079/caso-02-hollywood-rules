# Caso 2: Hollywood Rules

Analítica de los Negocios (BA-2630), Pontificia Universidad Javeriana, 2026-3.
Profesor: Juan Nicolás Velásquez Rey.

¿Rinde invertir en un portafolio de películas de USD 20 a 100 millones? Con los
datos de 75 películas de 2006 respondemos las preguntas 1 a 4 completas y los
literales a, b y g de la pregunta 7, que es el alcance que indicó el profesor
para esta entrega.

## Equipo

| Integrante | Parte |
|---|---|
| Maximo van Fulpen | Preguntas 1 a 4, estructura y README |
| Helen Sofía Castiblanco | Pregunta 7 (antes también 5 y 6) |
| Camilo Hernández | Preguntas 8 a 10, que quedaron fuera del alcance de esta entrega |

## Archivos

- `data/Hollywood.xls`: datos del caso (hoja Exhibit 1)
- `R/00_setup.R`: carga de datos, variables derivadas (comedia y ROI) y funciones comunes
- `R/01_descriptivos_y_pruebas.R`: preguntas 1 a 4
- `R/02_regla_del_25.R`: pregunta 7 a, b y g
- `docs/respuestas-q01-q04.md` y `docs/respuestas-q07.md`: respuestas
- `output/tables/` y `output/figures/`: tablas y gráficas que generan los scripts

## Cómo correrlo

1. Instalar R (4.3 o más reciente) y los paquetes:

```r
install.packages(c("tidyverse", "readxl", "scales"))
```

2. Abrir R con la carpeta del repositorio como directorio de trabajo. En RStudio
   basta con abrir la carpeta como proyecto. Las rutas son relativas a esa
   carpeta.

3. Correr los scripts en orden:

```r
source("R/01_descriptivos_y_pruebas.R")
source("R/02_regla_del_25.R")
```

Cada script carga `R/00_setup.R`, que lee los datos y verifica que haya 75
películas sin datos faltantes. Las tablas quedan en `output/tables/` y las
gráficas en `output/figures/`.
