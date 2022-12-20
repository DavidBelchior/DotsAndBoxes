# Projeto Nº 1: Época Normal
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

## Introdução
Este documento corresponde ao manual do utilizador do projeto Dots and Boxes que é um jogo para dois jogadores. Foi publicado pela primeira vez no século 19 pelo matemático francês Édouard Lucas, que o chamou de la pipopipette.

Neste documento serão disponibilizadas informações, que tem como objetivo principal ajudar os utilizadores a compreender como interagir com o sistema desenvolvido  
(Jogo- Dots and Boxes) e compreender como esta funciona.

## Instalação

A aplicação necessita de algum IDE que permita a execução do jogo desenvolvido, no qual se aconselha a instalação do IDE LispWorks.

LispWorks é uma Plataforma integrada que serve como ferramenta de desenvolvimento para Common Lisp. Poderá adquirir o PersonalEdition e fazer o seu download [Aqui](http://www.lispworks.com/products/lispworks.html)

![image](https://user-images.githubusercontent.com/76535435/208490754-d3c80aa9-4556-4fae-87b5-a5c755f775ab.png)


## Interface da Aplicação

De seguida será apresentado os respetivos menus que interagem com o utilizador e a explicação de comos estes funcionam, como também os passos necessários a realizar para a execução de um dos algoritmos pretendidos:

### Menu Principal

O menu principal exibe opções básicas inicias, no qual o utilizador pode escolher uma das duas opções, a primeira para realizar experiências que corresponde aos algoritmos e a outra opção que permite sair do programa.

```

           ______________________________________________________
          |                                                      |
          |                    Dots and Boxes                    |
          |                      Feito por:                      |
          |                     Andre Matias                     |
          |                    David Belchior                    |
          |                                                      |
          |                                                      |
          |            (Pressione 1 para Experiencias)           |
          |                (Pressione 2 para Sair)               |
          |______________________________________________________|

Opcao:

--> 

```

### Menu Algoritmos

O menu referente aos algoritmos, este exibe cinco opções, no qual a primeira corresponde à execução do algoritmo BFS (Breadth First Search), a segunda corresponde à 
execução do algoritmo DFS (Depth-first search), a terceira corresponde ao algoritmo A* e a última opção corresponde à opção que permite sair do programa.

```

           ______________________________________________________
          |                                                      |
          |               Selecione um Algoritmo:                |
          |                                                      |
          |                (Pressione 1 para BFS)                |
          |                (Pressione 2 para DFS)                |
          |               (Pressione 3 para ASTAR)               |
          |                (Pressione 4 para Sair)               |
          |______________________________________________________|

Opcao:

-->

```


### Inserção da Diretoria

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

### Menu Heuristica
Este menu permite ao utilizador escolher se pretende utilizar a heurística base ou a desenvolvida pelo grupo. 

> **Note**
Ambas as heurísticas foram anteriormente descritas. 

```


           ______________________________________________________
          |            Insira a Heuristica pretendida            |
          |                                                      |
          |                                                      |
          |                        1-Dada                        |
          |                    2-Devensolvida                    |
          |                                                      |
          |______________________________________________________|

Opcao:

-->

```

### Escolha do Problema

Este menu correponde ao input solicitado ao utilizador, no qual aqui terá de inserir um número no intervalo de números disponibilizados.

> **Note**
como por exemplo:

```
           ______________________________________________________
          |                  Escolha o Problema                  |
          |                                                      |
          |                    0-Menu-Inicial                    |
          |                     1-Problema A                     |
          |                     2-Problema B                     |
          |                     3-Problema C                     |
          |                     4-Problema D                     |
          |                     5-Problema E                     |
          |                     6-Problema F                     |
          |                                                      |
          |______________________________________________________|

Opcao:

-->

```
No qual, neste caso o utilizador apenas poderá colocar os seguintes números 1, 2, 3 ou 4.


## Resultado

Por fim nesta secção será descrita o resultado apresentado no ficheiro solução que é o resultado obtido através dos algoritmos implementados que também são visualizados no output da consola.

Exemplo de um resultados obtidos no ficheiro solução:

```
Tempo de execucao: 0 ms

Penetrancia: 8/93

Factor de ramificacao: 1.5400125

Numero de nos gerados: 93

Numero de nos expandidos: 8

Caminho: (((((0 0 0) (0 1 1) (0 1 1) (0 0 1)) ((1 1 1) (1 1 1) (1 1 1) (0 1 1))) 8) ((((0 0 0) (0 0 1) (0 1 1) (0 0 1)) ((1 1 1) (1 1 1) (1 1 1) (0 1 1))) 7) ((((0 0 0) (0 0 1) (0 1 1) (0 0 1)) ((1 1 1) (1 1 1) (1 0 1) (0 1 1))) 6) ((((0 0 0) (0 0 1) (0 1 1) (0 0 1)) ((1 1 1) (1 1 1) (0 0 1) (0 1 1))) 5) ((((0 0 0) (0 0 1) (0 1 1) (0 0 1)) ((1 1 1) (1 1 0) (0 0 1) (0 1 1))) 4) ((((0 0 0) (0 0 1) (0 1 1) (0 0 1)) ((1 1 1) (0 1 0) (0 0 1) (0 1 1))) 3) ((((0 0 0) (0 0 1) (0 1 1) (0 0 1)) ((1 1 0) (0 1 0) (0 0 1) (0 1 1))) 2) ((((0 0 0) (0 0 1) (0 1 1) (0 0 1)) ((1 0 0) (0 1 0) (0 0 1) (0 1 1))) 1) ((((0 0 0) (0 0 1) (0 1 1) (0 0 1)) ((0 0 0) (0 1 0) (0 0 1) (0 1 1))) 0))

Solucao: ((((0 0 0) (0 1 1) (0 1 1) (0 0 1)) ((1 1 1) (1 1 1) (1 1 1) (0 1 1))) 8 NIL ((((0 0 0) (0 0 1) (0 1 1) (0 0 1)) ((1 1 1) (1 1 1) (1 1 1) (0 1 1))) 7 NIL ((((0 0 0) (0 0 1) (0 1 1) (0 0 1)) ((1 1 1) (1 1 1) (1 0 1) (0 1 1))) 6 NIL ((((0 0 0) (0 0 1) (0 1 1) (0 0 1)) ((1 1 1) (1 1 1) (0 0 1) (0 1 1))) 5 NIL ((((0 0 0) (0 0 1) (0 1 1) (0 0 1)) ((1 1 1) (1 1 0) (0 0 1) (0 1 1))) 4 NIL ((((0 0 0) (0 0 1) (0 1 1) (0 0 1)) ((1 1 1) (0 1 0) (0 0 1) (0 1 1))) 3 NIL ((((0 0 0) (0 0 1) (0 1 1) (0 0 1)) ((1 1 0) (0 1 0) (0 0 1) (0 1 1))) 2 NIL ((((0 0 0) (0 0 1) (0 1 1) (0 0 1)) ((1 0 0) (0 1 0) (0 0 1) (0 1 1))) 1 NIL ((((0 0 0) (0 0 1) (0 1 1) (0 0 1)) ((0 0 0) (0 1 0) (0 0 1) (0 1 1))) 0 NIL)))))))))

```




