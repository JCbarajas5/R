# Clase 1 - Curso de Análisis Estadístico en R Nivel Básico
# 16-enero-2023

# Comandos básicos

## Sumas

2 + 2

## Restas

3 - 1

## Multiplicaciones

3 * 3

## Divisiones

3 / 3

## Operaciones combinadas

4 * 2 + 3 / 2
4*2+3/2

## Raiz cuadrada con la función `sqrt()`

sqrt(49)

## Logaritmos con la función `log()`

log(4)

## Exponenciales con la función `exp()`

exp(4)

# Creación de objetos

### Para eso debemos darle un nombre a nuestro objeto y luego haciendo uso de la flecha (<-) asignamos la variable que irá dentro de nuestro objeto

#### Variable numérica única

numero <- 49
numero

#### Variable de texto (categórica) única
##### Las variables de texto deben ir entre comillas ("") para que R reconozca que es un texto.

objeto <- "variables"

#### Además de la flecha (<-), también se puede utilizar el igual (=) para asignar una variable a un objeto

objeto1 = "hola"

#### Y también pueden colocar la flecha de manera inversa 

"hola" -> objeto2


## Vectores

### la función `c()` se utiliza para concatenar datos 

vector <- c(49, 12, 15, 64, 24)
vector

vector2 <- c("David", "Rosa")

altura <- c(180, 150, 169, 161, 179, 173, 145)

#### Función para generar una variable aleatoria con distribución normal `rnorm()`
##### Los argumentos de esta función son `n` que será el número de observaciones que deseamos, `mean` que será la media que tendrá nuestra variable, y `sd` que será la desviación estándar que tendran nuestros datos.

altura1 <- rnorm(n = 5, mean = 170, sd = 20)
altura1

##### Para redondear valores con muchos decimales podemos utilizar la función `round()`, para esto tenemos que colocar el nombre del objeto que contiene nuestra variable y con el argumento `digits` especificamos la cantidad de decimales que queremos.

round(altura1, digits = 2)

#### Otra forma de generar una variable aleatoria es mediante la función `sample()`. Aquí colocamos el rango que contendrá nuestros datos separado con dos puntos (:), esto indica que mis observaciones tendrán datos de alturas entre 150 y 195 cm. Con el argumento `size` indicamos el número de observaciones o datos que queremos 

altura2 <- sample(150:195, size = 5)
altura2

nombres <- c("David", "Rosa", "Abril", "Roger", "Jairo", "Adrian", "Ana")

# Creacion de tablas

## Para elaborar una tabla utilizamos la función `data.frame()` y colocamos las variables que hicimos previamente en el orden que queremos que aparezcan en nuestra tabla.
## Todas las variables que ingresemos en nuestra tabla deben tener el mismo número de observaciones.

tabla <- data.frame(nombres, altura)

## Agregar nuevas columnas (variables) a una tabla existente

peso <- c(80, 67, 54, 62, 70, 80, 75)

### Para eso utilizamos el símbolo de dólar ($) y especificamos el nombre de nuestra nueva variable y con la flecha (<-) o el igual (=) asignamos la variable deseada

tabla$peso <- peso

sexo <- c("M", "F", "F", "M", "M", "M", "F")

tabla$sexo <- sexo 

## Formas de visualizar nuestras tablas

View(tabla) # abre una pestaña mostrando toda la tabla

head(tabla) # muestra las primeras seis (6) filas de nuestra tabla

tail(tabla) # muestra las últimas seis (6) filas de nuestra tabla

summary(tabla) # muestra un resumen de las variables que tenemos en nuestra tabla

str(tabla) # muestra la estructura de nuestra tabla

# Guardar (exportar) nuestras tablas

## En formato .csv con la función `write.csv`

write.csv(tabla, file = "datos/tabla.csv") # Colocamos dentro de comillas ("") la ruta de ubicación donde queremos que se guarde nuestra tabla. Si queremos guardarla en una carpeta fuera de la carpeta que contiene nuestro proyecto de R, debemos colocar la ruta completa de ubicación.Por ejemplo: "C:\Users\Nombre\Documents\CursoR\datos\tabla.csv"
#Recuerden colocar el formato después del nombre que queremos asignar a nuestra tabla, en este caso .csv

##También podemos hacerlo con ayuda de paquetes
#### Llamar paquetes con la función `library()`

library(rio) # El paquete `rio` incluye funciones para importar y exportar bases de datos

## En formato .xlsx (excel)

export(tabla, "datos/tabla.xlsx") # De igual forma, si queremos guardar nuestra tabla en una carpeta externa, debemos especificar la ruta completa de ubicación de esa carpeta.

# Importar tablas o bases de datos

## Para importar tablas en formato .csv utilizamos la función `read.csv()` y colocamos la ruta de ubicación de nuestra tabla entre comillas ("").

tablaimportada <- read.csv("datos/tabla.csv")
tablaimportada

## También podemos hacerlo con la función `import()` del paquete `rio`

tablaexcel <- import("datos/tabla.xlsx")
