;;;;
;;;; Algoritmo alfabeta
;;;;

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