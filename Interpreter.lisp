;; -*- Mode: lisp; Author: ysz; -*-

;; Copyright (c) 2016 Nobreach Inc. All rights reserved.

(in-package "NB")
(defvar *llvm-interpreter* #+:linux "/opt/llvm-trunk/lib/libLLVMInterpreter.so")
(fli:define-foreign-function (LLVMLinkInInterpreter "LLVMLinkInInterpreter")
    () :module 'llvm-interpreter)
