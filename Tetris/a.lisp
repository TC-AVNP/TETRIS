
(struct node-A* estado accao custo pai)

(defun cria-node-A* (estado accao custo pai)
	(make-node-A*	:estado estado
					:accao accao
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

; (defun solution (p)
	; (if
		; (funcall (problema-solucao p) (problema-estado-inicial p))
		; t
		; nil))

; (defun solution-node-A* (n)
	; (if
		; (solution (node-A*-estado n))
		; t
		; nil))
		
		
		
(defun procura-A* (p h)
	(let
		((opened '()) (closed '()) (solucao '())    																					;listas
		(novonode) (novoestado)																								   				;nos novos
		(fresultado (problema-resultado p)) (faccoes (problema-accoes p))
		(fcusto (problema-custo-caminho p)) (fsolucao (problema-solucao))										 							;funcoes
		(noded (cria-node-A* (problema-estado-inicial p) nil (funcall (problema-custo-caminho p) (problema-estado-inicial p)) nil)))	;no a ser avaliado

		(if 
			(funcall fsolucao (node-A*-estado noded))
			(return-from procura-A* solucao))
				
		(push noded opened)
		(block soluxion
			(loop do
				(setf noded (escolhe-novo-no opened))												;escolhe no com custo menor
				(setf opended (remove noded opened))												;apaga o no da lista de abertos
				(push noded closed)																	;adiciona a lista dos fechados
				; (if
					; (funcall solution-node-A* noded)
					; (return-from soluxion))
;EXPANDIR NO
				(dolist (x (reverse (funcall actions (node-A*-estado noded))))   												;lista de accoes
						(setf novoestado (funcall resultado (node-A*-estado noded)) x)
						(setf novonode (cria-node-A* novoestado x (funcall custo novoestado) noded))
						(if
							(funcall fsolucao novoestado)
							(progn
								(setf noded novonode)
								(return-from soluxion)))
						
						(if 																	;verifica se pode adicionar o node aos abertos
							(and
								(not (eq (funcall actions (node-A*-estado novoestado)) nil))	;estado final sem solucao
								(not (esta-contido closed novonode)))							;existe na lista de fechados
							(push novonode opened)))											;adiciona no a lista de abertos
			
			while (not (eq opened nil))))									;fim do loop  lista opened vazia ;fecha o block soluxion
;CONSTROI A SOLUCAO
			(setf solucao (constroi-caminho noded))
		solucao))
		
		
		
		
		
		
		

		




		
		
		