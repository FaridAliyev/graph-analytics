(DEFINE-FILE-INFO 	PACKAGE "INTERLISP"
					READTABLE "INTERLISP" BASE 10
)

(* ; "Class Vertex")
(SETQ Vertex (DefineClass 'Vertex '(Class)))

(* ; "Add instance variables")
(PutCIVHere Vertex
            'id NIL
            'doc "Unique identifier for the vertex.")

(PutCIVHere Vertex 
            'label NIL 
            'doc "Label of the vertex.")

STOP