(in-package "CL-USER")
(load (current-pathname "defsys"))
(compile-system "NOBREACH-ENGINE" :load t :force t)
(in-package "NB")
(register-LLVM)
(LLVMLinkInInterpreter)

;;                   ; lib/ExecutionEngine/MCJIT/MCJIT.cpp
;; (LLVMLinkInMCJIT) ; only these types of arguments will work:
;;                   ;
;;                   ; (int, char**, char**)
;;                   ; (int, char**)
;;                   ; (int)
;;                   ; (void)

;; (LLVMInitializeNativeTarget)
;; (LLVMInitializeNativeAsmParser)
(defun 20? ()
  (multiple-value-bind (mod sum) (create-module)
    (let ((EE (LLVMCreateExecutionEngineForModule mod)))
      (print-bitcode mod)
      (let ((rv (LLVMRunFunction EE sum '(4 5))))
        (assert (= 9 (LLVMGenericValueToInt rv t) ))
        rv))))

;(20?)

