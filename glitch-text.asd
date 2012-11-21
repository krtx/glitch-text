#|
  This file is a part of glitch-text project.
  Copyright (c) 2012 akimono iryou (akimonoiryou@gmail.com)
|#

(in-package :cl-user)
(defpackage glitch-text-asd
  (:use :cl :asdf))
(in-package :glitch-text-asd)

(defsystem glitch-text
  :version "0.1-SNAPSHOT"
  :author "akimono iryou"
  :license "LLGPL"
  :depends-on (:cl-annot)
  :components ((:module "src"
                :components
                ((:file "glitch-text"))))
  :description ""
  :long-description
  #.(with-open-file (stream (merge-pathnames
                             #p"README.markdown"
                             (or *load-pathname* *compile-file-pathname*))
                            :if-does-not-exist nil
                            :direction :input)
      (when stream
        (let ((seq (make-array (file-length stream)
                               :element-type 'character
                               :fill-pointer t)))
          (setf (fill-pointer seq) (read-sequence seq stream))
          seq)))
  :in-order-to ((test-op (load-op glitch-text-test))))
