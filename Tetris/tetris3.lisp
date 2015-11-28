; Luis Pedro Condeco - 79712; Pedro Ferreira - 79120; Tomas Agostinho - 73548
; Grupo 91
;;;--------------------------------------------------------
;;;------------------------Accao---------------------------
;;;--------------------------------------------------------

;;;cria-accao: inteiro x array -> accao
;; devolve par inteiro arreio
(defun cria-accao(inteiro arreio)
	(cons inteiro arreio))
	
;;;accao-coluna: accao -> inteiro
;;recebe uma accao devolve o primeiro elemnto do tuplo (o inteiro)
(defun accao-coluna(accao)
	(car accao))
		
;;;accao-peca: accao -> array
;;recebe uma accao devolve o segundo elemento do tuplo(o arreio)
(defun accao-peca(accao)
	(cdr accao))
	
	
	
	
;;;--------------------------------------------------------
;;;------------------------Tabuleiro-----------------------
;;;--------------------------------------------------------	


;;;cria-tabuleiro: {} -> tabuleiro
;; cria um tabuleiro vazio,  um arreio bidimensional 18 10
(defun cria-tabuleiro()
	(make-array(list 18 10)))
	
	
;;;copia-tabuleiro: tabuleiro -> tabuleiro
;;recebe um tabuleiro e devolve um tabuleiro igual mas com outra referencia
(defun copia-tabuleiro(tabuleiro)
	(let
		((newtabuleiro (make-array (array-dimensions tabuleiro))))
	(dotimes (i (array-total-size tabuleiro))
		(setf (row-major-aref newtabuleiro i)
			  (row-major-aref tabuleiro i)))
	newtabuleiro))



;;;tabuleiro-preenchido-p: tabuleiro x inteiro x inteiro -> logico
;;verifica se uma posicao do tabuleiro esta preenchida ou nao
(defun tabuleiro-preenchido-p(tabuleiro linha coluna)
	(cond
		((and -
				(>= linha 0) (<= linha 17)
				(>= coluna 0) (<= coluna 9))
	(let
		((flag nil))
	(cond
		((eql t (aref tabuleiro linha coluna))
		(setf flag t)))
	flag))))



;;;tabuleiro-altura-coluna: tabuleiro x inteiro -> inteiro
;;devolve a posicao da ultima peca numa dada coluna
(defun tabuleiro-altura-coluna (tabuleiro coluna)
	(let
		((linha 0))
	(dotimes (altura 18)
		(cond
			((eq t (aref tabuleiro altura coluna))
				(setf linha (+ 1 altura)))))
	linha))


;;;tabuleiro-linha-completa-p: tabuleiro x inteiro -> logico
;;verifica se uma linha esta completa
(defun tabuleiro-linha-completa-p(tabuleiro linha)
	(let
		((flag t))
		(dotimes (y 10)
		(cond
			((eq nil (aref tabuleiro linha y)) (setf flag nil))))
		flag))



;;;tabuleiro-preenche!: tabuleiro x inteiro x inteiro -> {}
;;recebe linha e coluna e preenche esse espaco
(defun tabuleiro-preenche!(tabuleiro linha coluna)
		(cond
			((and -
				(>= linha 0) (<= linha 17)
				(>= coluna 0) (<= coluna 9))
			(setf (aref tabuleiro linha coluna) t))));;tnao sei o que devolver



;;;tabuleiro-remove-linha!: tabuleiro x inteiro -> {}
;;apaga uma linha apos esta estar completa
(defun tabuleiro-remove-linha!(tabuleiro linha)
	(if
		(< linha 17)
		(loop for i from linha to 16 do
			(dotimes (y 10)
				(setf (aref tabuleiro i y) (aref tabuleiro (1+ i) y)))))
	(dotimes (y 10)
		(setf (aref tabuleiro 17 y) nil)))



;;;tabuleiro-topo-preenchido-p: tabuleiro -> logico
;;verifica se existe alguma peca no topo do tabuleiro
(defun tabuleiro-topo-preenchido-p(tabuleiro)
	(let (
		(flag nil))
	(dotimes (y 10)
		(cond
			((eq t (aref tabuleiro 17 y)) (setf flag t))))
	flag))


