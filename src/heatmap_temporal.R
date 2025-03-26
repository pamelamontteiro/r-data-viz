# Gráficos que visualizem os dados para avaliação das notificações de dengue do Estado de Rosas (fictício). 
# Para isso você precisará organizar informações que possam apresentar a situação das notificações do estado entre os anos 2007 e 2012 para o secretário de saúde.

# Esta primeira linha verifica se o pacote está instalado.
# Caso não esteja, irá prosseguir com a instalação
if(!require(foreign)) install.packages("foreign");library(foreign)
if(!require(knitr)) install.packages("knitr");library(knitr)
if(!require(lubridate)) install.packages("lubridate");library(lubridate)
if(!require(aweek)) install.packages("aweek");library(aweek)
if(!require(xts)) install.packages("xts");library(xts)
if(!require(plotly)) install.packages("plotly");library(plotly)
if(!require(ggTimeSeries)) install.packages("ggTimeSeries");library(ggTimeSeries)


# criando objeto do tipo dataframe (tabela) {`nindi`} com o banco de dados 
# {`NINDINET.dbf`}
nindi <- read.dbf('/home/pamela/Documentos/r-data-viz/Dados/NINDINET.dbf', as.is = TRUE)



# 4.4 Gráfico de pontos
ggplot(data = vigitel) +
  
  # Definindo os títulos dos eixos x e y, rodapé, subtítulo e título do gráfico
  labs(
    title = 'Grafico de Distribuição de Peso e Altura por Sexo - VIGITEL 2015',
  ) +
  
  
  # Definindo argumentos estéticos com as variáveis usadas em x e em y
  # e a variável usada para as cores dos pontos
  aes(x = peso, y = altura, colour = sexo) +
  
  # Adicionando a geometria de pontos
  geom_point()




#5.2 Gráficos temporais de calor (heatmaps)
# Criando o objeto {`dengue_heat`}
dengue_heat <- dengue |>
  
  # Filtrando os registros dentre intervalos de datas
  filter(DT_SIN_PRI >= "2007-01-01" & DT_SIN_PRI <= "2011-12-31") |>
  
  # Contando a frequência de notificações por data dos primeiros sintomas
  count(DT_SIN_PRI, name = 'casos') |>
  
  # Utilizando a função `mutate()` para criar a coluna de ano de início
  # dos primeiros sintomas
  mutate(Ano = year(DT_SIN_PRI))


kable(head(dengue_heat, 10))

#O pacote ggTimeSeries adiciona uma série de funções, 
# entre elas a que vamos utilizar para fazer mapas de calor tipo calendário.
ggplot_calendar_heatmap(dengue_heat, 'DT_SIN_PRI','casos')



ggplot(data = dengue_heat) +
  
  # Definindo argumentos estéticos com as variáveis usadas em x e em y
  # e a variável usada para o preenchimento da série
  aes(date = DT_SIN_PRI, fill = casos) +
  
  # Adicionando geometria de `heatmap`
  stat_calendar_heatmap() +
  
  # Definindo a rampa de cores de preenchimento 
  scale_fill_gradient2(
    low = 'lightblue',
    high = 'red',
    mid = 'orange',
    midpoint = 75
  ) +
  
  # Arrumando o eixo y, definindo quais os marcadores (`breaks`) 
  # serão mostrados que, no caso, será uma sequência de 1 a 7, referente aos
  # dias da semana. O argumento `expand` ajuda nesse processo.
  scale_y_continuous(
    breaks = c(1:7),
    labels = c("S", "T", "Q", "Q", "S", "S", "D"),
    expand = c(0, 0)
  ) +
  
  # Arrumando o eixo x, definindo quais os marcadores (`breaks`) e
  # os rótulos do gráfico `labels`.
  scale_x_continuous(
    breaks = c(2, 6, 11, 16, 19, 24, 28, 33, 37, 42, 46, 50),
    labels = c(
      'J', 'F', 'M', 'A', 'M', 'J',
      'J', 'A', 'S', 'O', 'N', 'D'
    ),
    expand = c(0, 0)
  ) +
  
  # Definindo a estratificação por ano e o visual com uma coluna
  facet_wrap( ~ Ano, ncol = 1) +
  
  # Definindo o tema base
  theme_light() +
  
  # Definindo título do gráfico
  labs(
    title = "Mapa de calor dos casos notificados de dengue, estado de Rosas, 
    2007-2012.",
    fill = "Número de casos \nnotificados"
  )
