# Caso 2: Hollywood Rules

Analítica de los Negocios (BA-2630), Pontificia Universidad Javeriana, 2026-3.
Profesor: Juan Nicolás Velásquez Rey.

## Equipo

| Integrante | Preguntas |
|---|---|
| Maximo van Fulpen | 1 a 4 |
| Helen Sofía Castiblanco | 5 a 7 y resumen ejecutivo |
| Camilo Hernández | 8 a 10 |

## Archivos

- `data/Hollywood.xls`: datos del caso
- `R/00_setup.R`: carga de datos y funciones comunes
- `R/01_descriptivos_y_pruebas.R`: preguntas 1 a 4
- `R/02_regresiones_antes_del_estreno.R`: preguntas 5 a 7
- `R/03_despues_del_estreno.R`: pregunta 8
- `R/04_criticas_comedias_y_estrellas.R`: preguntas 9 y 10
- `docs/`: resumen ejecutivo y respuestas
- `output/`: gráficas y tablas

## Cómo correrlo

Desde la carpeta del repositorio, con R y los paquetes `tidyverse` y `readxl`:

```r
source("R/01_descriptivos_y_pruebas.R")
source("R/02_regresiones_antes_del_estreno.R")
source("R/03_despues_del_estreno.R")
source("R/04_criticas_comedias_y_estrellas.R")
```
