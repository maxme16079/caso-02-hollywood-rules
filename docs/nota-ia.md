# Nota de uso de inteligencia artificial

**Caso 2 — Hollywood Rules**
Equipo: Maximo van Fulpen · Helen Sofía Castiblanco · Camilo Hernández
Fecha: 7 de octubre de 2026

Usamos Claude Code (Anthropic) para generar el código en R del análisis y los
borradores de los documentos, y para organizar el repositorio.

Revisamos las salidas antes de aceptarlas. Comparamos cada número citado en los
documentos contra las tablas que genera el código, y revisamos las gráficas una
por una. Dos ejemplos de lo que corregimos: el primer borrador explicaba la
ventaja de las comedias en ROI diciendo que cuestan menos, y al revisar la tabla
vimos que su presupuesto es casi igual al del resto (47,1 contra 50,2 millones,
p = 0,59). Y en la pregunta 7 las pruebas individuales del modelo log-log no
rechazaban la regla del 25 %, pero la prueba conjunta sí, así que la conclusión
se apoya en la prueba conjunta y en el modelo con la pendiente restringida.

La elección de los modelos, la interpretación de los resultados y las
recomendaciones a Meyer son nuestras. Cada integrante revisó y respalda la
sección que firma en el reparto del `README.md`.

Esta nota se incluye conforme a la política de divulgación del syllabus.
