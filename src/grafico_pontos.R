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





#4.2 Graficos
# casos por ano segundo o sexo do paciente notificado com suspeita de dengue, 
#no estado fictício de Rosas, entre os anos de 2007 e 2012.
# Criando a tabela {`dengue_ano`}
dengue_ano <- dengue |>
  
  # Filtrando os registros cuja coluna `CS_SEXO` não tenha registros como `I`
  filter(CS_SEXO != 'I') |>
  
  # Agrupando as notificações pelo ano e sexo
  group_by(NU_ANO, CS_SEXO) |>
  
  # Contando a frequência de notificações
  count(name = 'n_casos')


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


#Gráfico de pontos, com título e subtítulo, da distribuição da variável peso com a variável altura,
#segundo sexo, dos entrevistados no VIGITEL 2015.
ggplot(data = vigitel) +
  
  # Definindo argumentos estéticos com as variáveis usadas em x e em y
  # e a variável usada para o preenchimento das barras do histograma
  aes(x = peso, y = altura, colour = sexo) +
  
  # Adicionando a geometria de pontos e definindo o tamanho do ponto
  geom_point(size = 1.5) +
  
  # Definindo os títulos dos eixos x e y, rodapé, subtítulo e título do gráfico.
  # Para legenda, estamos definindo o título para "Sexo".
  labs(
    title = 'Vigilância de Fatores de Risco e Proteção para Doenças Crônicas',
    subtitle =  'Inquérito por telefone Vigitel',
    caption = 'Fonte: Vigitel, 2015.',
    x = "Peso (kg)",
    y = "Altura (cm)",
    colour = "Sexo"
  ) +
  
  # Definindo o tema base
  theme_light()
