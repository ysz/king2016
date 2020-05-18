;; -*- Mode: lisp; Author: ysz; -*-

;; Copyright (c) 2016 Nobreach Inc. All rights reserved.

(in-package "NB")
(defvar *llvm-c* #+:linux "/opt/llvm-trunk/lib/libLLVMCore.so")
;(fli:register-module 'llvm :real-name *llvm-c*)
;(fli:make-pointer :symbol-name "LLVMModuleCreateWithName" :module 'llvm)
(fli:define-opaque-pointer LLVMModuleRef LLVMOpaqueModule)
(fli:define-foreign-function (LLVMModuleCreateWithName "LLVMModuleCreateWithName")
    ((ModuleID (:reference-pass :ef-mb-string)))
  :result-type LLVMModuleRef
  :module 'llvm)
(fli:define-opaque-pointer LLVMTypeRef LLVMOpaqueType)
(fli:define-foreign-function (LLVMInt32Type "LLVMInt32Type") () :result-type LLVMTypeRef :module 'llvm)
(fli:define-foreign-function (LLVMDoubleType "LLVMDoubleType") () :result-type LLVMTypeRef :module 'llvm)
(fli:define-c-typedef LLVMBool (:boolean :int))
(fli:define-foreign-function (%LLVMFunctionType "LLVMFunctionType")
    ((ReturnType LLVMTypeRef)
     (ParamTypes (:pointer LLVMTypeRef)) ;dynamically sized array
     (ParamCount :unsigned)
     (IsVarArg LLVMBool))
  :result-type LLVMTypeRef
  :module 'llvm)
;;; (defun make-ParamTypes (lst)
;;;   (fli:allocate-foreign-object 
;;;    :type 'LLVMTypeRef
;;;    :nelems (length lst)
;;;    :initial-contents lst))
(defun LLVMFunctionType (ReturnType ParamTypes IsVarArg-p)
  (fli:with-dynamic-foreign-objects
      ((pt LLVMTypeRef :nelems (length ParamTypes) :initial-contents ParamTypes))
    (%LLVMFunctionType ReturnType pt (length ParamTypes) IsVarArg-p)))
(fli:define-opaque-pointer LLVMValueRef LLVMOpaqueValue)
(fli:define-foreign-function (LLVMAddFunction "LLVMAddFunction")
    ((M LLVMModuleRef)
     (Name (:reference-pass :ef-mb-string))
     (FunctionTy LLVMTypeRef))
  :result-type LLVMValueRef
  :module 'llvm)
(fli:define-opaque-pointer LLVMBasicBlockRef LLVMOpaqueBasicBlock)
(fli:define-foreign-function (LLVMAppendBasicBlock "LLVMAppendBasicBlock")
    ((FnRef LLVMValueRef) (Name (:reference-pass :ef-mb-string)))
  :result-type LLVMBasicBlockRef
  :module 'llvm)
(fli:define-opaque-pointer LLVMBuilderRef LLVMOpaqueBuilder)
(fli:define-foreign-function (LLVMCreateBuilder "LLVMCreateBuilder")
    () :result-type LLVMBuilderRef :module 'llvm)
(fli:define-foreign-function (LLVMPositionBuilderAtEnd "LLVMPositionBuilderAtEnd")
    ((Builder LLVMBuilderRef) (Block LLVMBasicBlockRef)) :module 'llvm)
(fli:define-foreign-function (LLVMBuildAdd "LLVMBuildAdd")
    ((B LLVMBuilderRef) 
     (LHS LLVMValueRef)
     (RHS LLVMValueRef)
     (Name (:reference-pass :ef-mb-string)))
  :result-type LLVMValueRef
  :module 'llvm)
(fli:define-foreign-function (LLVMGetParam "LLVMGetParam")
    ((FnRef LLVMValueRef) (index :unsigned))
  :result-type LLVMValueRef :module 'llvm)
(fli:define-foreign-function (LLVMBuildRet "LLVMBuildRet")
    ((B LLVMBuilderRef) (V LLVMValueRef))
  :result-type LLVMValueRef :module 'llvm)
(fli:define-foreign-function (LLVMDisposeMessage "LLVMDisposeMessage")
    ((Message (:pointer :char))) :module 'llvm)
