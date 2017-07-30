;;; catmacs --- Prototyping simple CAT interface for Yaesu FT991A
;;
;;  Copyright © 2017 Frank Singleton
;;
;;; Commentary:
;;
;;  Provides an Emacs CAT client for controlling Yaesu FT991A.
;;
;;  Under construction... eventually it will support a Major Mode
;;
;;
;;; Custom:
;;

(defgroup catmacs nil
  "CAT client for Yaesu FT-991A."
  :prefix "catmacs-"
  :group 'applications)

(defcustom catmacs-serial-port "/dev/tty.SLAB_USBtoUART"
  "Serial port for CAT communications."
  :type '(string)
  :group 'catmacs)

(defcustom catmacs-baud-rate 38400
  "Baud rate for CAT serial communications."
  :type 'integer
  :group 'catmacs)

(defcustom catmacs-accept-timeout 0.1
  "Sets the timeout for accepting process output.  See `accept-process-output' \
for details."
  :type 'float
  :group 'catmacs)

;;
;;; Code:
;;

(defun catmacs-send-serial (command)
  "Send a COMMAND string over serial port."
  (interactive "sCAT Command:")
  (with-temp-buffer
    (let ((process (make-serial-process
		    :port catmacs-serial-port
		    :speed catmacs-baud-rate
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
    (accept-process-output process catmacs-accept-timeout)
    (buffer-string)))

(catmacs-send-serial "FA018344628;")

;;(catmacs-send-serial "FA;")

(provide 'catmacs)
;;; catmacs.el ends here
