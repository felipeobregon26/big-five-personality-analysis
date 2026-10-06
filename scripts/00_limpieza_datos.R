################################################################################
############################# LIMPIEZA DE DATOS ###############################
## Redondea los puntajes de los 5 rasgos a 2 decimales y elimina casos nulos. ##
## Genera data/processed/big_five_scores.csv, usado por el resto de scripts. ##
## El archivo original en data/raw/ nunca se modifica.                       ##
## Felipe Obregon Ochoa - Psicologo                                          ##
################################################################################

library(dplyr)
library(readr)

data <- read_csv("data/raw/big_five_scores.csv", show_col_types = FALSE)

big_five <- data[complete.cases(data), ] %>%
  mutate(across(
    c(agreeable_score, extraversion_score, openness_score,
      conscientiousness_score, neuroticism_score),
    ~ round(.x, 2)
  ))

write_csv(big_five, "data/processed/big_five_scores.csv")

cat("N casos:", nrow(big_five), "\n")
cat("Guardado en data/processed/big_five_scores.csv\n")
