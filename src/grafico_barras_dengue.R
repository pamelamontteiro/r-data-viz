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





# Criando o objeto gráfico {`graf_barras`}
graf_barras <- ggplot(dengue, aes(x = factor(NU_ANO))) +
  
  # Adicionando uma geometria de barras e definindo a cor do preenchimento
  # das barras
  geom_bar(fill = 'purple') +
  
  # Definindo os títulos dos eixos x e y, rodapé, subtítulo e título do gráfico
  labs(
    title = 'Casos Notificados de Dengue em Rosas - Cidade Fictícia',
    subtitle =  '2007 a 2012',
    caption = 'Fonte: SINAN',
    x = "Ano",
    y = "Casos"
  ) +
  
  # Definindo o tema base do gráfico
  theme_light()

# Plotando o objeto `graf_barras`
print(graf_barras)