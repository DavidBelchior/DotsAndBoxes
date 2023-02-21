;;;;
;;;; Constantes:
;;;;
(defvar *jogador2* 2)
(defvar *jogador1* 1)
(defvar *valor* most-negative-fixnum)
(defvar *primeiro-estado* nil)
(defvar *primeiro-jogador* 1)
(defvar *cortes-alfa* 0)
(defvar *cortes-beta* 0)
(defvar *numero-de-nos-analisados* 0)
(defvar *inicio* 0)

;;;;
;;;; Funcoes:
;;;;

;; Tabuleiro inicial
(defun tabuleiro-inicial ()
  "Funcao responsavel por mostrar o tabuleiro inicial"
  '(;estado
    (;tabuleiro figura 1
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
    (8 4);8 caixas fechadas pelo jogador1 e 4 caixas fechadas pelo jogador2
    0
  )
)

(defun no-estado (no)
  "Retorna o estado de um no"
  (first no)
)

(defun no-numero-de-caixas (no)
  "Retorna o numero de caixas de um no"
  (second no)
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

;; teste: (operadores)
;; resultado: (VERTICAIS HORIZONTAIS)
(defun operadores ()
 "Cria uma lista com todos os operadores do problema."
 (list 'verticais 'horizontais )
)

(defun numeroDeQuadrados (tabuleiro &optional (dentro 0) (fora 0))
  "Funcao responsavel por contar o numero de quadrados de fechados numa tabuleiro"
  (cond ((null tabuleiro) nil)
        ((>= (1+ dentro) (length (get-arcos-horizontais tabuleiro))) 0)
        ((>= (1+ fora) (length (get-arcos-verticais tabuleiro))) (numeroDeQuadrados tabuleiro (+ dentro 1) 0))
        ((and (not (= (get-arco-na-posicao dentro fora(get-arcos-horizontais tabuleiro)) 0))
              (not (= (get-arco-na-posicao (+ dentro 1) fora (get-arcos-horizontais tabuleiro)) 0))
              (not (= (get-arco-na-posicao fora dentro (get-arcos-verticais tabuleiro)) 0))
              (not (= (get-arco-na-posicao (+ fora 1) dentro (get-arcos-verticais tabuleiro)) 0))
          )
         (+ 1 (numeroDeQuadrados tabuleiro dentro (+ fora 1)))
        )
        (t (numeroDeQuadrados tabuleiro dentro (+ fora 1)))
  )
)


(defun no-preenchidop (no)
  "Verifica se um no esta totalmente preenchido"
  (cond ((= (fn-numero-de-quadradodos no) 30) T)
        (T nil)
  )
)


(defun fn-numero-de-quadradodos (no)
"Funcao que retorna o numero de quadrados fechados por um jogador"
  (+ (first (no-numero-de-caixas no)) (second (no-numero-de-caixas no))) ;; retorna a soma que corresponde ao numero de caixas fechadas
)

(defun troca-jogador (jogador)
 "Funcao que permite trocar de jogador"
  (if (= 1 jogador) *jogador2* *jogador1*) ;; se o jogador for 1 troca para 2, se for 2 troca para 1 
)


(defun tempo-limite (tempo prof-no)
  "Funcao que verifica se o tempo limite foi atingido"
  (if (= prof-no 0) (setf *inicio* (get-internal-real-time))) ;; se for a primeira chamada do algoritmo, guarda o tempo inicial
  (if (<= (- tempo 700) (- (get-internal-real-time) *inicio*)) t nil) ;; se o tempo limite for atingido retorna t, senao retorna nil
)


;;;; guarda a solucao se o algoritmo encontrar uma solucao e tiver uma melhor heuritica
(defun guardar-solucao (estado novo-alfa)
   "Guarda uma solução se o alfa for maior que o valor atual"
  (cond ((> novo-alfa *valor*) (setq *valor* novo-alfa)(setq *primeiro-estado* estado));; se o alfa for maior que o valor atual guarda a solucao
        (t NIL) ;; se o alfa for menor que o valor atual nao guarda a solucao
  )
)

(defun cria-no (estado no-quadrados prof-no)
  "Cria um novo no"
  (list estado no-quadrados prof-no) ;; cria um novo no com o estado, o numero de quadrados fechados e a profundidade
)

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

(defun jogar-outra-vez (contagem-de-quadrados nos-sucessores jogador prof-no)
    "Joga mais que uma vez"
  (cond ((null nos-sucessores) nil) ;; Se a lista de sucessores eativer vazia retorna null
        ((< contagem-de-quadrados (fn-numero-de-quadradodos (car nos-sucessores))) (append (novos-sucessores (car nos-sucessores) jogador prof-no) (jogar-outra-vez contagem-de-quadrados (cdr nos-sucessores) jogador prof-no))) ;; se fechar uma caixa permite jogar uma vez mais de seguida
        (t (cons (car nos-sucessores) (jogar-outra-vez contagem-de-quadrados (cdr nos-sucessores) jogador prof-no))) ;; se nao fechar uma caixa nao permite jogar mais de seguida
  )
)

(defun gerar-sucessores (tabuleiro operador jogador)
  "Função que gera os sucessores de um tabuleiro"
  (cond((eq operador 'verticais) (mapcar (lambda (x) (cons (get-arcos-horizontais tabuleiro) (list (arco-na-posicao (first x) (second x) (get-arcos-verticais tabuleiro) jogador)))) (espacos-vazios tabuleiro operador) )) 
       ((eq operador 'horizontais) (mapcar (lambda (x) (cons (arco-na-posicao (second x) (first x)  (get-arcos-horizontais tabuleiro) jogador) (list (get-arcos-verticais tabuleiro)))) (espacos-vazios tabuleiro operador) ))
  )
)

(defun colocar-na-posicao (tabuleiro operador jogador x) 
  "Coloca um arco na posicao x"
  (cond ((eq operador 'vertical) (cons (get-arcos-horizontais tabuleiro) (list (arco-na-posicao (first x) (second x) (get-arcos-verticais tabuleiro) jogador)))) ;; Se o operador for vertical coloca o arco na posicao x
        ((eq operador 'horizontal) (cons (arco-na-posicao (second x) (first x) (get-arcos-horizontais tabuleiro) jogador) (list (get-arcos-verticais tabuleiro)))) ;; Se o operador for horizontal coloca o arco na posicao x
        (t NIL);; se o operador nao for vertical nem horizontal retorna null
  )
)

(defun cria-no-quadrados-fechados (estado contagem-de-quadrados no-quadrados jogador)
  "Função que cria um novo no com o numero de quadrados fechados"
 (let ((numero-quadrados (numeroDeQuadrados estado))) ;; numero de quadrados fechados no estado
  (if (= contagem-de-quadrados numero-quadrados) ;; Permite verificar se o estado onde se encontra tem o mesmo numero de quadrados fechados
      no-quadrados 
      (if (= 1 jogador) ;; se o jogador for 1
      (list (+ (first no-quadrados) (- numero-quadrados contagem-de-quadrados)) (second no-quadrados)) ;; Permite adicionar o numero de quadrados fechados ao jogador 1 se fechar mais quadrados
      (list  (first no-quadrados) (+ (second no-quadrados) (- numero-quadrados contagem-de-quadrados)))) ;; Permite adicionar o numero de quadrados fechados ao jogador 2 se fechar mais quadrados
  ) 
 )
)

(defun arco-na-posicao (posicao-arco posicao-elemento lista-arcos jogador)
  "Função que retorna o elemento que se encontra numa posicao da lista de arcos"
  (cond ((null lista-arcos) nil)
            ((= posicao-arco 0) (cons (substituir posicao-elemento (car lista-arcos) jogador) (cdr lista-arcos))) ;; se a posicao do arco for 0 retorna a lista de arcos com o elemento na posicao do elemento substituido pelo jogador
            (t (cons (car lista-arcos) (arco-na-posicao (- posicao-arco 1)  posicao-elemento (cdr lista-arcos) jogador))) ;; se a posicao do arco nao for 0 retorna a lista de arcos com o elemento na posicao do elemento substituido pelo jogador
  )
)

(defun substituir (indice lista &optional (x 1)) 
"Funcao que recebe um indice, uma lista e valor x e devera substituir o elemento nessa posicao pelo valor x, que deve ser definido com o valor de default a 1."
  (cond ((null lista) nil) ;; se a lista for vazia retorna nil
        ((= indice 0) (cons x (cdr lista))) ;; se o indice for 0 retorna a lista com o elemento na posicao do indice substituido pelo valor x
        (t (cons (car lista) (substituir (- indice 1) (cdr lista) x))) ;; se o indice nao for 0 retorna a lista com o elemento na posicao do indice substituido pelo valor x
  )
)

;; teste: (espacos-vazios '(((0 0 0) (0 0 1) (0 1 1) (0 0 1)) ((0 0 0) (0 1 1) (1 0 1) (0 1 1))) 'verticais)
;; resultado: ((0 0) (0 1) (0 2) (1 0) (2 1) (3 0))
(defun espacos-vazios (lista operador &optional (dentro 0) (fora 0))
  "Retorna uma lista com os espacos vazios de um tabuleiro"
    (cond ((null lista) nil) 
      ((>= dentro (length (car (if (eq operador 'verticais) (second lista) (first lista))))) (espacos-vazios lista operador 0 (+ fora 1))) ;; se ja leu todos os elementos da linha, entao passa para a proxima linha
      ((>= fora (length (if (eq operador 'verticais) (second lista) (first lista)) )) nil) ;; se ja leu todas as linhas, entao retorna 0     
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
        ((/= (get-arco-na-posicao indice1 indice2 lista) 0) t)
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
        ((/= (get-arco-na-posicao indice1 indice2  lista) 0) t)
        (t nil)
    )
)

;; teste: (tem-arco-vertical 0 0 (get-arcos-verticais'(((0 0 0) (0 0 1) (0 1 1) (0 0 1)) ((0 0 0) (0 1 1) (1 0 1) (0 1 1)))))
;; resultado: NIL
(defun tem-arco-vertical-T (indice1 indice2 lista) 
  "Função que recebe dois índices e o tabuleiro e verifica se existe um arco vertical"
    (cond ((null lista) T)
        ((<= (length lista) indice1) T)
        ((<= (length (first lista)) indice2) T)
        ((/= (get-arco-na-posicao indice1 indice2 lista) 0) t)
        (t nil)
    )
)

;; teste: (tem-arco-horizontal 0 0 (get-arcos-horizontais'(((0 0 0) (0 0 1) (0 1 1) (0 0 1)) ((0 0 0) (0 1 1) (1 0 1) (0 1 1)))))
;; resultado: NIL
(defun tem-arco-horizontal-T (indice1 indice2 lista) 
  "Função que recebe dois índices e o tabuleiro e verifica se existe um arco horizontal"
    (cond ((null lista) T)
        ((<= (length lista) indice1) T)
        ((<= (length (first lista)) indice2) T)
        ((/= (get-arco-na-posicao indice1 indice2  lista) 0) t)
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

(defun valores-iniciais (jogador)
  "Função que inicializa as variaveis globais"
  (setq *cortes-alfa* 0)
  (setq *cortes-beta* 0)
  (setq *numero-de-nos-analisados* 0)
  (setq *valor* most-negative-fixnum)
  (setq *primeiro-estado* nil)
  (setq *primeiro-jogador* jogador)
  (setq *inicio* (get-internal-real-time))
)

(defun printar-detalhes (inicial)
  "Funcao que imprime os detalhes da jogada"
  (cond ((eq inicial t) )
        (t (format t "Tempo de execucao: ~a ms~%~%" (- (get-internal-real-time) *inicio*))
           (format t "Jogada: ~a~%~%" (no-estado *primeiro-estado*))
           (format t "Novo estado: ~a~%~%" *primeiro-estado*)
           (format t "Numero de cortes alfa: ~a~%~%" *cortes-alfa*)
           (format t "Numero de cortes beta: ~a~%~%" *cortes-beta*)
           (format t "Numero de nos analisados: ~a~%~%" *numero-de-nos-analisados*))
  )
  (printar-detalhes-ficheiro inicial)
)

(defun printar-detalhes-ficheiro (inicial)
  "Funcao que imprime os detalhes da jogada"
  (with-open-file (str "C:/Users/asus/Documents/Log.dat"
                     :direction :output
                     :if-exists :append
                     :if-does-not-exist :create)

    (cond ((eq inicial t) )
          (t (format str "Tempo de execucao: ~a ms~%~%" (- (get-internal-real-time) *inicio*))
            (format str "Jogada: ~a~%~%" (no-estado *primeiro-estado*))
            (format str "Novo estado: ~a~%~%" *primeiro-estado*)
            (format str "Numero de cortes alfa: ~a~%~%" *cortes-alfa*)
            (format str "Numero de cortes beta: ~a~%~%" *cortes-beta*)
            (format str "Numero de nos analisados: ~a~%~%" *numero-de-nos-analisados*))
    )
  )
)

;; tender para o primeiro jogador que joga
(defun avaliacao (no)
  "Função que retorna o valor da heuristica"
  (if (= *primeiro-jogador* 1) (- (first (no-numero-de-caixas no)) (second (no-numero-de-caixas no)))  (- (second (no-numero-de-caixas no)) (first (no-numero-de-caixas no))))
)