;;;  Test to see if the type testing predicates work

        ;; fixnum
        "Fixnum" out
        #\newline out
        
        1 fixnum? out
        #\newline out

        #f fixnum? out
        #\newline out


        ;; bool
        "bool" out
        #\newline out
        
        #t bool? out
        #\newline out

        #\c bool? out
        #\newline out

        ;; pair
        "Pair" out
        #\newline out
        
        1 2 cons pair? out
        #\newline out 

        () pair? out
        #\newline out

        
        ;; String test
        "String" out
        #\newline out

        "string" string? out
        #\newline out

        34 string? out
        #\newline out

        ;; Symbol test
        "Symbol" out
        #\newline out

        s"string" symbol? out
        #\newline out

        "string" symbol? out
        #\newline out

        ;; Vector test
        "Vector" out
        #\newline out
        
        10 vector vector? out
        #\newline out

        #\d vector? out
        #\newline out 

        ;; null test
        "Null" out
        #\newline out
        
        () null? out
        #\newline out

        #\d null? out
        #\newline out 

        
        
