# Clase 3
# 18-enero-2023

# Paquetes
library(rio)
library(car)
library(DescTools)
library(interpretCI)
library(nortest)
library(MVN)

# Pruebas de normalidad y homocedasticidad

# Prueba de normalidad de Shapiro-Wilk (para muestras de <= 50 datos)

datos <- import("datos/medidas_personas.csv")
head(datos)

shapiro.test(datos$altura)
# p < 0.05 = datos tienen una distribución NO normal
# p > 0.05 = datos tienen una distribución normal

SM <- subset(datos, sexo == "M")
SF <- subset(datos, sexo == "F")

shapiro.test(SM$altura)
shapiro.test(SF$altura)

shapiro.test(datos$peso)
shapiro.test(SM$peso)

shapiro.test(datos$edad)

# Prueba de normalidad de Kolmogorov-Smirnov (para muestras > 50 datos)

ks.test(datos$altura, pnorm, mean(datos$altura), sd(datos$altura)) # para esta prueba tenemos que especificar la media y la desviación estándar de los datos, si no lo hacemos, retornará un valor de p diferente.

# Prueba de normalidad de Lilliefors con una función del paquete `DescTools`

LillieTest(datos$altura)

# o con una función del paquete `nortest`

lillie.test(datos$altura)


# Pruebas de normalidad multivariada con el paquete `MVN`

datos

multivariada <- mvn(data = datos[,2:4], mvnTest = "royston", univariateTest = "SW")
multivariada
multivariada$multivariateNormality
multivariada$univariateNormality

multisubset <- mvn(data = datos, subset = "sexo", mvnTest = "royston", univariateTest = "Lillie")
multisubset
multisubset$multivariateNormality
multisubset$univariateNormality


# Pruebas de homogeneidad de la varianza (homocedastidad)

# Prueba de Levenne con el paquete `car`

leveneTest(altura ~ sexo, data = datos)
# p < 0.05 = datos con heterogeneidad de varianza
# p > 0.05 = datos con homogeneidad de varianza

# Prueba de Levenne con el paquete `DescTools`
LeveneTest(altura ~ sexo, data = datos)

# También podemos hacer una prueba F para comparar la homogeneidad entre dos varianzas
var.test(altura ~ sexo, data = datos)


# Pruebas de hipótesis
# Para comprobar si hay diferencias estadísticamente significativas entre dos grupos

# T Student
# Comparar 2 grupos

t.test(altura ~ sexo, data = datos)
# p < 0.05 = Si hay diferencias estadísticamente significativas
# p >= 0.05 = No hay diferencias estadísticamente significativas

# Alternativa al T Student

## Wilcoxon (Mann-Whitney)

wilcox.test(altura ~ sexo, data = datos)
# p < 0.05 = Si hay diferencias estadísticamente significativas
# p >= 0.05 = No hay diferencias estadísticamente significativas

# Estimación de parámetros

meanCI(datos, sexo, altura)

# Se puede decir con un 95% de confianza que la diferencia en la altura entre el sexo femenino y el sexo masculino está entre 12.31 y 22.31 cm (media de 17.31 cm) p = 6.622e-10

