(load "utils.fas")
;;;------------------------------------------------
;;;--------------------Accao-----------------------
;;;------------------------------------------------

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
	
	
	
	
;;;------------------------------------------------
;;;--------------------Tabuleiro-------------------
;;;------------------------------------------------	


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
;;;----------------TESTES-----------------------------------------------------	
;;(defvar t1 (cria-tabuleiro))   ;gera tabuleiro
;;(defvar t2 (copia-tabuleiro t1)) ;copia tabuleiro para t2
;;(print t1) 
;;(print "----------------------------------------------------")
;;(print t2);verifica que t2 e igual a t1
;;(print "++++++++++++++++++++++++++++++++++++++++++++++++++++")
;;(dotimes (i 10)   ;altera t1
;;(setf (aref t1 i i) 123))
;;(print t1);verifica que t1 foi alterado
;;(print "----------------------------------------------------")
;;(print t2);verifica que apesar de t1 ter sido alteraddo t2 mantem se igual
;;-----------------------------------------------------------------------------


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
;;;----------------TESTES-----------------------------------------------------	
;;(defvar t1 (cria-tabuleiro))  cria tabuleiro
;;(print (tabuleiro-preenchido-p t1 0 0))   verifica que esta vazia
;;(setf (aref t1 0 0) t)                    muda o valor verificado acima para preenchido
;;(print (tabuleiro-preenchido-p t1 0 0))   verifica que defacto esta preenchido
;;-----------------------------------------------------------------------------


;;;tabuleiro-altura-coluna: tabuleiro x inteiro -> inteiro
;;devolve a posicao da ultima peca numa dada coluna
(defun tabuleiro-altura-coluna (tabuleiro coluna)
	(let
		((linha 0))
	(dotimes (altura 18)
		(cond
			((eq t (aref tabuleiro altura coluna))
			(setf linha altura))))
	(if (> linha 0)(incf linha))
	linha))
;;;----------------TESTES-----------------------------------------------------	
;;
;; 
;; 
;; 
;;-----------------------------------------------------------------------------


;;;tabuleiro-linha-completa-p: tabuleiro x inteiro -> logico
;;verifica se uma linha esta completa
(defun tabuleiro-linha-completa-p(tabuleiro linha)
	(let
		((flag t))
		(dotimes (y 10)
		(cond
			((eq nil (aref tabuleiro linha y)) (setf flag nil))))
		flag))
;;;----------------TESTES-----------------------------------------------------	
;;
;; 
;; 
;; 
;;-----------------------------------------------------------------------------


;;;tabuleiro-preenche!: tabuleiro x inteiro x inteiro -> {}
;;recebe linha e coluna e preenche esse espaco
(defun tabuleiro-preenche!(tabuleiro linha coluna)
		(cond
			((and -
				(>= linha 0) (<= linha 17)
				(>= coluna 0) (<= coluna 9))
			(setf (aref tabuleiro linha coluna) t))));;tnao sei o que devolver
;;;----------------TESTES-----------------------------------------------------	
;;
;; 
;; 
;; 
;;-----------------------------------------------------------------------------


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
;;;----------------TESTES-----------------------------------------------------	
;;(defvar t1 (cria-tabuleiro))
;;(dotimes (x 10) (setf (aref t1 16 x) t))
;;(print t1)
;;(print "-----------------------------------------------------") 
;;(dotimes (x 10) (setf (aref t1 17 x) t))
;;(print t1)
;;(print "-----------------------------------------------------") 
;;(tabuleiro-remove-linha! t1 17)             ;verifica que apaga uma linha e a outra cai um nivel
;;(print t1)
;;-----------------------------------------------------------------------------		


;;;tabuleiro-topo-preenchido-p: tabuleiro -> logico
;;verifica se existe alguma peca no topo do tabuleiro
(defun tabuleiro-topo-preenchido-p(tabuleiro)
	(let (
		(flag nil))
	(dotimes (y 10)
		(cond
			((eq t (aref tabuleiro 17 y)) (setf flag t))))
	flag))
;;;----------------TESTES-----------------------------------------------------	
;;(defvar t1 (cria-tabuleiro))
;;(dotimes (x 10) (setf (aref t1 16 x) t))
;;(print (tabuleiro-topo-preenchido-p t1))
;;(setf (aref t1 17 4) t)
;;(print (tabuleiro-topo-preenchido-p t1))
;;-----------------------------------------------------------------------------


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
;;;----------------TESTES-----------------------------------------------------	
;;(defvar t1 (cria-tabuleiro))
;;(dotimes (x 10) (setf (aref t1 16 x) t))
;;(defvar t2 (copia-tabuleiro t1))
;;(print (tabuleiros-iguais-p t1 t2))   ;dois iguais
;;(setf (aref t2 17 4) t)  ;altera t2
;;(print (tabuleiros-iguais-p t1 t2))  ;verifica que sao diferentes
;;-----------------------------------------------------------------------------		


