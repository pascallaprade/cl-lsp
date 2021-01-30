(cl-lsp/defpackage:defpackage :cl-lsp/test/initialized
  (:use :cl
        :rove
        :cl-lsp/server
        :cl-lsp/test/test-server)
  (:local-nicknames (:protocol :cl-lsp.lem-lsp-utils/protocol)
                    (:json :cl-lsp.lem-lsp-utils/json)))
(in-package :cl-lsp/test/initialized)

(deftest did-not-initialized
  (let ((server (make-instance 'test-server)))
    (server-listen server)
    (let ((response
            (call-lsp-method server
                             "initialized"
                             nil)))
      (ok (equal -32002 (json:json-get response "code")))
      (ok (equal "did not initialize" (json:json-get response "message"))))))

(deftest success
  (let ((server (make-instance 'test-server)))
    (server-listen server)
    (cl-lsp/test/initialize:initialize-request server)
    (let ((response
            (call-lsp-method server
                             "initialized"
                             nil)))
      (ok (null response)))))
