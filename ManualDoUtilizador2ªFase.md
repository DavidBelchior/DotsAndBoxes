# Projeto Nº 2: Época Normal
![image](https://user-images.githubusercontent.com/76535435/208324726-69dc1bec-cdeb-4446-b659-0055c1ddd4bc.png)
## Inteligência Artificial 22/23
### Prof. Joaquim Filipe
### Eng. Filipe Mariano

# Dots and Boxes
## Manual Técnico
#### Realizado por:
#### André Matias - 202000941
#### David Belchior - 202001670
#### 18 de janeiro de 2023

## Indice
* Introdução
* Arquitetura do Sistema
* Entidades e sua implementação
* As regras a contemplar nesta 2ª fase do Projeto
* Algoritmo implementado
* Descrição dos tipos abstratos usados no programa
* Limitações técnicas e ideias para desenvolvimento futuro
* Análise crítica dos resultados
* Análise estatística acerca de uma execução do programa contra um adversário humano

## Introdução
Este documento corresponde ao manual técnico do projeto Dots and Boxes que é um jogo para dois jogadores. Foi publicado 
pela primeira vez no século 19 pelo matemático francês Édouard Lucas, que o chamou de la pipopipette.

No âmbito da unidade curricular de Inteligência Artificial, foi proposto o projecto do jogo “Dots and Boxes”, no qual este 
é um jogo constituído por um tabuleiro de n * m caixas (n linhas de caixas e m colunas de caixas). Cada caixa é delimitada 
por 4 pontos entre os quais é possível desenhar um arco. Quando os quatro pontos à volta de uma caixa tiverem conectados 
por 4 arcos, a caixa é considerada fechada. O espaço da solução é portanto constituído por n * m caixas, (n + 1) * (m + 1) 
pontos e (m * (n + 1)) + (n * (m + 1)) arcos.

O jogo inicia com um tabuleiro vazio em que os jogadores alternadamente vão colocando um arco horizontal ou vertical. 
Quando o arco colocado por um jogador fecha uma caixa, essa caixa conta como 1 ponto para o jogador que colocou o arco e 
esse jogador deve jogar novamente.

O jogo termina quando todas as caixas tiverem fechadas, ou seja, não existirem mais arcos para colocar, ganhando o jogador 
que fechou mais caixas.

O objectivo desta segunda fase do projeto é permitir jogar de duas formas, a primera é humano vs máquina e a segunda é 
máquina vs máquina.Para esta implementação ter-se-à de desenvolver o algoritmo AlfaBeta. Este projeto será desenvolvido na 
linguagem de programação funcional Common Lisp, utilizando toda a matéria lecionada na unidade curricular até ao momento.

Neste documento serão descritas detalhadamente todas as metricas de desenvolvimento usadas e funções implementadas.

## Arquitetura do Sistema

O Jogo foi implementado em linguagem LISP, utilizando o IDE LispWorks. A estrutura do projeto é composta por 4 ficheiros:

- jogo.lisp Carrega os outros ficheiros de código, escreve e lê de ficheiros e trata da interação com o utilizador.

- puzzle.lisp -  Código relacionado com o problema.

- algoritmo.lisp Deve conter a implementação do algoritmo de jogo independente do domínio.

-  log.dat - Que conterá  a jogada realizada, o novo estado, o número de nós analisados, o número de cortes efetuados (de 
cada tipo) e o tempo gasto.
    
## Entidades e sua implementação

### Tabuleiro
    
O tabuleiro consiste numa apresentação sob a forma de uma lista de listas em LISP, composta por atomos, em que cada atomo
representa uma casa com um valor numérico,o tabuleiro é representado por n linhas de m colunas. A primeira lista 
corresponde a todos os arcos horizontais e a segunda corresponde a todos os arcos verticais.

Para esta versão do jogo, irá se utilizar um tabuleiro de 30 caixas, em que n=5 e m=6 como por exemplo ilustrado na 
seguinte figura:

![image](https://user-images.githubusercontent.com/76535435/213316167-89fc9ff9-68ea-40c1-929d-2a6c6dc08538.png)


No qual em termos mais tecnicos será por exemplo da seguinte forma:

;tabuleiro da figura anterior 
(
 (;arcos horizontais
 (1 2 1 1 0 2) 
 (2 1 1 1 1 0) 
 (0 2 1 1 2 0) 
 (0 1 0 2 2 0) 
 (1 2 0 0 0 0) 
 (0 1 2 1 2 1)
 ) 
 (;arcos verticais
 (1 0 1 0 0) 
 (2 1 1 2 2) 
 (2 1 1 2 0) 
 (1 2 2 1 1) 
 (1 2 2 0 0) 
 (0 1 2 1 2) 
 (2 2 1 2 0) 
 )
)


## Representação de Estados

Este jogo permite que o tabuleiro contenha diversas possibilidades de jogadas e diversos caminhos possiveis até encontrar uma solução, neste caso o problema será 
equacionado em termos de estados, no qual até chegar a uma solução possivel, irá existir diversos estados. Para a transição (mudança) destes estados, do seu estado inicial até ao final, ter-se-á de utilizar os operadores possiveis que permitiam colocar arcos na vertical ou na horizontal.

### Operadores

Ter-se-á os seguintes tipos de operadores possiveis:

* Verticais
* Horizontais

Pelo que o número total de operadores dependerá da dimensão do tabuleiro em questão e do número de posições possiveis de inserir arcos, tanto na vertical como na horizontal. Ou seja, como por exemplo um tabuleiro onde exista 16 operadores possíveis (16 movimentos possíveis), como se pode observar marcado na seguinte figura com uma estrela (figura) de forma a ser melhor compreendido: 


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

# FAZER O QUE FALTA
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


## As regras a contemplar nesta 2ª fase do Projeto:

* O jogo é disputado entre 2 jogadores.
* Para esta versão do jogo, irá se utilizar um tabuleiro de 30 caixas, em que n=5 e m=6 tal como
* ilustrado na figura 1.
* As jogadas são feitas à vez e, em cada turno, o jogador coloca um arco horizontal ou arco vertical numa posição vazia.
* O jogador que coloque o último arco de uma caixa, ganha 1 ponto e joga novamente. Se na jogada seguinte fechar novamente
um arco, poderá continuar a jogar até que o arco colocado não
feche nenhuma caixa.
* O jogo termina quando nenhum dos jogadores consegue colocar mais arcos.
* Quando o jogo termina, os jogadores contam o número de pontos obtidos ao fechar caixas no tabuleiro, e o jogador que
tiver o maior número de caixas fechadas é o vencedor.



## Algoritmo implementado

No âmbito deste projeto, é utilizado o algoritmo ALFABETA que é um algoritmo de procura em árvore, utilizado em jogos de 
inteligência artificial para determinar a melhor jogada a ser feita. É uma variação do algoritmo Minimax, que procura 
maximizar o resultado para uma dada jogada, mas adiciona uma otimização para evitar a avaliação de jogadas que não são 
promissoras, o que permite uma procura mais rápida e eficiente. O objetivo do algoritmo Alpha-Beta é encontrar a jogada 
mais ótima para o jogador que está a realizar a procura, tendo em conta as jogadas possíveis do adversário.



Pseudocódigo básico:

function alphabeta(node, depth, alpha, beta, maximizingPlayer)
    if depth = 0 or node is a terminal node
        return the heuristic value of node
    if maximizingPlayer
        value := -infinity
        for each child of node
            value := max(value, alphabeta(child, depth - 1, alpha, beta, false))
            alpha := max(alpha, value)
            if beta <= alpha
                break
        return value
    else
        value := infinity
        for each child of node
            value := min(value, alphabeta(child, depth - 1, alpha, beta, true))
            beta := min(beta, value)
            if beta <= alpha
                break
        return value



### Implementação
# FAZER O QUE FALTA
```lisp
;; procura em largura
;; teste: (bfs '((((0 0 0) (0 0 1) (0 1 1) (0 0 1)) ((0 0 0) (0 1 0) (0 0 1) (0 1 1))) 0 nil) 'no-solucaop 'sucessores (operadores) 3)
;; resultado: ((((0 0 0) (0 1 1) (0 1 1) (0 0 1)) ((0 0 0) (0 1 0) (0 1 1) (0 1 1))) 2 NIL (((# # # #) (# # # #)) 1 NIL ((# #) 0 NIL)))
(defun bfs (initialNode fnSolucao fnSucessores operators obj &optional (abertos nil) (fechados nil))
  (cond ((and (null abertos) (null fechados)) (bfs initialNode fnSolucao fnSucessores operators obj (list initialnode) fechados))
        ((null abertos) nil)
        (T 
          (let* ((n-fechados (append fechados (list (car abertos)))) (next-nodes (nos-unicos-bfs n-fechados (funcall fnSucessores (car abertos) operators 'bfs))))
              (let ((no-obj-val (no-obj next-nodes fnSolucao obj)))
              (format t "abertos: ~a~%" (length abertos))
              (format t "fechados: ~a~%" (length n-fechados))
              (format t "depth: ~a~%" (no-profundidade (car abertos)))
              (terpri)
                (cond ((not (null no-obj-val)) no-obj-val)
                      (t (bfs initialNode fnSolucao fnSucessores operators obj (abertos-bfs (cdr abertos) next-nodes) n-fechados))
                )
              )
          )
        )
  )
)
```



### Funções Auxiliares

#### Função de Avaliação

# FAZER O QUE FALTA




## Descrição dos tipos abstratos usados no programa
# FAZER O QUE FALTA





## Limitações Técnicas e Ideias Para Desenvolvimento Futuro

No desenvolvimento desta fase do projeto, deparamo-nos com algumas limitações, no qual identificamos alguns problemas com o 
lispworks devido à reduzida memoria que este apresenta.
Obtivemos também algumas dificuldades na programação neste IDE uma vez que este é um pouco limitado em questão de 
verificações de erros, debug e não previne muito erros de usabilidade.

Propomos um futuro desenvolvimento em linguagem python no IDE pycharm para uma melhor compreensão e experiência.




## Análise Critica Dos Resultados
# FAZER O QUE FALTA

Primeiramente, quanto ao algoritmo BFS, chegou-se à conclusão que este apenas conseguia resolver os problemas a) e b), uma vez que para os restantes este tería de 
executar milhares de iterações que resultariam na alocação maxima possivel na stack do programa LispWorks.

