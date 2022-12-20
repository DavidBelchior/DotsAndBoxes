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




```lisp
;; teste: (no-solucaop '((((0 0 0) (0 0 1) (0 1 1) (0 0 1)) ((0 0 0) (0 1 1) (1 0 1) (0 1 1))) 0 NIL NIL) 1)
;; resultado: T
(defun no-solucaop (no obj)
  "Verifica se um no e solucao"
  (cond ((= (numeroDeQuadrados (no-estado no)) obj) T)
        (T nil)
  )
)
```

Quantos aos algoritmos utilizados estes serão descritos em seguida:

## BFS (Breadth First Search)

Este é um algoritmo de travessia de grafos que começa a percorrer o grafo a partir do nó raiz e explora todos os nós vizinhos. Em seguida, ele seleciona o nó mais 
próximo e explora todos os nós inexplorados.
O BFS coloca cada vértice do grafo em duas categorias - visitado e não visitado. Ele seleciona um único nó em um grafo e, em seguida, visita todos os nós adjacentes ao 
nó selecionado.

Isto é:

1. Nó inicial => ABERTOS
2. Se ABERTOS vazia falha.
3. Remove o primeiro nó de ABERTOS (n) e coloca-o em FECHADOS 
4. Expande o nó n. Colocar os sucessores no fim de ABERTOS, colocando os ponteiros para n.
5. Se algum dos sucessores é um nó objectivo sai, e dá a solução. Caso contrário vai para 2.

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


