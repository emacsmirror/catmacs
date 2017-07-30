;;; catmacs --- Prototyping simpel CAT interface for Yaesu FT991A

;;;
;; Author: Frank Singleton
;;


;;; Code:

(defun catmacs-send-serial (command)
  "Send a COMMAND string over serial port."
  (with-temp-buffer
    (let ((process (make-serial-process
		    :port "/dev/tty.SLAB_USBtoUART"
		    :speed 38400
                    :name "rig"
                    :flowcontrol 'hw
                    :coding 'no-conversion
		    :buffer (current-buffer)))
	  result)
      (catmacs-send-process process command)
      (delete-process process)
      result)))

(defun catmacs-send-process (process command)
  "Send to a specified PROCESS, a COMMAND string."
  (message "process = [%s] command = [%s]" process command)
  (with-current-buffer (process-buffer process)
    (process-send-string process command)
    (accept-process-output process 0.1)
    (buffer-string)))

(catmacs-send-serial "FA013344628;")

(catmacs-send-serial "FA;")

(provide 'catmacs)
;;; catmacs.el ends here
