;;;
;;; Some very crude port tests
;;;

(include "expect.scm")

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

