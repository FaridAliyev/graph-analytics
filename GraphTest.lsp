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

(* ; "Add edges to the graph")
(addEdge G1 E1)
(addEdge G1 E2)
(addEdge G1 E3)
(addEdge G1 E4)
(addEdge G1 E5)
(addEdge G1 E6)
(addEdge G1 E7)
(addEdge G1 E8)
(addEdge G1 E9)
(addEdge G1 E10)
(addEdge G1 E11)
(addEdge G1 E12)

STOP