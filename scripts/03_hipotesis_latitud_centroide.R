################################################################################
################## HIPOTESIS: LATITUD Y PERSONALIDAD (CENTROIDE) #############
## Analisis de ROBUSTEZ / POST-HOC, no preregistrado.                       ##
## Usa la latitud del centroide geografico del pais en vez de la capital,   ##
## a peticion explicita despues de ver los resultados del analisis          ##
## preregistrado (scripts/02_hipotesis_latitud.R).                          ##
## Ver: preregistro/2026-09-27_latitud_extraversion_apertura.md,            ##
## seccion "Desviaciones post-registro".                                    ##
## Felipe Obregon Ochoa - Psicologo                                         ##
################################################################################

library(dplyr)
library(readr)
library(lme4)
library(lmerTest)

##--------------------------- CARGA DE DATOS ---------------------------------##

data <- read_csv("data/raw/big_five_scores.csv", show_col_types = FALSE)
big_five <- data[complete.cases(data), ]

paises <- read_csv("data/raw/country_latitude.csv", show_col_types = FALSE)

##------------------------- UNION CON LATITUDES -------------------------------##

big_five_geo <- big_five %>%
  left_join(paises, by = c("country" = "country_raw"))

sin_match <- big_five_geo %>% filter(is.na(include))
if (nrow(sin_match) > 0) {
  warning(paste(nrow(sin_match), "casos sin match en country_latitude.csv"))
}

big_five_geo <- big_five_geo %>%
  filter(include == TRUE) %>%
  mutate(latitud_absoluta = abs(latitude_centroid))

cat("N original (casos completos):", nrow(big_five), "\n")
cat("N tras exclusiones geograficas:", nrow(big_five_geo), "\n")
cat("Paises incluidos:", n_distinct(big_five_geo$country_name), "\n")

##------------------------- MODELOS MULTINIVEL --------------------------------##

modelo_extraversion <- lmer(
  extraversion_score ~ latitud_absoluta + age + sex + (1 | country_name),
  data = big_five_geo
)

modelo_apertura <- lmer(
  openness_score ~ latitud_absoluta + age + sex + (1 | country_name),
  data = big_five_geo
)

cat("\n\n==================== MODELO: EXTRAVERSION (centroide) ====================\n")
print(summary(modelo_extraversion))
cat("\nIC 95% (Wald):\n")
print(confint(modelo_extraversion, parm = "latitud_absoluta", method = "Wald"))

cat("\n\n==================== MODELO: APERTURA (centroide) ====================\n")
print(summary(modelo_apertura))
cat("\nIC 95% (Wald):\n")
print(confint(modelo_apertura, parm = "latitud_absoluta", method = "Wald"))

##------------------------------- GUARDAR SALIDA ------------------------------##

sink("output/resultados_hipotesis_latitud_centroide.txt")
cat("N original (casos completos):", nrow(big_five), "\n")
cat("N tras exclusiones geograficas:", nrow(big_five_geo), "\n")
cat("Paises incluidos:", n_distinct(big_five_geo$country_name), "\n\n")
cat("==================== MODELO: EXTRAVERSION (centroide) ====================\n")
print(summary(modelo_extraversion))
cat("\n==================== MODELO: APERTURA (centroide) ====================\n")
print(summary(modelo_apertura))
sink()

cat("\n\nResultados guardados en output/resultados_hipotesis_latitud_centroide.txt\n")
