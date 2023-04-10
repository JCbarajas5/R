# Clase 2 - Curso de Análisis Estadístico en R Nivel Básico
# 17-enero-2023

# Estadística descriptiva

library(rio)

datos <- import("datos/medidas_personas.csv")

head(datos)

datos$sexo <- as.factor(datos$sexo) ## Convertir las variables de tipo caracter (texto) a tipo factor para evitar que R nos indique un error.
## El tipo factor se usa para representar un vector como datos categóricos agrupados en diferentes niveles, en este caso, los niveles de nuestra variable sexo serian M (masculino) y F (femenino)

## Medidas de tendencia central

### Media

mean(datos$altura)

mean(datos$peso)

mean(datos$edad)

### Mediana

median(datos$altura)

median(datos$peso)

median(datos$edad)

### Moda

#### Para calcular la moda necesitamos el paquete `modeest` y utilizamos la función `mlv()` que nos devuelve los valores más frecuentes (el valor o los valores que más se repiten) en nuestro conjunto de datos.

library(modeest)

mlv(datos$altura)

mlv(datos$peso)

mlv(datos$edad)

## Medidas de dispersión

### Desviación estándar

sd(datos$altura)

sd(datos$peso)

sd(datos$edad)

### Varianza

var(datos$altura)

var(datos$peso)

var(datos$edad)

### Covarianza
#### Indica la variabilidad o variación conjunta de dos variables respecto a sus medias. Para calcularla colocamos las dos variables como argumentos dentro de nuestra función `var()`.

var(datos$altura, datos$peso)

## La función `describe()` del paquete `psych` nos muestra un resumen de nuestras variables con medidas de tendencia central y medidas de dispersión

library(psych)

describe(datos)

## Para guardar este resultado debemos crear un objeto y usar la función `data.frame()`. Después podemos utilizar la función `export()`.

describe <- data.frame(describe(datos))
describe

export(describe, "datos/describeresultados.xlsx")

summary(datos)

## Gráficos exploratorios

### Gráficos univariados

hist(datos$altura) # histograma

boxplot(datos$altura) # gráfico de cajas de una sola variable

### Gráfico multivariado

boxplot(altura ~ sexo, data = datos) # gráfico de cajas para dos variables

plot(x = datos$peso, y = datos$altura, # gráfico de dispersión (scatterplot)
     pch = 6, # pch, para indicar el estilo del símbolo (puede ser un valor del 1 al 25)
     cex = 1, # cex, para indicar el tamaño del símbolo
     col = "red", # col, para indicar el color del símbolo
     title("Peso vs Altura", 
           adj = 0.5, 
           line = 1), # title, para titulo (también puede ser el argumento main). adj, para ajustar la posición del título, valores entre 0 (izquierda) y 1 (derecha). line, para modificar la altura del título  
     xlab = "Peso", # xlab, para el título del eje x
     ylab = "Altura") # ylab, para el título del eje y

library(palmerpenguins)
data("penguins")
head(penguins)

## La función `vis_dat()` del paquete `visdat` nos muestra un gráfico con nuestras variables agrupadas por tipo (factores, números enteros, números con decimales) y también indica dónde tenemos valores NA.

library(visdat)

vis_dat(penguins)

## Con el paquete `SmartEDA` podemos explorar las variables de nuestra base de datos 

library(SmartEDA)

### Para explorar las variables numéricas:

ExpNumViz(penguins)

### Para explorar las variables categóricas:

ExpCatViz(penguins)

### Alternativa para graficar frecuencias en lugar de proporciones
library(tidyverse)

#### Primero tenemos que hacer un subconjunto de datos a partir de nuestra tabla original
pin <- penguins |>
  group_by(island) |>
  summarise(frecuencia = n())
pin

####Luego graficamos con el paquete `ggplot2`
ggplot(pin, aes(island, frecuencia)) +
  geom_col(aes(fill = island), show.legend = NULL) +
  geom_text(aes(label = frecuencia, vjust = -1)) + # `geom_text()`, para colocar la etiqueta de los datos, `vjust =` para ajustar las etiquetas en el eje y
  ylim(c(0,200)) # `ylim()`, para especificar los valores del rango del eje y
  

## El paquete `tidyverse` es un super paquete que contiene otros paquetes, entre ellos `ggplot2` que sirve para graficar datos en R

library(tidyverse)