![bfs_gif](https://user-images.githubusercontent.com/76535435/208426425-864229b0-4ea6-4a9e-a5e0-82867bf73d5f.gif)


## DFS (Depth-first search)

Este algoritmo de procura em profundidade inicia a usa procura no nó raiz da árvore, de seguida expande o seu primeiro sucessor, e continuamente 
expande, aprofunda a árvore até que o nó objetivo seja encontrado ou até que este se depare que não possui mais sucessores. No caso do ramo da árvore não ter mais 
sucessores então retrocede e começa no próximo sucessor do nó raiz da arvore, se este o tiver, realizando repetidamente os passos anteriormente descritos.

Isto é:

1. Nó inicial => ABERTOS
2. Se ABERTOS vazia falha.
3. Remove o primeiro nó de ABERTOS (n) e coloca-o em FECHADOS 
4. Se a profundidade de n é maior que d vai para 2.
5. Expande o nó n. Colocar os sucessores no início de ABERTOS, colocando os ponteiros para n.
6. Se algum dos sucessores é um nó objectivo sai, e dá a solução. Caso contrário vai para 2.


![dfs_gif](https://user-images.githubusercontent.com/76535435/208429926-ed6c1fe2-a335-49b9-ba74-8f936a12625c.gif)


## A* (A* Search Algorithm)

Este é um algoritmo de procura usado para encontrar o caminho mais curto entre um ponto inicial e um ponto final, no qual é calculado para cada sucessor o seu valor de 
f, que é especificado em seguida. Com o valor de f calculado é comparado com os restantes nós expandidos se existe algum com menor valor de f, se houver este é 
expandido e assim sucessivamente, até se encontrar a melhor solução.

A fórmula de custo tem uma combinação total e é dada por: f(x) = g(x) + h(x), onde:

* g(x): Representa uma função de custo sobre uma posição de origem até a posição
* h(x): Representa a função heurística. Proposta para estimativa da posição até o destino

No seguimento da especificação do algotimo, de forma a ser melhor compreendido tem-se o seguinte:

1. Nó inicial(s) => ABERTOS. Faz f(s)=0.
2. Se ABERTOS vazia falha.
3. Remove o nó de ABERTOS (n) com menor custo (f) e coloca-o em FECHADOS 
4. Expande o nó n. Calcula o f de cada um dos sucessores. 
5. Colocar os sucessores que ainda não existem em ABERTOS nem FECHADOS na lista de ABERTOS, por ordem de f colocando os ponteiros para n.
6. Se algum sucessor for um nó objectivo termina e dá a solução.
7. Associa aos sucessores já em ABERTOS ou FECHADOS o menor dos valores de f (existente ou agora calculado). Coloca em ABERTOS os sucessores que estavam em FECHADOS cujos valores de f baixaram. Redirecciona para n os ponteiros de todos os nós cujos valores de f baixaram.
8. Vai para 2.

### Ordenação

Foi desenvolvido uma função que permitisse ordenar os nós pelo seu custo, de forma a serem utilizados neste algoritmo descrito anteriormente.

#### 1. Ordenar-nos

```lisp
;; teste: (ordenar-nos '(((((0 0 0) (0 0 1) (0 1 1) (0 0 1)) ((0 0 0) (0 1 1) (1 0 1) (0 1 1))) 0 1 NIL) ((((0 0 0) (0 0 1) (0 1 1) (1 1 1)) ((0 0 0) (0 1 1) (1 0 1) (0 1 1))) 1 2 NIL)))
;; resultado: (((((0 0 0) (0 0 1) (0 1 1) (0 0 1)) ((0 0 0) (0 1 1) (1 0 1) (0 1 1))) 0 1 NIL) ((((0 0 0) (0 0 1) (0 1 1) (1 1 1)) ((0 0 0) (0 1 1) (1 0 1) (0 1 1))) 1 2 NIL))
(defun ordenar-nos (lista)
  "Função que ordena uma lista de nos"
  (sort lista #'< :key #'calcular-custo-astar)
)
```

### Heurística

A procurar por heurística permite realizar a pesquisa por meio da quantificação de proximidade de um determinado objetivo, no qual a ideia central é evitar considerar 
todas as alternativas, focando a atenção apenas nas que têm mais interesse, sendo necessário avaliar o “interesse” dos nós, isto é, funções de avaliação.
Estas regras são específicas do problema em causa e nem sempre resultam.

#### Heurística Base

Neste projeto foi fornecida uma heuristica base, que priviligia os tabuleiros com maior número de caixas fechadas. Sendo a seguinte:

h(x) = o(x) - c(x)

Em que:

* o(x) é o objetivo para esse tabuleiro: o número de caixas a fechar no tabuleiro x
* c(x) é o número de caixas já fechadas no tabuleiro x

#### Heurística Desenvolvida

Foi desenvolvida uma heurística pelo grupo, que priviligia também os tabuleiros com maior número de caixas fechadas. Sendo a seguinte:

h(x) = (o(x) - a(x)) * (t(x) - o(x))

Em que:

* a(x) é o número atual de caixas fechadas no tabuleiro x
* o(x) é o objetivo para esse tabuleiro: o número de caixas a fechar no tabuleiro x
* t(x) é o número total de caixas fechadas possíveis no tabuleiro x


## Limitações Técnicas e Ideias Para Desenvolvimento Futuro

No desenvolvimento desta fase do projeto, deparamo-nos com algumas limitações, no qual identificamos alguns problemas com o lispworks devido à reduzida memoria que 
este apresenta.
Obtivemos também algumas dificuldades na programação neste IDE uma vez que este é um pouco limitado em questão de verificações de erros, debug e não previne muito 
erros de usabilidade.

Propomos um futuro desenvolvimento em linguagem python no IDE pycharm para uma melhor compreensão e experiência.


## Resultados/ Estatísticas

Para poder comparar a eficácia dos 4 algoritmos funcionais foram desenvolvidas tatabelas com as estatisticas de cada algoritmo na resolução de cada problema.


### BFS (Breadth First Search)


| Problema      | Objetivo      | Nº Nós Gerados | Nº Nós Expandidos |Profundidade |Penetrância | Fator de Ramificação Média| Tempo De Execução|
| ------------- | ------------- | -------------  |-------------------|-------------|------------|---------------------------|------------------|
| a)            | 3             |  108           |  8                |    2        |  1/54      | 9.895994                  |  0ms             |
| b)            | 7             |   2            |  1                |    1        |  1/2       | 1.9947598                 |  0ms             |
| c)            | 10            |   -            |  -                | -           |  -         | -                         | -                |
| d)            | 10            |   -            |  -                | -           |  -         | -                         | -                |
| e)            | 20            |   -            |  -                | -           |  -         | -                         | -                |
| f)            | 35            |   -            |  -                | -           |  -         | -                         | -                |


