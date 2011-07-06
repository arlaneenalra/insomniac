        
loop:
        read
        dup     
        out

        #\x eq
        not

        jnf loop

        "bye" out
        
        
        