;;;tabuleiros-iguais-p: tabuleiro x tabuleiro -> logico
;;verifica se dois tabuleiros sao iguais
(defun tabuleiros-iguais-p(t1 t2)
	(let (
		(flag))
	(setf flag t)
	(dotimes (i (array-total-size t1))
		(cond
			((not(eq (row-major-aref t1 i) (row-major-aref t2 i))) (setf flag nil))))
	flag))



;;;tabuleiro->array: tabuleiro -> array
;;recebe tabuleiro devolve array
(defun tabuleiro->array(tabuleiro)
	(let(
		(arreio(make-array(list 18 10))))
	(dotimes (i (array-total-size tabuleiro))
		(setf (row-major-aref arreio i)(row-major-aref tabuleiro i)))
	arreio))


;;;array->tabuleiro: array -> tabuleiro
;;recebe array devolve tabuleiro
(defun array->tabuleiro(arreio)
	(let (
		(tabuleiro(make-array(list 18 10))))
	(dotimes (i (array-total-size arreio))
		(setf (row-major-aref tabuleiro i)(row-major-aref arreio i)))
	tabuleiro))



;;;--------------------------------------------------------
;;;------------------------Estado--------------------------
;;;--------------------------------------------------------	


;;; estrutura do estado, representa o estado de um jogo de Tetris
(defstruct estado (pontos 0) pecas-por-colocar pecas-colocadas tabuleiro)

;;; copia-estado: estado -> estado
;;  recebe um estado e devolve um novo estado que e uma copia, independete do original
(defun copia-estado(e1)
	(let
		((copia (make-estado :pontos (estado-pontos e1)
                             :pecas-por-colocar (copy-list (estado-pecas-por-colocar e1))
                             :pecas-colocadas (copy-list (estado-pecas-colocadas e1)) 
                             :tabuleiro (copia-tabuleiro (estado-tabuleiro e1)))))
	copia))
	

;;;estados-iguais-p: estado x estado -> logico
;; Compara se dois estados sao iguais, t se positivo, nil caso contrario
(defun estados-iguais-p(e1 e2)
	(equalp e1 e2)) 

