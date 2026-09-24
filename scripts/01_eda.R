################################################################################
################################ BIG FIVE ######################################
############## Análisis exploratorio de muestra internacional ##################
####################### Muestreo alaeatorio simple #############################
#################### Felipe Obregón Ochoa - Psicólogo ##########################
############################### 20-09-2026 #####################################
################################################################################

library(dplyr)
library(readr)
library(psych)
library(ggplot2)
library(tidyr)

##--------------------------- CARGA DE DATOS---------------------------------##

data <- read_csv("data/raw/big_five_scores.csv")

# eliminar casos nulos

big_five <- data[complete.cases(data), ]

##-------------------------------- EDA --------------------------------------##

describe(big_five)

#vars                      n      mean       sd    median   trimmed       mad   min       max
#case_id                    1 307141 166628.24 96111.21 166231.00 166543.17 122981.67  1.00 334161.00
#country*                   2 307141    185.10    66.10    219.00    200.49      0.00  1.00    235.00
#age                        3 307141     25.19    10.00     22.00     23.60      7.41 10.00     99.00
#sex                        4 307141      1.60     0.49      2.00      1.63      0.00  1.00      2.00
#agreeable_score            5 307141      0.70     0.09      0.70      0.70      0.09  0.20      1.00
#extraversion_score         6 307141      0.67     0.11      0.68      0.68      0.11  0.20      0.99
#openness_score             7 307141      0.73     0.09      0.74      0.74      0.09  0.25      1.00
#conscientiousness_score    8 307141      0.70     0.11      0.71      0.70      0.11  0.21      1.00
#neuroticism_score          9 307141      0.57     0.13      0.57      0.57      0.13  0.20      1.00
#                             range  skew kurtosis     se
#case_id                 334160.00  0.01    -1.19 173.42
#country*                   234.00 -1.70     1.21   0.12
#age                         89.00  1.49     2.25   0.02
#sex                          1.00 -0.42    -1.82   0.00
#agreeable_score              0.80 -0.52     0.51   0.00
#extraversion_score           0.79 -0.33    -0.11   0.00
#openness_score               0.74 -0.17    -0.14   0.00
#conscientiousness_score      0.79 -0.19    -0.15   0.00
#neuroticism_score            0.80  0.13    -0.30   0.00

## cantidad de paises
n_distinct(big_five$country)
#[1] 235

## pivotar tabla

big_five_largo <- big_five %>%
  pivot_longer(
    cols = c(
      agreeable_score,
      extraversion_score,
      openness_score,
      conscientiousness_score,
      neuroticism_score
    ),
    names_to = "rasgo",
    values_to = "puntuacion"
  )

## visualizar distribución (histograma por rasgo)

distribucion01 <- 
  ggplot(
  big_five_largo,
  aes(x = puntuacion)
) +
  geom_histogram(bins = 40) +
  facet_wrap(~ rasgo) +
  labs(
    title = "Distribución de los rasgos Big Five",
    x = "Puntuación",
    y = "Frecuencia"
  )

## guardar grafico en jpg

ggsave("graficos/distribucion01.jpg" , plot = distribucion01, width = 8, height = 6, dpi = 300)
