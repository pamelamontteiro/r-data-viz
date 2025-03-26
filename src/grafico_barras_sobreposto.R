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





#4.1 Gráfico de barras
# Criando a tabela {`dengue`}
dengue <- nindi |>
  
  # Filtrando os registros de casos de dengue (CID = A90)
  filter(ID_AGRAVO == 'A90') |>
  
  # Criando novas colunas
  mutate(
    
    # Transformando a variável `DT_SIN_PRI` para data
    DT_SIN_PRI = ymd(DT_SIN_PRI),
    
    # Criando uma nova coluna chamada 'sem_epi', referente à semana
    # epidemiológica dos primeiros sintomas
    sem_epi = epiweek(DT_SIN_PRI),
    
    # Criando uma nova coluna chamada 'ano_epi', referente ao ano epidemiológico
    # dos primeiros sintomas
    ano_epi = epiyear(DT_SIN_PRI),
    
    # Criando uma nova coluna chamada 'mes', referente ao mês dos primeiros sintomas
    mes = month(DT_SIN_PRI),
    
    # Transformando a coluna `NU_ANO` no tipo numérico
    NU_ANO = as.numeric(NU_ANO)
  )


# criando gráfico de barras para avaliação temporal da dengue
ggplot(data = dengue, aes(x = NU_ANO)) + geom_bar()





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




# Gráfico de barras sobreposto
# Criando o objeto gráfico {`graf_barras_sobrepostas`}
graf_barras_sobrepostas <- ggplot(data = dengue_ano) +
  
  # Definindo argumentos estéticos com as variáveis usadas em x e em y
  # e a variável usada para o preenchimento das colunas
  aes(x = NU_ANO, y = n_casos, fill = CS_SEXO) +
  
  # Adicionando a geometria de colunas e definindo o tipo empilhado
  geom_col(position = 'stack') +
  
  # Definindo os títulos dos eixos x e y, rodapé, subtítulo e título do gráfico.
  # Para a legenda, estamos definindo o título como "Sexo"
  labs(
    title = 'Casos Notificados de Dengue em Rosas - Cidade Fictícia',
    subtitle =  '2007 a 2012',
    caption = 'Fonte: SINAN',
    x = "Ano",
    y = "Casos",
    fill = 'Sexo'
  ) +
  
  # Arrumando o eixo x, definindo quais os marcadores (`breaks`)
  # serão mostrados que, no caso, será uma sequência de 2007 a 2012,
  # referente aos anos.
  scale_x_continuous(breaks = 2007:2012) +
  
  # Definindo o tema base
  theme_light()

# Plotando o objeto `graf_barras_agrupadas`
graf_barras_sobrepostas






#Gráfico de barras agrupadas da distribuição de casos de dengue por sexo.
# Criando o objeto gráfico {`graf_barras_agrupadas`}
graf_barras_agrupadas <- ggplot(data = dengue_ano) +
  
  # Definindo argumentos estéticos com as variáveis usadas em x e em y
  # e a variável usada para o preenchimento das colunas
  aes(x = NU_ANO, y = n_casos, fill = CS_SEXO) +
  
  # Adicionando a geometria de colunas e definindo o tipo agrupado
  geom_col(position = 'dodge') +
  
  
  # Definindo os títulos dos eixos x e y, rodapé, subtítulo e título do gráfico.
  # Para a legenda, estamos definindo o título como "Sexo"
  labs(
    title = 'Gráfico de barras agrupadas de casos de dengue por sexo.',
    subtitle =  '2007 a 2012',
    caption = 'Fonte: SINAN',
    x = "Ano",
    y = "Casos",
    fill = 'Sexo'
  ) +
  
  # Definindo o título da legenda das cores usadas para preenchimento
  # das colunas
  labs(fill = 'Sexo') +
  
  # Arrumando o eixo x, definindo quais os marcadores (`breaks`)
  # serão mostrados que, no caso, será uma sequência de 2007 a 2012,
  # referente aos anos.
  scale_x_continuous(breaks = 2007:2012) +
  
  # Definindo o tema base
  theme_light()

# Plotando o objeto `graf_barras_agrupadas`
graf_barras_agrupadas