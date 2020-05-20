(in-package :common-lisp-user)

(defpackage :win-api
  (:use :common-lisp)
  (:export :set-process
           :release-process
           :read-address
           :write-address))


(defpackage :main-train
  (:use :common-lisp :win-api)
  (:export :get-sacrifice))

