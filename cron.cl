(load "/home/savior/quicklisp/setup.lisp")
(ql:quickload "split-sequence")


(defvar *jobs* nil)
(defvar *jobs-file* "./jobs.list")

(defun make-job (script-path interval)
  (list :script-path script-path :interval interval))

(defun add-job (job) (push job *jobs*))

(defun read-jobs-file ()
  (with-open-file (stream *jobs-file*)
    (loop for line = (read-line stream nil)
          while line
          collect line)))

(defun parse-jobs-file ()
  (dolist (job (read-jobs-file))
    (add-job (make-job (car (split-sequence:SPLIT-SEQUENCE #\space job))
                       (cdr (split-sequence:SPLIT-SEQUENCE #\space job))))))

(defun run-job (job)
  (sb-ext:run-program (getf job :script-path) nil :wait t :output t))

(defun run-jobs ()
  (dolist (job *jobs*)
    (run-job job)))

(defun run ()
  (parse-jobs-file)
  (run-jobs))
(run)