;;;tabuleiro->array: tabuleiro -> array
;;recebe tabuleiro devolve array
(defun tabuleiro->array(tabuleiro)
	(let(
		(arreio(make-array(list 18 10))))
	(dotimes (i (array-total-size tabuleiro))
		(setf (row-major-aref arreio i)(row-major-aref tabuleiro i)))
	arreio))
;;;----------------TESTES-----------------------------------------------------	
;;
;; 
;; 
;; 
;;-----------------------------------------------------------------------------	


;;;array->tabuleiro: array -> tabuleiro
;;recebe array devolve tabuleiro
(defun array->tabuleiro(arreio)
	(let (
		(tabuleiro(make-array(list 18 10))))
	(dotimes (i (array-total-size arreio))
		(setf (row-major-aref tabuleiro i)(row-major-aref arreio i)))
	tabuleiro))
;;;----------------TESTES-----------------------------------------------------	
;;
;; 
;; 
;; 
;;-----------------------------------------------------------------------------	



;;;------------------------------------------------
;;;--------------------Estado----------------------
;;;------------------------------------------------	


;;; estrutura do estado, representa o estado de um jogo de Tetris
(defstruct estado pontos pecas-por-colocar pecas-colocadas tabuleiro)

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

;;;---------------------TESTES-----------------------------------------------------------
;estados-iguais-p
;(setf array1 (make-array '(3 3) :initial-contents '((0 1 2 ) (3 4 5) (6 7 8))))		 
;(setf array2 (make-array '(3 3) :initial-contents '((2 2 2 ) (3 4 5) (6 7 8))))
;(setf e1 (make-estado :pontos 100 :pecas-por-colocar 100 :pecas-colocadas 10 :tabuleiro array1 ))
;(setf e2 (make-estado :pontos 100 :pecas-por-colocar 100 :pecas-colocadas 10 :tabuleiro array2 ))
;(print "TESTE ESTADOS IGUAIS:")
;(print (estados-iguais-p e1 e2))

;copia-estado
;(print "TESTE copia-estado:")
;(setf copia (copia-estado e1))
;(print copia)
;(setf (estado-pecas-por-colocar copia) 5)
;(print copia)
;(print e1) ;nao e alterado quando copia e alterado



;;;------------------------------------------------
;;;--------------------Problema-------------------
;;;------------------------------------------------	

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
;;que corresponde ao valor negativo dos pontos ganhos ate ao momento  
(defun qualidade (e1)
	(* -1 (estado-pontos e1)))

;;;resultado: estado x accao -> estado
;; recebe um estado e uma accao, devolve um novo estado que resulta de aplicar a accao
;; calcula pontos e remove linhas, quando aplicavel
(defun resultado (e1 a1)
	(let( 
		(e2 (copia-estado e1)) (coluna-esq (accao-coluna a1)) 		;novo estado para devolver no fim ;coluna mais a esquerda onde a peca ficara
		(peca (accao-peca a1)) (tab (estado-tabuleiro e1))			;desenho da peca (array) ;tabuleiro
		(linha-alta (tabuleiro-altura-coluna (estado-tabuleiro e1) (accao-coluna a1)))	;linha mais alta da coluna-esq
		(nr-linhas-peca (array-dimension (accao-peca a1) 0)) (nr-colunas-peca (array-dimension (accao-peca a1) 1))
		(altura 0) (ACERTA 0) (ACERTA2 0)							;comeca na altura minima
		(peca-colocada) (linhas-completas 0) (tab2))
		(setf tab2 (estado-tabuleiro e2))

	;;descobrir a primeira true da coluna da peca
	(dotimes (i nr-linhas-peca)
		(if 
			(eq t (aref tab i 0))
			(progn
				(setf ACERTA i)   ;;ACERTA e o valor correcto que se tem de adiciona para comecar
				(return))))
	;;descobrir onde a peca encaixa
	(block um
		(dotimes (x nr-linhas-peca)
				(setf altura (- (+ ACERTA2 linha-alta) ACERTA))
			(dotimes (y nr-colunas-peca)
				(if (and
						(eq t (aref peca x y)) 											;so da problema quando o sitio da peca e t num
						(eq t (tabuleiro-preenchido-p tab (- (+ x ACERTA2 linha-alta) ACERTA) coluna-esq)))	;lugar onde o tabuleiro tb e t	
					(progn
						(setf ACERTA2 (+ 1 ACERTA2))
						(return-from um))))))
	
	;;Colocar a peca no tabuleiro
	(dotimes (i nr-linhas-peca)
		(dotimes (j nr-colunas-peca)
			(tabuleiro-preenche! (estado-tabuleiro e2) (+ i altura) (+ j coluna-esq))))
	
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