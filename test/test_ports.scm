;;;
;;; Some very crude port tests
;;;

(include "../lib/test/expect.scm")

(define test-file "test.file")

(define out-port (open-binary-output-file test-file))

(expect "Verify that a binary port can be written to"
    (lambda () (write-bytevector (bytevector 0 1 2 3 4 5 6 7 8 9) out-port))
    10)

(expect "Verify that a binary port can be written to"
    (lambda () (write-bytevector (bytevector 0 1 2 3 4 5 6 7 8 9) out-port 5))
    5)

(expect "Verify that the port is open for writing"
	(lambda () (output-port-open? out-port))
	#t)

(expect "Verify that the port is not an open input-port"
	(lambda () (input-port-open? out-port))
	#f)

(expect "Verify close port returns appropriately"
    (lambda () (close-port out-port))
    '())

(expect "Verify that the port is closed"
	(lambda () (output-port-open? out-port))
	#f)

(define in-port (open-binary-input-file test-file))

(expect "Verify that the port is open for input"
	(lambda () (input-port-open? in-port))
	#t)

(expect "Verify that the port is not and open output-port"
	(lambda () (output-port-open? in-port))
	#f)

(expect "Verify that a binary read port can be read from"
    (lambda () (read-bytevector 20 in-port))
    (bytevector 0 1 2 3 4 5 6 7 8 9 5 6 7 8 9))

(expect "Verify that we get an eof object after the end of the file"
    (lambda () (read-bytevector 15 in-port))
    (eof-object))

(expect "Verify close port returns appropriately on a input port"
    (lambda () (close-port in-port))
    '())

(expect "Verify that the port is closed"
	(lambda () (input-port-open? in-port))
	#f)

(define test-text-file "test.txt")

(define out-text-port (open-output-file test-text-file))

(expect "Check that textual-port? can identify a port"
    (lambda ()
        (textual-port? out-text-port))
    #t) 

(expect "Write data to the text file"
    (lambda ()
        (write-string "Testing" out-text-port))
    7)

(expect "Verify close port returns appropriately with a text port"
    (lambda () (close-port out-text-port))
    '())

(expect "Verify that the text port is closed"
	(lambda () (output-port-open? out-text-port))
	#f)

(define in-text-port (open-input-file test-text-file))

(expect "Verify that the text port is open"
	(lambda () (input-port-open? in-text-port))
	#t)

(expect "Check that data can be read from the data file"
    (lambda ()
        (read-string 5 in-text-port))
    "Testi")

(expect "Check that the rest of the data can be read from the data file"
    (lambda ()
        (read-string 5 in-text-port))
    "ng")

(expect "Check that an of is returned when nothing is left to return"
    (lambda ()
        (read-string 5 in-text-port))
    (eof-object))

(expect "Verify close port returns appropriately with a text input port"
    (lambda () (close-port in-text-port))
    '())

(expect "Verify that the text port is closed"
	(lambda () (input-port-open? in-port))
	#f)

;; Binary memory ports
(define memory-input-port
    (open-input-bytevector (bytevector 0 1 2 3 4 5)))

(expect "Verify that the bytevector input port is binary"
    (lambda ()
        (binary-port? memory-input-port))
    #t)

(expect "Read from the input port"
    (lambda ()
        (list
            (read-bytevector 2 memory-input-port)
            (read-bytevector 2 memory-input-port)
            (read-bytevector 2 memory-input-port)
            (read-bytevector 2 memory-input-port)))
    (list
        (eof-object)
        (bytevector 4 5)
        (bytevector 2 3)
        (bytevector 0 1)))

(expect "Write to an output port"
    (lambda ()
        (define out-port (open-output-bytevector))
       
        (list
            (get-output-bytevector out-port)
            (write-bytevector (bytevector 2 3) out-port)
            (write-bytevector (bytevector 1 2 3) out-port)))
    (list 
        (bytevector 1 2 3 2 3)
        2  
        3)) 




