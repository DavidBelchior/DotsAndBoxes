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


### Nó

#### Composição do Nó

A composição do nó é uma lista composta por:

(Estado | número de quadrados | Profundidade do Nó)

```lisp
(defun cria-no (estado no-quadrados prof-no)
  "Cria um novo no"
  (list estado no-quadrados prof-no) ;; cria um novo no com o estado, o numero de quadrados fechados e a profundidade
)
```

#### Seletores do Nó

Os seletores do Nó são seletores que retornam os atributos que o compõem.

Nomeadamente:

* no-estado
* no-heuristica
* no-profundidade
* no-pai

#### Sucessores

A Sucessão de um determinado nó, é um conjunto de movimentos permitidos de inserção de um arco (vertical ou horizontal) no tabuleiro.

```lisp
;; jogar mais que uma vez 
;; ordenar pelo numero de quadrados fechados
(defun novos-sucessores (estado jogador prof-no)
  "Cria um novo no com o operador aplicado ao no"
  (let ((sucessores nil) ;; lista com os sucessores
        (nos-sucessores nil) ;;
        (no-quadrados (no-numero-de-caixas estado));; numero de quadrados fechados no estado
        (contagem-de-quadrados (fn-numero-de-quadradodos estado))) ;; numero de quadrados fechados

    (cond ((no-preenchidop estado) (list estado)) ;; se o estado estiver preenchido retorna o estado
          (t "Cria uma lista com os sucessores"
            (setq sucessores (append (gerar-sucessores (no-estado estado) 'verticais jogador) (gerar-sucessores (no-estado estado) 'horizontais jogador)))
  
            "cria um novo no para cada sucessor"
            (setq nos-sucessores (mapcar (lambda (x) (cria-no x (cria-no-quadrados-fechados x contagem-de-quadrados no-quadrados jogador) prof-no)) sucessores))
          
            "joga mais que uma vez"
            (remove-duplicates (jogar-outra-vez contagem-de-quadrados nos-sucessores jogador prof-no) :test 'equal))
    ) 
  )
)
```

```lisp
(defun gerar-sucessores (tabuleiro operador jogador)
  "Função que gera os sucessores de um tabuleiro"
  (cond((eq operador 'verticais) (mapcar (lambda (x) (cons (get-arcos-horizontais tabuleiro) (list (arco-na-posicao (first x) (second x) (get-arcos-verticais tabuleiro) jogador)))) (espacos-vazios tabuleiro operador) )) 
       ((eq operador 'horizontais) (mapcar (lambda (x) (cons (arco-na-posicao (second x) (first x)  (get-arcos-horizontais tabuleiro) jogador) (list (get-arcos-verticais tabuleiro)))) (espacos-vazios tabuleiro operador) ))
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
```lisp