### Para crear los gráficos usamos la función `ggplot()`. Colocamos nuestra base de datos, el argumento `aes()` es para indicar nuestro eje x y nuestro eje y (por defecto van en ese orden, pero podemos especificarlo colocando `x = variable` y `y = variable`). Para agregar argumentos a nuestro grafico utilizamos el símbolo más (+). `geom_` indica la geometría que queremos graficar.

#### Histograma

ggplot(penguins, aes(body_mass_g)) + 
  geom_histogram(fill = "mediumorchid2", # fill, para rellenar con color, también se puede usar el argumento `color = "nombre del color"` para indicar el color del borde
                 color = "black",
                 bins = 10) # bins, para indicar cuantas  secciones tendrá nuestro histograma


#### Gráfico de densidad

ggplot(penguins, aes(body_mass_g)) + 
  geom_density(fill = "tomato", alpha = 0.4) # alpha, para darle transparencia al relleno, valores de 0 (transparente) a 1 (sin transparencia)

#### Gráfico de cajas para una variable

ggplot(penguins, aes(y = body_mass_g)) +
  geom_boxplot(fill = "blue", alpha = 0.4) +
  ylab("Masa corporal (g)")

#### Eliminar los valores NA para que no aparezcan en nuestro gráfico

pinguinos <- na.omit(penguins)

#### Gráfico de barras 

ggplot(pinguinos, aes(species)) +
  geom_bar()

ggplot(pinguinos, aes(species, fill = sex)) + # En esto caso utilizamos el fill para que rellene mi variable de especie con los datos de sexo (la cantidad de observaciones)
  geom_bar(position = "dodge") # con `position = "dodge"` indicamos que aparezcan columnas a la par para cada sexo, omitiendo el arguemento position nos generaría un gráfico de columnas apiladas, también podemos especificarlo con `position = "stack"`


#### Gráfico de cajas para dos variables

grafico_cajas <- ggplot(pinguinos, aes(species, body_mass_g)) +
  geom_boxplot(aes(fill = species), show.legend = NULL) +
  geom_jitter(width = 0.3, alpha = 0.3) + # la función `geom_jitter()` es para que aparezcan nuestros datos en el gráfico de una forma dispersa, el argumento `width` es para indicar el ancho de esa dispersión (valores de 0 a 1)
  theme_classic() # con la función `theme_` podemos escoger un tema para el formato de fondo de nuestro gráfico

grafico_cajas

#### Gráfico de violín
Grafico <- ggplot(pinguinos, aes(species, body_mass_g)) +
  geom_violin(fill = "gray", show.legend = NULL, alpha = 0.4) +
  geom_jitter(width = 0.3, alpha = 1, aes(color = sex)) + # con `color` en la función `geom_jitter()` podemos especificar que coloree los puntos de nuestros datos en base a una variable, por ejemplo la variable sexo. Para eso tenemos que colocar el argumento `aes()` antes de color
  theme_classic() +
  xlab("Especies") +
  ylab("Masa corporal (g)") + 
  ggtitle("Masa corporal por Especies") + # Además de xlab, ylab, ggtitle, también podemos utilizar `labs()` y especificar los ejes `x =`, `y =` y el titulo `title`
  labs(color = "Sexo") + 
  theme(plot.title = element_text(hjust = 0.5, face = 12)) # con la función `theme()` y el argumento `plot.title = element_text()` podemos modificar la apariencia y la ubicación de nuestros título. `hjust =` para ajustar nuestro título en el eje x, valores de 0 (izquierda) a 1 (derecha). `face =`, para modificar el estilo del título (normal, negrita, cursiva, negrita + cursiva)

Grafico

## Guardar (exportar) gráficos

ggsave("imagenes/MasaCorp_Especies_Sexo.jpg") # por defecto se guarda el último gráfico que se desplegó

ggsave("imagenes/GraficoCaja.jpg", plot = grafico_cajas, dpi = 600) # para especificar el gráfico que queremos exportar debemos utilizar el argumento `plot =` y colocar el nombre del objeto que contiene nuestro gráfico. Con el argumento `dpi =` podemos especificar la cantidad de puntos por pulgada para mejorar la calidad de nuestro gráfico una vez que se exporte (por defecto es de 300 dpi)


#### Gráfico de dispersión (scatterplot)
ggplot(pinguinos, aes(body_mass_g, flipper_length_mm)) +
  geom_point() +
  theme_dark()

ggsave("imagenes/scatterplot.jpg")

ggsave("imagenes/graf.jpg", plot = Grafico)
