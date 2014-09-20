

;;; Check import
        ;; "src/libinsomniac_io/libinsomniac_io.so"
        "../build/src/libinsomniac_io/libinsomniac_io.dylib"
        import

bind_loop:

        ;; Pull out the first element of the alist
        dup car                 ; lib alist (s.f)
        swap                    ; lib (s.f) alist
        rot                     ; alist lib (s.f)

        call gen_closure
        bind

        cdr                     ; move to the next element in the alist
        dup
        ;; If the binding alist is empty
        ;; We're done
        ()
        eq
        
        jnf done
        
        jmp bind_loop

        ;; lib func -- closure
gen_closure:
        ;; Save the return value
        s" ret-val"
        bind

        dup cdr                 ; extract function from (s.f) ; alist lib (s.f) f
   
        ;; Bind function with space in name
        s" func"
        bind                    ; alist lib (s.f)

        swap                    ; bring library to the top
        dup                     ; make sure we keep a copy of the library
                                ; alist (s.f) lib lib
        
        ;; Bind library object with space in name
        s" lib"
        bind                    ; alist (s.f) lib

        rot                     ; lib alist (s.f)
        car                     ; lib alist symbol

        proc bound_closure      ; lib alist symbol proc

        swap                    ; lib alist proc symbol
        
        ;; Pop return value
        s" ret-val" @
        ret

bound_closure:
        ;; Save return value
        s" ret-val"
        bind

        s" lib" @                
        s" func" @
        call_ext
        

        ;; Pop return value
        s" ret-val" @
        ret

done:

        "Testing say"
        s"io-say" @ call_in
        
        s"io-hello-world" @ call_in
        out
        #\newline
        out
        
loop:
        out

        #\newline
        out

        depth

        0 >
        jnf loop

        #\newline
        out
        #\newline
        out

        "Done."
        out
        #\newline
        out


        #\newline
        out

