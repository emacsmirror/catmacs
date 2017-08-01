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
    (let ( process response)
      (setq process (make-serial-process
                     :port catmacs-serial-port
                     :speed catmacs-baud-rate
                     :name "rig"
                     :flowcontrol 'hw
                     :coding 'no-conversion
                     :buffer (current-buffer))
            )
      (message "process = [%s]" process)
      (setq response (catmacs-send-process process command))
      (message "process response = [%s]" response)
      (delete-process process)
      response
      )))

(defun catmacs-send-process (process command)
  "Send to a specified PROCESS, a COMMAND string."
  (message "process = [%s] command = [%s]" process command)
  (with-current-buffer (process-buffer process)
    (process-send-string process command)
    (accept-process-output process catmacs-accept-timeout)
    (message "CAT response = [%s]" (buffer-string))
    (buffer-string)))

;;
;; CAT Commands.
;;
;; Reference: FT-991A Cat Operation Reference Manual
;;

;;
;; AB
;;

(defun catmacs-ab-set ()
  "AB - Set - VFO-A to VFO-B."
  (interactive)
  (catmacs-send-serial "AB;"))

;;
;; AI
;;

(defun catmacs-ai-set ()
  "AI - Set - Auto Information STATE."
  (interactive)
  (let (cmd choice p1)
    (setq choice (completing-read "Select:" '("on" "off")))
    (message "choice = [%s]" choice)
    (pcase choice
      ('"on" (setq p1 1))
      ('"off" (setq p1 0))
      ;; default is off
      (_ (setq p1 0))
      )
    (message "%s" p1)
    (setq cmd (format "AI%1d;" p1))
    (catmacs-send-serial cmd)
    )
  )

;;
;; BD
;;

(defun catmacs-bd-set ()
  "BD - Set - Band Down."
  (interactive)
  (catmacs-send-serial "BD0;"))

;;
;; BS
;;

(defun catmacs-bs-set ()
  "BS - Set - Band Select."
  (interactive)
  (let (cmd choice p1)
    (setq choice (completing-read
                  "Select Band: " '("1.8MHz" "3.5MHz" "7MHz"
                                    "10MHz" "14MHz" "18MHz"
                                    "21MHz" "24.5MHz" "28MHz"
                                    "50MHz" "GEN" "MW" "AIR"
                                    "144MHz" "430MHz")))

    (message "choice = [%s]" choice)
    (pcase choice
      ('"1.8MHz" (setq p1 0))
      ('"3.5Mhz" (setq p1 1))
      ('"7MHz" (setq p1 3))
      ('"10MHz" (setq p1 4))
      ('"14MHz" (setq p1 5))
      ('"18MHz" (setq p1 6))
      ('"21MHz" (setq p1 7))
      ('"24.5MHz" (setq p1 8))
      ('"28MHz" (setq p1 9))
      ('"50MHz" (setq p1 10))
      ('"GEN" (setq p1 11))
      ('"MW" (setq p1 12))
      ('"AIR" (setq p1 14))
      ('"144MHz" (setq p1 15))
      ('"430MHz" (setq p1 16))
      ;; default is MW
      (_ (setq p1 12))
      )
    (message "%s" p1)
    (setq cmd (format "BS%02d;" p1))
    (message "cmd = [%s]" cmd)
    (catmacs-send-serial cmd)
    )
  )

;;
;; BU
;;

(defun catmacs-bu-set ()
  "BU - Set - Band Up."
  (interactive)
  (catmacs-send-serial "BU0;"))
;;
;; FA
;;

(defun catmacs-fa-set (frequency)
  "FA - Set - Frequency VFO-A.
Sets the FREQUENCY (Hz) of VFO-A"
  (interactive "nVFO-A Frequency: ")
  (let (cmd)
    (setq cmd (format "FA%09d;" (* 1000 frequency)))
    (catmacs-send-serial cmd)
    )
  )

(defun catmacs-fa-read ()
  "FA - Read - Frequency VFO-A.
Reads the FREQUENCY (Hz) of VFO-A"
  (interactive)
  (let (cmd response)
    (setq cmd (format "FA;"))
    (setq response (catmacs-send-serial cmd))
    (message "fa [%s]" response)
    (string-to-number (substring response 2 -2))
    )
  )


;;
;; NB
;;

(defun catmacs-nb-set ()
  "Set Noise Blanker STATUS."
  (interactive)
  (let (cmd choice p1 p2)
    (setq choice (completing-read "Select:" '("on" "off")))
    (message "choice = [%s]" choice)
    (pcase choice
      ('"on" (setq p2 1))
      ('"off" (setq p2 0))
      ;; default is off
      (_ (setq p2 0))
      )
    (setq p1 0)
    (message "%s" p1)
    (message "%s" p2)
    (setq cmd (format "NB%1d%1d" p1 p2))
    (catmacs-send-serial cmd)
    )
  )

;;
;; NL
;;

(defun catmacs-nl-set (level)
  "Set Noise Blanker LEVEL."
  (interactive "nNoise Blanker Level (0-10): ")
  (let (cmd)
    (setq cmd (format "NL0%03d;" level))
    (catmacs-send-serial cmd)
    )
  )

;;
;; QR
;;

(defun catmacs-qr-set ()
  "QR - Set - QMB recall.
Sets QMB Recall command.  This cycles through the 5 QMB memories."
  (interactive)
  (let (cmd)
    (setq cmd (format "QR;" ))
    (catmacs-send-serial cmd)
    )
  )



;;
;; RA
;;
(defun catmacs-ra-set ()
  "Foo."
  (interactive)
  (let (cmd choice p1 p2)
    (setq choice (completing-read "Select:" '("on" "off")))
    (message "choice = [%s]" choice)
    (pcase choice
      ('"on" (setq p2 1))
      ('"off" (setq p2 0))
      ;; default is off
      (_ (setq p2 0))
      )
    (setq p1 0)
    (message "%s" p1)
    (message "%s" p2)
    (setq cmd (format "RA%1d%1d;" p1 p2))
    (catmacs-send-serial cmd)
    )
  )

;;
;; RG
;;
(defun catmacs-rg-set (gain)
  "Set RF GAIN."
  (interactive "nRF Gain (0-255): ")
  (let (cmd)
    (setq cmd (format "RG0%03d;" gain))
    (catmacs-send-serial cmd)
    )
  )

;;
;; SQ
;;
(defun catmacs-sq-set (level)
  "Set Squelch LEVEL."
  (interactive "nSquelch Level: (0-100): ")
  (let (cmd)
    (setq cmd (format "SQ0%03d;" level))
    (catmacs-send-serial cmd)
    )
  )

;;
;; Testing
;;
(defun catmacs-test ()
  "For test, execute some catmacs commands."
  (catmacs-send-serial "FA018744728;")
  (catmacs-send-serial "BD0;")
  (catmacs-fa-read)
  )

(provide 'catmacs)
;;; catmacs.el ends here
