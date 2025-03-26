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


# 5.3 - Gráficos temporais com média móvel
dengue_semana <- dengue |>
  
  # Filtrando os registros com data de primeiros sintomas maior ou igual
  # a data de primeiro de janeiro de 2007.
  filter(DT_SIN_PRI >= '2007-01-01') |>
  
  # Utilizando a função `mutate()`pra criar novas colunas
  mutate (
    
    # Criando uma nova coluna chamada 'SEM_EPI` referente à semana
    # epidemiológica dos primeiros sintomas
    SEM_EPI = epiweek(DT_SIN_PRI),
    
    # Criando uma nova coluna chamada 'ANO_EPI` referente ao ano
    # epidemiológicos dos primeiros sintomas
    ANO_EPI = epiyear(DT_SIN_PRI),
    
    # Criando uma nova coluna chamada 'DT_INI_SEM` referente à 
    # data de início da semana epidemiológica
    DT_INI_SEM = get_date(SEM_EPI, ANO_EPI)
    
  ) |>
  
  # Agrupando as notificações pelo ano epidemiológico, semana
  # epidemiológica e data de início da semana epidemiológica
  group_by(ANO_EPI, SEM_EPI, DT_INI_SEM) |>
  
  # Contando a frequência de notificações
  count(name = 'casos')


# proximo passo
dengue_sem2 <- dengue_semana |>
  
  # Filtrando os registros com data  maior ou igual
  # a data de primeiro de janeiro de 2007.
  filter(DT_INI_SEM >= '2010-01-01') |>
  
  # Desagrupando os dados
  ungroup() |>
  
  # Substituindo os valores faltantes por zero
  replace_na(list(casos = 0)) |>
  
  # Utilizando a função `mutate()` para criar colunas
  mutate(
    
    # Criando uma nova coluna chamada 'mm14` referente à média
    # móvel dos casos notificados de dengue
    mm14 = zoo::rollmean(casos, 14, fill = TRUE, align = 'center'),
    
    # Criando uma nova coluna referente ao rótulo que será
    # usado no gráfico
    rotulo = sprintf('%02d-%s', SEM_EPI, str_sub(ANO_EPI, 3, 4))
    
    
  )


kable(head(dengue_sem2, 10))






# com gráfico de linha com a média móvel em vermelho e, por fim, uma linha pontilhada laranja mostrando 50 casos.
# Criando o objeto gráfico {`gsem1`}
gsem1 <- ggplot(data = dengue_sem2) +
  
  # Definindo argumentos estéticos com as variáveis usadas em x e em y
  aes(x = DT_INI_SEM, y = casos) +
  
  # Adicionado a geometria de barras e 
  # definindo a variável usada para o preenchimento
  geom_col(fill = "gray") +
  
  # Adicionando a geometria de linhas e definindo a cor e
  # a espessura
  geom_line(aes(y = mm14), color = 'red', size = 1) +
  
  # Adicionado uma geometria de linha cruzando com o 
  # eixo y no valor 50 e definindo a linha como 
  # tracejada (`dashed`), cor laranja e espessura
  geom_hline(
    yintercept = 50,
    linetype = 'dashed',
    color = 'orange',
    size = 1
  ) +
  
  # Arrumando a data do eixo x, definindo os intervalos
  # (de 3 em 3 meses) e o rótulo
  scale_x_date(date_breaks = '3 months',
               date_labels = '%b/%Y',
               expand = c(0, 0))  +
  
  # Definindo o tema base
  theme_light() +
  
  # Alterando o tema do gráfico
  theme(
    
    # Alterando o texto do eixo x
    axis.text.x = element_text(
      angle = 90,
      hjust = 1,
      size = 12,
      color = 'grey32'
    )) +
  
  # Definindo o título d gráfico e títulos dos eixos x e y
  labs(
    title = "Gráfico da média móvel e marcação dos 50 casos de dengue em Rosas",
    x = "Data",
    y = "Frequência"
  )

gsem1



# Com o objeto gsem1 será possível modificar alguns aspectos como a escala do eixo X 
# para representar as datas por semanas epidemiológicas e alterar o tamanho das letras dos respectivos eixos. 

gsem1 +
  
  # Definindo os títulos dos eixos x e y
  labs(x = "Semana epidemiológica", y = "Casos") +
  
  # Arrumando o eixo x, definindo os marcadores (`breaks`)
  # e os rótulos
  scale_x_date(date_breaks = '3 weeks',
               date_labels = '%W/%Y',
               expand = c(0, 0))  +
  # Alterando o tema do gráfico
  theme(
    
    # Alterando o texto do eixo x
    axis.text.x = element_text(
      angle = 90,
      hjust = 1,
      size = 6,
      color = 'grey32'
    ),
    
    # Alterando o texto do eixo y
    axis.text.y = element_text(
      hjust = 1,
      size = 14,
      color = 'grey32'
    ),
    
    # Definindo que as grades do gráfico
    # nulas
    panel.grid.major.x =  element_blank() ,
    panel.grid.minor.x =  element_blank()
  )
