(DEFINE-FILE-INFO 	PACKAGE "INTERLISP"
					READTABLE "INTERLISP" BASE 10
)

(* ; "Add a vertex to the graph")
(DEFINEQ
    (addVertex
        (LAMBDA (graph vertex)
            (PutValue graph 'vertices (CONS vertex (GetValue graph 'vertices)))
        )
    )
)

(* ; "Remove a vertex from the graph")
(DEFINEQ
    (removeVertex
        (LAMBDA (graph vertex)
            (PutValue graph 'vertices (REMOVE vertex (GetValue graph 'vertices)))
        )
    )
)

(* ; "Add an edge to the graph")
(DEFINEQ
    (addEdge
        (LAMBDA (graph edge)
            (PutValue graph 'edges (CONS edge (GetValue graph 'edges)))
        )
    )
)

(* ; "Remove an edge from the graph")
(DEFINEQ
    (removeEdge
        (LAMBDA (graph edge)
            (PutValue graph 'edges (REMOVE edge (GetValue graph 'edges)))
        )
    )
)

(* ; "Find all shortest paths between two vertices in the graph")
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

(* ; "Compute the betweenness centrality of a vertex in the graph")
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
                                    (SETQ totalPaths (IPLUS totalPaths (LENGTH paths)))

                                    (CL:DOLIST (path paths)
                                        (COND 
                                            ((MEMBER vertex (CDR (CL:BUTLAST path)))
                                             (SETQ passingPaths (ADD1 passingPaths)))
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

(* ; "Compute the density of the graph")
(DEFINEQ
    (density
        (LAMBDA (graph)
            (LET ((vertices (GetValue graph 'vertices))
                  (edges (GetValue graph 'edges))
                  (numVertices 0)
                  (numEdges 0)
                  (maxEdges 0)
                  (density 0))

                (SETQ numVertices (LENGTH vertices))
                (SETQ numEdges (LENGTH edges))

                (SETQ maxEdges (IQUOTIENT (ITIMES numVertices (SUB1 numVertices)) 2))

                (COND
                    ((> maxEdges 0) 
                     (SETQ density (/ numEdges maxEdges)))
                    (T (SETQ density 0)))

                (PRINT (LIST "Graph Density:" density))

                density
            )
        )
    )
)

(* ; "Compute the diameter of the graph (longest shortest path)")
(DEFINEQ
    (diameter
        (LAMBDA (graph)
            (LET ((vertices (GetValue graph 'vertices))
                  (maxShortestPath 0))

                (CL:DOLIST (source vertices)
                    (CL:DOLIST (target vertices)
                        (COND
                            ((NOT (EQUAL source target))
                             (LET ((paths (shortestPaths graph source target)))
                                (COND 
                                    ((AND paths (LENGTH paths))
                                     (LET ((pathLength (LENGTH (CAR paths))))
                                         (COND 
                                             ((> pathLength maxShortestPath)
                                              (SETQ maxShortestPath pathLength)))))))))))

                maxShortestPath
            )
        )
    )
)

(* ; "Check if the graph is connected (if all vertices have a path between them)") 
(DEFINEQ
    (isConnected
        (LAMBDA (graph)
            (LET ((vertices (GetValue graph 'vertices)))

                (CL:DOLIST (source vertices)
                    (CL:DOLIST (target vertices)
                        (COND
                            ((NOT (EQUAL source target))
                             (LET ((paths (shortestPaths graph source target)))

                                (COND
                                    ((NULL paths)
                                     (PRINT (LIST "Disconnected pair found:" source target))
                                     (RETURN NIL))))))))

                T
            )
        )
    )
)

(* ; "Compute the closeness centrality of a vertex")
(DEFINEQ
    (closeness
        (LAMBDA (graph vertex)
            (LET ((vertices (GetValue graph 'vertices))
                  (numVertices 0)
                  (totalDistance 0)
                  (closenessScore 0))

                (SETQ numVertices (LENGTH vertices))

                (CL:DOLIST (target vertices)
                    (COND
                        ((NOT (EQUAL vertex target))
                         (LET ((paths (shortestPaths graph vertex target)))

                            (COND
                                ((AND paths (LENGTH paths))
                                 (LET ((pathLength (LENGTH (CAR paths))))
                                     (SETQ totalDistance (+ totalDistance pathLength)))))))))

                (COND
                    ((> totalDistance 0) 
                     (SETQ closenessScore (/ (SUB1 numVertices) totalDistance)))
                    (T (SETQ closenessScore 0)))

                (PRINT (LIST "Closeness centrality for" vertex ":" closenessScore))

                closenessScore
            )
        )
    )
)

(* ; "Compute the eigenvector centrality of a vertex")
(DEFINEQ
    (eigenvectorCentrality
        (LAMBDA (graph vertex)
            (LET ((vertices (GetValue graph 'vertices))
                (scores NIL)
                (newScores NIL)
                (iterations 10)
                (i 0))

                (CL:DOLIST (v vertices)
                    (SETQ scores (CONS (LIST v 1.0) scores)))


                (PROG NIL
                    LOOP
                    (COND ((>= i iterations) (RETURN NIL)))

                    (SETQ newScores NIL)

                    (LET ((totalSum 0))
                        
                        (CL:DOLIST (v vertices)
                            (LET ((neighbors (neighbors v))
                                  (sum 0))

                                (CL:DOLIST (neighbor neighbors)
                                    (SETQ sum (+ sum (CADR (ASSOC neighbor scores)))))

                                
                                (SETQ totalSum (+ totalSum sum))

                                
                                (SETQ newScores (CONS (LIST v sum) newScores))))

                        (COND 
                            ((> totalSum 0)
                             (LET ((normalizedScores NIL))
                                 (CL:DOLIST (s newScores)
                                     (SETQ normalizedScores 
                                           (CONS (LIST (CAR s) (/ (CADR s) totalSum)) normalizedScores)))
                                 (SETQ newScores normalizedScores)))))

                    (SETQ scores newScores)

                    (PRINT (LIST "Iteration" i "scores:" scores))

                    (SETQ i (+ i 1))

                    (GO LOOP))

                (CADR (ASSOC vertex scores))
            )
        )
    )
)

STOP