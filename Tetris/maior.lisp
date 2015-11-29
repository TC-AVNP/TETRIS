(load "utils.lisp")

;; Teste 19 E2 
;; procura A* num tabuleiro onde e possivel fazer 4 linhas com qualidade.
;deve retornar IGNORE
; (ignore-value (setf t1 (cria-tabuleiro)))
;deve retornar IGNORE
; (ignore-value (dotimes (linha 10) (dotimes (coluna 8) (tabuleiro-preenche! t1 linha coluna))))
;deve retornar uma lista de accoes (ver ficheiro output)

; (setf accs (procura-A* (make-problema :estado-inicial (make-estado :pontos 0 :tabuleiro t1 :pecas-colocadas () :pecas-por-colocar '(l j))
 ; :solucao #'solucao :accoes #'accoes :resultado #'resultado :custo-caminho #'qualidade) #'(lambda (x) 0)))
 ; (print accs)
 ; (setf estado (make-estado :pontos 0 :tabuleiro t1 :pecas-colocadas () :pecas-por-colocar '(l j)))
 ; (setf e1(resultado estado (cria-accao 8 peca-l2)))
 ; (desenha-estado e1)
 ; (setf acc (procura-pp (make-problema :estado-inicial (make-estado :pontos 0 :tabuleiro t1 :pecas-colocadas () :pecas-por-colocar '(l j)) 
; :solucao #'solucao :accoes #'accoes :resultado #'resultado :custo-caminho #'qualidade)))
 ; (executa-jogadas estado acc)
 
 
;;; Teste 13 E2
;;; procura profundidade primeiro num tabuleiro vazio, e num tabuleiro onde nao existe solucao
;deve retornar IGNORE
; (ignore-value (setf t1 (cria-tabuleiro)))
;deve retornar uma lista de accoes (ver ficheiro output)
; (procura-pp (make-problema :estado-inicial (make-estado :pontos 0 :tabuleiro t1 :pecas-colocadas () :pecas-por-colocar '(j l t o z s i)) :solucao #'solucao :accoes #'accoes :resultado #'resultado :custo-caminho #'(lambda (x) 0)))
;deve retornar IGNORE
; (print "yaaaaaaaaaaaaaa")
; (tabuleiro-preenche! t1 17 0)
;deve retornar NIL (nao existe solucao)
; (procura-pp (make-problema :estado-inicial (make-estado :pontos 0 :tabuleiro t1 :pecas-colocadas () :pecas-por-colocar '(j l t o z s i)) :solucao #'solucao :accoes #'accoes :resultado #'resultado :custo-caminho #'(lambda (x) 0)))

; (setf t1 (cria-tabuleiro))
; (dotimes (y 5)

; (dotimes (x 10)
	; (tabuleiro-preenche! t1 y x))	)
	
	
	

; (tabuleiro-preenche! t1 6 1)
	
; (setf e (make-estado :tabuleiro t1))
; (desenha-estado e)
; (tabuleiro-preenche! t1 8 1)(tabuleiro-preenche! t1 5 5)(tabuleiro-preenche! t1 5 6)(tabuleiro-preenche! t1 5 7)(tabuleiro-preenche! t1 5 0)
	; (print (heuristica-linhas t1))
	; (print (A-HEURISTICA-A-MELHOR-HEURISTICA e))
	
	;;; Teste 25 E2
;;; procura-best num tabuleiro com 4 jogadadas por fazer. Os grupos tem um tempo limitado para conseguir obter pelo menos 500 pontos. 
;;; deve retornar IGNORE
(ignore-value (setf a1 '#2A((T T T T NIL NIL T T T T)(T T T NIL NIL NIL T T T T)(T T T NIL NIL NIL T T T T)(T T T NIL NIL NIL T T T T)(NIL NIL NIL NIL NIL NIL NIL NIL NIL NIL)(NIL NIL NIL NIL NIL NIL NIL NIL NIL NIL)(NIL NIL NIL NIL NIL NIL NIL NIL NIL NIL)(NIL NIL NIL NIL NIL NIL NIL NIL NIL NIL)(NIL NIL NIL NIL NIL NIL NIL NIL NIL NIL)(NIL NIL NIL NIL NIL NIL NIL NIL NIL NIL)(NIL NIL NIL NIL NIL NIL NIL NIL NIL NIL)(NIL NIL NIL NIL NIL NIL NIL NIL NIL NIL)(NIL NIL NIL NIL NIL NIL NIL NIL NIL NIL)(NIL NIL NIL NIL NIL NIL NIL NIL NIL NIL)(NIL NIL NIL NIL NIL NIL NIL NIL NIL NIL)(NIL NIL NIL NIL NIL NIL NIL NIL NIL NIL)(NIL NIL NIL NIL NIL NIL NIL NIL NIL NIL)(NIL NIL NIL NIL NIL NIL NIL NIL NIL NIL))))
;;;deve retornar IGNORE
(ignore-value (setf r1 (procura-best a1 '(t i l l))))
;;;deve retornar T
(>= (executa-jogadas (make-estado :tabuleiro (array->tabuleiro a1) :pecas-por-colocar '(t i l l) :pontos 0 :pecas-colocadas '()) r1) 500)

	
	
