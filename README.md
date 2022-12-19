# Projeto Nº 1: Época Normal
![image](https://user-images.githubusercontent.com/76535435/208324726-69dc1bec-cdeb-4446-b659-0055c1ddd4bc.png)
## Inteligência Artificial 22/23
### Prof. Joaquim Filipe
### Eng. Filipe Mariano

# Dots and Boxes
## Manual Técnico
#### Realizado por:
#### André Matias - 202000941
#### David Belchior - 202001670
#### 21 de Dezembro de 2022

## Indice
* Introdução
* Arquitetura do Sistema
* Entidades e sua implementação
* Algoritmos e sua implementação
* Resultados
* Limitações técnicas e ideias para desenvolvimento futuro

## Introdução
Este documento corresponde ao manual técnico do projeto Dots and Boxes que é um jogo para dois jogadores. Foi publicado pela primeira vez no século 19 pelo matemático francês Édouard Lucas, que o chamou de la pipopipette.

No âmbito da unidade curricular de Inteligência Artificial, foi proposto o projecto do jogo “Dots and Boxes”, no qual este é um jogo constituído por um tabuleiro de n * m caixas (n linhas de caixas e m colunas de caixas). Cada caixa é delimitada por 4 pontos entre os quais é possível desenhar um arco. Quando os quatro pontos à volta de uma caixa tiverem conectados por 4 arcos, a caixa é considerada fechada. O espaço da solução é portanto constituído por n * m caixas, (n + 1) * (m + 1) pontos e (m * (n + 1)) + (n * (m + 1)) arcos.

O jogo inicia com um tabuleiro vazio em que os jogadores alternadamente vão colocando um arco horizontal ou vertical. Quando o arco colocado por um jogador fecha uma caixa, essa caixa conta como 1 ponto para o jogador que colocou o arco e esse jogador deve jogar novamente.

O jogo termina quando todas as caixas tiverem fechadas, ou seja, não existirem mais arcos para colocar, ganhando o jogador que fechou mais caixas.

O objectivo deste projeto é resolver todos os problemas descritos no anexo do enunciado de A) a F), no qual cada um destes contém um objetivo que corresponde ao número de caixas pretendidas. A resolução dos problemas mencionados será implementada na linguagem de programação funcional Common Lisp, utilizando toda a matéria lecionada na unidade curricular até ao momento, a fim de tentar fornecer uma solução apropriada para cada um dos problemas apresentados.

Neste documento serão descritas detalhadamente todas as metricas de desenvolvimento usadas e funções implementadas.

## Arquitetura do Sistema

O Jogo foi implementado em linguagem LISP, utilizando o IDE LispWorks. A estrutura do projeto é composta por 4 ficheiros:

- projeto.lisp - Carrega os outros ficheiros de código, escreve e lê ficheiros, e trata da interação com o utilizador.

- puzzle.lisp -  Código relacionado com o problema.

- procura.lisp - Contém implementação de:

  * Algoritmo de Procura de Largura Primeiro (BFS)
  * Algoritmo de Procura do Profundidade Primeiro (DFS)
  * Algoritmo de Procura do Melhor Primeiro (A*)
  * Os algoritmos SMA*, IDA* e/ou RBFS (caso optem por implementar o bónus)
  
- problemas.dat - Funções com os problemas de A) a F).

- solucao.dat - Que é o output descrito para cada um dos problemas solucionados com os algoritmos identificados que conterá:

  * A solução encontrada 
  
  * E dados estatísticos sobre a sua eficiência, nomeadamente:
    - O fator de ramificação média
    - O número de nós gerados
    - O número de nós expandidos
    - A penetrância
    - O tempo de execução
    - E o caminho até à solução
    
## Entidades e sua implementação

### Tabuleiro
    
O tabuleiro consiste numa apresentação sob a forma de uma lista de listas em LISP, composta por atomos, em que cada atomo representa uma casa com um valor numérico,o tabuleiro é representado por n linhas de m colunas. A primeira lista corresponde a todos os arcos horizontais e a segunda corresponde a todos os arcos verticais.

Temos assim ao todo 6 problemas que são os tabuleiros de A) a F) apresentados no ficheiro problemas.dat.

Como exemplo de um Estado Inicial para uma melhor compreensão do anteriormente descrito será de seguida apresentado o Problema a):

* (((0 0 0) (0 0 1) (0 1 1) (0 0 1)) ((0 0 0) (0 1 0) (0 0 1) (0 1 1))) :arrow_right: Coresponde ao tabuleiro geral
* ((0 0 0) (0 0 1) (0 1 1) (0 0 1)) :arrow_right: arcos horizontais
* ((0 0 0) (0 1 0) (0 0 1) (0 1 1)) :arrow_right: arcos verticais

