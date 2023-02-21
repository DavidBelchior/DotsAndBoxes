(defun Menu-Inicial ()
"Funcao que permite fornecer um menu inicial ao utilizador"
       (format t "~%           ______________________________________________________")      
       (format t "~%          |                                                      |")
       (format t "~%          |                    Dots and Boxes                    |")
       (format t "~%          |                   Desenvolvido por:                  |")            
       (format t "~%          |                     Andre Matias                     |")
       (format t "~%          |                    David Belchior                    |")
       (format t "~%          |                                                      |")
       (format t "~%          |                                                      |")
       (format t "~%          |                (Pressione 1 para Jogar)              |")
       (format t "~%          |                (Pressione 2 para Sair)               |")
       (format t "~%          |______________________________________________________|")      
       (format t "~%~%Opcao:~%~%")
       (format t "--> ")
  (let ((opcao (read))) 
    (cond ((not (numberp opcao)) (Menu-Inicial)) ;; Verifica se esta a inserir um numero
          ((= opcao 1) (Tipo-de-Jogo)) ;; Vai para um menu que permitira escolhar que tipo de jogo quer jogar
          ((= opcao 2) (format t "Saindo...~%")) ;; Sai do jogo
          (t (format t "Opcao invalida!~%")(Menu-Inicial)) ;; Se não inserir um numero entre 1 e 2 volta a pedir uma opção
    )
  ) 
) 


(defun Tipo-de-Jogo ()
"Funcao que permite fornecer um menu ao utilizador de forma a que possa escolher o tipo de jogo"
       (format t "~%           ________________________________________________________")      
       (format t "~%          |                                                        |")
       (format t "~%          |                Selecione uma Opcao de Jogo:            |")
       (format t "~%          |                                                        |")
       (format t "~%          | (Pressione 1 para Humano vs Maquina -->Humano Comeca)  |")
       (format t "~%          | (Pressione 2 para Humano vs Maquina -->Maquina Comeca) |")
       (format t "~%          |              (Pressione 3 Maquina vs Maquina)          |")
       (format t "~%          |                   (Pressione 4 para Sair)              |")
       (format t "~%          |________________________________________________________|")      
       (format t "~%~%Opcao:~%~%")
       (format t "--> ")
  (let ((opcao (read))) 
    (cond ((not (numberp opcao)) (Tipo-de-Jogo)) ;; Verifica se esta a inserir um numero
          ((= opcao 1) (Tempo-Jogada 1)) 
          ((= opcao 2) (Tempo-Jogada 2))
          ((= opcao 3) (Tempo-Jogada 3))    
          ((= opcao 4) (format t "Saindo...~%")) ;; Sai do jogo
          (t (format t "Opcao invalida!~%")(Tipo-de-Jogo)) ;; Se não inserir um numero entre 1 e 3 volta a pedir uma opção
    )
  ) 
)



