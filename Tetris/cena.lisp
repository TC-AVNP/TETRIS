
; (block um
(let ((a 0))
	(block um
		(dotimes (x 5)
		(print a)	
			(block dois
				(dotimes (y 7)
					(if (= y 5)
						(return-from dois)
						(print y))
						(setf a y)))
			
			(if (= x 10) 
				(return-from um	))
				(print "ta feito"))))
	(print "yyyy")
			; (setf a (+ a 1)))
			
			; ((= a 5))
			; ((print a)))