### DFS (Depth-first search)


| Problema      | Objetivo      | Nº Nós Gerados | Nº Nós Expandidos |Profundidade |Profundidade Máxima| Penetrância | Fator de Ramificação Média|Tempo De Execução|
| ------------- | ------------- | -------------  |-------------------|-------------|-------------------|-------------|---------------------------|-----------------|
| a)            | 3             |  93            |  83               | 2           |  2                |  2/93       |  9.15703                  |  1ms            |
| b)            | 7             |  2             |  1                | 1           |  1                |  1/2        |  1.9947598                |  0ms            |
| c)            | 10            |  203           |  90               | 10          |  10               |  10/203     |  1.5400125                |  2ms            |
| d)            | 10            |  992           |  37               | 37          |  37               |  37/992     |  1.1421085                |  16ms           |
| e)            | 20            |  758           |  28               | 28          |  28               |  14/379     |  1.198952                 |  11ms           |
| f)            | 35            |  5877          |  95               | 95          |  95               |  95/5877    |  1.0852652                |  516ms          |


### A* (A* Search Algorithm)

#### Heuristica Base

| Problema      | Objetivo      | Nº Nós Gerados | Nº Nós Expandidos |Profundidade |Penetrância | Fator de Ramificação Média| Tempo De Execução|
| ------------- | ------------- | -------------  |-------------------|-------------|------------|---------------------------|------------------|
| a)            | 3             | 32             | 2                 | 2           | 1/16       |  5.177991                 |  1ms             |
| b)            | 7             | 16             | 1                 | 1           | 1/16       |  15.978241                |  0ms             |
| c)            | 10            | 7926           | 1403              | 8           | 4/3963     |  2.9042545                |  3021ms          |
| d)            | 10            | -              | -                 | -           | -          |  -                        |  -               |
| e)            | 20            | 7543           | 260               | 16          | 16/7543    |  1.6536994                |  1400ms          |
| f)            | 35            | -              | -                 | -           | -          |  -                        |  -               |


#### Heuristica Desenvolvida pelo grupo

| Problema      | Objetivo      | Nº Nós Gerados | Nº Nós Expandidos |Profundidade |Penetrância | Fator de Ramificação Média| Tempo De Execução|
| ------------- | ------------- | -------------  |-------------------|-------------|------------|---------------------------|------------------|
| a)            | 3             | 32             | 2                 | 2           | 1/16       |  5.177991                 | 1ms              |
| b)            | 7             | 16             | 1                 | 1           | 1/16       |  15.978241                | 1ms              |
| c)            | 10            | 219            | 19                | 8           | 8/219      |  1.7673862                | 3ms              |
| d)            | 10            | 22200          | 1386              | 27          | 9/7400     |  1.3694822                | 22714ms          |
| e)            | 20            | 537            | 16                | 16          | 16/537     |  1.3694822                | 8ms              |
| f)            | 35            | -              | -                 | -           | -          |  -                        | -                |


## Análise Critica Dos Resultados

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


## Lista dos Requisitos do Projeto que Não Foram Implementados

Desenvolvimento dos seguintes algoritmos:

* IDA*
* RBFS
* SMA*



## Anexos

Poblema a)

![image](https://user-images.githubusercontent.com/76535435/208658903-c4306d7a-13de-4654-b512-8738e48a6ec5.png)

Poblema b)

![image](https://user-images.githubusercontent.com/76535435/208658995-5bf90f4a-5554-4074-8245-f62decabfa34.png)


Poblema c)

![image](https://user-images.githubusercontent.com/76535435/208659033-75ed55da-b406-4573-85a4-9ddab0786c90.png)


Poblema d)

![image](https://user-images.githubusercontent.com/76535435/208659058-4edbe90d-cef9-4be1-b0a0-e7d34a228c15.png)


Poblema e)

![image](https://user-images.githubusercontent.com/76535435/208659099-bafe4fff-8937-4f3e-95d7-99fc96466457.png)


Poblema f)

![image](https://user-images.githubusercontent.com/76535435/208659230-a61354ac-bcce-4ee8-81da-61c446cdddd0.png)


