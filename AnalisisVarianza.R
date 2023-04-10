# Clase 5
# 19-enero-2023

# Análisis de varianza
## Para más de dos grupos

# Paquetes 
library(car)
library(tidyverse)
library(agricolae)
library(palmerpenguins)
library(FSA)

# Datos
data("penguins")
head(penguins)

# variable dependiente = variable respuesta
# variable independiente = variable predictora

# ANOVA
## Es una prueba paramétrica, requiere que los datos cumplan con el supuesto de normalidad y homogeneidad de varianza, para lo que deberíamos hacer una prueba de normalidad y una prueba de homogeneidad (homocedasticidad) de varianza.
## El ANOVA solo permite variables predictoras categóricas 

# Tener cuidado con el orden de las variables, primero va la variable respuesta (dependiente) y luego la variable predictora (independiente)
anova <- aov(bill_length_mm ~ species, data = penguins)

summary(anova)
# El summary nos da la información de nuestro análisis de varianza, como los grados de libertad, la suma de cuadrados, la media de cuadrados, el estadístico F y el valor de p, este último es el que interpretamos para ver si las diferencias entre los grupos son estadísticamente significativas o no.
# p < 0.05 = si hay diferencias estadísticamente significativas
# p >= 0.05 = no hay diferencias estadísticamente significativas

## Pruebas de contraste
### Se realizan para conocer entre cuáles grupos existe esa diferencia estadísticamente significativa. Si el valor de p de la prueba de ANOVA es >= 0.05 (no hay diferencias estadísticamente significativas), no es necesario hacer una prueba de contraste, aunque se puede realizar para obtener los grupos y graficarlo.

### Prueba de Tukey
contraste <- TukeyHSD(anova, "species") # especificar la variable que contiene los grupos.
contraste

### Prueba de Tukey con la función `HSD.test()` del paquete `agricolae`
contraste2 <- HSD.test(anova, "species")
contraste2
### Esta función nos da más información que la anterior

### Prueba de Duncan con la función `duncan.test()` del paquete `agricolae`
duncan <- duncan.test(anova, "species")
duncan

# Gráficos de pruebas de contraste

### Gráficos simples con el paquete base
plot(contraste)

plot(contraste2)

plot(duncan)

anova2 <- aov(body_mass_g ~ species, data = penguins)
summary(anova2)

contraste3 <- HSD.test(anova2, "species")
contraste3

plot(contraste3,
     main = "Masa corporal por especies")

## Para hacer un gráfico con el paquete `ggplot2` primero tenemos que hacer un resumen de nuestros datos, para eso usamos la función `Summarize()` del paquete `FSA`

resumen <- Summarize(body_mass_g ~ species, data = penguins)
resumen

## Después añadimos una columna con el error estándar (estadístico que mide la precisión de la estimación, es parte de la estadística inferencial y no de la estadística descriptiva)
## La fórmula para calcular el error estándar es: desviación estandar/raíz cuadrada de n. En este caso, n = número de observaciones para cada grupo.
resumen$EE <- resumen$sd / sqrt(resumen$n)
resumen

## Con el error estándar podemos calcular el intervalo de confianza al 95%
### El IC95% se calcula multiplicando el error estándar por el valor Z para ese nivel de confianza, Z = 1.96.
### Para un intervalo de confianza al 90% se multiplica por el valor Z = 1.645
### Para un intervalo de confianza al 98% se multiplica por el valor Z = 2.33
### Para un intervalo de confianza al 99% se multiplica por el valor Z = 2.757

resumen$IC95 <- resumen$EE * 1.96
resumen$LIIC95 <- resumen$mean - resumen$EE * 1.96
resumen$LSIC95 <- resumen$mean + resumen$EE * 1.96

resumen

# Gráfico con ggplot
## Gráfico de columnas con barras de error (con el IC95%)
ggplot(resumen, aes(species, mean)) +
  geom_col(width = 0.6, color = "black", fill = c("gray", "blue", "darkslategray")) +
  geom_errorbar(aes(ymin = LIIC95, ymax = LSIC95), width = 0.4) + # indicamos el límite inferior y superior que tendran nuestras barras de error
  labs(title = "Masa corporal (g) por especie",
       y = "Masa corporal (g)", 
       x = "Especies") +
  geom_text(aes(label = c("b", "b", "a")), vjust = -1.5) + # agregamos los grupos de nuestro resultado de la prueba de contraste
  ylim(c(0,5500)) +
  theme(plot.title = element_text(hjust = 0.5)) +
  theme_classic()


