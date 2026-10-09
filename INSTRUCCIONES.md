# Sofía — cómo subir tu parte del caso 2 (10 minutos, sin instalar nada)

> **Lo unico que importa:** haz **4 subidas separadas**, una por carpeta `commit-N`. Eso no se puede arreglar despues, porque cada subida es un commit y son tus 4 contribuciones.
>
> Todo lo demas da igual. Si arrastras la carpeta equivocada, si queda en el sitio equivocado o si el mensaje no queda igualito, no importa: Maximo lo reorganiza despues y no se pierde nada. No te trabes con eso.

Repo: **https://github.com/maxme16079/caso-02-hollywood-rules**

Es lo mismo que hicimos en el caso 1. Te tocan las **preguntas 5 a 7**
(regresiones antes de producir y antes del estreno, y la regla del 25 %) y el
**resumen ejecutivo**. Todo se hace desde la página de GitHub, arrastrando
carpetas.

---

## Paso 1 — Aceptar la invitación

Es un repositorio nuevo, así que te llega otra invitación por correo,
*"maxme16079 invited you to collaborate"*. Le das a **Accept invitation**. Sin
esto no puedes subir nada.

## Paso 2 — Revisar lo que vas a subir

Abre `commit-3/docs/respuestas-q05-q07.md` y `commit-4/docs/resumen-ejecutivo.md`
y léelos. El syllabus dice que la interpretación tiene que ser tuya, así que
cambia lo que no te cuadre. Si cambias algo se nota en el historial y sale mejor.

Lo que deberías poder defender si el profesor pregunta:

- **Pregunta 5:** antes de producir quedan presupuesto, comedia y secuela. Una
  **secuela recauda 31,7 millones más** con lo demás igual. El modelo explica
  poco (R² ajustado 0,31).
- **Pregunta 6:** para el estreno quedan presupuesto, secuela y salas. **Cien
  salas más = 768 mil dólares más** en el estreno (IC 95 % de 477 mil a 1,06
  millones). Las fechas (verano, festivo, Navidad) no son significativas.
- **Pregunta 7:** la regresión simple da pendiente 3,12, no 4, pero tiene
  **heterocedasticidad** (los errores crecen con el tamaño del estreno). Por eso
  se usa un modelo **log-log**. Ahí la conclusión es que el estreno es el
  **30,4 % del total, no el 25 %**. La regla se rechaza: el estreno pesa todavía
  más de lo que dice la industria.
- **Ojo en 7f:** las pruebas de pendiente e intercepto por separado no rechazan,
  pero la conjunta sí. No se contradicen: los dos coeficientes están muy
  correlacionados. Manda la prueba conjunta.

## Paso 3 — Subir, cuatro veces

Para cada una:

1. Entra al repo y dale al botón **Add file** → **Upload files**
2. Abre la carpeta `commit-N` en tu computador y **arrastra la carpeta de
   adentro** (`R`, `output` o `docs`) a la página. Arrastra la carpeta, no los
   archivos sueltos, así se respeta la ubicación.
3. Abajo, en *Commit changes*, borra el texto que aparece y pega el mensaje que
   te doy aquí abajo
4. Dale a **Commit changes**

### Los cuatro mensajes

**commit-1** → arrastra la carpeta `R`
```
feat: regresiones antes de producir y antes del estreno (preguntas 5 a 7)
```

**commit-2** → arrastra la carpeta `output`
```
chore: graficas y tablas de las preguntas 5 a 7
```

**commit-3** → arrastra la carpeta `docs`
```
docs: respuestas 5 a 7 sobre secuelas, salas y la regla del 25 %
```

**commit-4** → arrastra la carpeta `docs`
```
docs: resumen ejecutivo con recomendaciones para Kim Meyer
```

## Paso 4 — Verificar

Entra a
https://github.com/maxme16079/caso-02-hollywood-rules/graphs/contributors
y confirma que sales con 4 commits.

---

## Dudas frecuentes

**¿Y si me equivoco de carpeta?** No pasa nada, se borra o se vuelve a subir. No
se rompe nada.

**¿Choco con lo que suba Camilo?** No. Cada uno sube archivos distintos.

**Nota sobre IA:** la nota de uso de IA va solo en el PDF que se le manda al
profesor. En GitHub no se menciona, así que no pongas nada de eso en los
mensajes de commit.
