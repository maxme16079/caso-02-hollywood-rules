# Caso 2: Hollywood Rules

Analítica de los Negocios (BA-2630), Pontificia Universidad Javeriana, 2026-3.
Profesor: Juan Nicolás Velásquez Rey.

Este repositorio analiza si conviene invertir en un portafolio de películas de
USD 20 a 100 millones. Usa los datos de 75 películas de 2006 y responde las
preguntas 1 a 4 completas y los literales a, b y g de la pregunta 7.

## Equipo

| Integrante | Parte |
|---|---|
| Maximo van Fulpen | Preguntas 1 a 4, estructura del repositorio y README |
| Helen Sofía Castiblanco | Pregunta 7 |
| Camilo Hernández | Preguntas 8 a 10, que quedaron fuera del alcance de esta entrega |

## Archivos

| Ruta | Contenido |
|---|---|
| `data/Hollywood.xls` | Datos del caso (hoja Exhibit 1) |
| `R/00_setup.R` | Carga de datos, variables derivadas y funciones comunes |
| `R/01_descriptivos_y_pruebas.R` | Preguntas 1 a 4 |
| `R/02_regla_del_25.R` | Pregunta 7 a, b y g |
| `docs/` | Respuestas de cada pregunta |
| `output/tables/` | Tablas que generan los scripts |
| `output/figures/` | Gráficas que generan los scripts |

## Cómo correrlo

1. Instalar R 4.3 o más reciente y los paquetes del análisis.

```r
install.packages(c("tidyverse", "readxl", "scales"))
```

2. Abrir R con la carpeta del repositorio como directorio de trabajo. En RStudio
   basta con abrir la carpeta como proyecto.

3. Correr los dos scripts en orden.

```r
source("R/01_descriptivos_y_pruebas.R")
source("R/02_regla_del_25.R")
```

Cada script carga `R/00_setup.R`, que lee los datos y verifica que haya 75
películas sin datos faltantes. Las tablas quedan en `output/tables/` y las
gráficas en `output/figures/`.
