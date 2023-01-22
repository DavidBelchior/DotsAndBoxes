# Projeto Nº 2: Época Normal
![image](https://user-images.githubusercontent.com/76535435/208324726-69dc1bec-cdeb-4446-b659-0055c1ddd4bc.png)
## Inteligência Artificial 22/23
### Prof. Joaquim Filipe
### Eng. Filipe Mariano

# Dots and Boxes
## Manual Do Utilizador
#### Realizado por:
#### André Matias - 202000941
#### David Belchior - 202001670
#### 21 de Dezembro de 2022

## Indice

* Introdução
* Instalação
* Interface da Aplicação
* Resultados
* Limitações do programa

## Introdução
Este documento corresponde ao manual do utilizador do projeto Dots and Boxes que é um jogo para dois jogadores. Foi publicado pela primeira vez no século 19 pelo matemático francês Édouard Lucas, que o chamou de la pipopipette.

Neste documento serão disponibilizadas informações, que tem como objetivo principal ajudar os utilizadores a compreender 
como interagir com o sistema desenvolvido (Jogo- Dots and Boxes) e compreender como este funciona.

## Instalação

A aplicação necessita de algum IDE que permita a execução do jogo desenvolvido, no qual se aconselha a instalação do IDE LispWorks.

LispWorks é uma Plataforma integrada que serve como ferramenta de desenvolvimento para Common Lisp. Poderá adquirir o PersonalEdition e fazer o seu download [Aqui](http://www.lispworks.com/products/lispworks.html)

![image](https://user-images.githubusercontent.com/76535435/208490754-d3c80aa9-4556-4fae-87b5-a5c755f775ab.png)


## Interface da Aplicação

De seguida será apresentado os respetivos menus que interagem com o utilizador e a explicação de comos estes funcionam, como também os passos necessários para jogar.

### Menu Principal

O menu principal exibe opções básicas inicias, no qual o utilizador pode escolher uma das duas opções, a primeira para jogar e a outra opção que permite sair do programa.

```

           ______________________________________________________
          |                                                      |
          |                    Dots and Boxes                    |
          |                   Desenvolvido por:                  |
          |                     Andre Matias                     |
          |                    David Belchior                    |
          |                                                      |
          |                                                      |
          |                (Pressione 1 para Jogar)              |
          |                (Pressione 2 para Sair)               |
          |______________________________________________________|

Opcao:

--> 

```

### Menu Tipo-de-Jogo

Este menu permite ao utilizador escolher como pretende jogar, ou seja humano vs maquina, começando o  humano a jogar ou vice-versa e se pretende um jogo em que sejam duas máquinas a jogar uma contra a outra.

```

           ________________________________________________________
          |                                                        |
          |                Selecione uma Opcao de Jogo:            |
          |                                                        |
          | (Pressione 1 para Humano vs Maquina -->Humano Comeca)  |
          | (Pressione 2 para Humano vs Maquina -->Maquina Comeca) |
          |              (Pressione 3 Maquina vs Maquina)          |
          |                   (Pressione 4 para Sair)              |
          |________________________________________________________|

Opcao:

--> 

```

### Menu Tempo-Jogada

Este menu permite ao utilizador dar um tempo de cada jogada entre 1 e 20 segundos e se pretender sair terá de inserir o 
número 0.

```
           ______________________________________________________
          |                                                      |
          | Insira um tempo de cada jogada entre 1 e 20 segundos:|
          |                             Ou                       |
          |                  (Pressione 0 para Sair)             |
          |______________________________________________________|

tempo:

--> 

```

### Alterar Profundidade
Se pretender alterar a profundidade máxima da jogada terá de ir até ao seguinte pedaço de código:

```lisp
(defun jogada-computador (estado tempo &optional (jogador *jogador1*) (inicial t))
  "Permite ao computador jogar."
  (terpri)
  (cond ((no-preenchidop estado) (setq *primeiro-estado* nil)(PrintDaMatriz (no-estado estado)))
        (t  (PrintDaMatriz (no-estado estado))
            (printar-detalhes inicial)
            (valores-iniciais jogador)
            (terpri)
            (format t "Jogada do Computador ~a" jogador)
            (terpri)
            (AlfaBeta estado most-negative-fixnum most-positive-fixnum 3 tempo jogador)
            
            ;;(escreve-resultado estado jogador 20000)
        )
  ) 
)

```

> **Warning**
* (AlfaBeta estado most-negative-fixnum most-positive-fixnum 3 tempo jogador) --> O valor "3" é ai que terá de alterar o 
valor para ter uma profundidade diferente


### Inserção da Diretoria
#FALTA FAZER SE FOR NECESSÁRIO
Esta secção correponde ao input solicitado ao utilizador, no qual aqui terá de inserir o caminho/diretoria onde guardou o ficheiro que contém os problemas iniciais.
A inserção deste caminho terá de seguir as seguintes normas:

> **Warning**
* Caminho entre aspas ""
* Com "barras diagonais" para a direita /

> **Note**
Como por exemplo:

"C:/Users/David/Desktop/3ano/IA/projeto/problemas.dat"


```
           ______________________________________________________
          |                  Insira a Diretoria                  |
          |                                                      |
          |                                                      |
          |             Tenha atencao a / e as aspas             |
          |                                                      |
          |______________________________________________________|

Diretoria:

-->

```

### Como Jogar
Terá de inserir uma posição e o tipo de arco que quer inserir (vertical ou horizontal) ou seja por exemplo:


```

```


## Limitações do programa
Um ponto que deveria ser melhorado seria a jogabilidade do utilizador, tal como a forma de inserção de uma jogada, uma vez 
que deveria ser ainda mais "direto", tendo de passar por 3 passos. Outro ponto seria na representação do tabuleiro, como 
esta em formato consola torna-se dificil para o utilizador saber quais são as caixas que ele fechou, uma vez que não existe 
a representação dos arcos com diferentes cores por exemplo.





