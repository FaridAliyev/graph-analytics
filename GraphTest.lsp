(DEFINE-FILE-INFO 	PACKAGE "INTERLISP"
					READTABLE "INTERLISP" BASE 10
)

(* ; "Create an instance of Graph")
(SETQ G1 (SEND Graph New))
(SEND G1 SetName 'G1)

(* ; "Add vertices to the graph")
(addVertex G1 A)
(addVertex G1 B)
(addVertex G1 C)
(addVertex G1 D)
(addVertex G1 E)
(addVertex G1 F)
(addVertex G1 G)

STOP