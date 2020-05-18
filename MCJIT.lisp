;; -*- Mode: lisp; Author: ysz; -*-

;; Copyright (c) 2016 Nobreach Inc. All rights reserved.

(in-package "NB")
(defvar *llvm-mcjit* #+:linux "/opt/llvm-trunk/lib/libLLVMMCJIT.so")
;(fli:register-module 'llvm-mcjit :real-name *llvm-mcjit*)
(fli:define-foreign-function (LLVMLinkInMCJIT "LLVMLinkInMCJIT") () :module 'llvm-mcjit);???
;(fli:define-foreign-function (XXXLLVMInitializeNativeTarget "LLVMInitializeNativeTarget")
;    () :result-type LLVMBool :module 'llvm)
