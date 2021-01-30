(cl-lsp/defpackage:defpackage :cl-lsp/test/test-server
  (:use :cl
        :cl-lsp/server)
  (:local-nicknames (:protocol :cl-lsp.lem-lsp-utils/protocol)
                    (:json :cl-lsp.lem-lsp-utils/json))
  (:export :test-server
           :call-lsp-method))
(in-package :cl-lsp/test/test-server)

(defclass test-server (abstract-server)
  ((method-table
    :initform (make-hash-table :test 'equal)
    :reader server-method-table)))

(defmethod register-request ((server test-server) request)
  (setf (gethash (request-method-name request) (server-method-table server))
        request))

(defun call-lsp-method (server name params)
  (let ((request (gethash name (server-method-table server))))
    (unless request
      (error "~A is not defined" name))
    (with-server (server)
      (funcall request params))))
