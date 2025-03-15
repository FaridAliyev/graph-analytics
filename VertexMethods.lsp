(DEFINE-FILE-INFO 	PACKAGE "INTERLISP"
					READTABLE "INTERLISP" BASE 10
)

(DEFINEQ 
  (neighbors (LAMBDA (V)
	  (GetValue V 'connectedVertices)
  ))
)

(SETQ neighborsA (neighbors A))

(DEFINEQ 
  (degree (LAMBDA (V)
    (LENGTH (GetValue V 'connectedVertices))
  ))
)

STOP