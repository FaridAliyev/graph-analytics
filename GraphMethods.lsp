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

(* ; "Breadth-first search algorithm")
(DEFINEQ
  (bfs
    (LAMBDA (graph start)
      (LET ((visited (LIST start))
            (queue (LIST (LIST start 0)))
            (distances (LIST (LIST start 0))))

        (WHILE queue
          (LET ((pair (CAR queue)))
            (SETQ queue (CDR queue))

            (LET ((node (CAR pair))
                  (dist (CADR pair)))

              (PRINT (LIST "Visiting:" node "Dist:" dist))

              (CL:DOLIST (neighbor (neighbors node))
                (COND ((NOT (MEMBER neighbor visited))
                       (SETQ visited (CONS neighbor visited))
                       (SETQ queue (APPEND queue (LIST (LIST neighbor (+ dist 1)))))
                       (SETQ distances (CONS (LIST neighbor (+ dist 1)) distances))
                       (PRINT (LIST "  Found neighbor:" neighbor "-> Distance:" (+ dist 1)))))))))

        distances
      )
    )
  )
)

(* ; "Find all shortest paths between all pairs of vertices in the graph")
(DEFINEQ
  (allPairsShortestPaths
    (LAMBDA (graph)
      (LET ((vertices (GetValue graph 'vertices))
            (result NIL))

        (CL:DOLIST (v vertices)
          (LET ((dists (bfs graph v)))
            (SETQ result (CONS (LIST v dists) result))))

        result
      )
    )
  )
)

(* ; "Find all shortest paths between two vertices in the graph")
(DEFINEQ
  (shortestPaths
    (LAMBDA (graph start end)
      (LET ((queue (LIST (LIST start)))
            (shortestPaths NIL)
            (visited NIL)
            (foundDistance NIL))

        (WHILE queue
          (LET ((path (CAR queue)))
            (SETQ queue (CDR queue))

            (LET ((node (CAR (LAST path))))
              (COND
                ((AND foundDistance (> (LENGTH path) foundDistance))
                 (SETQ queue NIL))

                ((EQUAL node end)
                 (COND
                   ((NULL foundDistance)
                    (SETQ foundDistance (LENGTH path)))
                   )
                 (SETQ shortestPaths (CONS path shortestPaths)))

                ((OR (NULL foundDistance) (< (LENGTH path) foundDistance))
                 (CL:DOLIST (neighbor (neighbors node))
                   (COND ((NOT (MEMBER neighbor path))
                          (SETQ queue (APPEND queue (LIST (APPEND path (LIST neighbor)))))))))))))

        shortestPaths
      )
    )
  )
)

(* ; "Compute the betweenness centrality of a vertex in the graph")
(DEFINEQ
  (betweenness
    (LAMBDA (graph vertex)
      (LET ((vertices (GetValue graph 'vertices))
            (totalPaths 0)
            (passingPaths 0))

        (CL:DOLIST (s vertices)
          (CL:DOLIST (t vertices)
            (COND
              ((AND (NOT (EQUAL s t))
                    (NOT (EQUAL s vertex))
                    (NOT (EQUAL t vertex)))
               (LET ((paths (shortestPaths graph s t)))

                 (SETQ totalPaths (+ totalPaths (LENGTH paths)))

                 (CL:DOLIST (path paths)
                   (COND
                     ((MEMBER vertex (CDR (CL:BUTLAST path)))
                      (SETQ passingPaths (+ passingPaths 1))))))))))

        (COND
          ((> totalPaths 0)
           (/ passingPaths totalPaths))
          (T 0)
        )
      )
    )
  )
)

(* ; "Compute the density of the graph (ratio of actual edges to maximum possible edges)")
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
      (LET ((allPairs (allPairsShortestPaths graph))
            (maxDist 0))

        (CL:DOLIST (entry allPairs)
          (LET ((distances (CADR entry)))
            (CL:DOLIST (pair distances)
              (LET ((d (CADR pair)))
                (COND ((> d maxDist)
                       (SETQ maxDist d)))))))

        maxDist
      )
    )
  )
)

(* ; "Check if the graph is connected (if all vertices have a path between them)") 
(DEFINEQ
  (isConnected
    (LAMBDA (graph)
      (LET ((vertices (GetValue graph 'vertices))
            (disconnected NIL))

        (CL:DOLIST (source vertices)
          (CL:DOLIST (target vertices)
            (COND
              ((AND (NOT (EQUAL source target))
                    (NULL (shortestPaths graph source target)))
               (PRINT (LIST "Disconnected pair found:" source target))
               (SETQ disconnected T)))))

        (COND (disconnected NIL)
              (T T))
      )
    )
  )
)

(* ; "Compute the closeness centrality of a vertex")
(DEFINEQ
  (closeness
    (LAMBDA (graph vertex)
      (LET ((allPairs (allPairsShortestPaths graph))
            (numVertices (LENGTH (GetValue graph 'vertices)))
            (totalDistance 0))

        (CL:DOLIST (entry allPairs)
          (LET ((v (CAR entry))
                (distances (CADR entry)))
            (COND
              ((EQUAL v vertex)
               (CL:DOLIST (pair distances)
                 (LET ((target (CAR pair))
                       (dist (CADR pair)))
                   (COND ((NOT (EQUAL vertex target))
                          (SETQ totalDistance (+ totalDistance dist))))))))))

        (COND
          ((> totalDistance 0)
           (/ (SUB1 numVertices) totalDistance))
          (T 0)
        )
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

(* ; "Computes the shortest path between the source and target vertices")
(DEFINEQ
    (shortestPath
        (LAMBDA (graph source target)
            (LET ((paths (shortestPaths graph source target))
                  (bestPath NIL)
                  (minLength 9999))

                (CL:DOLIST (p paths)
                    (LET ((len (LENGTH p)))
                        (COND ((< len minLength)
                               (SETQ minLength len)
                               (SETQ bestPath p)))))

                bestPath
            )
        )
    )
)

STOP