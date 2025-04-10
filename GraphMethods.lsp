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

              (COND (debug (PRINT (LIST "Visiting:" node "Dist:" dist))))

              (CL:DOLIST (neighbor (neighbors node))
                (COND ((NOT (MEMBER neighbor visited))
                       (SETQ visited (CONS neighbor visited))
                       (SETQ queue (APPEND queue (LIST (LIST neighbor (+ dist 1)))))
                       (SETQ distances (CONS (LIST neighbor (+ dist 1)) distances))
                       (COND (debug (PRINT (LIST "  Found neighbor:" neighbor "-> Distance:" (+ dist 1)))))))))))

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
           (FQUOTIENT passingPaths totalPaths))
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
                     (SETQ density (FQUOTIENT numEdges maxEdges)))
                    (T (SETQ density 0)))

                (COND (debug (PRINT (LIST "Graph Density:" density))))

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
               (COND (debug (PRINT (LIST "Disconnected pair found:" source target))))
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
           (FQUOTIENT (SUB1 numVertices) totalDistance))
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

                    (COND (debug (PRINT (LIST "Iteration" i "scores:" scores))))

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

(* ; "Finds connected components of a graph using BFS")
(DEFINEQ
  (clusters
    (LAMBDA (graph)
      (LET ((vertices (GetValue graph 'vertices))
            (unvisited (GetValue graph 'vertices))
            (components NIL))

        (WHILE unvisited
          (LET ((start (CAR unvisited))
                (component NIL)
                (queue (LIST (CAR unvisited))))

            (WHILE queue
              (LET ((v (CAR queue)))
                (SETQ queue (CDR queue))
                (COND ((NOT (MEMBER v component))
                       (SETQ component (CONS v component))
                       (SETQ unvisited (REMOVE v unvisited))
                       (CL:DOLIST (n (neighbors v))
                         (COND ((MEMBER n unvisited)
                                (SETQ queue (APPEND queue (LIST n))))))))))

            (SETQ components (CONS component components))))

        components
      )
    )
  )
)

(* ; "Computes the Minimum Spanning Tree (MST) of a graph using BFS")
(DEFINEQ
  (mst
    (LAMBDA (graph)
      (LET ((vertices (GetValue graph 'vertices))
            (visited NIL)
            (edges NIL)
            (queue NIL))

        (COND ((NULL vertices) NIL))

        (SETQ queue (LIST (CAR vertices)))
        (SETQ visited (LIST (CAR vertices)))

        (WHILE queue
          (LET ((v (CAR queue)))
            (SETQ queue (CDR queue))

            (CL:DOLIST (n (neighbors v))
              (COND ((NOT (MEMBER n visited))
                     (SETQ visited (CONS n visited))
                     (SETQ edges (CONS (LIST v n) edges))
                     (SETQ queue (APPEND queue (LIST n))))))))

        edges
      )
    )
  )
)

(* ; "Calculates the PageRank score for a vertex in a graph using an iterative algorithm")
(DEFINEQ
  (pageRank
    (LAMBDA (graph vertex)
      (LET ((vertices (GetValue graph 'vertices))
            (d 0.85)
            (iterations 10)
            (scores NIL)
            (newScores NIL)
            (i 0)
            (N (LENGTH (GetValue graph 'vertices))))

        (CL:DOLIST (v vertices)
          (SETQ scores (CONS (LIST v (/ 1.0 N)) scores)))

        (WHILE (< i iterations)
          (SETQ newScores NIL)

          (CL:DOLIST (v vertices)
            (LET ((neighbors (neighbors v))
                  (sum 0))

              (CL:DOLIST (n neighbors)
                (LET ((nPR (CADR (ASSOC n scores)))
                      (deg (LENGTH (neighbors n))))
                  (COND ((> deg 0)
                         (SETQ sum (FPLUS sum (/ nPR deg)))))))

              (SETQ newScores (CONS (LIST v (FPLUS (FQUOTIENT (FDIFFERENCE 1 d) N) (FTIMES d sum))) newScores))))

          (SETQ scores newScores)
          (SETQ i (+ i 1)))

        (CADR (ASSOC vertex scores))
      )
    )
  )
)

(* ; "Calculates the clustering coefficient of a vertex, measuring how tightly its neighbors are connected")
(DEFINEQ
  (clusteringCoefficient
    (LAMBDA (vertex)
      (LET ((neighborsV (neighbors vertex))
            (numLinks 0)
            (k 0))

        (SETQ k (LENGTH neighborsV))

        (CL:DOLIST (v1 neighborsV)
          (CL:DOLIST (v2 neighborsV)
            (COND ((AND (NOT (EQUAL v1 v2))
                        (MEMBER v2 (neighbors v1)))
                   (SETQ numLinks (ADD1 numLinks))))))

        (SETQ numLinks (FQUOTIENT numLinks 2))

        (COND
          ((AND (> k 1))
           (FQUOTIENT (FTIMES 2 numLinks) (FTIMES k (SUB1 k))))
          (T 0)
        )
      )
    )
  )
)

(* ; "Calculates the eccentricity of a vertex, measuring the longest shortest path to any other vertex")
(DEFINEQ
  (eccentricity
    (LAMBDA (graph vertex)
      (LET ((distances (bfs graph vertex))
            (maxDist 0))

        (CL:DOLIST (pair distances)
          (LET ((target (CAR pair))
                (d (CADR pair)))
            (COND
              ((NOT (EQUAL vertex target))
               (COND ((> d maxDist)
                      (SETQ maxDist d)))))))

        maxDist
      )
    )
  )
)

(* ; "Determines whether the graph can be divided into two distinct sets of vertices such that all edges connect vertices from different sets")
(DEFINEQ
  (isBipartite
    (LAMBDA (graph)
      (LET ((vertices (GetValue graph 'vertices))
            (colorMap NIL)
            (visited NIL)
            (queue NIL)
            (isBipartite T))

        (CL:DOLIST (start vertices)
          (COND
            ((NOT (MEMBER start visited))
             (SETQ queue (LIST start))
             (SETQ colorMap (CONS (LIST start 0) colorMap))

             (WHILE (AND queue isBipartite)
               (LET ((v (CAR queue)))
                 (SETQ queue (CDR queue))
                 (SETQ visited (CONS v visited))
                 (LET ((currentColor (CADR (ASSOC v colorMap))))

                   (CL:DOLIST (n (neighbors v))
                     (COND
                       ((NULL (ASSOC n colorMap))
                        (SETQ colorMap (CONS (LIST n (LOGXOR 1 currentColor)) colorMap))
                        (SETQ queue (APPEND queue (LIST n))))
                       ((= (CADR (ASSOC n colorMap)) currentColor)
                        (COND (debug (PRINT (LIST "Conflict found between:" v "and" n))))
                        (SETQ isBipartite NIL))))))))))

        isBipartite
      )
    )
  )
)

(* ; "Bron–Kerbosch recursive algorithm to find all maximal cliques in a graph")
(DEFINEQ
  (bronkerbosch
    (LAMBDA (R P X cliques)
      (COND
        ((AND (NULL P) (NULL X))
         (SETQ cliques (CONS R cliques)))

        (T
         (CL:DOLIST (v P)
           (LET ((Nv (neighbors v)))
             (SETQ cliques
                   (bronkerbosch
                    (CONS v R)
                    (intersection P Nv)
                    (intersection X Nv)
                    cliques))
             (SETQ P (REMOVE v P))
             (SETQ X (CONS v X))))))

      cliques
    )
  )
)

(* ; "Finds all maximal cliques in the given graph using Bron–Kerbosch algorithm")
(DEFINEQ
  (cliques
    (LAMBDA (graph)
      (LET ((vertices (GetValue graph 'vertices)))
        (bronkerbosch NIL vertices NIL NIL)
      )
    )
  )
)

(* ; "Computes the power centrality of a vertex in the graph")
(DEFINEQ
  (powerCentrality
    (LAMBDA (graph vertex)
      (LET ((vertices (GetValue graph 'vertices))
            (alpha 0.2)
            (beta 1.0)
            (iterations 4)
            (scores NIL)
            (newScores NIL)
            (i 0))

        (CL:DOLIST (v vertices)
          (SETQ scores (CONS (LIST v 1.0) scores)))

        (WHILE (< i iterations)
          (SETQ newScores NIL)

          (CL:DOLIST (v vertices)
            (LET ((sum 0))
              (CL:DOLIST (n (neighbors v))
                (SETQ sum (FPLUS sum (CADR (ASSOC n scores)))))
              (SETQ newScores (CONS (LIST v (FPLUS beta (FTIMES alpha sum))) newScores))))

          (SETQ scores newScores)
          (SETQ i (+ i 1)))

        (CADR (ASSOC vertex scores))
      )
    )
  )
)

(* ; "Finds the communities in the graph using the Label Propagation algorithm")
(DEFINEQ
  (communities
    (LAMBDA (graph)
      (LET ((vertices (GetValue graph 'vertices))
            (labels NIL)
            (iterations 10)
            (i 0))

        (CL:DOLIST (v vertices)
          (SETQ labels (CONS (LIST v v) labels)))

        (WHILE (< i iterations)
          (CL:DOLIST (v vertices)
            (LET ((neighborLabels NIL))

              (CL:DOLIST (n (neighbors v))
                (LET ((label (CADR (ASSOC n labels))))
                  (SETQ neighborLabels (CONS label neighborLabels))))

              (LET ((bestLabel NIL)
                    (bestCount 0))

                (CL:DOLIST (l neighborLabels)
                  (LET ((count 0))
                    (CL:DOLIST (x neighborLabels)
                      (COND ((EQUAL x l) (SETQ count (+ count 1)))))
                    (COND ((> count bestCount)
                           (SETQ bestCount count)
                           (SETQ bestLabel l)))))

                (CL:SETF (CADR (ASSOC v labels)) bestLabel))))

          (SETQ i (+ i 1)))

        (LET ((communities NIL))
          (CL:DOLIST (pair labels)
            (LET ((v (CAR pair))
                  (label (CADR pair)))
              (LET ((group (ASSOC label communities)))
                (COND
                  (group (CL:SETF (CDR group) (CONS v (CDR group))))
                  (T (SETQ communities (CONS (LIST label v) communities)))))))

        (LET ((result NIL))
          (CL:DOLIST (g communities)
            (SETQ result (CONS (CDR g) result)))
          result)
      )
    )
  )
))

(* ; "Computes the betweenness centrality of an edge in the graph")
(DEFINEQ
  (edgeBetweenness
    (LAMBDA (graph edge)
      (LET ((u (GetValue edge 'from))
            (v (GetValue edge 'to))
            (vertices (GetValue graph 'vertices))
            (totalPaths 0)
            (passingPaths 0))

        (CL:DOLIST (s vertices)
          (CL:DOLIST (t vertices)
            (COND
              ((NOT (EQUAL s t))
               (LET ((paths (shortestPaths graph s t)))
                 (SETQ totalPaths (+ totalPaths (LENGTH paths)))

                 (CL:DOLIST (path paths)
                   (LET ((i 0)
                         (found NIL))

                     (WHILE (< (+ i 1) (LENGTH path))
                       (LET ((a (getListElementAt i path))
                             (b (getListElementAt (+ i 1) path)))
                         (COND ((OR (AND (EQUAL a u) (EQUAL b v))
                                    (AND (EQUAL a v) (EQUAL b u)))
                                (SETQ found T))))
                       (SETQ i (+ i 1)))

                     (COND (found (SETQ passingPaths (+ passingPaths 1)))))))))))

        (COND ((> totalPaths 0)
               (FQUOTIENT passingPaths totalPaths))
              (T 0))
      )
    )
  )
)

(* ; "Finds all central nodes in the graph (vertices with minimum eccentricity)")
(DEFINEQ
  (centralNodes
    (LAMBDA (graph)
      (LET ((vertices (GetValue graph 'vertices))
            (eccentricities NIL)
            (minEccentricity NIL)
            (result NIL))

        (CL:DOLIST (v vertices)
          (LET ((e (eccentricity graph v)))
            (SETQ eccentricities (CONS (LIST v e) eccentricities))
            (COND
              ((OR (NULL minEccentricity) (< e minEccentricity))
               (SETQ minEccentricity e)))))

        (CL:DOLIST (pair eccentricities)
          (COND ((= (CADR pair) minEccentricity)
                 (SETQ result (CONS (CAR pair) result)))))

        result
      )
    )
  )
)

(* ; "Computes percolation centrality for a given vertex and percolation score p(v)")
(DEFINEQ
  (percolationCentrality
    (LAMBDA (graph vertex pValue)
      (LET ((vertices (GetValue graph 'vertices))
            (total 0))

        (CL:DOLIST (s vertices)
          (CL:DOLIST (t vertices)
            (COND
              ((AND (NOT (EQUAL s t))
                    (NOT (EQUAL s vertex))
                    (NOT (EQUAL t vertex)))

               (LET ((paths (shortestPaths graph s t))
                     (passing 0)
                     (totalPaths 0))

                 (SETQ totalPaths (LENGTH paths))

                 (CL:DOLIST (p paths)
                   (COND ((MEMBER vertex (CDR (CL:BUTLAST p)))
                          (SETQ passing (+ passing 1)))))

                 (COND ((> totalPaths 0)
                        (SETQ total (FPLUS total (FTIMES (FQUOTIENT passing totalPaths) pValue))))))))))

        total
      )
    )
  )
)

(* ; "Returns how many maximal cliques the given vertex belongs to")
(DEFINEQ
  (crossCliqueCentrality
    (LAMBDA (graph vertex)
      (LET ((cliqueList (cliques graph))
            (count 0))

        (CL:DOLIST (c cliqueList)
          (COND ((MEMBER vertex c)
                 (SETQ count (+ count 1)))))

        count
      )
    )
  )
)

(* ; "Computes Freeman degree centrality of the entire graph")
(DEFINEQ
  (freemanCentrality
    (LAMBDA (graph)
      (LET ((vertices (GetValue graph 'vertices))
            (degrees NIL)
            (maxDegree 0)
            (numerator 0)
            (n 0))

        (CL:DOLIST (v vertices)
          (LET ((deg (LENGTH (neighbors v))))
            (SETQ degrees (CONS deg degrees))
            (COND ((> deg maxDegree) (SETQ maxDegree deg)))))

        (CL:DOLIST (d degrees)
          (SETQ numerator (+ numerator (- maxDegree d))))

        (SETQ n (LENGTH vertices))

        (COND
          ((< n 3) 0)
          (T (FQUOTIENT numerator (FTIMES (SUB1 n) (- n 2)))))
      )
    )
  )
)

(* ; "Computes the average global efficiency of the graph based on shortest path distances")
(DEFINEQ
  (graphEfficiency
    (LAMBDA (graph)
      (LET ((vertices (GetValue graph 'vertices))
            (sum 0)
            (n (LENGTH (GetValue graph 'vertices))))

        (CL:DOLIST (i vertices)
          (CL:DOLIST (j vertices)
            (COND
              ((NOT (EQUAL i j))
               (LET ((paths (shortestPaths graph i j)))
                 (COND ((AND paths (> (LENGTH paths) 0))
                        (LET ((firstPath (CAR paths))
                              (length 0))
                          (SETQ length (- (LENGTH firstPath) 1))
                          (COND ((> length 0)
                                 (SETQ sum (+ sum (/ 1.0 length)))))))))))))

        (COND ((<= n 1) 0)
              (T (FQUOTIENT sum (FTIMES n (- n 1)))))
      )
    )
  )
)

(* ; "Computes contribution centrality of a vertex based on change in global efficiency")
(DEFINEQ
  (contributionCentrality
    (LAMBDA (graph vertex)
      (LET ((originalEfficiency (graphEfficiency graph))
            (modifiedGraph (SEND Graph New))
            (newEfficiency 0))

        (CL:DOLIST (v (GetValue graph 'vertices))
          (COND ((NOT (EQUAL v vertex))
                 (addVertex modifiedGraph v))))

        (CL:DOLIST (e (GetValue graph 'edges))
          (LET ((u (GetValue e 'from))
                (w (GetValue e 'to)))
            (COND ((AND (NOT (EQUAL u vertex)) (NOT (EQUAL w vertex)))
                   (addEdge modifiedGraph e)))))

        (SETQ newEfficiency (graphEfficiency modifiedGraph))

        (COND ((= originalEfficiency 0) 0)
              (T (/ (- originalEfficiency newEfficiency) originalEfficiency)))
      )
    )
  )
)

STOP