(DEFINE-FILE-INFO 	PACKAGE "INTERLISP"
					READTABLE "INTERLISP" BASE 10
)

(* ; "Class Graph")
(SETQ Graph (DefineClass 'Graph NIL ($ Class)))

(* ; "Add instance variables")
(PutCIVHere Graph 
            'vertices NIL 
            'doc "List of vertices in the graph.")

(PutCIVHere Graph 
            'edges NIL 
            'doc "List of edges in the graph.")

STOP
