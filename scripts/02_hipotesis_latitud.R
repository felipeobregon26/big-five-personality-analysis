################################################################################
######################## HIPOTESIS: LATITUD Y PERSONALIDAD ###################
## "Entre mas cerca del ecuador esta un pais, mayores son los niveles de    ##
##  extraversion y apertura a la experiencia"                               ##
## Felipe Obregon Ochoa - Psicologo                                         ##
## Analisis preregistrado - ver preregistro/2026-09-27_latitud_extraversion_apertura.md
################################################################################

library(dplyr)
library(readr)
library(lme4)
library(lmerTest)

##--------------------------- CARGA DE DATOS ---------------------------------##

big_five <- read_csv("data/processed/big_five_scores.csv", show_col_types = FALSE)

paises <- read_csv("data/raw/country_latitude.csv", show_col_types = FALSE)

##------------------------- UNION CON LATITUDES -------------------------------##

big_five_geo <- big_five %>%
  left_join(paises, by = c("country" = "country_raw"))

## verificar que todos los paises de la muestra tengan match en la tabla de latitudes
sin_match <- big_five_geo %>% filter(is.na(include))
if (nrow(sin_match) > 0) {
  warning(paste(nrow(sin_match), "casos sin match en country_latitude.csv"))
}

## aplicar criterios de exclusion definidos en el preregistro
big_five_geo <- big_five_geo %>%
  filter(include == TRUE) %>%
  mutate(latitud_absoluta = abs(latitude_capital))

## resumen de exclusiones
cat("N original (casos completos):", nrow(big_five), "\n")
cat("N tras exclusiones geograficas:", nrow(big_five_geo), "\n")
cat("Paises incluidos:", n_distinct(big_five_geo$country_name), "\n")

##------------------------- MODELOS MULTINIVEL --------------------------------##
## Individuos anidados en paises. Prediccion: coeficiente de latitud_absoluta
## negativo (a mayor distancia del ecuador, menor extraversion/apertura).

modelo_extraversion <- lmer(
  extraversion_score ~ latitud_absoluta + age + sex + (1 | country_name),
  data = big_five_geo
)

modelo_apertura <- lmer(
  openness_score ~ latitud_absoluta + age + sex + (1 | country_name),
  data = big_five_geo
)

cat("\n\n==================== MODELO: EXTRAVERSION ====================\n")
print(summary(modelo_extraversion))
cat("\nIntervalo de confianza 95% (Wald):\n")
print(confint(modelo_extraversion, parm = "latitud_absoluta", method = "Wald"))

cat("\n\n==================== MODELO: APERTURA A LA EXPERIENCIA ====================\n")
print(summary(modelo_apertura))
cat("\nIntervalo de confianza 95% (Wald):\n")
print(confint(modelo_apertura, parm = "latitud_absoluta", method = "Wald"))

##------------------------------- GUARDAR SALIDA ------------------------------##

sink("output/resultados_hipotesis_latitud.txt")
cat("N original (casos completos):", nrow(big_five), "\n")
cat("N tras exclusiones geograficas:", nrow(big_five_geo), "\n")
cat("Paises incluidos:", n_distinct(big_five_geo$country_name), "\n\n")
cat("==================== MODELO: EXTRAVERSION ====================\n")
print(summary(modelo_extraversion))
cat("\n==================== MODELO: APERTURA A LA EXPERIENCIA ====================\n")
print(summary(modelo_apertura))
sink()

cat("\n\nResultados guardados en output/resultados_hipotesis_latitud.txt\n")
