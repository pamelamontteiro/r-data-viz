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




# 4.5 Histogramas

# Criando o objeto dataframe {`dengue_2008`}
dengue_2008 <- dengue |>
  
  # Filtrando os registros com ano epidemiológico igual a 2008
  filter(ano_epi == 2008)


#eixo x definiremos a variável de data dos primeiros sintomas (DT_SIN_PRI) e “preencheremos” o gráfico 
#com as categorias da variável sexo (CS_SEXO), utilizando o argumento fill. 
#A geometria para histograma é representada pela função geom_histogram().

# Utilizando a tabela {`dengue_2008`} criada anteriormente
ggplot(data = dengue_2008) +
  
  # Definindo argumentos estéticos com as variáveis usadas em x e em y
  # e a variável usada para o preenchimento das barras do histograma
  aes(x = DT_SIN_PRI, fill = CS_SEXO) +
  
  # Adicionado geometria de colunas de histograma
  geom_histogram() +
  
  # Definindo os títulos dos eixos x e y, rodapé, subtítulo e título do gráfico.
  # Para legenda, estamos definindo o título para "Sexo".
  labs(
    title = "Distribuição dos casos notificados de dengue, Rosas, 2008.",
    caption = 'Fonte: SINAN',
    x = "Data dos primeiros sintomas",
    y = "Frequência",
    fill = 'Sexo'
  ) +
  
  # Definindo o tema base
  theme_light()