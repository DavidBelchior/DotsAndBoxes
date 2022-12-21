;; teste: (operadores)
;; resultado: (VERTICAIS HORIZONTAIS)
(defun operadores ()
 "Cria uma lista com todos os operadores do problema."
 (list 'verticais 'horizontais )
)

;; teste: (cria-no '(((0 0 0) (0 0 1) (0 1 1) (0 0 1))((0 0 0) (0 1 1) (1 0 1) (0 1 1))))
;; resultado: ((((0 0 0) (0 0 1) (0 1 1) (0 0 1)) ((0 0 0) (0 1 1) (1 0 1) (0 1 1))) 0 NIL NIL)
(defun cria-no (tabuleiro &optional (g 0) (heuristica nil) (pai nil))
  "Cria um no com o tabuleiro inserido, com a profundidade 0 se nao inserida, com o valor da heuristica e com o no pai."
  (list tabuleiro g heuristica pai)
)

;;; Funcoes auxiliares para saber valores do no

;; teste: (no-estado '((((0 0 0) (0 0 1) (0 1 1) (0 0 1)) ((0 0 0) (0 1 1) (1 0 1) (0 1 1))) 0 NIL NIL))
;; resultado: (((0 0 0) (0 0 1) (0 1 1) (0 0 1)) ((0 0 0) (0 1 1) (1 0 1) (0 1 1)))
(defun no-estado (no)
  "Retorna o estado de um no"
  (first no)
)

;; teste: (no-profundidade '((((0 0 0) (0 0 1) (0 1 1) (0 0 1)) ((0 0 0) (0 1 1) (1 0 1) (0 1 1))) 0 NIL NIL))
;; resultado: 0
(defun no-profundidade (no)
  "Retorna a profundidade de um no"
  (second no)
)

;; teste: (no-heuristica '((((0 0 0) (0 0 1) (0 1 1) (0 0 1)) ((0 0 0) (0 1 1) (1 0 1) (0 1 1))) 0 NIL NIL))
;; resultado: NIL
(defun no-heuristica (no)
  "Retorna a heuristica de um no"
  (third no)
)

;; teste: (no-pai '((((0 0 0) (0 0 1) (0 1 1) (0 0 1)) ((0 0 0) (0 1 1) (1 0 1) (0 1 1))) 0 NIL NIL))
;; resultado: NIL
(defun no-pai (no)
  "Retorna o pai de um no"
  (fourth no)
)

;; teste: (get-arcos-horizontais '(((0 0 0) (0 0 1) (0 1 1) (0 0 1)) ((0 0 0) (0 1 1) (1 0 1) (0 1 1))))
;; resultado: ((0 0 0) (0 0 1) (0 1 1) (0 0 1))
(defun get-arcos-horizontais (tabuleiro)
  "Retorna a lista dos arcos horizontais de um tabuleiro"
  (first tabuleiro) ;; retorna o primeiro elemento do tabuleiro
)

;; teste: (get-arcos-verticais '(((0 0 0) (0 0 1) (0 1 1) (0 0 1)) ((0 0 0) (0 1 1) (1 0 1) (0 1 1))))
;; resultado: ((0 0 0) (0 1 1) (1 0 1) (0 1 1))
(defun get-arcos-verticais (tabuleiro)
  "Retorna a lista dos arcos verticiais de um tabuleiro"
  (second tabuleiro) ;; retorna o segundo elemento do tabuleiro
)

;;; Funcoes de auxialio para as procuras

;; teste: (no-solucaop '((((0 0 0) (0 0 1) (0 1 1) (0 0 1)) ((0 0 0) (0 1 1) (1 0 1) (0 1 1))) 0 NIL NIL) 1)
;; resultado: T
(defun no-solucaop (no obj)
  "Verifica se um no e solucao"
  (cond ((= (numeroDeQuadrados (no-estado no)) obj) T)
        (T nil)
  )
)

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

;; teste: (gerar-sucessores '(((0 0 0) (0 0 1) (0 1 1) (0 0 1)) ((0 0 0) (0 1 1) (1 0 1) (0 1 1))) 'verticais)
;; resultado(apenas um tabuleiro): (((0 0 0) (0 0 1) (0 1 1) (0 0 1)) ((1 0 0) (0 1 1) (1 0 1) (0 1 1)))
(defun gerar-sucessores (tabuleiro operador)
  "Função que gera os sucessores de um tabuleiro"
  (cond ((eq operador 'verticais) (mapcar (lambda (x) (cons (get-arcos-horizontais tabuleiro) (list (arco-na-posicao (first x) (second x) (get-arcos-verticais tabuleiro))))) (espacos-vazios tabuleiro operador) ))
          ((eq operador 'horizontais) (mapcar (lambda (x) (cons (arco-na-posicao (second x) (first x)  (get-arcos-horizontais tabuleiro)) (list (get-arcos-verticais tabuleiro)))) (espacos-vazios tabuleiro operador) ))
    )
)

;; teste: (espacos-vazios '(((0 0 0) (0 0 1) (0 1 1) (0 0 1)) ((0 0 0) (0 1 1) (1 0 1) (0 1 1))) 'verticais)
;; resultado: ((0 0) (0 1) (0 2) (1 0) (2 1) (3 0))
(defun espacos-vazios (lista operador &optional (dentro 0) (fora 0))
  "Retorna uma lista com os espacos vazios de um tabuleiro"
    (cond ((null lista) nil) 
      ((>= dentro (length (caar lista)))  (espacos-vazios lista operador 0 (+ fora 1))) ;; se ja leu todos os elementos da linha, entao passa para a proxima linha
      ((>= fora (length (car lista) )) nil) ;; se ja leu todas as linhas, entao retorna 0     
      (t (cond ((eq operador 'verticais) 
              (cond ((equal (tem-arco-vertical fora dentro (get-arcos-verticais lista) ) nil)  (cons (list fora dentro) (espacos-vazios lista operador (+ dentro 1) fora))) 
                    (t (espacos-vazios lista operador (+ dentro 1) fora)) )
            )
            ((eq operador 'horizontais) 
                (cond ((equal (tem-arco-horizontal fora dentro (get-arcos-horizontais lista) ) nil)  (cons (list dentro fora) (espacos-vazios lista operador (+ dentro 1) fora))) 
                      (t (espacos-vazios lista operador (+ dentro 1) fora)) )
            )
            (t nil)
          ))   
    )
)

;; teste: (tem-arco-vertical 0 0 (get-arcos-verticais'(((0 0 0) (0 0 1) (0 1 1) (0 0 1)) ((0 0 0) (0 1 1) (1 0 1) (0 1 1)))))
;; resultado: NIL
(defun tem-arco-vertical (indice1 indice2 lista) 
  "Função que recebe dois índices e o tabuleiro e verifica se existe um arco vertical"
    (cond ((null lista) nil)
        ((<= (length lista) indice1) nil)
        ((<= (length (first lista)) indice2) nil)
        ((= (get-arco-na-posicao indice1 indice2 lista) 1) t)
        (t nil)
    )
)

;; teste: (tem-arco-horizontal 0 0 (get-arcos-horizontais'(((0 0 0) (0 0 1) (0 1 1) (0 0 1)) ((0 0 0) (0 1 1) (1 0 1) (0 1 1)))))
;; resultado: NIL
(defun tem-arco-horizontal (indice1 indice2 lista) 
  "Função que recebe dois índices e o tabuleiro e verifica se existe um arco horizontal"
    (cond ((null lista) nil)
        ((<= (length lista) indice1) nil)
        ((<= (length (first lista)) indice2) nil)
        ((= (get-arco-na-posicao indice1 indice2  lista) 1) t)
        (t nil)
    )
)

;; teste: (get-arco-na-posicao 0 0 (get-arcos-horizontais'(((0 0 0) (0 0 1) (0 1 1) (0 0 1)) ((0 0 0) (0 1 1) (1 0 1) (0 1 1)))))
;; resultado: 0
(defun get-arco-na-posicao (indice1 indice2 lista)
  "Função que retorna o arco que se encontra numa posicao da lista de arcos horizontais ou verticais"
  (cond ((null lista) nil) ;; se a lista for vazia retorna nil
        (t (nth indice2 (nth indice1 lista))) ;; retorna o arco na posicao numero1, numero2
  )
)

;; teste: (arco-na-posicao 0 0 (get-arcos-horizontais'(((0 0 0) (0 0 1) (0 1 1) (0 0 1)) ((0 0 0) (0 1 1) (1 0 1) (0 1 1)))))
;; resultado: ((1 0 0) (0 0 1) (0 1 1) (0 0 1))
(defun arco-na-posicao (posicao-arco posicao-elemento lista-arcos)
  "Função que retorna o elemento que se encontra numa posicao da lista de arcos"
  (cond ((null lista-arcos) nil)
            ((= posicao-arco 0) (cons (substituir posicao-elemento (car lista-arcos)) (cdr lista-arcos)))
            (t (cons (car lista-arcos) (arco-na-posicao (- posicao-arco 1)  posicao-elemento (cdr lista-arcos))))
  )
)

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

;; teste: (heuristica '(((0 0 0) (0 0 1) (0 1 1) (0 0 1)) ((0 0 0) (0 1 1) (1 0 1) (0 1 1))) 2)
;; resultado: 1
(defun heuristica (tabuleiro obj)
  "Função que retorna o valor da heuristica"
    (- obj (numeroDeQuadrados tabuleiro))
)

;; teste: (nossa-heuristica '(((0 0 0) (0 0 1) (0 1 1) (0 0 1)) ((0 0 0) (0 1 1) (1 0 1) (0 1 1))) 2)
;; resultado: 1/10
(defun nossa-heuristica (tabuleiro obj)
  "Função que retorna o valor da nossa heuristica"
    (* (- obj (numeroDeQuadrados tabuleiro)) (- (* (length (caar tabuleiro)) (length (cadr tabuleiro))) obj ))
)

;; teste: (calcular-custo-astar '((((0 0 0) (0 0 1) (0 1 1) (0 0 1)) ((0 0 0) (0 1 1) (1 0 1) (0 1 1))) 0 2 NIL))
;; resultado: 2
(defun calcular-custo-astar (no)
  "Função que retorna o custo, ou seja, a profundidade do no mais a heuristica"
  (+ (no-profundidade no) (no-heuristica no))
)

;; teste: (ordenar-nos '(((((0 0 0) (0 0 1) (0 1 1) (0 0 1)) ((0 0 0) (0 1 1) (1 0 1) (0 1 1))) 0 1 NIL) ((((0 0 0) (0 0 1) (0 1 1) (1 1 1)) ((0 0 0) (0 1 1) (1 0 1) (0 1 1))) 1 2 NIL)))
;; resultado: (((((0 0 0) (0 0 1) (0 1 1) (0 0 1)) ((0 0 0) (0 1 1) (1 0 1) (0 1 1))) 0 1 NIL) ((((0 0 0) (0 0 1) (0 1 1) (1 1 1)) ((0 0 0) (0 1 1) (1 0 1) (0 1 1))) 1 2 NIL))
(defun ordenar-nos (lista)
  "Função que ordena uma lista de nos"
  (sort lista #'< :key #'calcular-custo-astar)
)
 
;; Ordena a juncao da lista de nos abertos e sucessores
(defun colocar-sucessores-em-abertos (sucessores abertos)
  "Função que coloca os sucessores numa lista de abertos"
  (ordenar-nos (append sucessores abertos))
)

;; primeiro a lista de abertos e depois a lista de sucessores (nivel seguinte do no)
(defun abertos-bfs (listaAbertos listaSucessores)
  "Função que ordena a lista de abertos para o Breadth-First Search"
  (append listaAbertos listaSucessores)
)

;; primeiro a lista de sucessores e depois a restante lista de abertos (nivel seguinte do no)
(defun abertos-dfs (listaAbertos listaSucessores)
  "Função que ordena a lista de abertos para o Depth-First Search"
  (append listaSucessores listaAbertos)
)

;; no bfs se existir devolve T
;; no dfs se existir e a profundidade for menor devolve T senão devolve F
;; no astar se existir e o custo for menor devolve T senão devolve F
(defun no-existep (no fechados algoritmo)
  "Função que verifica se um no existe numa lista de fechados e dependendo do algoritmo retorna T ou F"
  (cond ((null fechados) nil)
        ((equal (no-estado no) (no-estado (car fechados))) 
         (cond ((equal algoritmo 'bfs) T)
               ((equal algoritmo 'dfs)
                 (cond ((>= (no-profundidade no)) (no-profundidade (first fechados)) T)
                       (T nil)
                 )
                )
                ((equal algoritmo 'astar)
                 (cond ((>= (calcular-custo-astar no) (calcular-custo-astar (first fechados))) T)
                       (T nil)
                 )
               )
         )
        )
        (T (no-existep no (cdr fechados) algoritmo))
  )
)
 
(defun nos-unicos-bfs (fechados sucessores)
  "Devolve apenas nos que sejam diferentes aos nos em fechados"
   (cond
       ((null sucessores) NIL)
       ((null fechados) sucessores)
       ((no-existep (car sucessores) fechados 'bfs) (nos-unicos-bfs fechados (cdr sucessores)))
       (T (cons (car sucessores) (nos-unicos-bfs fechados (cdr sucessores))))
   )
)


(defun nos-unicos-dfs (abertos fechados sucessores)
  "Retorna os sucessores que ainda nao estao em abertos e que possam estar em fechados mais abaixo (profundidade menor)"
  (remove-duplicates (append (not-in-abertos-fechados abertos sucessores) (not-in-abertos-fechados fechados sucessores)) :test 'equal)
)


(defun nos-unicos-astar (abertos fechados sucessores)
  "Retorna os sucessores que ainda nao estao em abertos nem em fechados"
   (let ((abertos-mais-fechados (append abertos fechados)))
     (cond
         ((null sucessores) NIL)
         ((null abertos-mais-fechados) sucessores)
         ((no-existep (car sucessores) abertos-mais-fechados 'astar) (nos-unicos-astar abertos fechados (cdr sucessores)))
         (T (cons (car sucessores) (nos-unicos-astar abertos fechados (cdr sucessores))))
     )
   )
)


(defun not-in-abertos-fechados (lista sucessores)
  "Retorna os sucessores que ainda nao estao em abertos nem em fechados ou se estao, estao numa profundidade menor "
  (cond
      ((null sucessores) NIL)
      ((no-existep (car sucessores) lista 'dfs) (not-in-abertos-fechados lista (cdr sucessores)))
      (T (cons (car sucessores) (not-in-abertos-fechados lista (cdr sucessores))))
  )
)


(defun remove-sucessores-from-fechados (fechados sucessores)
  "Remove os sucessores de uma lista de fechados"
  (set-difference fechados sucessores :test 'equal-states)
)


(defun equal-states (no1 no2)
  "Função que verifica se o estado de dois nos são iguais"
  (equal (no-estado no1) (no-estado no2))
)


(defun no-obj (lista funObj obj)
  "Função que devolve o primeiro no que satisfaz a condição do funObj"
  (cond
      ((null lista) NIL)
      ((funcall funObj (car lista) obj) (car lista))
      (T (no-obj (cdr lista) funObj obj))
   )
)


(defun no-solucaop-astar (no)
  "Função que verifica se o no é solução"
  (cond ((= (no-heuristica no) 0) T)
        (T nil)
  )
)


(defun sucessores-que-estao-em-fechados-com-menor-custo-astar (fechados sucessores)
  "Função que devolve os sucessores que estão em fechados com menor custo"
   (cond
       ((null sucessores) NIL)
       ((null fechados) sucessores)
       ((no-existep (car sucessores) fechados 'astar) (sucessores-que-estao-em-fechados-com-menor-custo-astar fechados (cdr sucessores)))
       (T (cons (car sucessores) (sucessores-que-estao-em-fechados-com-menor-custo-astar fechados (cdr sucessores))))
   )
)


(defun penetrancia (abertos fechados no-obj)
" Funcao que devolve a penetrancia"
    (cond ((or (null abertos) (null fechados)) nil)
        (t (/ (- (length (caminho no-obj)) 1) (numeroDeNosGerados abertos fechados)))
    )
)


(defun numeroDeNosGerados (fechados abertos)
" Funcao que recebe uma lista de nos e devolve o numero de nos gerados"
    (+ (length fechados) (length abertos))
)


(defun polinomial (b-value l-value t-value)
  "B + B^2 + ... + B^L=T"
  (cond ((= 1 l-value) (- b-value t-value))
    (T (+ (expt b-value l-value) (polinomial b-value (- l-value 1) t-value)))
  )
)

;; l-value = caminho
;; t-value = numero de nos gerados
(defun branching-factor (l-value t-value &optional (erro 0.1) (bmin 1) (bmax 10e11))
  "Devolve o factor de ramificacao, executando o metodo da bisseccao"
  (let ((bmedio (/ (+ bmin bmax) 2)))
    (cond ((< (- bmax bmin) erro) (/ (+ bmax bmin) 2))
          ((< (polinomial bmedio l-value t-value) 0) (branching-factor l-value t-value erro bmedio bmax))
          (t (branching-factor l-value t-value erro bmin bmedio))
    )
  )
)


(defun tempo-de-execucao (funcao)
  (let ((real-base (get-internal-real-time))
        (run-base (get-internal-run-time)) )
    funcao
    (values (/ (- (get-internal-real-time) real-base) internal-time-units-per-second)
            (/ (- (get-internal-run-time) run-base) internal-time-units-per-second))))


(defun numeroDeNosExpandidos (fechados)
" Funcao que recebe uma lista de nos e devolve o numero de nos expandidos"
    (length fechados)
) 


(defun caminho (no)
" Funcao que recebe um no e devolve o caminho ate a raiz"
    (cond 
        ((null no) nil)
        (t (cons (list (no-estado no) (no-profundidade no)) (caminho (no-pai no))))
    )
) 


(defun numeroDeQuadrados (tabuleiro &optional (dentro 0) (fora 0))
  "Funcao responsavel por contar o numero de quadrados de fechados numa tabuleiro"
  (cond ((null tabuleiro) nil) ;; se o tabuleiro for nulo, entao retorna nulo
    ((>= dentro (length (caar tabuleiro)))  (numeroDeQuadrados tabuleiro 0 (+ fora 1))) ;; se ja leu todos os elementos da linha, entao passa para a proxima linha
    ((>= fora (length (car tabuleiro))) 0) ;; se ja leu todas as linhas, entao retorna 0
    ;; verifica se os arcos da caixa estao todos fechados
    ((and (equal (nth dentro (nth fora (nth 0 tabuleiro))) 1) 
          (equal (nth dentro (nth (+ fora 1) (nth 0 tabuleiro))) 1) 
          (equal (nth fora (nth dentro (nth 1 tabuleiro))) 1) 
          (equal (nth fora  (nth (+ dentro 1) (nth 1 tabuleiro))) 1) 
     )
     (+ 1 (numeroDeQuadrados tabuleiro (+ dentro 1) fora ))) ;; se estiverem fechados, entao soma 1 e continua a leitura
    (t (numeroDeQuadrados tabuleiro (+ dentro 1) fora )) ;; se nao estiverem fechados, entao continua a leitura
  )
)


(defun substituir (indice lista &optional (x 1)) 
"Funcao que recebe um indice, uma lista e valor x e devera substituir o elemento nessa posicao pelo valor x, que deve ser definido com o valor de default a 1."
  (cond ((null lista) nil) ;; se a lista for vazia retorna nil
        ((= indice 0) (cons x (cdr lista)))
        (t (cons (car lista) (substituir (- indice 1) (cdr lista) x)))
  )
)


(defun contarArcos (lista)
  "Funcao que recebe uma lista e devera contar o numero de arcos colocados"
  (cond ((null lista) nil) 
    (t (+ (contarArcosVertical lista) (contarArcosHorizontal lista)))
  )
)


(defun contarArcosVertical (lista &optional (dentro 0)  (fora 0))
  "Funcao que recebe uma lista e devera contar o numero de arcos colocados na vertical"
  (cond ((null lista) nil)
    ((>= dentro (length (caar lista))) (+ 0 (contarArcosVertical lista 0 (+ fora 1) )) )
    ((>= fora (length (cadr lista))) 0)
    ( (equal (nth dentro (nth fora (nth 1 lista))) 1)  (+ 1 (contarArcosVertical lista (+ dentro 1) fora)))
    (t (+ 0 (contarArcosVertical lista (+ dentro 1) fora )))
  )
)


(defun contarArcosHorizontal (lista &optional (dentro 0)  (fora 0))
  "Funcao que recebe uma lista e devera contar o numero de arcos colocados na horizontal"
  (cond ((null lista) nil)
    ((>= dentro (length (caar lista))) (+ 0 (contarArcosHorizontal lista 0 (+ fora 1) )) )
    ((>= fora (length (car lista))) 0)
    ( (equal (nth dentro (nth fora (nth 0 lista))) 1)  (+ 1 (contarArcosHorizontal lista (+ dentro 1) fora)))
    (t (+ 0 (contarArcosHorizontal lista (+ dentro 1) fora )))
  )
)


(defun devolveSubstituido (lista posicao horientacao)
"Funcao que recebe uma lista de arcos, uma posicao e uma orientacao e devolve a lista com o arco na posicao substituido pela orientacao"
    (cond ((equal horientacao 'h) (list (juntarSub (car posicao) (get-arcos-horizontais lista) (substituir (second posicao) (nth (first posicao) (get-arcos-horizontais lista)))) (second lista)));; se for horizontal substitui nos arcos horizontais
          ((equal horientacao 'v) (list (first lista) (juntarSub (cadr posicao) (get-arcos-verticais lista) (substituir (first posicao) (nth (second posicao) (get-arcos-verticais lista)))))) ;; se for vertical substitui nos arcos verticais
          (t (print "erro")) ;; se nao for nem horizontal nem vertical da erro
    )
)


(defun juntarSub (n lista sub)
"Dada uma lista, uma posicao e uma sublista, retorna a lista com a sublista na posicao dada"
  (cond ((= n 0) (cons sub (cdr lista))) ;;Se a posicao for 0 retorna a sublista concatenada com o resto da lista
    (t (cons (car lista) (juntarSub (- n 1) (cdr lista) sub))) ;;Se a posicao nao for 0, retorna a cabeça da lista concatenada com a sublista na posicao pretendida
  )
)