;;;estado-final-p: estado -> logico
;; recebe um estado e devolve o valor logico verdade se corresponder a um estado final onde o jogador ja nao possa fazer mais jogadas, falso caso contrario.	
(defun estado-final-p (e1)
	(cond
		((or 
			(every #'null (estado-pecas-por-colocar e1)) 
			(tabuleiro-topo-preenchido-p (estado-tabuleiro e1))) 
		t)
		(t nil)))



;;;--------------------------------------------------------
;;;------------------------Problema------------------------
;;;--------------------------------------------------------	

(defstruct problema estado-inicial solucao accoes resultado custo-caminho)

;;;solucao: estado ->logico
;;Recebe um estado, e devolve true se o estado recebido e solucao, e false c.c.
(defun solucao (e1)
	(let (
		(tab (estado-tabuleiro e1)))
	(cond 
		((and 
			(not 
				(tabuleiro-topo-preenchido-p tab)) 
			(every #'null (estado-pecas-por-colocar e1)))
		t)
		(t nil))))
		

;;;accoes: estado -> lista de accoes
;;
(defun accoes (e1)
	(if 
		(estado-final-p e1)
		(return-from accoes nil))
	(let(
		(peca (car (estado-pecas-por-colocar e1)))
		(lista nil)
		(jogadas (list )))
		(cond
			((eq 'i peca) (setf lista(list peca-i0 peca-i1)))
			((eq 'j peca) (setf lista(list peca-j0 peca-j1 peca-j2 peca-j3)))
			((eq 'l peca) (setf lista(list peca-l0 peca-l1 peca-l2 peca-l3)))
			((eq 'o peca) (setf lista(list peca-o0)))
			((eq 's peca) (setf lista(list peca-s0 peca-s1)))
			((eq 'z peca) (setf lista(list peca-z0 peca-z1)))
			((eq 't peca) (setf lista(list peca-t0 peca-t1 peca-t2 peca-t3))))
		(dolist (peca lista)
			(dotimes (coluna (- 11 (cadr (array-dimensions	peca))))
				(setf jogadas (append jogadas (list (cria-accao coluna peca))))))
			jogadas))
		 
	
	
		
;;;qualidade: estado -> inteiro
;; recebe um estado e retorna um valor de qualidade 
;; que corresponde ao valor negativo dos pontos ganhos ate ao momento  
(defun qualidade (e1)
	(* -1 (estado-pontos e1)))

	
;;;resultado: estado x accao -> estado
;; recebe um estado e uma accao, devolve um novo estado que resulta de aplicar a accao
;; calcula pontos e remove linhas, quando aplicavel
(defun resultado (e1 a1)
	(let((listalinha '())
		(e2 (copia-estado e1)) (coluna-esq (accao-coluna a1)) 		;novo estado para devolver no fim ;coluna mais a esquerda onde a peca ficara
		(peca (accao-peca a1)) (tab (estado-tabuleiro e1))			;desenho da peca (array) ;tabuleiro
		(linha-alta (tabuleiro-altura-coluna (estado-tabuleiro e1) (accao-coluna a1)))	;linha mais alta da coluna-esq
		(nr-linhas-peca (array-dimension (accao-peca a1) 0)) (nr-colunas-peca (array-dimension (accao-peca a1) 1))
		(altura 0) (ACERTA 0) (ACERTA2 0)							;comeca na altura minima
		(peca-colocada) (linhas-completas 0) (tab2))
		(setf tab2 (estado-tabuleiro e2))
	;;descobrir a primeira true da coluna da peca
(if (= linha-alta 0) (setf ACERTA 0)
(block amen
	(dotimes (i nr-linhas-peca)
		(if 
			(eq t (aref peca i 0))
			(progn
				(setf ACERTA i)   ;;ACERTA e o valor correcto que se tem de adiciona para comecar
				(return-from amen))))))
				
(dotimes (x nr-colunas-peca)																	;linha mais alta
				(push (tabuleiro-altura-coluna tab (+ x coluna-esq)) listalinha))
(setf linha-alta (max-list listalinha))


	;;descobrir onde a peca encaixa
	(block um
		(dotimes (xzy (- 18 linha-alta))
			(block dois
				(setf altura (- (+ ACERTA2 linha-alta) ACERTA))
			(dotimes (x nr-linhas-peca)
				(dotimes (y nr-colunas-peca)
					(if (and
							(eq t (aref peca x y)) 											;so da problema quando o sitio da peca e t num
							(eq t (tabuleiro-preenchido-p tab (+ x altura) (+ y coluna-esq))))	;lugar onde o tabuleiro tb e t	
						(progn
							(setf ACERTA2 (+ 1 ACERTA2))
							(return-from dois)))))
							(return-from um))))
		
	;;Colocar a peca no tabuleiro
	(dotimes (i nr-linhas-peca)
		(dotimes (j nr-colunas-peca)
			(if (aref peca i j)
				(tabuleiro-preenche! (estado-tabuleiro e2) (+ i altura) (+ j coluna-esq)))))
	
	;;Atualizar lista de pecas por colocar e lista pecas colocadas
	(setf peca-colocada (car (estado-pecas-por-colocar e2))) ;;nome da peca esta em 1 lugar na lista
	(push peca-colocada (estado-pecas-colocadas e2))	;por na lista de colocadas
	(pop (estado-pecas-por-colocar e2)) ;tirar da lista das pecas por colocar
	
	;;Verificar se topo fica preenchido, se nao calcular pontos
	(if (not(tabuleiro-topo-preenchido-p tab2))
		;;calcular numero de linhas feitas
		(progn 
			(loop for i from 17 downto 0 do  ; vai de cima para baixo para nao se preocupar com a descida das linhas
				(if 
					(tabuleiro-linha-completa-p tab2 i)
					(progn
						(tabuleiro-remove-linha! tab2 i)
						(incf linhas-completas))))
			(case linhas-completas
				(0 (setf (estado-pontos e2) (+ (estado-pontos e2) 0)))
				(1 (setf (estado-pontos e2) (+ (estado-pontos e2) 100)))
				(2 (setf (estado-pontos e2) (+ (estado-pontos e2) 300)))
				(3 (setf (estado-pontos e2) (+ (estado-pontos e2) 500)))
				(otherwise (setf (estado-pontos e2) (+ (estado-pontos e2) 800))))))
	e2))	
	
(defun custo-oportunidade (e1)
	(let(
		(pontos 0))
	(dolist (peca (estado-pecas-colocadas e1))
		(cond 
			((eq peca 'i) (setf pontos (+ pontos 800)))
			((or 
				(eq peca 'j)(eq peca 'l)) (setf pontos (+ pontos 500)))
			((or 
				(eq peca 's) (eq peca 'z)
				(eq peca 't)(eq peca 'o)) (setf pontos (+ pontos 300)))))
	(setf pontos (- pontos (estado-pontos e1)))
	pontos))
	
	
;;;estruturas nodes para as pesquisas----------------------------
(defstruct node estado pai accao)

(defun cria-node (estado pai accao)
  (make-node 
		:estado estado 
		:pai pai
		:accao accao))
		
;;;remove primeiro elemento de uma lista
(defun removeprimeiro (n list)
  (remove-if (constantly t) list :start (1- n) :count 1))
	
;;;funcoes misc
(defun max-list(lista)
	(let ((maximum (car lista))) 
	(dolist (x lista)
		 (if (> x maximum)
			(setf maximum x)))
	maximum))
;;-----------------------pesquisas----------------------------
(defun procura-pp (p)
	(let
		((noded (cria-node p nil (funcall (problema-accoes p) (problema-estado-inicial p))))
		(estado) (problematico)
		(accoessolucao '()))
(if (estado-final-p (problema-estado-inicial p)) 
	(return-from procura-pp nil))
		(loop do

			(if 
				(funcall (problema-solucao (node-estado noded)) (problema-estado-inicial (node-estado noded)))	;se for solucao
				(progn																							;percorre arvore para cima				

					(loop do


						(if
							(not (eq (car (node-accao noded)) nil))
							(push (car(last (node-accao noded))) accoessolucao))
						(setf noded (node-pai noded))
					while (not (eq noded nil)))
					(return-from procura-pp accoessolucao))											;depois do ciclo retorna a lista de accoes
					
				(progn

					(setf estado (funcall 													;estado gerado por o resultado da primeira accao da lista
									(problema-resultado (node-estado noded)) 
									(problema-estado-inicial (node-estado noded)) 
									(car (last (node-accao noded)))))


					(block blocosolucao
					(block bloqueio
						(if 
							(funcall (problema-solucao (node-estado noded)) estado)		;se for um estado solucao
							(progn

								(setf problematico (copy-problema (node-estado noded)))
								(setf (problema-estado-inicial problematico) (copia-estado estado))
								(setf noded 												;proximo no
									(cria-node
											problematico 
											(copy-node noded)
											nil))										;faz return e faz o ciclo
								(return-from blocosolucao)))							;para devolver a lista

								
						(if																
							(and (eq (node-accao noded) nil) (not (eq (node-pai noded) nil)))	;node morto
							(progn
								(setf noded (node-pai noded))
								(setf (node-accao noded) (reverse (cdr (reverse(node-accao noded)))))
								(return-from bloqueio)))
								
						(if
							(estado-final-p estado)									;estado final sem solucao
							(progn														
								(setf (node-accao noded) (reverse (cdr (reverse (node-accao noded)))))
								(return-from bloqueio)))                          	;so gera novo estado se nao for final sem solucao
								
						(setf problematico (copy-problema (node-estado noded)))
						(setf (problema-estado-inicial problematico) (copia-estado estado))

						(setf noded 												;proximo no
									(cria-node
											problematico 
											noded
											(funcall (problema-accoes (node-estado noded)) estado))))))) ;fim do block bloqueio ;blocosolucao				
		while (not(and (eq (node-accao noded) nil) (eq (node-pai noded) nil))))
		nil))
		
		

 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;ASTERISCO;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 
(defstruct node-A* estado accao g h custo pai)

(defun cria-node-A* (estado accao g h custo pai)
	(make-node-A*	:estado estado
					:accao accao
					:g g
					:h h
					:custo custo
					:pai pai))
					
					
(defun escolhe-novo-no (lista)
	(let( 
		(maximum (car lista)))
	(dolist (x lista)
		 (if 
			(<= (node-A*-custo x) (node-A*-custo maximum))
			(setf maximum x)))
	maximum))
	

(defun esta-contido(lista elem)
	(let( 
	(contido  nil))
	(dolist (x lista)
		 (if (equalp x elem)
			(setf contido t)))
	contido))
	
	
(defun constroi-caminho (n)
	(let 
		((lista '()) (node n))
		(loop do
			(push (node-A*-accao node) lista)
			(setf node (node-A*-pai node))
		while (not (eq node nil)))
	lista))

		
		
(defun procura-A* (p h)
	(let
		((opened '()) (closed '()) (solucao '())    																					;listas
		(novonode) (novoestado)																								   			;nos novos
		(fresultado (problema-resultado p)) (faccoes (problema-accoes p))
		(fcusto (problema-custo-caminho p)) (fsolucao (problema-solucao p))										 						;funcoes
		(noded (cria-node-A* 	(problema-estado-inicial p) 
								nil 
								(funcall (problema-custo-caminho p) (problema-estado-inicial p))
								(funcall h (problema-estado-inicial p)) 
								(+ (funcall (problema-custo-caminho p) (problema-estado-inicial p)) (funcall h (problema-estado-inicial p)))
								nil)))												;no a ser avaliado
		(if 
			(funcall fsolucao (node-A*-estado noded))
			(return-from procura-A* solucao))
				
		(push noded opened)
		(block soluxion
			(loop do
				(setf noded (escolhe-novo-no opened))												;escolhe no com custo menor
				(setf opened (remove noded opened))												;apaga o no da lista de abertos
				(push noded closed)																	;adiciona a lista dos fechados
				; (if
					; (funcall solution-node-A* noded)
					; (return-from soluxion))
;EXPANDIR NO
				(dolist (x (reverse (funcall faccoes (node-A*-estado noded))))   					;lista de accoes
						(setf novoestado (funcall fresultado (node-A*-estado noded) x))
						(setf novonode (cria-node-A* 
													novoestado x 
													(funcall fcusto novoestado) (funcall h novoestado) 
													(+ (funcall fcusto novoestado) (funcall h novoestado))  noded))
						(if
							(funcall fsolucao novoestado)
							(progn
								(setf noded novonode)
								(return-from soluxion)))
						
						(if 																		;verifica se pode adicionar o node aos abertos
							(and
								(not (eq (funcall faccoes (node-A*-estado novoestado)) nil))		;estado final sem solucao
								(not (esta-contido closed novonode)))								;existe na lista de fechados
							(push novonode opened)))												;adiciona no a lista de abertos
			
			while (not (eq opened nil))))															;fim do loop  lista opened vazia ;fecha o block soluxion
;CONSTROI A SOLUCAO
			(setf solucao (constroi-caminho noded))
		solucao))
		
	
	

	
	; (setf b 1994)
	; (setf a '(1 99 4 5 6 4 2))
	; (push b a)
	; (print a)
	; (setf b 333)
	; (push b a)
	; (print a)
	
	
	
	
	
	
		; ((my-hash (make-hash-table))
		; (opened) (closed)
		; (listaaccoes (funcall (problema-accoes p) (problema-estado-inicial p)))
		; (estado))
		
		; (setf estado (funcall (problema-resultado p) (problema-estado p) (car listaacoes)))
		; (setf (hasget 
		
		
		; ))
		
		; (setf a (make-array '(2 2)))
		; (print (car a))







		; (let ((a (make-estado))(my-hash (make-hash-table))) (setf (gethash 1 my-hash) "lool") (setf (gethash 2 my-hash) a)
		; (setf (gethash 10 my-hash) "a") (setf (gethash 5 my-hash) "b")
		; (print (gethash 1 my-hash))
		; (maphash #'(lambda(k v)(print k)) my-hash)))
		
		
	
	
; (print (procura-pp 3))
	
	
;;;;;;;;;;;;;;;;;;;;TESTES

; (compile-file "tetris3.lisp")
	
	
	
	
	
	
	
(load "utils.fas")