(defun AlfaBeta (estado alfa beta profundidade tempo &optional (jogador 1) (prof-no 0) )
    "Algoritmo alfabeta"
    (cond ((tempo-limite tempo prof-no) (avaliacao estado)) ;; se o tempo limite for atingido retorna a avaliacao do estado
        ((progn (incf *numero-de-nos-analisados*) (no-preenchidop estado)) (avaliacao estado)) ;; se o estado estiver preenchido retorna a avaliacao do estado, incrementa o numero de nos analisados
        ((= prof-no profundidade ) (avaliacao estado)) ;; se a profundidade for atingida retorna a avaliacao do estado
        (t (let ((estados-sucessores(novos-sucessores estado jogador (1+ prof-no)))) ;; cria uma lista com os estados sucessores
              (cond ((= (mod prof-no 2) 0) (AlfaBetaMax alfa beta (1+ prof-no) profundidade (sort estados-sucessores #'> :key #'avaliacao) jogador tempo)) ;; se a profundidade for par chama a funcao AlfaBetaMax
                    (t (AlfaBetaMin alfa beta (1+ prof-no) profundidade (sort estados-sucessores #'< :key #'avaliacao) jogador tempo));; se a profundidade for impar chama a funcao AlfaBetaMin
              )
            )
        )
    ) 
)


(defun AlfaBetaMax (alfa beta prof-no profundidade sucessores jogador tempo)
  "Algoritmo alfabeta max"
  (cond ((null sucessores) alfa) ;; Se a lista de sucessores estiver vazia retorna o alfa 
        ((>= alfa beta) (incf *cortes-beta*) beta) ;; se o alfa for maior ou igual ao beta incrementa o numero de cortes beta e retorna o beta
        (t  (let ((novo-alfa (max alfa (AlfaBeta (car sucessores) alfa beta profundidade tempo (troca-jogador jogador) prof-no)))) ;; cria uma variavel com o novo alfa
              (cond ((= prof-no 1) (guardar-solucao (car sucessores) novo-alfa) (AlfaBetaMax novo-alfa beta prof-no profundidade (cdr sucessores) jogador tempo)) ;; se a profundidade for 1 guarda a solucao e chama a funcao AlfaBetaMax
                    (t (AlfaBetaMax novo-alfa beta prof-no profundidade (cdr sucessores) jogador tempo)) ;; se a profundidade nao for 1 chama a funcao AlfaBetaMax
              )
            )
        )
  )
)


(defun AlfaBetaMin (alfa beta prof-no profundidade sucessores jogador tempo)
   "Algoritmo alfabeta min"
  (cond ((null sucessores) beta) ;;Se a lista de sucessores estiver vazia retorna o beta
        ((>= alfa beta) (incf *cortes-alfa*) alfa) ;; se o alfa for maior ou igual ao beta incrementa o numero de cortes alfa e retorna o alfa
        (t (AlfaBetaMin alfa (min beta (AlfaBeta (car sucessores) alfa beta profundidade tempo (troca-jogador jogador) prof-no)) prof-no profundidade (cdr sucessores) jogador tempo)) ;; chama a funcao AlfaBetaMin
  )
) 


```

### Funções Auxiliares
```lisp
;;;; guarda a solucao se o algoritmo encontrar uma solucao e tiver uma melhor heuritica
(defun guardar-solucao (estado novo-alfa)
   "Guarda uma solução se o alfa for maior que o valor atual"
  (cond ((> novo-alfa *valor*) (setq *valor* novo-alfa)(setq *primeiro-estado* estado));; se o alfa for maior que o valor atual guarda a solucao
        (t NIL) ;; se o alfa for menor que o valor atual nao guarda a solucao
  )
)

(defun no-preenchidop (no)
  "Verifica se um no esta totalmente preenchido"
  (cond ((= (fn-numero-de-quadradodos no) 30) T)
        (T nil)
  )
)

(defun tempo-limite (tempo prof-no)
  "Funcao que verifica se o tempo limite foi atingido"
  (incf *numero-de-nos-analisados*) ;; incrementa o numero de nos analisados
  (if (= prof-no 0) (setf *inicio* (get-internal-real-time))) ;; se for a primeira chamada do algoritmo, guarda o tempo inicial
  (if (<= (- tempo 700) (- (get-internal-real-time) *inicio*)) t nil) ;; se o tempo limite for atingido retorna t, senao retorna nil
)

```


##### Função de Avaliação

Esta função de avaliação simples, é baseada no número de caixas completadas per cada jogador. Isso permite que o algoritmo de jogo priorize ações que aumentam o número de caixas completadas pelo jogador pretendido. Como se pode observar:

```lisp
(defun avaliacao (no)
  "Função que retorna o valor da heuristica"
  (if (= *primeiro-jogador* 1) (- (first (no-numero-de-caixas no)) (second (no-numero-de-caixas no)))  (- (second (no-numero-de-caixas no)) (first (no-numero-de-caixas no))))
)
```


## Limitações Técnicas e Ideias Para Desenvolvimento Futuro

No desenvolvimento desta fase do projeto, deparamo-nos com algumas limitações, no qual identificamos alguns problemas com o 
lispworks devido à reduzida memoria que este apresenta.
Obtivemos também algumas dificuldades na programação neste IDE uma vez que este é um pouco limitado em questão de 
verificações de erros, debug e não previne muito erros de usabilidade.

Propomos um futuro desenvolvimento em linguagem python no IDE pycharm para uma melhor compreensão e experiência.



## Análise Critica Dos Resultados
Como é possivel obsevar na análise Análise estatística em baixo aquando do aumento da profundidade o número de nós 
analisados, o número de cortes dos dois tipos e o tempo de execução também são aumentados.


## Análise estatística acerca de uma execução do programa contra um adversário humano

Por exemplo para uma jogada com tempo limite de 1 segundo e profundidade máxima de 3 obteve o seguinte resultado:
```
    Jogada do Computador 1

    .--.--.--.--.  .--.
    |  |  |  |  |     |  
    .--.--.--.--.--.  .
       |  |  |  |  |  |  
    .  .--.--.--.--.  .
    |  |  |  |  |  |  |  
    .  .--.--.--.--.  .
    |  |  |  |     |  |  
    .--.--.--.  .  .  .
       |  |  |     |     
    .  .--.--.--.--.--.

    Tempo de execucao: 309 ms

    Jogada: (((1 2 1 1 0 2) (2 1 1 1 1 0) (0 2 1 1 2 0) (0 1 1 2 2 0) (1 2 1 0 0 0) (0 1 2 1 2 1)) ((1 0 1 1 0) (2 1 1 2 2) (2 1 1 2 1) (1 2 2 1 1) (1 2 2 0 0) (0 1 2 1 2) (2 2 1 2 0)))

    Novo estado: ((((1 2 1 1 0 2) (2 1 1 1 1 0) (0 2 1 1 2 0) (0 1 1 2 2 0) (1 2 1 0 0 0) (0 1 2 1 2 1)) ((1 0 1 1 0) (2 1 1 2 2) (2 1 1 2 1) (1 2 2 1 1) (1 2 2 0 0) (0 1 2 1 2) (2 2 1 2 0))) (12 4) 1)

    Numero de cortes alfa: 0

    Numero de cortes beta: 34

    Numero de nos analisados: 232
```

Para um jogada com tempo de 20 segundos e profundidade 3 obteve-se o seguinte resultado:

```
    Jogada do Computador 1

    .--.--.--.--.  .--.
    |  |  |  |  |     |  
    .--.--.--.--.--.  .
       |  |  |  |  |  |  
    .  .--.--.--.--.  .
    |  |  |  |  |  |  |  
    .  .--.--.--.--.  .
       |  |  |     |  |  
    .--.--.--.  .  .  .
    |  |  |  |     |     
    .  .--.--.--.--.--.

    Tempo de execucao: 9549 ms

    Jogada: (((1 2 1 1 0 2) (2 1 1 1 1 0) (0 2 1 1 2 0) (0 1 1 2 2 0) (1 2 1 0 0 0) (0 1 2 1 2 1)) ((1 0 1 0 1) (2 1 1 2 2) (2 1 1 2 1) (1 2 2 1 1) (1 2 2 0 0) (0 1 2 1 2) (2 2 1 2 0)))

    Novo estado: ((((1 2 1 1 0 2) (2 1 1 1 1 0) (0 2 1 1 2 0) (0 1 1 2 2 0) (1 2 1 0 0 0) (0 1 2 1 2 1)) ((1 0 1 0 1) (2 1 1 2 2) (2 1 1 2 1) (1 2 2 1 1) (1 2 2 0 0) (0 1 2 1 2) (2 2 1 2 0))) (12 4) 1)

    Numero de cortes alfa: 118

    Numero de cortes beta: 83

    Numero de nos analisados: 4151
```

Para um jogada com tempo de 1 segundos e profundidade 4 obteve-se o seguinte resultado:

```
    Jogada do Computador 1

    .--.--.--.--.  .--.
    |  |  |  |  |     |  
    .--.--.--.--.--.  .
       |  |  |  |  |  |  
    .  .--.--.--.--.  .
    |  |  |  |  |  |  |  
    .  .--.--.--.--.  .
    |  |  |  |     |  |  
    .--.--.--.  .  .  .
       |  |  |     |     
    .  .--.--.--.--.--.

    Tempo de execucao: 385 ms

    Jogada: (((1 2 1 1 0 2) (2 1 1 1 1 0) (0 2 1 1 2 0) (0 1 1 2 2 0) (1 2 1 0 0 0) (0 1 2 1 2 1)) ((1 0 1 1 0) (2 1 1 2 2) (2 1 1 2 1) (1 2 2 1 1) (1 2 2 0 0) (0 1 2 1 2) (2 2 1 2 0)))

    Novo estado: ((((1 2 1 1 0 2) (2 1 1 1 1 0) (0 2 1 1 2 0) (0 1 1 2 2 0) (1 2 1 0 0 0) (0 1 2 1 2 1)) ((1 0 1 1 0) (2 1 1 2 2) (2 1 1 2 1) (1 2 2 1 1) (1 2 2 0 0) (0 1 2 1 2) (2 2 1 2 0))) (12 4) 1)

    Numero de cortes alfa: 21

    Numero de cortes beta: 34

    Numero de nos analisados: 809
```

Para um jogada com tempo de 20 segundos e profundidade 4 obteve-se o seguinte resultado:
```
    Jogada do Computador 1

    .--.--.--.--.  .--.
    |  |  |  |  |     |  
    .--.--.--.--.--.  .
       |  |  |  |  |  |  
    .  .--.--.--.--.  .
    |  |  |  |  |  |  |  
    .  .--.--.--.--.  .
       |  |  |     |  |  
    .--.--.--.  .  .  .
    |  |  |  |     |     
    .  .--.--.--.--.--.

    Tempo de execucao: 19375 ms

    Jogada: (((1 2 1 1 0 2) (2 1 1 1 1 0) (0 2 1 1 2 0) (0 1 1 2 2 0) (1 2 1 0 0 0) (0 1 2 1 2 1)) ((1 0 1 0 1) (2 1 1 2 2) (2 1 1 2 1) (1 2 2 1 1) (1 2 2 0 0) (0 1 2 1 2) (2 2 1 2 0)))

    Novo estado: ((((1 2 1 1 0 2) (2 1 1 1 1 0) (0 2 1 1 2 0) (0 1 1 2 2 0) (1 2 1 0 0 0) (0 1 2 1 2 1)) ((1 0 1 0 1) (2 1 1 2 2) (2 1 1 2 1) (1 2 2 1 1) (1 2 2 0 0) (0 1 2 1 2) (2 2 1 2 0))) (12 4) 1)

    Numero de cortes alfa: 2166

    Numero de cortes beta: 83

    Numero de nos analisados: 6391
```


