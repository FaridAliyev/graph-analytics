(DEFINE-FILE-INFO 	PACKAGE "INTERLISP"
					READTABLE "INTERLISP" BASE 10
)

(SETQ A (SEND Vertex New))
(SEND A SetName 'A)

(SETQ B (SEND Vertex New))
(SEND B SetName 'B)

(SETQ C (SEND Vertex New))
(SEND C SetName 'C)

(SETQ D (SEND Vertex New))
(SEND D SetName 'D)

(SETQ E (SEND Vertex New))
(SEND E SetName 'E)

(SETQ F (SEND Vertex New))
(SEND F SetName 'F)

(SETQ G (SEND Vertex New))
(SEND G SetName 'G)

(PutValue A 'id 1)
(PutValue A 'label 'A)
(PutValue A 'connectedVertices (LIST B C D))

(PutValue B 'id 2)
(PutValue B 'label 'B)
(PutValue B 'connectedVertices (LIST A C E))

(PutValue C 'id 3)
(PutValue C 'label 'C)
(PutValue C 'connectedVertices (LIST A B D E F))

(PutValue D 'id 4)
(PutValue D 'label 'D)
(PutValue D 'connectedVertices (LIST A C F))

(PutValue E 'id 5)
(PutValue E 'label 'E)
(PutValue E 'connectedVertices (LIST B C F G))

(PutValue F 'id 6)
(PutValue F 'label 'F)
(PutValue F 'connectedVertices (LIST C D E G))

(PutValue G 'id 7)
(PutValue G 'label 'G)
(PutValue G 'connectedVertices (LIST E F))

STOP