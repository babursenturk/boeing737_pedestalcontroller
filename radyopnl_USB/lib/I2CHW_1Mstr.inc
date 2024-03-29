;;*****************************************************************************
;;*****************************************************************************
;;  FILENAME: I2CHW_1.inc
;;   Version: 1.5, Updated on 2006/06/06 at 13:39:08
;;  Generated by PSoC Designer ver 4.4  b1884 : 14 Jan, 2007
;;
;;  DESCRIPTION: Assembler declarations for the I2CHW (Master) user module interface
;;               for the 22/24/27/29/42xxx PSoC family of devices
;;-----------------------------------------------------------------------------
;;  Copyright (c) Cypress MicroSystems 2000-2006. All Rights Reserved.
;;*****************************************************************************
;;*****************************************************************************


;-----------------
; Misc
;-----------------
I2CHW_1_READ:           equ  0x01 ; Set the R/W flag after the slave address.
I2CHW_1_WRITE:          equ  0x00 ; Clear the R/W flag after the slave address.
I2CHW_1_XFER_ERROR:     equ  0x00 ; Slave did not ACK

I2CHW_1_CompleteXfer:   equ  0x00 ; Perform a complete I2C transfer
I2CHW_1_RepStart:       equ  0x01 ; Perform a complete transfer with a Repeat Start
I2CHW_1_NoStop:         equ  0x02 ; Perform a complete transfer, but leave off the stop.

I2CHW_1_NAKslave:       equ  0x00 ; NAK the slave after a read
I2CHW_1_ACKslave:       equ  0x01 ; ACK the slave after a read

; end of file I2CHW_1.inc
