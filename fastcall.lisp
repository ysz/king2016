;; -*- Mode: lisp; Author: ysz; -*-

;; Copyright (c) 2016 Nobreach Inc. All rights reserved.

(in-package "NB")

(defun register-LLVM ()
  (fli:register-module 'llvm :real-name *llvm-c*)
  (fli:register-module 'llvm-analysis :real-name *llvm-analysis*)
;  (fli:register-module 'llvm-mcjit :real-name *llvm-mcjit*)
  (fli:register-module 'llvm-execution-engine :real-name *llvm-execution-engine*)
  (fli:register-module 'llvm-interpreter :real-name *llvm-interpreter*)
;  (fli:register-module 'llvm-x86-info :real-name *llvm-x86-info*)
;  (fli:register-module 'llvm-x86-code-gen :real-name *llvm-x86-code-gen*)
;  (fli:register-module 'llvm-x86-desc :real-name *llvm-x86-desc*)
  (fli:register-module 'llvm-bit-writer :real-name *llvm-bit-writer*)
  
  (values))

;;; https://llvm.org/svn/llvm-project/llvm/trunk/examples/HowToUseJIT/HowToUseJIT.cpp

(defun create-function (Name ReturnType args
                                        &key mod-Name )
  (let* ((mod (LLVMModuleCreateWithName mod-Name))
         (ret-type (LLVMFunctionType ReturnType args nil)))
    (values (LLVMAddFunction mod Name ret-type) mod)))

(defun create-module ()
  (multiple-value-bind (sum mod)
      (create-function "sum" (LLVMInt32Type) `(,(LLVMInt32Type) ,(LLVMInt32Type)) 
                                           :mod-Name "my_module" )
    (let* ((entry (LLVMAppendBasicBlock sum "entry"))
           (builder (LLVMCreateBuilder))
           )
      (LLVMPositionBuilderAtEnd builder entry)
      (let ((tmp (LLVMBuildAdd builder (LLVMGetParam sum 0) (LLVMGetParam sum 1) "tmp")))
        (LLVMBuildRet builder tmp)
        (values mod sum)
        ))))
    
;(LLVMVerifyModule )



