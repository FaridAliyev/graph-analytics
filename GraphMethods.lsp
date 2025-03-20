(DEFINE-FILE-INFO 	PACKAGE "INTERLISP"
					READTABLE "INTERLISP" BASE 10
)

(DEFINEQ
    (addVertex
        (LAMBDA (graph vertex)
            (PutValue graph 'vertices (CONS vertex (GetValue graph 'vertices)))
        )
    )
)

(DEFINEQ
    (removeVertex
        (LAMBDA (graph vertex)
            (PutValue graph 'vertices (REMOVE vertex (GetValue graph 'vertices)))
        )
    )
)

(DEFINEQ
    (shortestPaths
        (LAMBDA (graph start end)
            (PRINT (LIST "farids" graph start end))
            (LET ((queue (LIST (LIST start)))
                  (shortestPaths NIL)
                  (visited NIL))

                (WHILE queue
                    (LET ((path (CAR queue)))
                        (SETQ queue (CDR queue))

                        (LET ((node (CAR (LAST path))))
                            (PRINT (LIST "Processing node in shortestPaths:" node))

                            (COND
                                ((EQUAL node end)
                                 (PRINT "Reached Target!")
                                 (SETQ shortestPaths (CONS path shortestPaths)))

                                ((NOT (MEMBER node visited))
                                 (PROGN
                                    (SETQ visited (CONS node visited))
                                    (PRINT (LIST "farids" node))

                                    (CL:DOLIST (neighbor (neighbors node))
                                        (SETQ queue (CONS (APPEND path (LIST neighbor)) queue))))
                                 )
                            )
                        )
                    )
                )
                shortestPaths
            )
        )
    )
)

(DEFINEQ
    (betweenness
        (LAMBDA (graph vertex)
            (LET ((allVertices (GetValue graph 'vertices))
                  (totalPaths 0))
                (CL:DOLIST (source allVertices)
                    (CL:DOLIST (target allVertices)
                        (COND
                            ((AND (NOT (EQUAL source target))
                                  (NOT (EQUAL source vertex))
                                  (NOT (EQUAL target vertex)))
                                (PRINT (LIST "Calling shortestPaths on" source "to" target))
                                (LET ((paths (shortestPaths graph source target)))
                                    (SETQ totalPaths (+ totalPaths (LENGTH paths)))
                                    (PRINT (LIST "Paths from" source "to" target ":" paths))
                                )
                            )
                        )
                    )
                )
            )
        )
    )
)


STOP