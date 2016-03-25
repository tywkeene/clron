(load "/home/savior/quicklisp/setup.lisp")
(ql:quickload "split-sequence")

(defvar *timers* nil)
(defvar *jobs* nil)
(defvar *jobs-file* "./jobs.list")

(defun make-job (script-path interval)
  (list script-path interval))

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
  (sb-ext:run-program (car job) nil :wait t :output t))

(defun get-timer-interval (job)
  (parse-integer (car(car(cdr job)))))

(defun make-job-timer (job)
    (add-job-timer (schedule-timer (make-timer (lambda ()(run-job job))) (get-timer-interval job))))

(defun add-job-timer (timer) (push timer *timers*))

(defun init-jobs ()
  (dolist (job *jobs*)
    (add-job-timer (make-job-timer job))))
