
# 1.1 Preparando os dados
# Carregando pacotes exigidos: tidyverse
if(!require(tidyverse)) install.packages("tidyverse");library(tidyverse)



# Importando o banco de dados {`vigitel_2015.csv`}
# e armazenando os dados no objeto `vigitel`
vigitel <- read_csv2('/home/pamela/Documentos/r-data-viz/Dados/vigitel_2015.csv')


# Visualizando a estrutura do objeto {`vigitel`}
glimpse(vigitel)


vigitel <- vigitel |> 
  
  # Transformando os valores da coluna "fuma" para "sim" e "não" apenas
  mutate(fuma = if_else(fuma == "não", "não", "sim"))


# 1.2 Utilizando a função plot()
par(mfrow = c(2, 2))

plot(
  x = vigitel$peso,
  y = vigitel$altura,
  pch = 19,
  col = "blue",
  cex = 0.3,
  main = "Gráfico 1. Gráfico de pontos Peso x Altura",
  xlab = "Peso",
  ylab = "Altura"
)
abline(v = mean(vigitel$peso, na.rm = T), col = "green", lty = 2, lwd = 3)
abline(h = mean(vigitel$altura, na.rm = T), col = 2, lty = 2, lwd = 3)

# Gráfico 2
boxplot(
  vigitel$idade ~ vigitel$sexo,
  col = c("darkgreen", "darkred"),
  main = "Gráfico 2. Boxplot Idade / Sexo",
  xlab = "Sexo",
  ylab = "Idade"
)

# Gráfico 3
hist(
  x = vigitel$peso,
  col = "salmon",
  main = "Gráfico 3. Histograma Peso",
  xlab = "Peso",
  ylab = "Frequência"
)

# Gráfico 4
barplot(prop.table(table(vigitel$fuma)),
        col = c("steelblue", "orange"),
        main = "Gráfico 4.Proporção de Fumantes")