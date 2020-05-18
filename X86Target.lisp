;; -*- Mode: lisp; Author: ysz; -*-

;; Copyright (c) 2016 Nobreach Inc. All rights reserved.

(in-package "NB")
(defvar *llvm-x86-desc* #+:linux "/opt/llvm-trunk/lib/libLLVMX86Desc.so")
(defvar *llvm-x86-info* #+:linux "/opt/llvm-trunk/lib/libLLVMX86Info.so")
(defvar *llvm-x86-code-gen* #+:linux "/opt/llvm-trunk/lib/libLLVMX86CodeGen.so")
(fli:define-foreign-function (LLVMInitializeX86TargetInfo "LLVMInitializeX86TargetInfo") () :module 'llvm-x86-info)
(fli:define-foreign-function (LLVMInitializeX86Target "LLVMInitializeX86Target") () :module 'llvm-x86-code-gen)
(fli:define-foreign-function (LLVMInitializeX86TargetMC "LLVMInitializeX86TargetMC") () :module 'llvm-x86-desc)
(defun LLVMInitializeNativeTarget ()
;#ifdef LLVM_NATIVE_TARGET
  (LLVMInitializeX86TargetInfo)
  (LLVMInitializeX86Target)
  (LLVMInitializeX86TargetMC)
  0)
;#else
(fli:define-foreign-function (LLVMInitializeX86AsmPrinter "LLVMInitializeX86AsmPrinter") () :module 'llvm-x86-code-gen)
(defun LLVMInitializeNativeAsmParser ()
  (LLVMInitializeX86AsmPrinter))
