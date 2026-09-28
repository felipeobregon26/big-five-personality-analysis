# Preregistro: Latitud geográfica y rasgos de personalidad (Extraversión y Apertura a la Experiencia)

**Autor:** Felipe Obregón Ochoa (Psicólogo)
**Fecha de registro:** 2026-09-27
**Repositorio / código:** `scripts/02_hipotesis_latitud.R`

## 1. Antecedentes y naturaleza de los datos

Este análisis usa una base de datos secundaria ya recolectada (`data/raw/big_five_scores.csv`,
N = 307,141 casos completos, 236 códigos de país distintos), proveniente del proyecto Open
Psychometrics (test Big Five basado en ítems IPIP). **Los datos ya existían antes de este
preregistro**, pero no habían sido examinados ni analizados en relación con la hipótesis
de latitud geográfica antes de fijar este plan. Se documenta esto de forma transparente
siguiendo las prácticas de ciencia abierta para análisis secundarios de datos existentes.

## 2. Hipótesis

**H1:** Entre más cerca esté un país del ecuador (menor latitud absoluta), mayores son los
niveles promedio de **extraversión** y de **apertura a la experiencia** reportados por sus
habitantes.

**Predicción operacional:** el coeficiente de `latitud_absoluta` será **negativo y
estadísticamente significativo** (α = .05) tanto para extraversión como para apertura.

**H0:** No existe asociación entre la latitud absoluta de un país y los niveles de
extraversión o apertura a la experiencia de sus habitantes (coeficiente ≈ 0 o no significativo).

## 3. Variables

| Variable | Rol | Nivel | Descripción |
|---|---|---|---|
| `extraversion_score` | Dependiente (modelo 1) | Individual | Puntaje de extraversión (0–1) |
| `openness_score` | Dependiente (modelo 2) | Individual | Puntaje de apertura a la experiencia (0–1) |
| `latitud_absoluta` | Independiente | País (nivel 2) | Valor absoluto de la latitud de la capital del país (grados decimales) |
| `age` | Covariable de control | Individual | Edad en años |
| `sex` | Covariable de control | Individual | Sexo (codificado 1/2 en el dataset original) |
| `country_name` | Agrupador | País (nivel 2) | Efecto aleatorio (intercepto) |

**Definición de latitud (decidido de antemano):** se usa la latitud de la **capital** de
cada país (estándar en estudios transculturales de psicología, ej. Schmitt et al.), obtenida
de fuentes geográficas públicas y documentada en `data/raw/country_latitude.csv`. No se usa
el centroide geográfico del país.

## 4. Nivel de análisis y modelo estadístico

Se decidió **no** agrupar los países en categorías discretas de latitud (tropical/templado/
frío). En su lugar, se usa la **latitud absoluta como variable continua**, analizada mediante
un **modelo lineal multinivel (mixed model)** con individuos anidados en países:

```r
lmer(extraversion_score ~ latitud_absoluta + age + sex + (1 | country_name), data = ...)
lmer(openness_score    ~ latitud_absoluta + age + sex + (1 | country_name), data = ...)
```

- Efecto aleatorio: intercepto por país (`(1 | country_name)`), sin pendiente aleatoria.
- Significancia de efectos fijos: aproximación de Satterthwaite (paquete `lmerTest`).
- Se reporta el coeficiente de `latitud_absoluta`, su error estándar, valor p e intervalo
  de confianza del 95%.

Esta especificación se prefirió sobre una correlación simple de promedios por país porque
permite controlar por edad y sexo a nivel individual y no descarta la variabilidad dentro
de cada país. El modelo multinivel también maneja de forma natural los países con muestras
pequeñas mediante *shrinkage* (pooling parcial), por lo que no se requiere un punto de corte
arbitrario de tamaño mínimo de muestra por país.

## 5. Criterios de exclusión (definidos antes de analizar)

El campo `country` del dataset original viene truncado a 10 caracteres y contiene algunos
códigos que no representan un único país con una latitud asignable de forma inequívoca.
Se excluyen los siguientes casos (documentados con su razón en
`data/raw/country_latitude.csv`, columna `exclude_reason`):

1. **País vacío / faltante** (`""`) — sin información.
2. **`Antarctica`** — sin población permanente / no es un país.
3. **`Arabian Gu`** (Golfo Arábigo) — región ambigua que abarca múltiples países.
4. **`Borneo`** — isla compartida por Indonesia, Malasia y Brunéi; sin país único asignable.
5. **`Republic o`** — cadena truncada ambigua, no permite identificar el país con certeza.
6. **`British In`** (Territorio Británico del Océano Índico) — sin población civil, solo
   base militar.
7. **`Wake Islan`** y **`Johnston I`** — territorios estadounidenses deshabitados, uso militar.
8. **`Bouvet Isl`** — isla deshabitada.

