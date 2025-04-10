(DEFINE-FILE-INFO 	PACKAGE "INTERLISP"
					READTABLE "INTERLISP" BASE 10
)

(SETQ E1 (SEND Edge New))
(SEND E1 SetName 'E1)
(PutValue E1 'from A)
(PutValue E1 'to B)
(PutValue E1 'label 'E1)

(SETQ E2 (SEND Edge New))
(SEND E2 SetName 'E2)
(PutValue E2 'from A)
(PutValue E2 'to C)
(PutValue E2 'label 'E2)

(SETQ E3 (SEND Edge New))
(SEND E3 SetName 'E3)
(PutValue E3 'from A)
(PutValue E3 'to D)
(PutValue E3 'label 'E3)

(SETQ E4 (SEND Edge New))
(SEND E4 SetName 'E4)
(PutValue E4 'from B)
(PutValue E4 'to C)
(PutValue E4 'label 'E4)

(SETQ E5 (SEND Edge New))
(SEND E5 SetName 'E5)
(PutValue E5 'from B)
(PutValue E5 'to E)
(PutValue E5 'label 'E5)

(SETQ E6 (SEND Edge New))
(SEND E6 SetName 'E6)
(PutValue E6 'from C)
(PutValue E6 'to D)
(PutValue E6 'label 'E6)

(SETQ E7 (SEND Edge New))
(SEND E7 SetName 'E7)
(PutValue E7 'from C)
(PutValue E7 'to E)
(PutValue E7 'label 'E7)

(SETQ E8 (SEND Edge New))
(SEND E8 SetName 'E8)
(PutValue E8 'from C)
(PutValue E8 'to F)
(PutValue E8 'label 'E8)

(SETQ E9 (SEND Edge New))
(SEND E9 SetName 'E9)
(PutValue E9 'from D)
(PutValue E9 'to F)
(PutValue E9 'label 'E9)

(SETQ E10 (SEND Edge New))
(SEND E10 SetName 'E10)
(PutValue E10 'from E)
(PutValue E10 'to F)
(PutValue E10 'label 'E10)

(SETQ E11 (SEND Edge New))
(SEND E11 SetName 'E11)
(PutValue E11 'from E)
(PutValue E11 'to G)
(PutValue E11 'label 'E11)

(SETQ E12 (SEND Edge New))
(SEND E12 SetName 'E12)
(PutValue E12 'from F)
(PutValue E12 'to G)
(PutValue E12 'label 'E12)

(SETQ E13 (SEND Edge New))
(SEND E13 SetName 'E13)
(PutValue E13 'from H)
(PutValue E13 'to I)
(PutValue E13 'label 'E13)

STOP