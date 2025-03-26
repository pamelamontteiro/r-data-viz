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



# 5.4 Pirâmides etárias

#Dados Pirâmides etárias
# Criando o objeto {`piramide`}
piramide <- dengue |>
  
  # Filtrando os registros com sexo diferente de "I" (ignorado)
  filter(CS_SEXO != 'I') |>
  
  # Utilizando a função `mutate()` para criar colunas
  mutate(
    # Criando uma coluna de idade conforme a codificação da variável NU_IDADE_N
    idade_anos = if_else(str_sub(NU_IDADE_N, 1, 1) == "4", 
                         as.numeric(str_sub(NU_IDADE_N, 2, 4)), 0),
    
    # Criando uma coluna de faixa etária a partir da variável idade dos casos 
    # notificados
    # utilizando a função `cut()`
    fx_etaria = cut(
      
      # Definindo qual variável será classificada em faixas
      x = idade_anos,
      
      # Definindo os pontos de corte das classes
      breaks = c(-Inf, 10, 20, 30, 40, 50, 60, Inf),
      
      # Definindo o tipo do ponto de corte
      right = FALSE,
      include.lowest = FALSE,
      
      # Definindo os rótulos das classes
      labels = c("0-9", "10-19", "20-29", "30-39",  "40-49",  "50-59", "60 anos e+")
    )
  ) |>
  
  # Contando a frequência da faixa etária e sexo
  count(fx_etaria, CS_SEXO) |>
  
  # Utilizando a função `mutate()` para criar a coluna que
  # vai receber as configurações da pirâmide etária
  mutate(n = ifelse (CS_SEXO == 'F', n * -1, n))




#Tabela {piramide} com dados organizados para gerar um gráfico no formato pirâmide
kable(head(piramide, 10))



#Gráfico no formato pirâmide com a distribuição dos casos de dengue em Rosas por sexo.
# para a visualização da pirâmide etária de casos de dengue em Rosas. 
ggplot(data = piramide) +
  
  # Definindo argumentos estéticos com as variáveis usadas em x e em y
  # e a variável usada para o preenchimento das barras da pirâmide
  aes(x = n,
      y = factor(fx_etaria),
      fill = fct_drop(CS_SEXO)) +
  
  # Adicionando a geometria de colunas, definindo
  # a largura e o tipo de colunas
  geom_col(width = 0.9, position = "identity") +
  
  # Arrumando o eixo x, definindo os rótulos
  # a serem mostrados
  scale_x_continuous(labels = abs(c(-200, -100, 0, 100, 200))) +
  
  # Definindo os títulos dos eixos x, y e título da legenda do gráfico
  labs(
    title = 'Pirâmide etária dos casos notificados de dengue no estado de Rosas, 
    2007-2012',
    x = 'Número de casos notificados',
    y = 'Faixa Etária',
    fill = 'Sexo'
  ) +
  
  # Definindo o tema base
  theme_light() 