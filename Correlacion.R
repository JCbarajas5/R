# Clase 4
# 19-enero-2023

# Pruebas de correlación

# Paquetes
library(rio)
library(tidyverse)
library(GGally)
library(correlation)
library(see)
library(inspectdf)


# Datos
suelos <- import("datos/suelos.xlsx")
head(suelos)

# Prueba de correlación de Pearson
# Prueba paramétrica, requiere que los datos tengan una distribución normal

cor.test(suelos$pH, suelos$N)

ggplot(suelos, aes(pH, N)) +
  geom_point()

# Prueba de correlación de Spearman
# Prueba no paramétrica

cor.test(suelos$pH, suelos$N, method = "spearman")

# Correlación entre múltiples variables

# Con la función `ggpairs()` del paquete `GGally` 
## Primero se debe hacer un subconjunto de datos solo con las variables numéricas
## Para eso seleccionamos las columnas que deseamos incluir en nuestra prueba de correlación utilizando corchetes `[]`. [X,X] Los números a la izquierda de la coma son para seleccionar una o varias FILAS. Los números a la derecha de la coma son para seleccionar una o varias COLUMNAS. Para seleccionar columnas o filas seguidas solo basta con poner dos puntos `:` entre los numeros de la primera y la última columna que queremos seleccionar.
suelosb <- suelos[ ,6:14]
head(suelosb)

ggpairs(suelosb)

# También podemos reducir el número de variables especificando las que deseamos
ggpairs(suelosb, c("Conduc", "N", "P", "K"))

ggsave("imagenes/correlacion.jpg")


# Con la función `correlation()` del paquete `correlation`
## Esta función no requiere que hagamos un subconjunto de datos con las variables numéricas unicamente

cor <- correlation(suelos)
cor

# Para exportar como tabla
cor <- data.frame(correlation(suelos))
export(cor,"correlacionsuelos.xlsx")

## También podemos especificar el método que se utilice para realizar la correlación
corspearman <- correlation(suelos, method = "spearman")
corspearman

## Podemos generar una matriz de correlación resumida
resumen <- summary(corspearman)
resumen

## Podemos graficar la matriz resumida con la función `plot()`, para esto es necesario cargar el paquete `see`.
plot(resumen)
ggsave("imagenes/corr.jpg")


## Otra forma de presentar el gráfico anterior
corspearman %>%
  as.table() %>%
  plot(type = "tile", show_values = TRUE, show_p = TRUE)


# Con la función `inspect_cor()` del paquete `inspectdf`
ic <- inspect_cor(suelos)
ic

# Gráfico
show_plot(ic)

# Ejemplo con base de datos que tiene algunas variables que no tienen una correlación significativa
imtcars <- inspect_cor(mtcars) 
show_plot(imtcars)