No se aplica ningún filtro adicional de tamaño mínimo de muestra por país (ver justificación
en la sección 4).

**Nota de limpieza:** códigos distintos que representan el mismo país (por variantes de
truncamiento o nombres históricos) se consolidan bajo un mismo `country_name` para el
efecto aleatorio: `Vatican Ci`/`Vatican` → Vatican City; `Burma`/`Burma(Myan` → Myanmar;
`Samoa`/`W. Samoa` → Samoa.

## 6. Criterios de confirmación / disconfirmación

- Si el coeficiente de `latitud_absoluta` es **negativo y p < .05** en ambos modelos
  (extraversión y apertura): se considera **evidencia a favor de H1**.
- Si es significativo en solo uno de los dos rasgos: se reporta como **evidencia parcial**,
  discutiendo cada rasgo por separado.
- Si no es significativo, o el signo es positivo, en ambos modelos: se considera que **no
  hay evidencia a favor de H1** (no se rechaza H0).

## 7. Limitaciones reconocidas de antemano

- La latitud de la capital es un proxy imperfecto para países geográficamente extensos que
  abarcan varias zonas climáticas (ej. Rusia, Brasil, EE.UU., Australia, Canadá).
- El diseño es correlacional/observacional: no permite inferir causalidad entre latitud y
  personalidad, incluso si se encuentra la asociación esperada.
- La muestra no es representativa por país (algunos países tienen decenas de miles de
  casos —p. ej. USA— y otros solo unos pocos), lo cual el modelo multinivel mitiga pero no
  elimina completamente.
- No se controla por variables culturales, económicas o climáticas que podrían confundir
  la relación (ej. PIB per cápita, individualismo/colectivismo).

## 8. Script de análisis

El análisis completo, incluyendo unión de datos, aplicación de exclusiones y ajuste de
modelos, está en `scripts/02_hipotesis_latitud.R`. Los resultados se guardan en
`output/resultados_hipotesis_latitud.txt`.

## 9. Resultados (análisis preregistrado, latitud de capital)

*Registrado el 2026-09-27 después de correr el análisis fijado en las secciones 1-8.*

| Rasgo | Coef. `latitud_absoluta` | p | Dirección |
|---|---|---|---|
| Extraversión | −0.000216 | 0.012 | A favor de H1 (efecto trivial: ~2% de la escala en todo el rango 0-90°) |
| Apertura a la experiencia | +0.000639 | <0.001 | En contra de H1 (dirección opuesta) |

**Conclusión según los criterios de la sección 6:** los resultados son mixtos y **no
confirman H1 de forma integral**. Extraversión muestra el signo predicho pero con un efecto
prácticamente nulo en magnitud; apertura muestra un efecto significativo en la dirección
contraria a la predicha.

## 10. Desviaciones post-registro (exploratorio, NO preregistrado)

*Agregado el 2026-09-27, después de ver los resultados de la sección 9, a solicitud
explícita de re-analizar con otra definición de latitud.*

Se repitió el análisis reemplazando `latitud_absoluta` (basada en la capital, sección 3)
por la **latitud del centroide geográfico** del país, obtenida del dataset `countryref` del
paquete de R `CoordinateCleaner` (basado en los límites administrativos ADM0 de
geoBoundaries.org), promediando los registros de tipo `"country"` por código ISO3. Esta
fuente se documenta en `data/raw/country_latitude.csv` (columna `latitude_centroid`), junto
a la latitud de capital original (columna `latitude_capital`).

Script: `scripts/03_hipotesis_latitud_centroide.R`. Resultados:
`output/resultados_hipotesis_latitud_centroide.txt`.

| Rasgo | Coef. `latitud_absoluta` (centroide) | p | Dirección |
|---|---|---|---|
| Extraversión | −0.000208 | 0.012 | A favor de H1 (efecto trivial, ~2% de la escala) |
| Apertura a la experiencia | +0.000624 | <0.001 | En contra de H1 (dirección opuesta) |

**Esto es un análisis exploratorio/de robustez, no una confirmación preregistrada**: la
decisión de usar latitud de capital fue fijada de antemano en la sección 3, y cambiarla
después de ver resultados constituye una desviación del plan original, documentada aquí de
forma transparente en vez de presentarse como si hubiera sido el plan original.

**Conclusión de robustez:** los resultados son prácticamente idénticos a los de la sección 9
usando latitud de capital. El cambio de operacionalización de la variable independiente
no altera la conclusión: **la hipótesis H1 no se sostiene de forma integral** (extraversión
con efecto trivial en la dirección esperada, apertura en dirección opuesta), independientemente
de si se usa la latitud de la capital o del centroide del país.
