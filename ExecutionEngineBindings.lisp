;; -*- Mode: lisp; Author: ysz; -*-

;; Copyright (c) 2016 Nobreach Inc. All rights reserved.

(in-package "NB")
(defvar *llvm-execution-engine* #+:linux "/opt/llvm-trunk/lib/libLLVMExecutionEngine.so")
;(fli:register-module 'llvm-execution-engine :real-name *llvm-execution-engine*)
(fli:define-opaque-pointer LLVMExecutionEngineRef LLVMOpaqueExecutionEngine)
(fli:define-foreign-function (%LLVMCreateExecutionEngineForModule "LLVMCreateExecutionEngineForModule")
    ((:ignore (:reference-return LLVMExecutionEngineRef));OutE
     (M LLVMModuleRef)
     (:ignore (:reference-return (:pointer :char))));only if fail??? -- (:reference-return :ef-mb-string))));OutError
  :result-type LLVMBool
  :module 'llvm-execution-engine)
(fli:define-foreign-function (LLVMDisposeExecutionEngine "LLVMDisposeExecutionEngine")
    ((EE LLVMExecutionEngineRef)) :module 'llvm-execution-engine)
(defun LLVMCreateExecutionEngineForModule (M)
  (multiple-value-bind (not-okay? EE OutError) (%LLVMCreateExecutionEngineForModule M)
    (if not-okay?
        (values nil (fli:convert-from-foreign-string OutError))
        EE)))
(fli:define-opaque-pointer LLVMGenericValueRef LLVMOpaqueGenericValue)
(fli:define-foreign-function (%LLVMCreateGenericValueOfInt "LLVMCreateGenericValueOfInt")
    ((Ty LLVMTypeRef)
     (N (:unsigned :long-long))
     (IsSigned LLVMBool))
  :result-type LLVMGenericValueRef
  :module 'llvm-execution-engine)
(fli:define-foreign-function (LLVMGenericValueToInt "LLVMGenericValueToInt")
    ((GenValRef LLVMGenericValueRef)
     (IsSigned LLVMBool))
  :result-type (:unsigned :long-long)
  :module 'llvm-execution-engine)
(fli:define-foreign-function (%LLVMRunFunction "LLVMRunFunction")
    ((EE LLVMExecutionEngineRef)
     (F LLVMValueRef)
     (NumArgs :unsigned)
     (Args (:pointer LLVMGenericValueRef))) ;dynamically sized array
  :result-type LLVMGenericValueRef
  :module 'llvm-execution-engine)
(defun lisp->LLVM (x)
  (typecase x
    (integer (%LLVMCreateGenericValueOfInt (LLVMInt32Type) x t))
    (t (error "~A is not an integer" x))))
(defun make-Args (Args)
  ;(fli:allocate-dynamic-foreign-object
  (fli:allocate-foreign-object 
   :type 'LLVMGenericValueRef
   :nelems (length Args)
   :initial-contents (mapcar #'lisp->LLVM Args)))
(defun LLVMRunFunction (EE F Args)
  (%LLVMRunFunction EE F (length Args) (make-Args Args)))

