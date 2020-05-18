;; -*- Mode: lisp; Author: ysz; -*-

;; Copyright (c) 2016 Nobreach Inc. All rights reserved.

(in-package "NB")
(defvar *llvm-analysis* #+:linux "/opt/llvm-trunk/lib/libLLVMAnalysis.so")
;(fli:register-module 'llvm-analysis :real-name *llvm-analysis*)
(fli:define-c-enum LLVMVerifierFailureAction 
  LLVMAbortProcessAction LLVMPrintMessageAction LLVMReturnStatusAction)
(fli:define-foreign-function (%LLVMVerifyModule "LLVMVerifyModule")
    ((M LLVMModuleRef)
     (Action LLVMVerifierFailureAction)
;;;      (OutMessages (:pointer (:pointer :char))))
     (:ignore (:reference-return (:reference-return :ef-mb-string))));OutMessage
  :result-type LLVMBool
  :module 'llvm-analysis)
;;; (defun LLVMVerifyModule (M &optional (Action 'LLVMReturnStatusAction))
;;;   (fli:with-coerced-pointer (NULL :type :char) fli:*null-pointer*
;;;     (fli:with-dynamic-foreign-objects ((error (:pointer :char) :initial-element NULL))
;;;       (prog1 (%LLVMVerifyModule M Action error)
;;;              (LLVMDisposeMessage (fli:dereference error))))))
