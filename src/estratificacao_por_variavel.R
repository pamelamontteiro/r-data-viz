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



# 5.6 Estratificação por variáveis de interesse

# Criando o objeto {`dengue_distritos`}
dengue_distritos <- dengue |>
  
  # Filtrando os registros com data de início dos 
  # sintomas maior ou igual a 1 de janeiro de 2010
  filter(DT_SIN_PRI >= '2010-01-01') |>
  
  # Agrupando as notificações pelo ano epidemiológico, semana
  # epidemiológica e distritos administrativos
  group_by(ano_epi, sem_epi, ID_DISTRIT) |>
  
  # Contando a frequência de notificações
  count(name = "casos") |>
  
  # Utilizando a função `mutate()` para criar a coluna
  # de data de início da semana epidemiológica
  mutate(data_ini = get_date(sem_epi, ano_epi, start = 7))

# Criando o gráfico
ggplot(data = dengue_distritos) +
  
  # Definindo argumentos estéticos com as variáveis usadas em x e em y
  # e a variável usada para a cor
  aes(x = data_ini, y = casos, color = ID_DISTRIT) +
  
  # Adicionando a linha referente aos casos
  geom_line() +
  
  
  # Definindo o título do gráfico.
  labs(title = "Gráfico de linhas da distribuição de casos de dengue por distrito de Rosas, entre 2010 e 2013.")
  
  # Definindo o tema base
  theme_classic()
  

  
  
  
# No ggplot2 há duas funções para criar sub-gráficos estratificados por alguma variável:
  
# facet_grid(),
# facet_wrap().
  
  ggplot(data = dengue_distritos) +
    
    # Definindo argumentos estéticos com as variáveis usadas em x e em y
    # e a variável usada para a cor
    aes(x = data_ini, y = casos, color = ID_DISTRIT) +
    
    # Adicionando a linha referente aos casos
    geom_line() +
    
    # Estratificando pelo distrito
    facet_grid(~ID_DISTRIT) +
    
    # Definindo o tema base
    theme_light() +
    
    # Definindo o título do gráfico.
    labs(title = "Número de casos notificados de dengue no estado de Rosas segundo
o distrito de residência do paciente, 2010-2012.")
  
  
  

  
  
# A função facet_wrap() funciona da mesma forma e tem o mesmo tipo de argumento. 
# Uma das diferenças entre as duas é o output da função. 
# Utilizando a mesma tabela criada anteriormente, {dengue_distritos}, 
# vamos criar o mesmo gráfico anterior, só mudando para facet_wrap().
  
  ggplot(data =dengue_distritos) +
    
    # Definindo argumentos estéticos com as variáveis usadas em x e em y
    # e a variável usada para a cor
    aes(x = data_ini, y = casos, color = ID_DISTRIT) +
    
    # Adicionando a linha referente aos casos
    geom_line() +
    
    # Estratificando pelo distrito
    facet_wrap( ~ ID_DISTRIT) +
    
    # Definindo o tema base
    theme_light() +
    # Definindo o título do gráfico.
    labs(
      title = "Número de casos notificados de dengue no estado de Rosas segundo
o distrito de residência do paciente, 2010-2012."
    )
  
  
  
  
  
  
# Acompanhe o código a seguir e repita no seu computador:
  
  # Criando uma rampa de cores utilizando códigos hexadecimais
  cores <- c("#66C2A5" , "#FC8D62" , "#8DA0CB" , "#E78AC3", "#A6D854")
  
  
  ggplot(data =dengue_distritos) +
    
    # Definindo argumentos estéticos com as variáveis usadas em x e em y
    # e a variável usada para a cor
    aes(x = data_ini, y = casos, color = ID_DISTRIT) +
    
    # Adicionando geometria de linha e definindo a espessura
    geom_line(size = 0.8) +
    
    # Estratificando pelo distrito e definindo 2 colunas de disposição dos
    # sub-gráficos
    facet_wrap(~ ID_DISTRIT, ncol = 2) +
    
    # Definindo os títulos dos eixos x e y
    #   # Definindo o título do gráfico
    labs(
      title = "Número de casos notificados de dengue no estado de Rosas segundo
o distrito de residência do paciente, 2010-2012.",
      x = 'Data ',
      y = 'Casos dengue')+
    
    # Arrumando a rampa de cores conforme o vetor criado (`cores`)
    scale_color_discrete(type = cores, name = 'Distritos') +
    
    # Definindo o tema base
    theme_light() +
    
    # Alterando o tema do gráfico, posicionando a legenda para baixo
    theme(legend.position = "bottom")
  

  
  
  
  
# Uma das formas de adequar o gráfico é definir o argumento scales como free_y dentro da função facet_wrap(). 
  
  # Criando uma rampa de cores utilizando códigos hexadecimais
  cores <- c("#66C2A5" , "#FC8D62" , "#8DA0CB" , "#E78AC3", "#A6D854")
  
  # Criando o objeto gráfico {`painel`}
  painel <- ggplot(data =dengue_distritos) +
    
    # Definindo argumentos estéticos com as variáveis usadas em x e em y
    # e a variável usada para a cor
    aes(x = data_ini, y = casos, color = ID_DISTRIT) +
    
    # Adicionando a geometria de linha e definindo
    # a espessusra
    geom_line(size = 0.8) +
    
    # Estratificando pelo distrito e definindo
    # mudança no eixo y conforme cada sub-gráfico
    facet_wrap(~ ID_DISTRIT, ncol = 2, scales = "free_y") +
    
    # Definindo os títulos dos eixos x, y e título do gráfico
    labs(
      title = "Número de casos notificados de dengue nos distritos administrativos 
    do estado de Rosas, 2010-2012.",
      x = 'Data ',
      y = 'Casos dengue') +
    
    # Arrumando a rampa de cores
    scale_color_discrete(type = cores, name = 'Distritos') +
    
    # Definindo o tema base
    theme_light() +
    
    # Alterando o tema do gráfico
    theme(legend.position = "bottom")
  
  # Plotando o objeto `painel`
  painel

  
  
# 6. Exportar os gráficos como imagem
  # Sintaxe para exportação de imagens do `ggplot2`
  ggsave(
    plot = graf_barras,
    filename = "grafico_barras_dengue_2007_2012.png"
  )
  