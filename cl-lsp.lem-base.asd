(defsystem "cl-lsp.lem-base"
  :depends-on ("uiop"
               "iterate"
               "alexandria"
               "cl-ppcre"
               "cl-annot")
  :pathname "lem-base/"
  :serial t
  :components ((:file "package")
               (:file "documentation")
               (:file "util")
               (:file "errors")
               (:file "var")
               (:file "wide")
               (:file "macros")
               (:file "hooks")
               (:file "line")
               (:file "buffer")
               (:file "buffer-insert")
               (:file "buffers")
               (:file "point")
               (:file "basic")
               (:file "syntax")
               (:file "file")
               (:file "search")
               (:file "indent")))