De seguida para o algoritomo DFS, este conseguiu resolver todos os problemas uma vez que como executa a procura em profundidade terá uma quantidade significativamente
menor de iterações do que o DFS, pelo que em distância mais curtas até à solução o DFS terá um melhor performance.

Quanto ao algoritmo A* com a heurística base este consegue resolver os problemas que já se econtram com arcos colocados ou caixas em si completas, uma vez que esta é 
uma heurística que priviligia os tabuleiros com maior número de caixas fechadas, não conseguindo resolver os problemas d) e f) uma vez que este tem poucos ou nenhuns 
arcos colocados inicialmente, logo este terá muitos nós com o mesmo custo e assim sucessivamente, o que leva utilizar todos os recursos da memória stack do IDE não 
conseguindo então resolve-los.

Quanto ao algoritmo A* com a heurística desenvolvida pelo grupo base este consegue resolver os problemas que já se econtram com arcos colocados ou caixas em si 
completas, uma vez que esta também é uma heurística que priviligia os tabuleiros com maior número de caixas fechadas, não conseguindo resolver apenas o problema f) 
devido ao anteriormente referido.



## Análise estatística acerca de uma execução do programa contra um adversário humano
# FAZER O QUE FALTA

Para poder comparar a eficácia dos 4 algoritmos funcionais foram desenvolvidas tatabelas com as estatisticas de cada algoritmo na resolução de cada problema.


### Resultados


| Valor      | Profundidade      | Nº De Cortes (de cada tipo) | Tempo Limite de cada Jogada |
| -----------| ----------------- | --------------------------  |-----------------------------|
|            |                   |                             |                             |   





## Anexos
# FAZER O QUE FALTA



