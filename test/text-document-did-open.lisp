(cl-lsp/defpackage:defpackage :cl-lsp/test/text-document-did-open
  (:use :cl
        :rove
        :cl-lsp/server
        :cl-lsp/test/test-server
        :cl-lsp/text-document-controller)
  (:local-nicknames (:protocol :cl-lsp.lem-lsp-utils/protocol)
                    (:json :cl-lsp.lem-lsp-utils/json)))
(in-package :cl-lsp/test/text-document-did-open)

(deftest test
  (let ((server (make-instance 'test-server))
        (whole-text "(defun test (x) (cons x x))"))
    (server-listen server)
    (cl-lsp/test/initialize:initialize-request server)
    (let ((response
            (call-lsp-method
             server
             "textDocument/didOpen"
             (json:object-to-json
              (make-instance
               'protocol:did-open-text-document-params
               :text-document (make-instance 'protocol:text-document-item
                                             :uri "file://Users/user/hoge.lisp"
                                             :language-id "lisp"
                                             :version 1
                                             :text whole-text))))))
      (ok (null response))
      (let ((controller (server-text-document-controller server)))
        (let ((text-document (find-text-document controller "file://Users/user/hoge.lisp")))
          (ok text-document)
          (ok (equal whole-text
                     (cl-lsp.lem-base:buffer-text (text-document-file-contents text-document)))))))))
