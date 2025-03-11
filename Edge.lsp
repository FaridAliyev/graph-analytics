(DEFINE-FILE-INFO 	PACKAGE "INTERLISP"
					READTABLE "INTERLISP" BASE 10
)

(* ; "Class Edge")
(SETQ Edge (DefineClass 'Edge NIL ($ Class)))

(* ; "Add instance variables")
(PutCIVHere Edge 
            'start_vertex NIL 
            'doc "Starting vertex of the edge.")

(PutCIVHere Edge 
            'end_vertex NIL 
            'doc "Ending vertex of the edge.")

(PutCIVHere Edge 
            'label NIL 
            'doc "Label of the edge.")

STOP