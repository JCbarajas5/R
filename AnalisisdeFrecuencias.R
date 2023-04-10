# Clase 3
# 18-enero-2023

#Paquetes
library(DescTools)
library(rio)
library(gtsummary)
library(vcd)

# Análisis de frecuencias

# Chi cuadrado
### Muy utilizado cuando realizamos encuestas y tenemos proporciones

x <- c(tortillas = 300, pan = 250)

chi <- chisq.test(x)
# p < 0.05 = Si hay diferencias estadísticamente significativas
# p >= 0.05 = No hay diferencias estadísticamente significativas

chi$observed

chi$expected
## por defecto los valores esperados son del 50% para cada proporción (cuando solo tenemos dos opciones)

chi$stdres
# -2, 2, los que se pasan de esos valores son los que aportan a la significancia estadística


## Para especificar un valor esperado diferente

chiesp <- chisq.test(x = c(300,250), p = c(0.2, 0.8)) # con el argumento `p =` indicamos la proporción que nosotros esperariamos (por defecto la proporción esperada es del 50% para ambas frecuencias)

chiesp # El valor de p solo va a indicar si los valores observados son estadísticamente diferentes o no de los valores esperados, pero no nos indica la dirección de esa diferencia (menor o mayor)

chiesp$expected

chiesp$observed

prop.test(300, 550, p = 0.2)


## Estimación de proporciones con intervalos de confianza
binom.test(300, 550)

binom.test(250, 550)

## Estimación de la diferencia entre las dos proporciones respecto al total de la muestra
BinomDiffCI(300, 550, 250, 550)
# est 0.09090909*100 = 9.09%, IC95% = 3 - 15%

## Estimación de proporciones para más de dos opciones
MultinomCI(c(300, 250, 400))

# Tablas de contingencia

onco <- import("datos/oncocercosis.xlsx")
head(onco)

### Cambiar nombre a columnas
# Podemos crear una nueva columna con el nombre que queramos
onco$Infeccion <- onco$mf
head(onco)

### Podemos cambiar el nombre a una columna existente, para eso especificamos el número de columna dentro de corchetes `[]`
colnames(onco)[2] <- "Infeccion"
head(onco)

## Tabla de contingencia sencilla
contingencia <- table(onco$mf, onco$area)
contingencia

## Tabla de contingencia más compleja
contingencia2 <- tbl_cross(onco, Infeccion, area, percent = "cell") # el argumento `percent = "cell"` es para indicarle que agrege la proporción para cada una de las celdas

contingencia2


## Gráfico a partir de mi tabla de contingencia

mosaic(~ Infeccion + area, data = onco, shade = TRUE) # El argumento `shade = TRUE` es para agregar color a las celdas en base a los valores observados contra los valores esperados. También muestra una escala de color para la interpretación. Los valores de residuales que estén entre -2 y 2 son los que el valor observado no difiere significativamente del valor esperado.

## También podemos hacer una prueba de chi cuadrado a partir de nuestras tablas de contingencia

chitabla <- chisq.test(contingencia)
chitabla

chitabla$method

chitabla$observed

chitabla$expected

chitabla$stdres

data("HairEyeColor")

HairEyeColor

mosaic(HairEyeColor, shade = TRUE)