(defun Tempo-Jogada (TipoJogo)
"Funcao que permite fornecer um menu que permita ao utilizador inserir um tempo de cada jogada"
       (format t "~%           ______________________________________________________")      
       (format t "~%          |                                                      |")
       (format t "~%          | Insira um tempo de cada jogada entre 1 e 20 segundos:|")
       (format t "~%          |                             Ou                       |")
       (format t "~%          |                  (Pressione 0 para Sair)             |")
       (format t "~%          |______________________________________________________|")      
       (format t "~%~%tempo:~%~%")
       (format t "--> ")
  (with-open-file (str "C:/Users/asus/Documents/Log.dat"
                     :direction :output
                     :if-exists :supersede
                     :if-does-not-exist :create)
                (format str "Jogo ~%")
            )
  (let ((tempo (read))) 
    (cond ((not (numberp tempo)) (Tempo-Jogada TipoJogo)) ;; Verifica se esta a inserir um numero
          ((= tempo 0) (format t "Saindo...~%")) ;; Sai do jogo
          ((and (>= tempo 1) (<= tempo 20) (= TipoJogo 1)) (jogar-humano-pc (tabuleiro-inicial) 'humano (* 1000 tempo)))
          ((and (>= tempo 1) (<= tempo 20) (= TipoJogo 2)) (jogar-humano-pc (tabuleiro-inicial) 'pc (* 1000 tempo)))
          ((and (>= tempo 1) (<= tempo 20) (= TipoJogo 3)) (jogar-pc-pc (tabuleiro-inicial) (* 1000 tempo)))
          (t (format t "Opcao invalida!~%")(Tempo-Jogada TipoJogo)) ;; Se não inserir um numero entre 1 e 3 volta a pedir uma opção

    )
  ) 
)

(defun PrintDaMatriz(tabuleiro)
  "Funcao responsavel por mostrar ao utilizador a matriz com as ligacoes"
    (let ((horizontal (length (nth 0 tabuleiro))) (vertical (length (nth 1 tabuleiro)))) ;; Atribuicao de valores a variaveis
        (loop for x from 0 to (- horizontal 1) ;; Ciclo que percorre a matriz na horizontal
            do (loop for y from 0 to (- vertical 2) ;; Ciclo que percorre a matriz na vertical
                do 
                    (format t ".")
                     ;;verifica se existe ou nao uma ligacao para uma certa coordenada
                     ;;0 porque   na horizontal 
                    (cond ((= (nth y (nth x (nth 0 tabuleiro))) 0) (format t "  " ))
                          ((/= (nth y (nth x (nth 0 tabuleiro))) 0) (format t "--"))
                          (t t)) 
                )
                ;;Ponto final e muda de linha
                (format t ".")
                (terpri)
                (cond ((< x (- horizontal 1))
                (loop for y2 from 0 to (- vertical 1)
                do 
                     ;;verifica se existe ou nao uma ligacao para uma certa coordenada
                     ;;1 porque   na vertical
                     ;;aqui troca-se o x com o y pois existem 3 coordenadas com valores, mas como esta a ser percorrida
                     ;;na horizontal existem 4 espacos possiveis, por isso queremos a 1 posicao de cada coluna
                    (cond ((= (nth x (nth y2 (nth 1 tabuleiro))) 0) (format t " " ))
                          ((/= (nth x (nth y2 (nth 1 tabuleiro))) 0) (format t "|"))
                          (t t))
                          (format t "  ") 
                ))
                    (t (format t " " ))
                ) (terpri))
    )
)

(defun ver-quem-ganhou (estado)
  "Função que retorna o jogador que ganhou"
  (cond ((> (first (no-numero-de-caixas estado)) (second (no-numero-de-caixas estado))) "O Computador 1 ganhou")
        ((= (first (no-numero-de-caixas estado)) (second (no-numero-de-caixas estado))) "Ninguem ganhou")
        (t "O Computador 2 ganhou")
  )
)

(defun jogada-humano (estado tempo &optional (jogador *jogador1*) (inicial t))
  "Permite ao jogador humano jogar."
  (cond ((no-preenchidop estado) (PrintDaMatriz (no-estado estado))(printar-detalhes inicial)(ver-quem-ganhou estado))
        (T  (PrintDaMatriz (no-estado estado))
            (printar-detalhes inicial)
            (valores-iniciais (troca-jogador jogador))
            (let* ((linha nil) (coluna nil) (horientacao nil) (colocada nil))
              (format t "Jogada do Humano:")
              (terpri)
              (format t "Linha:" )
              (setq linha (read))
              (format t "Coluna:" )
              (setq coluna (read))
              (format t "Horientacao (vertical ou horizontal):" )
              (setq horientacao (read))
              (setq colocada (if (eq horientacao 'vertical) (tem-arco-vertical-T (1- coluna) (1- linha) (get-arcos-verticais (no-estado estado))) (tem-arco-horizontal-T (1- linha) (1- coluna) (get-arcos-horizontais (no-estado estado)))))
              (terpri)
              (cond ((not (null colocada)) (format t "Erro posicao incorreta !!!!!!!!!!!!!!")(terpri)(jogada-humano estado tempo jogador t))
                    ((eq colocada nil) 
                    (let* ((jogada (colocar-na-posicao (no-estado estado) horientacao jogador (list (1- coluna) (1- linha)))) 
                    (novo-estado (list jogada (cria-no-quadrados-fechados jogada (fn-numero-de-quadradodos estado) (no-numero-de-caixas estado) jogador) 0))
                    (joga-outra-vez (> (fn-numero-de-quadradodos novo-estado) (fn-numero-de-quadradodos estado))))
                                      (cond ((null novo-estado) (jogada-humano estado tempo jogador t))
                                            ((no-preenchidop novo-estado) (PrintDaMatriz (no-estado novo-estado))(ver-quem-ganhou estado))
                                            ((eq joga-outra-vez t) (jogada-humano novo-estado tempo jogador t))
                                            (t (jogada-computador novo-estado tempo (troca-jogador jogador) t)
                                               ;;(escreve-resultado estado (troca-jogador jogador) 20000)
                                               (jogada-humano *primeiro-estado* tempo jogador nil))
                                      )))
                    (t (jogada-humano estado jogador))
              )
            )
        )
  )
)

(defun jogar-humano-pc (estado ajogar tempo &optional (jogador *jogador1*) (inicial t))
  (cond ((eq ajogar 'humano) (jogada-humano estado tempo jogador inicial))
        ((eq ajogar 'pc) (jogada-computador estado tempo jogador inicial) (if (not (null *primeiro-estado*)) (jogada-humano *primeiro-estado* tempo (troca-jogador jogador) t) nil))
        (t nil)
  )
)



(defun jogar-pc-pc (estado tempo &optional (jogador *jogador1*) (inicial t))
  (jogada-computador estado tempo jogador inicial)
  (if (not (null *primeiro-estado*)) (jogar-pc-pc *primeiro-estado* tempo (troca-jogador jogador) nil) (progn (printar-detalhes inicial)(ver-quem-ganhou estado)))
)


(defun jogada-computador (estado tempo &optional (jogador *jogador1*) (inicial t))
  "Permite ao computador jogar."
  (terpri)
  (cond ((no-preenchidop estado) (setq *primeiro-estado* nil)(PrintDaMatriz (no-estado estado)))
        (t  (PrintDaMatriz (no-estado estado))
            (printar-detalhes inicial)
            (valores-iniciais jogador)
            (terpri)
            (format t "Jogada do Computador ~a" jogador)
            (with-open-file (str "C:/Users/asus/Documents/Log.dat"
                     :direction :output
                     :if-exists :append
                     :if-does-not-exist :create)
                (format str "Jogada do Computador ~a ~%" jogador)
            )
            (terpri)
            (AlfaBeta estado most-negative-fixnum most-positive-fixnum 4 tempo jogador)
            
            ;;(escreve-resultado estado jogador 20000)
        )
  ) 
)
