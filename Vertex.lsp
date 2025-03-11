(DEFINE-FILE-INFO 	PACKAGE "INTERLISP"
					READTABLE "INTERLISP" BASE 10
)

(* ; "Class Vertex")
(SETQ Vertex (DefineClass 'Vertex NIL ($ Class)))

(* ; "Add instance variables")
(PutCIVHere Vertex
            'id NIL
            'doc "Unique identifier for the vertex.")

(PutCIVHere Vertex 
            'label NIL 
            'doc "Label of the vertex.")

(PutCIVHere Vertex 
            'connectedVertices NIL 
            'doc "List of the vertices that this vertex is connected to.")

STOP
