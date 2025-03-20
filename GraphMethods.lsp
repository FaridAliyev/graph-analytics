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
            (LET ((queue (LIST (LIST start)))
                  (shortestPaths NIL)
                  (visited NIL))

                (WHILE queue
                    (LET ((path (CAR queue)))
                        (SETQ queue (CDR queue))

                        (LET ((node (CAR (LAST path))))

                            (COND
                                ((EQUAL node end)
                                 (SETQ shortestPaths (CONS path shortestPaths)))

                                ((NOT (MEMBER node visited))
                                 (PROGN
                                    (SETQ visited (CONS node visited))

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
                  (totalPaths 0)
                  (passingPaths 0))

                (CL:DOLIST (source allVertices)
                    (CL:DOLIST (target allVertices)
                        (COND
                            ((AND (NOT (EQUAL source target))
                                  (NOT (EQUAL source vertex))
                                  (NOT (EQUAL target vertex)))
                                (LET ((paths (shortestPaths graph source target)))
                                    (SETQ totalPaths (+ totalPaths (LENGTH paths)))

                                    (CL:DOLIST (path paths)
                                        (COND 
                                            ((MEMBER vertex (CDR (CL:BUTLAST path)))
                                             (SETQ passingPaths (+ passingPaths 1)))
                                        )
                                    )
                                )
                            )
                        )
                    )
                )

                (COND
                    ((> totalPaths 0) (/ passingPaths totalPaths))
                    (T 0)
                )
            )
        )
    )
)


STOP