Que corresponderá ao seguinte tabuleiro:

![image](https://user-images.githubusercontent.com/76535435/208327837-2cec45d5-bfa6-44e6-9696-75e921695dc8.png)

## Funções e Regras do Jogo
FAZERRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRR

## Representação de Estados

Este jogo permite que o tabuleiro contenha diversas possibilidades de jogadas e diversos caminhos possiveis até encontrar uma solução, neste caso o problema será 
equacionado em termos de estados, no qual até chegar a uma solução possivel, irá existir diversos estados. Para a transição (mudança) destes estados, do seu estado inicial até ao final, ter-se-á de utilizar os operadores possiveis que permitiam colocar arcos na vertical ou na horizontal.

### Operadores

Ter-se-á os seguintes tipos de operadores possiveis:

* Verticais
* Horizontais

Pelo que o número total de operadores dependerá da dimensão do tabuleiro em questão e do número de posições possiveis de inserir arcos, tanto na vertical como na horizontal. Ou seja, se se tiver como exemplo o primeiro problema a), este terá 16 operadores possíveis (16 movimentos possíveis), como se pode observar marcado na seguinte figura com uma estrela (figura) de forma a ser melhor compreendido: 


![image](https://user-images.githubusercontent.com/76535435/208329065-877df6e5-09e2-4acc-839c-4015debf52e6.png)

Os seguintes operadores são definidos com estes movimentos:

Do tipo vertical: (((0 0 0) (0 0 1) (0 1 1) (0 0 1)) ((0 0 0) (0 1 0) (0 0 1) (0 1 1)))

 * Operador1 🠊 (((0 0 0) (0 0 1) (0 1 1) (0 0 1)) ((1 0 0) (0 1 0) (0 0 1) (0 1 1)))
 * Operador2 🠊 (((0 0 0) (0 0 1) (0 1 1) (0 0 1)) ((0 1 0) (0 1 0) (0 0 1) (0 1 1)))
 * Operador3 🠊 (((0 0 0) (0 0 1) (0 1 1) (0 0 1)) ((0 0 1) (0 1 0) (0 0 1) (0 1 1)))
 * Operador4 🠊 (((0 0 0) (0 0 1) (0 1 1) (0 0 1)) ((0 0 0) (1 1 0) (0 0 1) (0 1 1)))
 * Operador5 🠊 (((0 0 0) (0 0 1) (0 1 1) (0 0 1)) ((0 0 0) (0 1 1) (0 0 1) (0 1 1)))
 * Operador6 🠊 (((0 0 0) (0 0 1) (0 1 1) (0 0 1)) ((0 0 0) (0 1 0) (1 0 1) (0 1 1)))
 * Operador7 🠊 (((0 0 0) (0 0 1) (0 1 1) (0 0 1)) ((0 0 0) (0 1 0) (0 1 1) (0 1 1)))
 * Operador8 🠊 (((0 0 0) (0 0 1) (0 1 1) (0 0 1)) ((0 0 0) (0 1 0) (0 0 1) (1 1 1)))

Do tipo horizontal: (((0 0 0) (0 0 1) (0 1 1) (0 0 1)) ((0 0 0) (0 1 0) (0 0 1) (0 1 1)))

 * Operador9 🠊 (((1 0 0) (0 0 1) (0 1 1) (0 0 1)) ((0 0 0) (0 1 0) (0 0 1) (0 1 1)))
 * Operador10 🠊 (((0 1 0) (0 0 1) (0 1 1) (0 0 1)) ((0 0 0) (0 1 0) (0 0 1) (0 1 1)))
 * Operador11 🠊 (((0 0 1) (0 0 1) (0 1 1) (0 0 1)) ((0 0 0) (0 1 0) (0 0 1) (0 1 1)))
 * Operador12 🠊 (((0 0 0) (1 0 1) (0 1 1) (0 0 1)) ((0 0 0) (0 1 0) (0 0 1) (0 1 1)))
 * Operador13 🠊 (((0 0 0) (0 1 1) (0 1 1) (0 0 1)) ((0 0 0) (0 1 0) (0 0 1) (0 1 1)))
 * Operador14 🠊 (((0 0 0) (0 0 1) (1 1 1) (0 0 1)) ((0 0 0) (0 1 0) (0 0 1) (0 1 1)))
 * Operador15 🠊 (((0 0 0) (0 0 1) (0 1 1) (1 0 1)) ((0 0 0) (0 1 0) (0 0 1) (0 1 1)))
 * Operador16 🠊 (((0 0 0) (0 0 1) (0 1 1) (0 1 1)) ((0 0 0) (0 1 0) (0 0 1) (0 1 1)))

### Nó

#### Composição do Nó

A composição do nó é uma lista composta por:

(Tabuleiro | Profundidade | Heuristica | Pai)

```lisp
;; teste: (cria-no '(((0 0 0) (0 0 1) (0 1 1) (0 0 1))((0 0 0) (0 1 1) (1 0 1) (0 1 1))))
;; resultado: ((((0 0 0) (0 0 1) (0 1 1) (0 0 1)) ((0 0 0) (0 1 1) (1 0 1) (0 1 1))) 0 NIL NIL)
(defun cria-no (tabuleiro &optional (g 0) (heuristica nil) (pai nil))
  "Cria um no com o tabuleiro inserido, com a profundidade 0 se nao inserida, com o valor da heuristica e com o no pai."
  (list tabuleiro g heuristica pai)
)
```

#### Seletores do Nó

Os seletores do Nó são seletores que retornam os atributos que o compõem.

Nomeadamente:

* no-estado
* no-heuristica
* no-profundidade
* no-pai

#### Sucessões

A Sucessão de um determinado nó, é um conjunto de movimentos permitidos de inserção de um arco (vertical ou horizontal) no tabuleiro.

```lisp
;; teste: (novo-sucessor '((((0 0 0) (0 0 1) (0 1 1) (0 0 1)) ((0 0 0) (0 1 1) (1 0 1) (0 1 1))) 0 NIL NIL) 'verticais)
;; resultado(apenas um no): ((((0 0 0) (0 0 1) (0 1 1) (0 0 1)) ((1 0 0) (0 1 1) (1 0 1) (0 1 1))) 1 NIL ((((0 0 0) (0 0 1) (0 1 1) (0 0 1)) ((0 0 0) (0 1 1) (1 0 1) (0 1 1))) 0 NIL NIL))
(defun novo-sucessor (no operador  &optional (obj nil) (fn-heuristica nil))
  "Cria um novo no com o operador aplicado ao no"
  (let ((estado (no-estado no)) 
        (profundidade (no-profundidade no))
        (pai no)
        (sucessores nil)
  )
    "verifica qual o operador"
    (cond ((eq operador 'verticais) (setq sucessores (gerar-sucessores estado operador)))
          ((eq operador 'horizontais) (setq sucessores (gerar-sucessores estado operador)))
    )
    "cria um novo no para cada sucessor"
    (cond ((and sucessores (not (null fn-heuristica))) (mapcar (lambda (x) (cria-no x (+ profundidade 1) (funcall fn-heuristica x obj) pai)) sucessores))
          (sucessores (mapcar (lambda (x) (cria-no x (+ profundidade 1) nil pai)) sucessores))
    )
  )
)
```

```lisp
;; teste: (sucessores '((((0 0 0) (0 0 1) (0 1 1) (0 0 1)) ((0 0 0) (0 1 1) (1 0 1) (0 1 1))) 0 NIL NIL) (operadores) 'dfs nil nil 2)
;; resultado(um no sucessor): ((((0 0 0) (0 0 1) (0 1 1) (0 0 1)) ((1 0 0) (0 1 1) (1 0 1) (0 1 1))) 1 NIL ((((0 0 0) (0 0 1) (0 1 1) (0 0 1)) ((0 0 0) (0 1 1) (1 0 1) (0 1 1))) 0 NIL NIL))
(defun sucessores (node operators algoritmo &optional (obj nil) (fn-heuristica nil) depth)
  "Função que retorna uma lista com os sucessores de um no dependendo do algoritmo"
  (cond ((eq algoritmo 'bfs) (append (novo-sucessor node (first operators)) (novo-sucessor node (second operators))))
        ((eq algoritmo 'dfs) 
          (cond ((< (no-profundidade node) depth) (append (novo-sucessor node (first operators)) (novo-sucessor node (second operators))))
                (T nil)
          )
        )
        ((eq algoritmo 'astar) (append (novo-sucessor node (first operators) obj fn-heuristica) (novo-sucessor node (second operators) obj fn-heuristica)))
  )
)
```



## Algoritmos e sua implementação

No âmbito deste projeto, o objetivo principal consiste em atingir os objetivos definidos, que correspondem a um determinado número de caixas fechadas em cada problema. 

Sendo que para tal é necessário utilizar algoritmos lecionados nesta unidade curricular, de forma a solucionar caminhos possiveis, que correspondem ao posicionamento 
de arcos no tabuleiro.

### Solução

A solução é uma função de paragem aos algorimos implementados que tem duas condições, o tabuleiro já não tem mais movimentos disponiveis, ou o objetivo dos número de 
caixas a serem fechadas foi concluido.


| Problema      | Objetivo      |
| ------------- | ------------- |
| a)            | 3             |
| b)            |  7            |
| c)            |  10           |
| d)            |  10           |
| e)            |  20           |
| f)            |  35           |








