(defun Menu-Inicial ()
"Funcao que permite fornecer um menu inicial ao utilizador"
       (format t "~%           ______________________________________________________")      
       (format t "~%          |                                                      |")
       (format t "~%          |                    Dots and Boxes                    |")
       (format t "~%          |                      Feito por:                      |")            
       (format t "~%          |                     Andre Matias                     |")
       (format t "~%          |                    David Belchior                    |")
       (format t "~%          |                                                      |")
       (format t "~%          |                                                      |")
       (format t "~%          |            (Pressione 1 para Experiencias)           |")
       (format t "~%          |                (Pressione 2 para Sair)               |")
       (format t "~%          |______________________________________________________|")      
       (format t "~%~%Opcao:~%~%")
       (format t "--> ")
  (let ((opcao (read))) 
    (cond ((not (numberp opcao)) (Menu-Inicial)) ;; Verifica se esta a inserir um numero
          ((= opcao 1) (Experiencias)) ;; Vai para o Menu com os Problemas
          ((= opcao 2) (format t "Saindo...~%")) ;; Sai do jogo
          (t (format t "Opcao invalida!~%")(Menu-Inicial)) ;; Se não inserir um numero entre 1 e 2 volta a pedir uma opção
    )
  ) 
) 

(defun Experiencias ()
"Funcao que permite fornecer um menu com os algoritmos ao utilizador"
       (format t "~%           ______________________________________________________")      
       (format t "~%          |                                                      |")
       (format t "~%          |               Selecione um Algoritmo:                |")
       (format t "~%          |                                                      |")
       (format t "~%          |                (Pressione 1 para BFS)                |")
       (format t "~%          |                (Pressione 2 para DFS)                |")
       (format t "~%          |               (Pressione 3 para ASTAR)               |")
       (format t "~%          |                (Pressione 4 para Sair)               |")
       (format t "~%          |______________________________________________________|")      
       (format t "~%~%Opcao:~%~%")
       (format t "--> ")
  (let ((opcao (read))) 
    (cond ((not (numberp opcao)) (Menu-Inicial)) ;; Verifica se esta a inserir um numero
          ((= opcao 1) (nivel-algoritmo (diretoria) 'bfs)) 
          ((= opcao 2) (nivel-algoritmo (diretoria) 'dfs nil (fn-depth))) 
          ((= opcao 3) (nivel-algoritmo (diretoria) 'astar (fn-heuristica))) 
          ((= opcao 4) (format t "Saindo...~%")) ;; Sai do jogo
          (t (format t "Opcao invalida!~%")(Menu-Inicial)) ;; Se não inserir um numero entre 1 e 2 volta a pedir uma opção
    )
  ) 
)

;; aspas nao funcionam
(defun diretoria ()
"Funcao que permite ao utilizador escolher a diretoria onde se encontram os problemas"
      (format t "~% ~%") 
      (format t "~%           ______________________________________________________")
      (format t "~%          |                  Insira a Diretoria                  |")
      (format t "~%          |                                                      |")
      (format t "~%          |                                                      |")
      (format t "~%          |             Tenha atencao a / e as aspas             |")    
      (format t "~%          |                                                      |")
      (format t "~%          |______________________________________________________|")
      (format t "~%~%Diretoria:~%~%")
      (format t "--> ")
    (let ((diretoria (read))) ;; Le a diretoria
      diretoria
    )
)



(defun fn-depth ()
"Funcao que permite ao utilizador escolher a profundidade maxima"
      (format t "~% ~%") 
      (format t "~%           ______________________________________________________")
      (format t "~%          |             Insira a Profundidade maxima             |")
      (format t "~%          |                                                      |")
      (format t "~%          |                                                      |")
      (format t "~%          |                 Deve ser maior que 0                 |")    
      (format t "~%          |                                                      |")
      (format t "~%          |______________________________________________________|")
      (format t "~%~%Profundidade:~%~%")
      (format t "--> ")
    (let ((deph (read))) 
      (cond ((not (numberp deph)) nil) ;; Verifica se esta a inserir um numero
            ((< deph 1) nil) ;; Verifica se a profundidade é maior que 0
            (t deph) ;; Se for maior que 0 retorna a profundidade
      )
    ) 
)

(defun fn-heuristica ()
"Funcao que permite ao utilizador escolher a profundidade maxima"
      (format t "~% ~%") 
      (format t "~%           ______________________________________________________")
      (format t "~%          |            Insira a Heuristica pretendida            |")
      (format t "~%          |                                                      |")
      (format t "~%          |                                                      |")
      (format t "~%          |                        1-Dada                        |")
      (format t "~%          |                    2-Desenvolvida                    |")    
      (format t "~%          |                                                      |")
      (format t "~%          |______________________________________________________|")
      (format t "~%~%Opcao:~%~%")
      (format t "--> ")
    (let ((opcao (read))) 
      (cond ((not (numberp opcao)) 'heuristica) ;; Verifica se esta a inserir um numero
            ((= opcao 1) 'heuristica) 
            ((= opcao 2) 'nossa-heuristica) 
      )
    ) 
)


(defun LerFicheiro (diretoria)
"Funcao que recebe uma string com o nome de um ficheiro e retorna uma lista com o conteudo do ficheiro"
(let ((in (open diretoria :if-does-not-exist nil)) (str nil) ) ;; Atribuicao de valores a variaveis
        (loop for line = (read-line in nil) ;; le a linha
            while (not (equal line nil)) do ;; enquanto a linha nao for nula
                (setf str (append str (string-to-list line))) ;; adiciona a linha a variavel str
        )
        (close in) ;; fecha o ficheiro
        str ;; retorna a variavel str
   )
)

(defun problemas (tamanho &optional (problema 0) (ascii 65))
"Funcao que recebe o tamanho dos problemas e retorna os problemas existentes na diretoria"
  (cond ((= tamanho problema) (format t "~%          |                                                      |"))
        (t (format t "~%          |                     ~A-Problema ~A                     |" (+ problema 1) (code-char ascii)) ;; Imprime o problema
           (problemas tamanho (+ problema 1) (+ ascii 1)) ;; Chama a funcao novamente
    )
  )
  )


(defun nivel-algoritmo (direc algoritmo &optional (fn-heuristica nil) (depth nil))
"Funcao que permite ao utilizador escolher o nivel do problema"
  (cond ((null (LerFicheiro direc)) (format t "~%Opcao Invalida~%") (Menu-Inicial) )
  (t 
  (let ((nivelEscolhido 0) (tamanho (/ (length (LerFicheiro direc)) 3)) ) ;; Atribui a nivelEscolhido o valor 0
    (terpri) ;; Quebra de linha
      (format t "~%           ______________________________________________________")
      (format t "~%          |                  Escolha o Problema                  |")
      (format t "~%          |                                                      |")
      (format t "~%          |                    0-Menu-Inicial                    |")
      (problemas tamanho) ;; Imprime os problemas existentes na diretoria
      (format t "~%          |______________________________________________________|")
      (format t "~%~%Opcao:~%~%")
      (format t "--> ")
    (setf nivelEscolhido (parse-integer(read-line))) ;; Le o valor inserido
      (cond ((not (numberp nivelEscolhido)) (Menu-Inicial)) ;; Verifica se esta a inserir um numero
            ((= nivelEscolhido 0) (Menu-Inicial))
            ((or  (< nivelEscolhido 1) (> nivelEscolhido tamanho)) (format t "~%Opcao Invalida~%") (Menu-Inicial)) ;; Verifica se o numero inserido esta entre 1 e o numero de problemas que existem na diretoria
            (t  (escreve-resultado algoritmo (escolherNivel nivelEscolhido (LerFicheiro direc)) (objetivo nivelEscolhido (LerFicheiro direc)) fn-heuristica depth))) ;; Se o numero inserido estiver entre 1 e o numero de problemas que existem na diretoria, vai para a funcao jogada
    ) 
  )
  )
)

(defun escolherNivel (nivel lista) 
"Funcao que permite escolher um nivel a partir de uma lista de listas."
  (cond ((null lista) nil) ;; se a lista for vazia retorna nil
    ((or (not (listp (car lista))) (equal (car lista) '/)) (escolherNivel nivel (cdr lista))) ;; Se o primeiro elemento da lista for '/' igonora e passa para o proximo
    ((and (= nivel 1) (listp (car lista))) (car lista)) ;; Se o nivel for 1 retorna o primeiro elemento da lista
    (t (escolherNivel (- nivel 1) (cdr lista))) ;; Se o nivel for maior que 1, ignora o primeiro elemento e passa para o proximo
  )
)

(defun objetivo (nivel lista) 
"Funcao que permite escolher o objetivo de um nivel a partir de uma lista de listas."
  (cond ((null lista) nil) ;; se a lista for vazia retorna nil
      ((or (listp (car lista)) (equal (car lista) '/)) (objetivo nivel (cdr lista))) ;; Se o primeiro elemento da lista for '/' igonora e passa para o proximo
      ((and (= nivel 1) (numberp (car lista))) (car lista)) ;; Se o nivel for 1 retorna o primeiro elemento da lista
      (t (objetivo (- nivel 1) (cdr lista))) ;; Se o nivel for maior que 1, ignora o primeiro elemento e passa para o proximo
  )
)

(defun escreve-resultado (algoritmo tabuleiro objetivo &optional fn-heuristica depth)
  "Funcao que escreve o resultado no ficheiro solucao.txt"
    (with-open-file (str "D:/Downloads/solucao.txt"
                     :direction :output
                     :if-exists :supersede
                     :if-does-not-exist :create)
      (let ((resultado nil) (ini (get-internal-real-time)))
          (cond ((equal algoritmo 'bfs) (setf resultado (time (bfs (list tabuleiro '0 'nil) 'no-solucaop 'sucessores (operadores) objetivo))))
                ((equal algoritmo 'dfs) (setf resultado (time (dfs (list tabuleiro '0 'nil) 'no-solucaop 'sucessores (operadores) depth objetivo))))
                ((equal algoritmo 'astar) (setf resultado (time (astar (list tabuleiro 0 (funcall fn-heuristica tabuleiro objetivo) nil ) 'no-solucaop-astar 'sucessores (operadores) fn-heuristica objetivo))))
          )
        (let ((abertos (first resultado)) (n-fechados (second resultado)) (no-obj-val (third resultado)) )
        (format str "Tempo de execucao: ~a ms~%~%" (- (get-internal-real-time) ini))
        (format str "Penetrancia: ~a~%~%" (penetrancia abertos n-fechados no-obj-val))
        (format str "Factor de ramificacao: ~a~%~%" (branching-factor (- (length (caminho  no-obj-val)) 1) (numeroDeNosGerados n-fechados abertos)))
        (format str "Numero de nos gerados: ~a~%~%" (numeroDeNosGerados n-fechados abertos))
        (format str "Numero de nos expandidos: ~a~%~%" (numeroDeNosExpandidos n-fechados))
        (format str "Caminho: ~a~%~%" (caminho no-obj-val ))
        (format str "Solucao: ~a~%~%" no-obj-val) )
      )
    )
) 


 
(defun string-to-list (str)
"Funcao responsavel por converter uma string em uma lista"
  (if (not (streamp str)) ;; Verifica se o parâmetro e uma stream
    (string-to-list (make-string-input-stream str)) ;; Se não for, cria uma stream
    (if (listen str) ;; Verifica se a stream não está vazia
      (cons (read str) (string-to-list str)) ;; se nao estiver vazia, lê e converte para uma lista
      nil
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
                     ;;0 porque � na horizontal 
                    (cond ((= (nth y (nth x (nth 0 tabuleiro))) 0) (format t "  " ))
                          ((= (nth y (nth x (nth 0 tabuleiro))) 1) (format t "--"))
                          (t t)) 
                )
                ;;Ponto final e muda de linha
                (format t ".")
                (terpri)
                (cond ((< x (- horizontal 1))
                (loop for y2 from 0 to (- vertical 1)
                do 
                     ;;verifica se existe ou nao uma ligacao para uma certa coordenada
                     ;;1 porque � na vertical
                     ;;aqui troca-se o x com o y pois existem 3 coordenadas com valores, mas como esta a ser percorrida
                     ;;na horizontal existem 4 espacos possiveis, por isso queremos a 1 posicao de cada coluna
                    (cond ((= (nth x (nth y2 (nth 1 tabuleiro))) 0) (format t " " ))
                          ((= (nth x (nth y2 (nth 1 tabuleiro))) 1) (format t "|"))
                          (t t))
                          (format t "  ")
                ))
                    (t (format t " " ))
                ) (terpri))
    )
)


;; Funcoes para a 2 parte do trabalho

(defun Menu ()
"Funcao que permite fornecer um menu inicial ao utilizador"
  (format t "~%Selecione uma opcao:~%")
  (format t "1 para Jogar~%")
  (format t "2 para Sair~%")
  (format t "Opcao:~%~%")
  (format t "--> ")
  (let ((opcao (read))) 
    (cond ((not (numberp opcao)) (Menu)) ;; Verifica se esta a inserir um numero
          ((= opcao 1) (Problemas-Iniciais)) ;; Vai para o Menu com os Problemas
          ((= opcao 2) (format t "Saindo...~%")) ;; Sai do jogo
          (t (format t "Opcao invalida!~%")(Menu)) ;; Se não inserir um numero entre 1 e 2 volta a pedir uma opção
    )
  ) 
) 

(defun Problemas-Iniciais ()
"Funcao que permite fornecer um menu ao utilizador com opcoes"
  (let ((opcao 0) (diretoria nil)) ;; Atribui a opcao o valor 0 e diretoria o valor nil
    (format t "~%Problemas:~%")
    (format t "1 para voltar ao menu inicial~%")
    (format t "2 para Sair~%")
    (format t "3 para inserir uma diretoria~%")
    (format t "Selecione uma opcao:~%~%")
    (format t "--> ")
    (setf opcao(read))
    (cond ((not(numberp opcao)) (Problemas-Iniciais))
          ((= opcao 1) (Menu)) ;; Volta para o Menu Inicial 
          ((= opcao 2) (format t "~%Saindo...~%")) ;; Sai do jogo
          ((= opcao 3)  (format t "~%Insira a diretoria onde se encontram os problemas com aspas incluidas~%") (terpri) (format t "--> ") (setf diretoria(read)) (terpri) (nivel diretoria)(terpri)) ;; Pede para inserir a diretoria onde se encontram os problemas
          (t (format t "Opcao invalida!~%")(Problemas-Iniciais))
     )      
    )
)

(defun nivel (direc)
"Funcao que permite ao utilizador escolher o nivel do problema"
  (let ((nivelEscolhido 0)) ;; Atribui a nivelEscolhido o valor 0
  (cond ((null (LerFicheiro direc)) (format t "~%Opcao Invalida~%") (Problemas-Iniciais) )
    (t 
    (terpri) ;; Quebra de linha
    (format t "Insira um valor entre 1 e ~a~%~%" (/ (length (LerFicheiro direc)) 2))  ;; Pede para inserir um valor entre 1 e o numero de problemas que existem na diretoria
    (format t "--> ")
    (setf nivelEscolhido (parse-integer(read-line))) ;; Le o valor inserido
      (cond ((not (numberp nivelEscolhido)) (Problemas-Iniciais)) ;; Verifica se esta a inserir um numero
            ((or (< nivelEscolhido 1) (> nivelEscolhido (/ (length (LerFicheiro direc)) 2))) (format t "~%Opcao Invalida~%") (Problemas-Iniciais)) ;; Verifica se o numero inserido esta entre 1 e o numero de problemas que existem na diretoria
            (t  (jogada (escolherNivel nivelEscolhido (LerFicheiro direc))))) ;; Se o numero inserido estiver entre 1 e o numero de problemas que existem na diretoria, vai para a funcao jogada
    ) 
  )
  )
)

(defun jogada (tabuleiro)
"Funcao que recebe um tabuleiro e permite ao utilizador jogar."
  (let ((posicao nil) (eixo "") (lista tabuleiro)) ;; variaveis locais
     (loop while (not (string-equal eixo "Sair"))  do ;; loop que permite ao utilizador jogar ate que ele decida sair
         (terpri)
         (PrintDaMatriz lista) ;; imprime o tabuleiro
         (format t "~%Indique em que eixo pretende jogar: v para vertical e h para horizontal~%") ;; imprime as opcoes para escolher horizontal ou vertical
         (format t "~%Se pretender sair escreva <Sair> ~%~%") ;; imprime as opcoes
         (format t "--> ")
         (setf eixo (read-line)) ;; le o eixo
         (terpri)
         (cond ((numberp eixo) (progn (format t "~%Opcao Invalida~%")(setf eixo ""))) ;; Se escrever um numero na orientacao da opcao invalida
               ((string-equal eixo "Sair") (format t "A sair....~%")) ;; Se escrever sai sai do jogo
               ((and (not (string-equal eixo "v")) (not (string-equal eixo "h"))) (format t "~%Opcao Invalida, tera de escolher h de horizontal ou v de vertical~%") ) ;; Se escrever qualquer coisa que nao seja h ou v da opcao invalida
               (t (format t "Insira uma posicao para jogar Ex: 1 1 (linha coluna)~%~%") ;; Se escrever h ou v pede a posicao
                  (format t "--> ")
                  (setf posicao (string-to-list (read-line))) ;; le a posicao
                  (cond ((/= (length posicao) 2) (format t "~%Opcao Invalida~%") ) ;;Se nao escolher um nivel possivel da opcao invalida
                        ((not (numberp (car posicao))) (format t "~%Opcao Invalida~%") ) ;;Se a primeira cordenada nao for um numero da opcao invalida
                        ((not (numberp (cadr posicao))) (format t "~%Opcao Invalida~%") ) ;;Se a segunda cordenada nao for um numero da opcao invalida
                        (t (setf posicao (list (- (car posicao) 1) (- (cadr posicao)1)))) ;;Se for tudo certo coloca a cordenada do utilizado no formato certo
                  )
                  (cond 
                    ((string-equal eixo "h") 
                        (cond ((equal (tem-arco-horizontal (car posicao) (cadr posicao) lista ) t) (format t "~%Ja existe um arco na posicao ~a ~a no eixo ~a~%" (+ (car posicao) 1) (+ (cadr posicao) 1) eixo))
                              ((and (>= (car posicao) 0) (<= (car posicao) (length (car (get-arcos-horizontais tabuleiro)))) (>= (cadr posicao) 0) (<= (cadr posicao) (length (cdr (get-arcos-horizontais tabuleiro))))) (setf lista (devolveSubstituido lista posicao eixo))))) ;;Se for horizontal e a cordenada for valida substitui o valor das cordenadas
                    ((string-equal eixo "v") 
                        (cond ((equal (tem-arco-vertical (car posicao) (cadr posicao) lista ) t) (format t "~%Ja existe um arco na posicao ~a ~a no eixo ~a~%" (car posicao) (cadr posicao) eixo))
                              ((and (>= (car posicao) 0) (<= (car posicao) (length (car (get-arcos-verticais tabuleiro)))) (>= (cadr posicao) 0) (<= (cadr posicao) (length (cdr (get-arcos-verticais tabuleiro))))) (setf lista (devolveSubstituido lista posicao eixo))))) ;;Se for vertical e a cordenada for valida substitui o valor das cordenadas
                    (t (format t "~%Opcao Invalida~%")) ;;Se nao for nem vertical nem horizontal da opcao invalida
                 )))
      )
  )
)

