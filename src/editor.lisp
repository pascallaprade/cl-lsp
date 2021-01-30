(cl-lsp/defpackage:defpackage :cl-lsp/editor
  (:use :cl)
  (:export :make-file-contents-position
           :make-file-contents-range
           :open-file-contents
           :close-file-contents
           :replace-file-contents
           :edit-file-contents))
(in-package :cl-lsp/editor)

(defgeneric open-file-contents-using-editor (editor uri text))
(defgeneric close-file-contents-using-editor (editor file-contents))
(defgeneric replace-file-contents-using-editor (editor file-contents text))
(defgeneric edit-file-contents-using-editor (editor file-contents range text))

(defclass editor () ())

(defclass lem (editor) ())

(defstruct file-contents-position
  line
  character)

(defstruct file-contents-range
  start
  end)

(defmethod open-file-contents-using-editor ((editor lem) uri text)
  (let ((buffer
          (cl-lsp.lem-base:make-buffer uri
                                :temporary t
                                :syntax-table cl-lsp.lem-lisp-syntax:*syntax-table*)))
    (cl-lsp.lem-base:insert-string (cl-lsp.lem-base:buffer-point buffer) text)
    buffer))

(defmethod close-file-contents-using-editor ((editor lem) file-contents)
  (check-type file-contents cl-lsp.lem-base:buffer)
  (cl-lsp.lem-base:delete-buffer file-contents)
  (values))

(defun move-to-position (point position)
  (cl-lsp.lem-base:move-to-line point (1- (file-contents-position-line position)))
  (cl-lsp.lem-base:line-offset point 0 (file-contents-position-character position)))

(defmethod replace-file-contents-using-editor ((editor lem) file-contents text)
  (let ((buffer file-contents))
    (cl-lsp.lem-base:erase-buffer buffer)
    (cl-lsp.lem-base:insert-string (cl-lsp.lem-base:buffer-point buffer) text)))

(defmethod edit-file-contents-using-editor ((editor lem) file-contents range text)
  (let* ((buffer file-contents)
         (point (cl-lsp.lem-base:buffer-point buffer)))
    (move-to-position point (file-contents-range-start range))
    (cl-lsp.lem-base:with-point ((end point))
      (move-to-position end (file-contents-range-end range))
      (cl-lsp.lem-base:delete-between-points point end))
    (cl-lsp.lem-base:insert-string point text)))


(defvar *editor* (make-instance 'lem))

(defun open-file-contents (uri text)
  (open-file-contents-using-editor *editor* uri text))

(defun close-file-contents (file-contents)
  (close-file-contents-using-editor *editor* file-contents))

(defun replace-file-contents (file-contents text)
  (replace-file-contents-using-editor *editor* file-contents text))

(defun edit-file-contents (file-contents range text)
  (edit-file-contents-using-editor *editor* file-contents range text))
