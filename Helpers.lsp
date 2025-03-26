(DEFINE-FILE-INFO 	PACKAGE "INTERLISP"
					READTABLE "INTERLISP" BASE 10
)

(* ; "Prints each clique in a readable format. Use it with the 'cliques' function (e.g. (printCliques (cliques graph)))")
(DEFINEQ
  (printCliques
    (LAMBDA (cliqueList)
      (CL:DOLIST (clique cliqueList)
        (PRINT (CONS "Clique:" clique)))
      'DONE
    )
  )
)

(* ; "Returns the element at the specified index in the list. If the index is out of bounds, it returns NIL.")
(DEFINEQ
  (getListElementAt
    (LAMBDA (n lst)
      (COND
        ((OR (NULL lst) (< n 0)) NIL)
        ((= n 0) (CAR lst))
        (T (getListElementAt (- n 1) (CDR lst)))))
  )
)

STOP