## Gráfico de punto
ggplot(resumen, aes(species, mean)) +
  geom_errorbar(aes(ymin = LIIC95, ymax = LSIC95), width = 0.2) +
  geom_point(shape = 19, size = 3, color = c("gray", "blue", "darkslategray")) +
  labs(title = "Masa corporal (g) por especie",
       y = "Masa corporal (g)", 
       x = "Especies") +
  geom_text(aes(label = c("b", "b", "a")), vjust = -2) +
  theme(plot.title = element_text(hjust = 0.5)) +
  theme_classic()

ggsave("imagenes/contrastepinguinos.jpg")  


# También podemos hacer un ANOVA con dos o más variables predictoras (independientes) 

anova2vars <- aov(body_mass_g ~ species + island, data = penguins)
summary(anova2vars)

contraste2vars <- HSD.test(anova2vars, c("species", "island")) # especificamos cuáles son los grupos
contraste2vars


## Alternativa al ANOVA
# Kruskal-Wallis
## Es una prueba no paramétrica, no requiere que la varianza de los datos tenga una distribución normal ni homogeneidad de varianza entre los grupos.

kruskal.test(body_mass_g ~ species, data = penguins)

## La prueba de contraste de Dunn es similar a la que se hace con la función `TukeyHSD()` del paquete base para un ANOVA
dunnTest(body_mass_g ~ species, data = penguins)

## La función `kruskal()` del paquete `agricolae` nos brinda el mismo formato de resultados que la función `HSD.test()` o la función `duncan.test()` para un ANOVA
kruskal <- kruskal(penguins$body_mass_g, penguins$species)
kruskal

plot(kruskal)

# Modelos lineales
### Los modelos lineales generales se basan en una regresión lineal simple y se utilizan cuando nuestra variable predictora (independiente) es numérica.

### Para facilitar la interpretación del resultado del modelo vamos a convertir nuestra variable de masa corporal de gramos a kilogramos
pin <- penguins
pin$masakg <- penguins$body_mass_g / 1000
head(pin)

## El modelo lineal se ejecuta con la función `lm()`
### También debemos tener cuidado con el orden de nuestra variable respuesta y nuestra variable predictora
modelo <- lm(flipper_length_mm ~ masakg, data = pin)

summary(modelo)
## El summary del modelo nos brinda información sobre la distribución del los residuales del modelo. Nos muestra el intercepto (el valor que tendría nuestra variable respuesta en el eje y cuando nuestra variable predictora es 0 en el eje x). El estimado bajo el intercepto es el resultado que interpretamos para este modelo. En este caso, la interpretación es: Por cada unidad (kilogramo) que aumenta mi variable predictora (masa corporal en kg), la variable respuesta (tamaño de aleta) aumenta 15.28 unidades (milímetros). Si el efecto fuese inversamente proporcional (si al aumentar la masa corporal, el tamaño de aleta disminuye) el valor del estimado sería negativo. Este resultado se basa en nuestro conjunto de datos y puede diferir si alguien tiene datos diferentes a los nuestros. El summary también nos devuelve el resultado del error estándar de esa estimación, el estadístico T, y el valor de p que nos indica si el efecto de nuestra variable predictora sobre nuestra variable respuesta es estadísticamente significativo o no. p < 0.05 = estadísticamente significativo; p >= 0.05 = No estadísticamete significativo. En la parte inferior del summary también nos aparece un valor de R cuadrado ajustado que indica cuánto explica nuestro modelo la variación en nuestros datos, en este caso, es un 0.758 que pasado a porcentaje sería 75.8%, y la interpretación es: la variable predictora (masa corporal) explica el 75.8% de la varianza de la variable respuesta (tamaño de aleta).


## También podemos generar modelos lineales con variables predictoras categóricas
modelocat <- lm(flipper_length_mm ~ species, data = penguins)
summary(modelocat)
### En este caso, la interpretación de los estimados es un poco diferente. El intercepto es la media de la variable respuesta (tamaño de aleta en mm) para el primer nivel de la variable predictora (especie Adelie), los siguientes estimados son la diferencia que hay entre el resto de niveles de la variable predictora comparados con el primer nivel, en este caso, el estimado para speciesChinstrap indica que el tamaño de aleta de la especie Chinstrap es 5.87 mm mayor que el tamaño de aleta de la especie Adelie (primer nivel de la variable predictora); el estimado para speciesGentoo indica que el tamaño de aleta de la especie Gentoo es 27.23 mm mayor que el tamaño de aleta de la especie Adelie. Si una de las especies tuviese un tamaño de aleta inferior al de la especie del primer nivel, el valor del estimado sería negativo. El resto de los resultados en el summary se interpretan de la misma forma que en el modelo anterior.