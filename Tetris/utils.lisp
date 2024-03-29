(load "tetris.lisp")

;;; definicao das configuracoes possiveis para cada peca
;;peca i 
(defconstant peca-i0 (make-array (list 4 1) :initial-element T))
(defconstant peca-i1 (make-array (list 1 4) :initial-element T))
;;peca l
(defconstant peca-l0 (make-array (list 3 2) :initial-contents '((T T)(T nil)(T nil))))
(defconstant peca-l1 (make-array (list 2 3) :initial-contents '((T nil nil)(T T T))))
(defconstant peca-l2 (make-array (list 3 2) :initial-contents '((nil T)(nil T)(T T))))
(defconstant peca-l3 (make-array (list 2 3) :initial-contents '((T T T)(nil nil T))))
;;peca j
(defconstant peca-j0 (make-array (list 3 2) :initial-contents '((T T)(nil T)(nil T))))
(defconstant peca-j1 (make-array (list 2 3) :initial-contents '((T T T)(T nil nil))))
(defconstant peca-j2 (make-array (list 3 2) :initial-contents '((T nil)(T nil)(T T))))
(defconstant peca-j3 (make-array (list 2 3) :initial-contents '((nil nil T)(T T T))))
;;peca o
(defconstant peca-o0 (make-array (list 2 2) :initial-element T))
;;peca s
(defconstant peca-s0 (make-array (list 2 3) :initial-contents '((T T nil)(nil T T))))
(defconstant peca-s1 (make-array (list 3 2) :initial-contents '((nil T)(T T)(T nil))))
;;peca z
(defconstant peca-z0 (make-array (list 2 3) :initial-contents '((nil T T)(T T nil))))
(defconstant peca-z1 (make-array (list 3 2) :initial-contents '((T nil)(T T)(nil T))))
;;peca t
(defconstant peca-t0 (make-array (list 2 3) :initial-contents '((T T T)(nil T nil))))
(defconstant peca-t1 (make-array (list 3 2) :initial-contents '((T nil)(T T)(T nil))))
(defconstant peca-t2 (make-array (list 2 3) :initial-contents '((nil T nil)(T T T))))
(defconstant peca-t3 (make-array (list 3 2) :initial-contents '((nil T)(T T)(nil T))))

;; acrescentei algumas funcoes auxiliares que vao dar jeito para testar automaticamente o codigo dos alunos
(defun ignore-value (x)
	(declare (ignore x))
	'ignore)

;;; random-element: list --> universal
;;; funcao que dada uma lista, devolve um elemento aleatorio dessa lista
;;; se a lista recebida for vazia, e devolvido nil
(defun random-element (list)
  (nth (random (length list)) list))

;;; random-pecas: inteiro --> lista
;;; funcao que recebe um inteiro que especifica o numero de pecas pretendidas, e devolve uma lista com
;;; pecas (representadas atraves de um simbolo) escolhidas aleatoriamente. O tamanho da lista devolvida corresponde
;;; ao inteiro recebido.
(defun random-pecas (n)
	(let ((lista-pecas nil))
		(dotimes (i n)
			(push (random-element (list 'i 'l 'j 'o 's 'z 't)) lista-pecas))
		lista-pecas))
		
;;; cria-tabuleiro-aleatorio: real (opcional) x real (opcional) --> tabuleiro
;;; funcao que recebe um valor real (entre 0 e 1) para a probabilidade a ser usada na primeira linha e outro real
;;; que representa o decrescimento de probabilidade de uma linha para a seguinte. Estes argumentos sao opcionais,
;;; e se nao forem especificados tem o valor por omissao de 1.0 (100%) e 0.05 (5%) respectivamente
;;; A funcao retorna um tabuleiro em que cada posicao foi preenchida de acordo com as probabilidades especificadas
;;; para cada linha. A linha inicial tera uma maior probabilidade, mas as linhas seguintes terao uma menor probabilidade
;;; de preenchimento, resultado em media mais posicoes preenchidas no fundo do tabuleiro do que no topo. 
(defun cria-tabuleiro-aleatorio (&optional (prob-inicial 1.0) (decaimento 0.05))
	(let ((tabuleiro (cria-tabuleiro))
		  (prob prob-inicial)
		  (coluna-a-evitar 0))
		(dotimes (linha 18)
			;;;precisamos de escolher sempre uma coluna para nao preencher, se nao podemos correr o risco de criarmos uma linha
			;;;completamente preenchida
			(setf coluna-a-evitar (random 10)) 
			(dotimes (coluna 10)
				(when (and (not (= coluna-a-evitar coluna)) (<= (random 1.0) prob)) (tabuleiro-preenche! tabuleiro linha coluna)))
			;;;nao podemos permitir valores negativos de probabilidade
			(setf prob (max 0 (- prob decaimento))))
		tabuleiro))
		
;;; executa-jogadas: estado x lista --> inteiro
;;; funcao que recebe um estado e uma lista de accoes e executa as accoes (pela ordem recebida) sobre o tabuleiro do estado inicial,
;;; desenhando no ecra os varios estados do tabuleiro. Para avancar entre ecras, o utilizador deve premir a tecla "Enter".
;;;	retorna o total de pontos obtidos pela sequencia de accoes no tabuleiro
(defun executa-jogadas (estado-inicial lista-accoes)
	(let ((estado estado-inicial))
		(do () ((or (estado-final-p estado) (null lista-accoes)))
			(desenha-estado estado)
			(read-char)
			(desenha-estado estado (first lista-accoes))
			(read-char)
			(setf estado (resultado estado (first lista-accoes)))
			(setf lista-accoes (rest lista-accoes)))
		(desenha-estado estado)
		(estado-pontos estado)))

;;; desenha-estado: estado x accao (opcional) --> {}
;;; funcao que recebe um estado (e pode receber opcionalmente uma accao) e desenha o estado do jogo de tetris no ecra
;;; se for recebida uma accao, entao essa accao contem a proxima jogada a ser feita, e deve ser desenhada na posicao correcta por cima 
;;; do tabuleiro de tetris. Esta funcao nao devolve nada.		
(defun desenha-estado (estado &optional (accao nil))
	(let ((tabuleiro (estado-tabuleiro estado)))
		(desenha-linha-exterior) (format T "  Proxima peca:~A~%" (first (estado-pecas-por-colocar estado))) 
		(do ((linha 3 (- linha 1))) ((< linha 0))
			(desenha-linha-accao accao linha) (format T "~%"))
		(desenha-linha-exterior) (format T "  Pontuacao:~A~%" (estado-pontos estado))
		(do ((linha 16 (- linha 1))) ((< linha 0))
			(desenha-linha tabuleiro linha) (format T "~%"))
		(desenha-linha-exterior)))

;;; desenha-linha-accao: accao x inteiro --> {}
;;; dada uma accao e um inteiro correspondente a uma linha que esta por cima do tabuleiro (linhas 18,19,20,21) desenha
;;; a linha tendo em conta que podera estar la a peca correspondente a proxima accao. Nao devolve nada.
(defun desenha-linha-accao (accao linha)
	(format T "| ")
	(dotimes (coluna 10)
		(format T "~A " (cond ((null accao) " ")
							  ((and (array-in-bounds-p (accao-peca accao) linha (- coluna (accao-coluna accao)))
									(aref (accao-peca accao) linha (- coluna (accao-coluna accao)))) "#")
							  (T " "))))
	(format T "|"))
	
;;; desenha-linha-exterior: {} --> {}
;;; funcao sem argumentos que desenha uma linha exterior do tabuleiro, i.e. a linha mais acima ou a linha mais abaixo
;;; estas linhas sao desenhadas de maneira diferente, pois utilizam um marcador diferente para melhor perceber 
;;; os limites verticais do tabuleiro de jogo
(defun desenha-linha-exterior ()
	(format T "+-")
	(dotimes (coluna 10)
		(format T "--"))
	(format T "+"))
	
;;; desenha-linha-vazia: {} --> {}
;;; funcao sem argumentos que desenha uma linha vazia. Nao devolve nada.
(defun desenha-linha-vazia ()
	(format T "| ")
	(dotimes (coluna 10)
		(format T "~A "))
	(format T "|"))
	
;;; desenha-linha: tabuleiro,inteiro --> {}
;;; esta funcao recebe um tabuleiro, e um inteiro especificando a linha a desenhar
;;; e desenha a linha no ecra, colocando o simbolo "#" por cada posicao preenchida, 
;;; e um espaco em branco por cada posicao nao preenchida. Nao devolve nada.
(defun desenha-linha (tabuleiro linha)
	(format T "| ")
	(dotimes (coluna 10)
		(format T "~A " (if (tabuleiro-preenchido-p tabuleiro linha coluna) "#" " ")))
	(format T "|"))			

			
;;exemplo muito simples de um tabuleiro com a primeira e segunda linha quase todas preenchidas
; (defvar t1 (cria-tabuleiro))
; (dotimes (coluna 9)
	; (tabuleiro-preenche! t1 0 coluna))
; (dotimes (coluna 9)
	; (tabuleiro-preenche! t1 1 coluna))
; (defvar e1 (make-estado :tabuleiro t1 :pecas-por-colocar '(i o j l t i)))
; (print (accoes e1))
 ; (setf a (cria-accao 9 peca-i0))
 ; (print a)
 ; (setf e2 (resultado e1 a))
 ; (print "--------------------------------")
 ; (setf e2 (resultado e1 a))
 ; (setf a1(cria-accao 9 peca-o0))
 
; (desenha-estado e2)
 ; (setf e3 (resultado e2 a1))

; (desenha-estado e3)
; (defvar p1
	; (make-problema :estado-inicial (make-estado :tabuleiro t1 :pecas-por-colocar '())
				   ; :solucao #'solucao
				   ; :accoes #'accoes
				   ; :resultado #'resultado
				   ; :custo-caminho #'custo-oportunidade))
				   
				   
				   
				   
; (setf estado1 (make-estado :pontos 0 :pecas-por-colocar '(t i j t z j) :pecas-colocadas '() :tabuleiro (cria-tabuleiro)))
; (desenha-estado estado1)
; (format t"~%......................................................~%")
; (setf estado2 (resultado estado1 '(0 . #2A((T T T)(NIL T NIL)))))
; (desenha-estado estado2)
; (setf estado2 (resultado estado2 '(1 . #2A((T)(T)(T)(T)))))
; (desenha-estado estado2)
										; (setf estado2 (resultado estado2 '(3 . #2A((NIL NIL T)(T T T)))))
										; (desenha-estado estado2)
										; (setf estado2 (resultado estado2 '(3 . #2A((NIL T NIL)(T T T)))))
										; (desenha-estado estado2)
										; (setf estado2 (resultado estado2 '(6 . #2A((NIL T T)(T T NIL)))))
										; (desenha-estado estado2)
; (setf estado2 (resultado estado2 '(0 . #2A((T T)(T T)))))
; (desenha-estado estado2)
; (setf estado2 (resultado estado2 '(6 . #2A((T T)(T T)))))
; (desenha-estado estado2)
; (setf estado2 (resultado estado2 '(4 . #2A((T T)(T T)))))
; (desenha-estado estado2)

											; (setf estado2 (resultado estado1 (cria-accao 1 peca-o0)))
											; (setf estado2 (resultado estado2 (cria-accao 1 peca-i0)))
											; (setf estado2 (resultado estado2 (cria-accao 0 peca-i1)))
											; (setf estado2 (resultado estado2 (cria-accao 3 peca-t3)))
											; (setf estado2 (resultado estado2 (cria-accao 5 peca-l1)))
											; (setf estado2 (resultado estado2 (cria-accao 5 peca-o0)))
											; (setf estado2 (resultado estado2 (cria-accao 7 peca-o0)))
											; (setf estado2 (resultado estado2 (cria-accao 8 peca-o0)))
											; (setf estado2 (resultado estado2 (cria-accao 6 peca-o0)))
											; (setf estado2 (resultado estado2 (cria-accao 5 peca-i0)))
											; (desenha-estado estado2)
											; (setf estado2 (resultado estado2 (cria-accao 6 peca-i1)))
											; (setf estado2 (resultado estado2 (cria-accao 6 peca-i0)))
											; (setf estado2 (resultado estado2 (cria-accao 6 peca-i0)))
											; (setf estado2 (resultado estado2 (cria-accao 6 peca-i1)))
											; (setf estado2 (resultado estado2 (cria-accao 6 peca-i1)))
											; (setf estado2 (resultado estado2 (cria-accao 6 peca-i1)))
											; (setf estado2 (resultado estado2 (cria-accao 6 peca-i0)))
											; (setf estado2 (resultado estado2 (cria-accao 6 peca-i0)))
; (desenha-estado estado2)
; (setf t1 (cria-tabuleiro))
; (setf (aref t1 0 0) t)
; (print(tabuleiro-altura-coluna t1 0))
; (setf (aref t1 0 1) t)
; (print(tabuleiro-altura-coluna t1 1))
; (setf (aref t1 1 1) t)
; (print t1)
; (print(tabuleiro-altura-coluna t1 1))



; (defvar t1 (cria-tabuleiro))
; (dotimes (coluna 9)
	; (tabuleiro-preenche! t1 16 coluna))
; (dotimes (coluna 9)
	; (tabuleiro-preenche! t1 1 coluna))
; (defvar e1 (make-estado :tabuleiro t1 :pecas-por-colocar '(i o j l t i)))

; (defvar p1
	; (make-problema :estado-inicial (make-estado :tabuleiro t1 :pecas-por-colocar '(i i))
				   ; :solucao #'solucao
				   ; :accoes #'accoes
				   ; :resultado #'resultado
				   ; :custo-caminho #'custo-oportunidade))
				   

			
; (print (problemaover p1))	
; (print (accoes e1))
; (desenha-estado (problema-estado-inicial p1))
; (print (cdr(funcall (problema-accoes p1) (problema-estado-inicial p1))))
; (print (problemaover p1))
; (setf p2 (copy-problema p1))
; (print (equalp p1 p2))
; (setf (problema-estado-inicial p1) 
						; (funcall 
							; (problema-resultado p1) (problema-estado-inicial p1) 
							; (car 
							; (funcall 
								; (problema-accoes p1) 
								; (problema-estado-inicial p1)))))
								; (print (problemaover p1))
; (print "aqui ->")(print (equalp p1 p2))
; (desenha-estado (problema-estado-inicial p1))
; (print (problema-estado-inicial p1))
; (print "yyyyyyyyyyyyyyyyyyyyyyy")
; (print (problemaover p1))
; (print "yyyyyyyyyyyyyyyyyyyyyyy")
; (setf (problema-estado-inicial p1) 
						; (funcall 
							; (problema-resultado p1) (problema-estado-inicial p1) 
							; (car 
							; (funcall 
								; (problema-accoes p1) 
								; (problema-estado-inicial p1)))))
								
; (print p1)
; (print p2)

		   
				   
				   
				   
				   
				   
				   
				   
				   
				   
				   
; (defvar p2 (copy-problema p1))
; (setf acs (funcall (problema-accoes p2) (problema-estado-inicial p2)))
; (setf accao (car acs))
; (setf estado (funcall (problema-resultado p1) (problema-estado-inicial p1) accao))

; (print p2)

; (setf (problema-estado-inicial p2) estado)
; (print "--------------------------------------------------------------------------------")
; (print p2)

; (print (equalp p1 p2))



; (defstruct ai ox)
; (defvar oi (make-ai :ox 3))
; (defvar aii (copy-ai oi))
; (print oi)
; (print aii)
; (print(equalp oi aii))
; (print "------------")
; (setf (ai-ox aii) 4)

; (print oi)
; (print aii)
; (print(equalp oi aii))





;;; testes


 ; (defvar t1 (cria-tabuleiro))
 ; (dotimes (x 17)
; (dotimes (coluna 9)
	; (tabuleiro-preenche! t1 x coluna)))

; (setf e1 (make-estado :tabuleiro t1 :pecas-por-colocar '(i)))
; (desenha-estado e1)
; (setf prob1 
	; (make-problema :estado-inicial (make-estado :tabuleiro t1 :pecas-por-colocar '(i i i o))
				   ; :solucao #'solucao
				   ; :accoes #'accoes
				   ; :resultado #'resultado
				   ; :custo-caminho #'custo-oportunidade))
				   
				   
				   
				   
	
	; (print (procura-pp prob1))

	
;;;;;;;;;;;;;;;;;;;



;;; Teste 14 E2 
;;; procura profundidade primeiro num tabuleiro com algumas pecas
;deve retornar IGNORE
; (ignore-value (setf t1 (cria-tabuleiro)))
; (ignore-value (dotimes (coluna 9) (tabuleiro-preenche! t1 0 (+ coluna 1))(tabuleiro-preenche! t1 1 (+ coluna 1))(tabuleiro-preenche! t1 2 (+ coluna 1))))
; deve retornar uma lista de accoes (ver ficheiro output)
; (print (procura-pp (make-problema :estado-inicial (make-estado :pontos 0 :tabuleiro t1 :pecas-colocadas () :pecas-por-colocar '(o o o o o l l t t j j i i)) :solucao #'solucao :accoes #'accoes :resultado #'resultado :custo-caminho #'(lambda (x) 0))))







; (setf t1 (cria-tabuleiro))
; (defvar e1 (make-estado :tabuleiro t1 :pecas-por-colocar '(i i i l t i)))
; (setf a1 (cria-accao 5 peca-i0))
; (setf e1 (resultado e1 a1))

; (setf a1 (cria-accao 4 peca-i0))
; (setf e1 (resultado e1 a1))

; (setf a1 (cria-accao 6 peca-i0))
; (setf e1 (resultado e1 a1))

; (setf a1 (cria-accao 6 peca-o0))
; (setf e1 (resultado e1 a1))

; (setf a1 (cria-accao 5 peca-i1))
; (setf e1 (resultado e1 a1))



; (setf a1 (cria-accao 2 peca-i1))
; (setf e1 (resultado e1 a1))
; (desenha-estado e1)


; (defun solution (p)
	; (if
		; (funcall (problema-solucao p) (problema-estado-inicial p))
		; t
		; nil))
		
		
		
		; (print "ola")
		; (print (solution p1))
