catmacs
=======

This is an extension to Emacs to support **CAT** control of **Yaesu Transceivers.**

Currently a work in progress, but quite usable. Initial focus is on FT991(A) Transceiver.

Install
-------

To install **catmacs** type the following.

``` emacs-lisp
M-x package-install RET catmacs RET
```

Catmacs Functions
-----------------

Output from M-x a catmacs

```

Type RET on a type label to view its full documentation.

catmacs
  Group: CAT client for Yaesu FT-991A.
  Properties: group-documentation custom-prefix custom-group
catmacs-ab-set
  Command: AB - Set - VFO-A to VFO-B.
catmacs-accept-timeout
  User option: Sets the timeout for accepting process output.  See
               ‘accept-process-output’ for details.
  Properties: standard-value custom-type custom-requests
              variable-documentation
catmacs-ag-set
  Command: AF - Set - AF GAIN (0-255).
catmacs-ag-set-ni
  Function: AF - Set - AF GAIN P1 P2.
catmacs-ai-set
  Command: AI - Set - Auto Information STATE.
catmacs-baud-rate
  User option: Baud rate for CAT serial communications.
  Properties: standard-value custom-type custom-requests
              variable-documentation
catmacs-bd-set
  Command: BD - Set - Band Down.
catmacs-bs-set
  Command: BS - Set - Band Select.
  Properties: event-symbol-element-mask event-symbol-elements
              modifier-cache
catmacs-bu-set
  Command: BU - Set - Band Up.
catmacs-ch-set
  Command: CH - Set - Channel Up/Down.
catmacs-da-set
  Command: DA - Set - Dimmer.
catmacs-dn-set
  Command: DN - Set - Microphone Down.
catmacs-ed-set
  Command: ED - Set - Encorder Down.
catmacs-eu-set
  Command: EU - Set - Encorder Up.
catmacs-fa-read
  Command: FA - Read - Frequency VFO-A.
catmacs-fa-set
  Command: FA - Set - Frequency VFO-A.
  Properties: event-symbol-element-mask event-symbol-elements
              modifier-cache
catmacs-fa-set-ni
  Function: FA - Set - Frequency VFO-A P1.
catmacs-fs-set
  Command: FS - Set - Fast Step.
catmacs-if-read
  Command: IF - Read - Information.
catmacs-lk-set
  Command: LK - Set - Lock.
catmacs-md-set
  Command: MD - Set - Operating Mode.
  Properties: event-symbol-element-mask event-symbol-elements
              modifier-cache
catmacs-md-set-ni
  Function: MD - Set - Operating Mode - P1 P2.
catmacs-nb-set
  Command: Set Noise Blanker STATUS.
catmacs-nl-set
  Command: Set Noise Blanker LEVEL.
catmacs-qr-set
  Command: QR - Set - QMB recall.
  Properties: event-symbol-element-mask event-symbol-elements
              modifier-cache
catmacs-ra-set
  Command: RA - Set - RF Attenuator.
catmacs-ra-set-ni
  Function: RA - Set - RF Attenuator (P1 P2).
catmacs-rg-set
  Command: RG - Set - RF GAIN.
catmacs-rg-set-ni
  Function: RG - Set - RF GAIN P1 P2.
catmacs-send-process
  Function: Send to a specified PROCESS, a COMMAND string.
catmacs-send-serial
  Command: Send a COMMAND string over serial port.
catmacs-serial-port
  User option: Serial port for CAT communications.
  Properties: standard-value custom-type custom-requests
              variable-documentation
catmacs-sq-set
  Command: SQ - Set - Squelch LEVEL.
  Properties: event-symbol-element-mask event-symbol-elements
              modifier-cache
catmacs-sv-set
  Command: SV - Set - Swap VFO.
  Properties: event-symbol-element-mask event-symbol-elements
              modifier-cache
catmacs-test
  Command: For test, execute some catmacs-xyz-set-ni commands.
  Properties: event-symbol-element-mask event-symbol-elements
              modifier-cache
catmacs-up-set
  Command: UP - Set - Microphone UP.

```

Test
----
When you run the *catmacs-test* command (M-x catmacs-test), a small subset of
the API is executed. This does not enable the TX, only RX mode is used.

Here is an example of the *messages* logged during the test.

```
catmacs: process = [rig]
catmacs: process = [rig] command = [DA000215;]
catmacs: CAT response = []
catmacs: process response = []
catmacs: process = [rig]
catmacs: process = [rig] command = [RA00;]
catmacs: CAT response = []
catmacs: process response = []
catmacs: process = [rig]
catmacs: process = [rig] command = [AG0050;]
catmacs: CAT response = []
catmacs: process response = []
catmacs: Setting frequency to 1377 kHz and mode to AM
catmacs: process = [rig]
catmacs: process = [rig] command = [MD05;]
catmacs: CAT response = []
catmacs: process response = []
catmacs: process = [rig]
catmacs: process = [rig] command = [FA001377000;]
catmacs: CAT response = []
catmacs: process response = []
catmacs: Setting frequency to 531 kHz
catmacs: process = [rig]
catmacs: process = [rig] command = [FA000531000;]
catmacs: CAT response = []
catmacs: process response = []
catmacs: Setting frequency to 15 MHz, mode to USB, RF Attenuator ON
catmacs: process = [rig]
catmacs: process = [rig] command = [MD02;]
catmacs: CAT response = []
catmacs: process response = []
catmacs: process = [rig]
catmacs: process = [rig] command = [FA015000000;]
catmacs: CAT response = []
catmacs: process response = []
catmacs: process = [rig]
catmacs: process = [rig] command = [RA01;]
catmacs: CAT response = []
catmacs: process response = []
catmacs: Setting RF Attenuator OFF
catmacs: process = [rig]
catmacs: process = [rig] command = [RA00;]
catmacs: CAT response = []
catmacs: process response = []
catmacs: process = [rig]
catmacs: process = [rig] command = [FA;]
catmacs: CAT response = [FA015000000;]
catmacs: process response = [FA015000000;]
catmacs: VFO-A Frequency = 1500000 Hz
catmacs: process = [rig]
catmacs: process = [rig] command = [DA000100;]
catmacs: CAT response = []
catmacs: process response = []

```


Minor Mode Key Bindings
-----------------------

There are far more functions than key bindings. The most used functions are
bound to the following keystrokes.

Current Key bindings

    C-c m f - Set Frequency
    C-c m m - Set Mode
    C-c m q - Set QMB Recall
    C-c m a - Set RF Attentation
    C-c m l - Set VFO-A Lock
    C-c m b - Set Band Select
    C-c m v - Set AF Gain (Volume)
    C-c m s - Swap VFO
    C-c m e u - Set Encoder Up
    C-c m e d - Set Encoder Down


Work is ongoing, but the API is usable for now. Its great to be developing in
Emacs and be able to tune around the band at the same time, with just a few
keystrokes. TX and data modes may come later...

73's de vk3fcs/km5ws
