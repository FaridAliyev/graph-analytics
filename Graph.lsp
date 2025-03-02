(DEFINE-FILE-INFO 	PACKAGE "INTERLISP"
					READTABLE "INTERLISP" BASE 10
)

(* ; "Class Graph")
(SETQ Graph (DefineClass 'Graph '(Class)))

(* ; "Add instance variables")
(PutCIVHere Graph 
            'vertices NIL 
            'doc "List of vertices in the graph.")

(PutCIVHere Graph 
            'edges NIL 
            'doc "List of edges in the graph.")

(* ; "Define methods")
(DefineMethod ($ Graph) 'add_vertex '(v)
  '(SETF (GETIV SELF 'vertices) (CONS v (GETIV SELF 'vertices))))

(DefineMethod ($ Graph) 'add_edge '(e)
  '(SETF (GETIV SELF 'edges) (CONS e (GETIV SELF 'edges))))

(DefineMethod ($ Graph) 'neighbors '(v)
  '(RETURN (MAPCAR #'(LAMBDA (e)
                        (IF (EQUAL (GETIV e 'start_vertex) v)
                            (GETIV e 'end_vertex)
                          NIL))
                   (GETIV SELF 'edges))))

(DefineMethod ($ Graph) 'delete_vertex '(v)
  '(SETF (GETIV SELF 'vertices) (DELETE v (GETIV SELF 'vertices))))

(DefineMethod ($ Graph) 'delete_edge '(e)
  '(SETF (GETIV SELF 'edges) (DELETE e (GETIV SELF 'edges))))

STOP
