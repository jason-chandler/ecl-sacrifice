(require :cmp)
(require 'asdf)
(asdf:load-asd "c:/msys64/home/chand/portacle/projects/ecl-trainer/ecl-trainer.asd")
(push "./" asdf:*central-registry*)
(asdf:make-build :ecl-trainer
                 :type :program
                 :monolithic t
                 :move-here "./"
                 :epilogue-code (main-train:get-sacrifice))
