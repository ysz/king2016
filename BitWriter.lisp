;; -*- Mode: lisp; Author: ysz; -*-

;; Copyright (c) 2016 Nobreach Inc. All rights reserved.

(in-package "NB")
(defvar *llvm-dis* #+:linux "/opt/llvm-trunk/bin/llvm-dis")
(defvar *llvm-bit-writer* #+:linux "/opt/llvm-trunk/lib/libLLVMBitWriter.so")
(fli:define-foreign-function (LLVMWriteBitcodeToFile "LLVMWriteBitcodeToFile")
    ((M LLVMModuleRef) (Path (:reference-pass :ef-mb-string)))
  :result-type :int
  :module 'llvm-bit-writer)
(defun print-bitcode (M &optional (stream *standard-output*) depth)
  (declare (ignore depth))
  (let ((Path (create-temp-file :file-type "bc")))
    (LLVMWriteBitcodeToFile M (namestring Path))
    (system:call-system `(,*llvm-dis* ,(namestring Path)))
    (with-open-file
        (in (make-pathname :type "ll" :defaults Path) :direction :input)
      (loop for line = (read-line in nil nil)
            while line
            do (write-line line stream)))
    (values)))
  