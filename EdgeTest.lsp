(DEFINE-FILE-INFO 	PACKAGE "INTERLISP"
					READTABLE "INTERLISP" BASE 10
)

(SETQ E1 (SEND Edge New))
(SEND E1 SetName 'E1)
(PutValue E1 'start_vertex A)
(PutValue E1 'end_vertex B)
(PutValue E1 'label 'E1)

(SETQ E2 (SEND Edge New))
(SEND E2 SetName 'E2)
(PutValue E2 'start_vertex A)
(PutValue E2 'end_vertex C)
(PutValue E2 'label 'E2)

(SETQ E3 (SEND Edge New))
(SEND E3 SetName 'E3)
(PutValue E3 'start_vertex A)
(PutValue E3 'end_vertex D)
(PutValue E3 'label 'E3)

(SETQ E4 (SEND Edge New))
(SEND E4 SetName 'E4)
(PutValue E4 'start_vertex B)
(PutValue E4 'end_vertex C)
(PutValue E4 'label 'E4)

(SETQ E5 (SEND Edge New))
(SEND E5 SetName 'E5)
(PutValue E5 'start_vertex B)
(PutValue E5 'end_vertex E)
(PutValue E5 'label 'E5)

(SETQ E6 (SEND Edge New))
(SEND E6 SetName 'E6)
(PutValue E6 'start_vertex C)
(PutValue E6 'end_vertex D)
(PutValue E6 'label 'E6)

(SETQ E7 (SEND Edge New))
(SEND E7 SetName 'E7)
(PutValue E7 'start_vertex C)
(PutValue E7 'end_vertex E)
(PutValue E7 'label 'E7)

(SETQ E8 (SEND Edge New))
(SEND E8 SetName 'E8)
(PutValue E8 'start_vertex C)
(PutValue E8 'end_vertex F)
(PutValue E8 'label 'E8)

(SETQ E9 (SEND Edge New))
(SEND E9 SetName 'E9)
(PutValue E9 'start_vertex D)
(PutValue E9 'end_vertex F)
(PutValue E9 'label 'E9)

(SETQ E10 (SEND Edge New))
(SEND E10 SetName 'E10)
(PutValue E10 'start_vertex E)
(PutValue E10 'end_vertex F)
(PutValue E10 'label 'E10)

(SETQ E11 (SEND Edge New))
(SEND E11 SetName 'E11)
(PutValue E11 'start_vertex E)
(PutValue E11 'end_vertex G)
(PutValue E11 'label 'E11)

(SETQ E12 (SEND Edge New))
(SEND E12 SetName 'E12)
(PutValue E12 'start_vertex F)
(PutValue E12 'end_vertex G)
(PutValue E12 'label 'E12)

STOP