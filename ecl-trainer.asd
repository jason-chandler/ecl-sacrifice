(in-package #:cl-user)
(asdf:defsystem ecl-trainer
  :version "0.0.0"
  :license "BSD-3"
  :author "Jason <jasonchandler@pm.me>"
  :maintainer "Jason <jasonchandler@pm.me>"
  :description "Embeddable lisp trainer for Windows"
  :serial T
  :components ((:file "packages")
               (:file "win-api" :depends-on ("packages"))
               (:file "ecl-trainer" :depends-on ("win-api")))
  :depends-on ())
