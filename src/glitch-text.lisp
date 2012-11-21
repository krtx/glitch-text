#|
  This file is a part of glitch-text project.
  Copyright (c) 2012 akimono iryou (akimonoiryou@gmail.com)
|#

(in-package :cl-user)
(defpackage glitch-text
  (:use :cl))
(in-package :glitch-text)

(cl-annot:enable-annot-syntax)

(defun code-utf8 (code-point)
  "unicode code point to UTF-8 byte list"
  (cond ((<= #x0000 code-point #x007F)
         (list code-point))
        ((<= #x0080 code-point #x07FF)
         (list (+ 192 (logand #x1F (ash code-point -6)))
               (+ 128 (logand #x3F code-point))))
        ((<= #x0800 code-point #xFFFF)
         (list (+ 224 (logand #xF (ash code-point -12)))
               (+ 128 (logand #x3F (ash code-point -6)))
               (+ 128 (logand #x3F code-point))))
        ((<= #x10000 code-point #x10FFFF)
         (list (+ 240 (logand #x7 (ash code-point -18)))
               (+ 128 (logand #x3F (ash code-point -12)))
               (+ 128 (logand #x3F (ash code-point -6)))
               (+ 128 (logand #x3F code-point))))
        (t
         (error (format nil "no unicode value: ~A" code-point)))))

(defmacro with-gensyms (syms &body body)
  `(let ,(mapcar #'(lambda (s) (list s '(gensym))) syms)
     ,@body))

(defmacro list-byteseq (lst)
  (with-gensyms (seq el)
    `(let ((,seq (make-array 0
                            :fill-pointer 0
                            :element-type '(unsigned-byte 8))))
       (dolist (,el ,lst ,seq)
         (vector-push-extend ,el ,seq)))))

(defun insert-after (list index item)
  (push item (cdr (nthcdr index list)))
  list)

@export
(defun glitch (text &key (level 1))
  (let* ((text-list (map 'list (lambda (x) (char-code x)) text))
         (times (* (length text) level)))
    (dotimes (i times)
      (insert-after text-list
                    (random (length text-list))
                    (+ #x300 (random #x70))))
    (loop
       for ch in text-list
       append (code-utf8 ch) into ret
       finally
         (return (sb-ext:octets-to-string (list-byteseq ret))))))
