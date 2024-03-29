;;*****************************************************************************
;;*****************************************************************************
;;  FILENAME: USBFS_1_cls_hid.asm
;;   Version: 1.1, Updated on 2006/06/19 at 11:41:37
;;  Generated by PSoC Designer ver 4.4  b1884 : 14 Jan, 2007
;;
;;  DESCRIPTION: USB Human Interface Device (HID) Class request implemenatation
;;               for the CY8C24090 and CY7C64215 family of devices
;;
;;  NOTE: User Module APIs conform to the fastcall convention for marshalling
;;        arguments and observe the associated "Registers are volatile" policy.
;;        This means it is the caller's responsibility to preserve any values
;;        in the X and A registers that are still needed after the API
;;        function returns. Even though these registers may be preserved now,
;;        there is no guarantee they will be preserved in future releases.
;;-----------------------------------------------------------------------------
;;  Copyright (c) Cypress Semiconductor 2005. All Rights Reserved.
;;*****************************************************************************
;;*****************************************************************************

include "m8c.inc"
include "USBFS_1_macros.inc"
include "USBFS_1.inc"
include "memory.inc"

;-----------------------------------------------
;  Global Symbols
;-----------------------------------------------
EXPORT USBFS_1_UpdateHIDTimer
EXPORT _USBFS_1_UpdateHIDTimer
EXPORT USBFS_1_bGetProtocol
EXPORT _USBFS_1_bGetProtocol
;export of the following items allows an application to initialize the data
; if necessary, possibly on reboot or other programatic events (usb reset).
; USBFS_1_Protocol is the variable controling boot/report mode for 
; HID devices.
EXPORT  _USBFS_1_IdleReload    ; Idle Timer Reload Value
EXPORT   USBFS_1_IdleReload    ; Idle Timer Reload Value
EXPORT  _USBFS_1_Protocol	  ; Active Protocol
EXPORT   USBFS_1_Protocol    ; Active Protocol

AREA InterruptRAM (RAM,REL,CON)
;-----------------------------------------------
;  Constant Definitions
;-----------------------------------------------
;-----------------------------------------------
; Variable Allocation
;-----------------------------------------------
;----------------------------------------------------------------------------
; Interface Setting
;----------------------------------------------------------------------------
  USBFS_1_IdleReload:
 _USBFS_1_IdleReload:                   BLK   1h    ; Idle Timer Reload Value
 USBFS_1_IdleTimer:                     BLK   1h    ; Idle Timers
  USBFS_1_Protocol:   
 _USBFS_1_Protocol:                     BLK   1h    ; Active Protocol

AREA UserModules (ROM, REL)
;-----------------------------------------------------------------------------
;  FUNCTION NAME: USBFS_1_bGetProtocol
;
;  DESCRIPTION:   Returns the selected protocol value to the application
;
;-----------------------------------------------------------------------------
;
;  ARGUMENTS:    A: Interface number
;
;  RETURNS:      A: Protocol values
;
;  SIDE EFFECTS: REGISTERS ARE VOLATILE: THE A AND X REGISTERS MAY BE MODIFIED!
;
;  THEORY of OPERATION or PROCEDURE:
;
;-----------------------------------------------------------------------------
.SECTION
 USBFS_1_bGetProtocol:
_USBFS_1_bGetProtocol:
    RAM_PROLOGUE RAM_USE_CLASS_3
	RAM_SETPAGE_IDX >USBFS_1_Protocol
    mov  X, A                          ; Argument is the index
    mov  A, [X + USBFS_1_Protocol] ; Return the protocol
	RAM_EPILOGUE RAM_USE_CLASS_3
    ret
.ENDSECTION
;-----------------------------------------------------------------------------
;  FUNCTION NAME: USBFS_1_UpdateHIDTimer
;
;  DESCRIPTION:    Updates the HID report timer and reloads it if it expires
;
;-----------------------------------------------------------------------------
;
;  ARGUMENTS:     A: Interface number
;
;  RETURNS:       A: USB_IDLE_TIMER_EXPIRED, if the timer is running and expired
;                    USB_IDLE_TIMER_RUNNING, if the timer is running
;                    USB_IDLE_TIMER_INDEFINITE, if the report should be made on change
;
;  SIDE EFFECTS: REGISTERS ARE VOLATILE: THE A AND X REGISTERS MAY BE MODIFIED!
;
;  THEORY of OPERATION or PROCEDURE:
;
;-----------------------------------------------------------------------------
.SECTION
 USBFS_1_UpdateHIDTimer:
_USBFS_1_UpdateHIDTimer:
    RAM_PROLOGUE RAM_USE_CLASS_3
	RAM_SETPAGE_IDX >USBFS_1_IdleReload
    mov  X, A                          ; Make the argument the index
; Flow here to check if the timer is "indefinite"
    cmp	 [X + USBFS_1_IdleReload], 0   ; Indefinite?
    jz   .indefinite                   ; Jump if Indefinite?
; Flow here to check the timers
    DEC    [X + USBFS_1_IdleTimer]     ; Decrement the timer
    jc   .expired
; Flow here if the timer has not expired
    mov  A, USB_IDLE_TIMER_RUNNING     ; Return value (not expired)
	RAM_EPILOGUE RAM_USE_CLASS_3
    ret                                ; Quick exit
; Jump here if the timer expired
.expired:
    mov  A, [X + USBFS_1_IdleReload]   ; Reload the timer
    mov  [X + USBFS_1_IdleTimer], A    ; 
    mov  A, USB_IDLE_TIMER_EXPIRED     ; Return value (expired)
    ret                                ; Quick exit
; Jump here to make return "on change/indefinite"
.indefinite:
    mov  A, USB_IDLE_TIMER_INDEFINITE  ; Return value (change/indefinite)
	RAM_EPILOGUE RAM_USE_CLASS_3
    ret                                ; Exit
.ENDSECTION
;-----------------------------------------------------------------------------
;  FUNCTION NAME: USBFS_1_CB_d2h_std_ifc_06
;
;  DESCRIPTION:   Get Interface Descriptor
;
;****************************************************************
; STANDARD INTERFACE IN REQUEST: Get_Interface_Descriptor
;****************************************************************
;
; bmRequestType   : (IN | STANDARD | INTERFACE)    = 81h
; bRequest        : GET_DESCRIPTOR                 = 06h    
; wValue          : DESCRIPTOR TYPE | INDEX        = xxxxh  
; wIndex          : INTERFACE                      = --xxh
; wLength         : DESCRIPTOR_LENGTH              = --xxh  
; 
; The GET_INTERFACE_DESCRIPTOR request returns the specified 
; descriptor if the descriptor exists. 
;
; The upper byte of request_value contains the descriptor type and 
; the lower byte contains the descriptor index. request_index 
; contains either 0000h or the Language ID. request_length contains 
; the descriptor length. The actual descriptor information is 
; transferred in subsequent data packets. 
;
; USB defines only a DEVICE recipient but the HID spec added 
; support for the INTERFACE recipient.
;
; Get Descriptor from an HID interface returns either HID, 
; REPORT, or PHYSICAL descriptors.
;
;****************************************************************
IF (USB_CB_SRC_d2h_std_ifc_06 & USB_UM_SUPPLIED)
export  USBFS_1_CB_d2h_std_ifc_06
USBFS_1_CB_d2h_std_ifc_06:
    call  USBFS_1_GetInterfaceLookupTable  ; Point the the interface lookup table
    push  A                            ; Save the MSB
    mov   A, REG[USBFS_1_EP0DATA+wValueHi] ; Get descriptor type
    cmp   A, DESCR_TYPE_HID_CLASS      ; HID Class descriptor?
    jz    .send_hid_class_descr
    cmp   A, DESCR_TYPE_HID_REPORT     ; HID Report descriptor?
    jz    .send_hid_report_descr
; Jump or flow here if the request is not supported
.not_supported:
    pop   A                            ; Restore the stack
    jmp   USBFS_1_Not_Supported_Local_Hid
; Jump here to send the HID Report Descriptor
.send_hid_report_descr:
    pop   A                            ; Restore the interface lookup table MSB
    swap  A, X                         ; Add the offset
    add   A, 2                         ; Point to the right table entry
    jmp   .finish
; Jump here to send the HID Class Descriptor
.send_hid_class_descr:
    pop   A                            ; Restore the interface lookup table MSB
    swap  A, X                         ; Add the offset
    add   A, 4                         ; Point to the right table entry
; Jump or flow here with A:X Pointing to the 
.finish:
    swap  A, X                         ; Back where they belong
    adc   A, 0                         ; Don't forget the carry
    mov   [USBFS_1_t2],USBFS_1_t1      ; Set the GETWORD destination 
    call  USBFS_1_GETWORD              ; Get the pointer to the transfer descriptor table
                                       ; ITempW has the address
; Get the interface number
    mov   A, REG[USBFS_1_EP0DATA+wIndexLo] ; Get the interface number
    mov   [USBFS_1_t2], A              ; Save it for the call to LOOKUP
    mov   A, [USBFS_1_t1]              ; Get the transfer descriptor ROM Address MSB
    mov   X, [USBFS_1_t1+1]            ; Get the transfer descriptor ROM Address LSB

    jmp   USBFS_1_GetTableEntry_Local_Hid
ENDIF
;-----------------------------------------------------------------------------
;  FUNCTION NAME: USBFS_1_CB_d2h_cls_ifc_01
;
;  DESCRIPTION:   Get Report
;
;****************************************************************
; HID CLASS INTERFACE IN REQUEST: Get_Report   
;****************************************************************
;
; bmRequestType  : (IN | CLASS | INTERFACE)       = A1h
; bRequest       : GET_REPORT                     = 01h    
; wValue         : REPORT TYPE | REPORT ID        = xxxxh  
; wIndex         : INTERFACE                      = --xxh
; wLength        : REPORT LENGTH                  = --xxh  
; 
; The GET_REPORT request allows the host to receive a report from 
; a specific interface via the control pipe. 
;
;****************************************************************
;-----------------------------------------------------------------------------
;
;  ARGUMENTS:
;
;  RETURNS:
;
;  SIDE EFFECTS: REGISTERS ARE VOLATILE: THE A AND X REGISTERS MAY BE MODIFIED!
;
;  THEORY of OPERATION or PROCEDURE:
;
;-----------------------------------------------------------------------------

IF (USB_CB_SRC_d2h_cls_ifc_01 & USB_UM_SUPPLIED)
export  USBFS_1_CB_d2h_cls_ifc_01
USBFS_1_CB_d2h_cls_ifc_01:

    call    Find_Report
    NULL_PTR_CHECK USBFS_1_Not_Supported_Local_Hid
    
    jmp     USBFS_1_GetTableEntry_Local_Hid

ENDIF
;-----------------------------------------------------------------------------
;  FUNCTION NAME: USBFS_1_CB_d2h_cls_ifc_02
;
;  DESCRIPTION:   Get Idle
;
;****************************************************************
; HID CLASS INTERFACE IN REQUEST: Get_Idle
;****************************************************************
;
; bmRequestType  : (OUT | CLASS | INTERFACE)      = A1h
; bRequest       : GET_IDLE                       = 02h    
; wValue         : REPORT ID                      = 00xxh  
; wIndex         : INTERFACE                      = --xxh
; wLength        : Report Size                    = 0001h  
; 
; The GET_IDLE request reads the current idle rate for a given 
; input report on a specific interface. 
;
;****************************************************************
;-----------------------------------------------------------------------------
;
;  ARGUMENTS:
;
;  RETURNS:
;
;  SIDE EFFECTS: REGISTERS ARE VOLATILE: THE A AND X REGISTERS MAY BE MODIFIED!
;
;  THEORY of OPERATION or PROCEDURE:
;
;-----------------------------------------------------------------------------

IF (USB_CB_SRC_d2h_cls_ifc_02 & USB_UM_SUPPLIED)
; TODO: Should this table move to another file (GetIdleTable)
; TODO: How will we build this table to the correct size? (GetIdleTable)
.LITERAL
GetSetIdleTable:
    TD_START_TABLE  1h                 ; One entry for each interface
    TD_ENTRY        USB_DS_RAM, 1, USBFS_1_IdleReload,   NULL_PTR  ; Reuse the transfer buffer
    TD_ENTRY        USB_DS_RAM, 1, USBFS_1_IdleReload+1, NULL_PTR  ; Reuse the transfer buffer
.ENDLITERAL

export  USBFS_1_CB_d2h_cls_ifc_02
USBFS_1_CB_d2h_cls_ifc_02:

; TODO: Verify that report numbers 1 to n (or 0 to n-1)
    mov   A, REG[USBFS_1_EP0DATA+wValueLo] ; Get the report number
    cmp   A, 0                         ; We don't support report by report idle
    jnz   USBFS_1_Not_Supported_Local_Hid

    mov   A, REG[USBFS_1_EP0DATA+wIndexLo] ; Get the interface number
    cmp   A, 1h                        ; We don't support report by report idle
    jnc   USBFS_1_Not_Supported_Local_Hid


    mov   [USBFS_1_t2], A              ; Use the UM temp var--Selector
    mov   A,>GetSetIdleTable           ; Get the ROM Address MSB
    mov   X,<GetSetIdleTable           ; Get the ROM Address LSB
    
    jmp   USBFS_1_GetTableEntry_Local_Hid

ENDIF

;-----------------------------------------------------------------------------
;  FUNCTION NAME: USBFS_1_CB_d2h_cls_ifc_03
;
;  DESCRIPTION:   Get Protocol
;
;****************************************************************
; HID CLASS INTERFACE IN REQUEST: Get_Protocol
;****************************************************************
;
; bmRequestType  : (OUT | CLASS | INTERFACE)      = A1h
; bRequest       : GET_PROTOCOL                   = 03h    
; wValue         : RESERVED                       = 0000h  
; wIndex         : INTERFACE                      = --xxh
; wLength        : SIZEOF_INTERFACE_PROTOCOL      = 0001h  
; 
; The GET_PROTOCOL request reads which protocol is currently 
; active.
;
;****************************************************************
;-----------------------------------------------------------------------------
;
;  ARGUMENTS:
;
;  RETURNS:
;
;  SIDE EFFECTS: REGISTERS ARE VOLATILE: THE A AND X REGISTERS MAY BE MODIFIED!
;
;  THEORY of OPERATION or PROCEDURE:
;
;-----------------------------------------------------------------------------
IF (USB_CB_SRC_d2h_cls_ifc_03 & USB_UM_SUPPLIED)

.LITERAL
GetProtocolTable:
    TD_START_TABLE  2                  ; One entry for BOOT/One entry for REPORT
    TD_ENTRY        USB_DS_ROM, 1, ROM_ZERO,   NULL_PTR  ; Simply use a a hard coded zero or one
    TD_ENTRY        USB_DS_ROM, 1, ROM_ONE,    NULL_PTR  ; 
ROM_ZERO:   DB  0
ROM_ONE:    DB  1
.ENDLITERAL

export  USBFS_1_CB_d2h_cls_ifc_03
USBFS_1_CB_d2h_cls_ifc_03:
    mov   A, REG[USBFS_1_EP0DATA+wIndexLo]  ; Get the interface number
    cmp   A, 1h                        ; Range check
    jnc   USBFS_1_Not_Supported_Local_Hid

    mov   X, A                         ; Get the protocol for the requested interface
    mov   A, [X + USBFS_1_Protocol]    ; 

    mov   [USBFS_1_t2], A              ; Use the UM temp var--Selector

    mov   A,>GetProtocolTable          ; Get the ROM Address MSB
    mov   X,<GetProtocolTable          ; Get the ROM Address LSB
    
    jmp   USBFS_1_GetTableEntry_Local_Hid
ENDIF
;-----------------------------------------------------------------------------
;  FUNCTION NAME: USBFS_1_CB_h2d_cls_ifc_09
;
;  DESCRIPTION:   Set Report
;
;****************************************************************
; HID CLASS INTERFACE OUT REQUEST: Set_Report
;****************************************************************
;
; bmRequestType   : (OUT | CLASS | INTERFACE)      = 21h
; bRequest        : SET_REPORT                     = 09h    
; wValue          : REPORT TYPE | REPORT ID        = xxxxh  
; wIndex          : INTERFACE                      = --xxh
; wLength         : REPORT LENGTH                  = --xxh  
; 
; The SET_REPORT request allows the host to send a report to the 
; device, possibly setting the state of input, output or feature 
; controls. 
;
;****************************************************************
;-----------------------------------------------------------------------------
;
;  ARGUMENTS:
;
;  RETURNS:
;
;  SIDE EFFECTS: REGISTERS ARE VOLATILE: THE A AND X REGISTERS MAY BE MODIFIED!
;
;  THEORY of OPERATION or PROCEDURE:
;
;-----------------------------------------------------------------------------

IF (USB_CB_SRC_h2d_cls_ifc_09 & USB_UM_SUPPLIED)
export  USBFS_1_CB_h2d_cls_ifc_09
USBFS_1_CB_h2d_cls_ifc_09:
    CALL    Find_Report
    NULL_PTR_CHECK USBFS_1_Not_Supported_Local_Hid
    
    JMP     USBFS_1_GetTableEntry_Local_Hid
ENDIF
;-----------------------------------------------------------------------------
;  FUNCTION NAME: USBFS_1_CB_h2d_cls_ifc_10
;
;  DESCRIPTION:   Set Idle
;
;****************************************************************
; HID CLASS INTERFACE OUT REQUEST: Set_Idle
;****************************************************************
;
; bmRequestType   : (OUT | CLASS | INTERFACE)      = 21h
; bRequest        : SET_IDLE                       = 0Ah    
; wValue          : DURATION | REPORT ID           = xxxxh  
; wIndex          : INTERFACE                      = --xxh
; wLength         : ZERO                           = 0000h  
; 
; The SET_IDLE request silences a particular input report (or all 
; input reports) on a specific interface until a new event occurs 
; or the specified amount of time passes. 
;
;****************************************************************
; Note: This function does not support multiple reports per interface.
;****************************************************************
;-----------------------------------------------------------------------------
;
;  ARGUMENTS:
;
;  RETURNS:
;
;  SIDE EFFECTS: REGISTERS ARE VOLATILE: THE A AND X REGISTERS MAY BE MODIFIED!
;
;  THEORY of OPERATION or PROCEDURE:
;
;-----------------------------------------------------------------------------

IF (USB_CB_SRC_h2d_cls_ifc_10 & USB_UM_SUPPLIED)
export  USBFS_1_CB_h2d_cls_ifc_10
USBFS_1_CB_h2d_cls_ifc_10:

; TODO: Verify that report numbers 1 to n (or 0 to n-1)
    mov   A, REG[USBFS_1_EP0DATA+wValueLo]  ; Get the report number
    cmp   A, 0                         ; We don't support report by report idle
    jnz   USBFS_1_Not_Supported_Local_Hid

    mov   A, REG[USBFS_1_EP0DATA+wIndexLo]  ; Get the interface number
    cmp   A, 1h                        ; Range Check
    jnc   USBFS_1_Not_Supported_Local_Hid

    mov   X, A                         ; Interface Number becomes an index

    mov   A, REG[USBFS_1_EP0DATA+wValueHi]  ; Get the duration

    mov   [X+USBFS_1_IdleReload], A    ; Save the reload immediately
    cmp   A, 0                         ; Is this request setting the duration to indefinite?
    jz    .reload                      ; If so, reload the timer 

    ; Otherwise, we need to determine if we reset the current expiry
    ; (HID Spec says to send the next report if we are within 4 ms (1 count)
    ; of sending the next report
    cmp   [X+USBFS_1_IdleTimer], 1     ; Within 4 ms?
    jz    .done                        ; Jump to let the timer expire "naturally" 

; Jump or Flow here to reload the timer
.reload:
    mov   [x+USBFS_1_IdleTimer], A     ; Reload the timer
            
.done:
    jmp   USBFS_1_NoDataStageControlTransfer

ENDIF

;-----------------------------------------------------------------------------
;  FUNCTION NAME: USBFS_1_CB_h2d_cls_ifc_11
;
;  DESCRIPTION:   Set Idle
;
;****************************************************************
; HID CLASS INTERFACE OUT REQUEST: Set_Protocol
;****************************************************************
;
; bmRequestType  : (OUT | CLASS | INTERFACE)      = 21h
; bRequest       : SET_PROTOCOL                   = 0Bh    
; wValue         : DURATION | REPORT ID           = xxxxh  
; wIndex         : PROTOCOL                       = --xxh
; wLength        : ZERO                           = 0000h  
; 
; The SET_PROTOCOL request switches between the boot protocol and 
; the report protocol (or vice versa). 
;
;****************************************************************
;-----------------------------------------------------------------------------
;
;  ARGUMENTS:
;
;  RETURNS:
;
;  SIDE EFFECTS: REGISTERS ARE VOLATILE: THE A AND X REGISTERS MAY BE MODIFIED!
;
;  THEORY of OPERATION or PROCEDURE:
;
;-----------------------------------------------------------------------------
IF (USB_CB_SRC_h2d_cls_ifc_11 & USB_UM_SUPPLIED)
export  USBFS_1_CB_h2d_cls_ifc_11
USBFS_1_CB_h2d_cls_ifc_11:
    mov   A, REG[USBFS_1_EP0DATA+wIndexLo]  ; Get the interface number
    cmp   A, 1h                        ; Range check
    jnc   USBFS_1_Not_Supported_Local_Hid

    mov   X, A                         ; Save the interface number

    mov   A, REG[USBFS_1_EP0DATA+wValueLo]  ; Get the protocol
    cmp   A, (1+1)                     ; Must be zero or one
    jnc   USBFS_1_Not_Supported_Local_Hid

    mov   [X + USBFS_1_Protocol], A    ; Save the new protocol

    jmp   USBFS_1_NoDataStageControlTransfer

ENDIF
;-----------------------------------------------------------------------------
;  FUNCTION NAME:   Find_Report
;
;  DESCRIPTION:     Scan the HID Report Tree and return a pointer to the 
;                   HID Report Transfer Descriptor (TD) or NULL
;                   This function is called in during the processing of
;                   GET_REPORT or SET_REPORT HID Class Requests.
;
;-----------------------------------------------------------------------------
;
;  ARGUMENTS:       
;
;  RETURNS:
;
;  SIDE EFFECTS: REGISTERS ARE VOLATILE: THE A AND X REGISTERS MAY BE MODIFIED!
;
;  THEORY of OPERATION or PROCEDURE:
;
;-----------------------------------------------------------------------------
Find_Report:
    call  USBFS_1_GetInterfaceLookupTable  ; Point the the interface lookup table
    ; The first entry of the table point to the report table.
    mov   [USBFS_1_t2],USBFS_1_t1      ; Set the GETWORD destination 
    call  USBFS_1_GETWORD              ; Get the pointer to the transfer descriptor table
                                       ; ITempW has the address
    mov   A, REG[USBFS_1_EP0DATA+wIndexLo]  ; Get the interface number
    mov   [USBFS_1_t2], A              ; Use the UM temp var--Selector
    mov   A, [USBFS_1_t1]              ; Get the Table Address MSB
    mov   X, [USBFS_1_t1+1]            ; Get the Table Address LSB

    asl   [USBFS_1_t2] ; Convert the index to offset

    swap  A, X
    add   A, [USBFS_1_t2]
    swap  A, X
    adc   A, 0                         ; A:X now points to the table entry we want

; Get the pointer to the Report Type Table
    GET_WORD

; Dereference to the requested Report Type
    push  A                            ; Don't loose the pointer MSB
    mov   A, REG[USBFS_1_EP0DATA+wValueHi]  ; Get the Report Type
    dec   A                            ; Make it 0 based
    mov   [USBFS_1_t2], A              ; Use the UM temp var--Selector
    pop   A                            ; Get the MSB back
    push  A                            ; Don't loose the pointer MSB
    romx                               ; Get the table size
    cmp   A, [USBFS_1_t2]              ; Range check
    jc    .not_supported_pop_1
        
    pop   A                            ; Get the MSB back
    inc   X                            ; Point to the next  entry
    adc   A, 0                         ;

    LT_INDEX_TO_OFFSET USBFS_1_t2      ; Convert the index to offset

    swap  A, X
    add   A, [USBFS_1_t2]
    swap  A, X
    adc   A, 0                         ; A:X now points to the table entry we want
; Get the pointer to the requested Report Table
    GET_WORD                            ; A:X points to the 

    NULL_PTR_CHECK .not_supported      ; Null Table entries indicated not supported
; Dereference to the requested TRANSFER DESCRIPTOR
    push  A                            ; Don't loose the pointer MSB
    mov   A, REG[USBFS_1_EP0DATA+wValueLo]  ; Get the Report ID
    mov   [USBFS_1_t2], A              ; Use the UM temp var--Selector
    pop   A                            ; Get the MSB back
    push  A                            ; Don't loose the pointer MSB
    romx                               ; Get the table size
    cmp   A, [USBFS_1_t2]              ; Range check
    jc    .not_supported_pop_1
        
    pop   A                            ; Get the MSB back

    ret                                ; Finished A:X point to the TD

.not_supported_pop_1:
    pop   A                            ; Restore the stack
.not_supported:
    mov   A, 0                         ; Return a null pointer
    mov   X, A                         ; 
    ret

;-----------------------------------------------------------------------------
;  FUNCTION NAME: USBFS_1_GetInterfaceLookupTable
;
;  DESCRIPTION:   Point to the interface lookup table
;
;-----------------------------------------------------------------------------
;
;  ARGUMENTS:
;
;  RETURNS:
;
;  SIDE EFFECTS: REGISTERS ARE VOLATILE: THE A AND X REGISTERS MAY BE MODIFIED!
;
;  THEORY of OPERATION or PROCEDURE:
;
;-----------------------------------------------------------------------------
export  USBFS_1_GetInterfaceLookupTable:
USBFS_1_GetInterfaceLookupTable:
    call  USBFS_1_GET_CONFIG_TABLE_ENTRY ; Get the CONFIG_LOOKUP entry
    swap  A, X                         ; Second entry points to the HID_LOOKUP table
    add   A, 2                         ; So add two
    swap  A, X                         ; 
    adc   A, 0                         ; Don't forget the carry
    mov   [USBFS_1_t2],USBFS_1_t1      ; Set the GETWORD destination 
    call  USBFS_1_GETWORD              ; Get the pointer to the HID_LOOKUP table
                                       ; ITempW has the address
    mov   A, [USBFS_1_t1]              ; Get the table address MSB
    mov   X, [USBFS_1_t1+1]            ; Get the table address LSB
    ret




;-----------------------------------------------------------------------------
;-----------------------------------------------------------------------------
;  USB 2nd Tier Dispactch Jump Tables for HID Class Requests (based on bRequest)
;-----------------------------------------------------------------------------
;  FUNCTION NAME: ;  USB 2nd Tier Dispactch Jump Table
;
;  DESCRIPTION:   The following tables dispatch to the Standard request handler
;                 functions.  (Assumes bmRequestType(5:6) is 0, Standard)
;
;-----------------------------------------------------------------------------
;
;  ARGUMENTS:
;
;  RETURNS:
;
;  SIDE EFFECTS: REGISTERS ARE VOLATILE: THE A AND X REGISTERS MAY BE MODIFIED!
;
;  THEORY of OPERATION or PROCEDURE:
;
;-----------------------------------------------------------------------------
;-----------------------------------------------------------------------------
USBFS_1_DT_h2d_cls_ifc:
;-----------------------------------------------------------------------------

    jmp     USBFS_1_CB_h2d_cls_ifc_00
    jmp     USBFS_1_CB_h2d_cls_ifc_01
    jmp     USBFS_1_CB_h2d_cls_ifc_02
    jmp     USBFS_1_CB_h2d_cls_ifc_03
    jmp     USBFS_1_CB_h2d_cls_ifc_04
    jmp     USBFS_1_CB_h2d_cls_ifc_05
    jmp     USBFS_1_CB_h2d_cls_ifc_06
    jmp     USBFS_1_CB_h2d_cls_ifc_07
    jmp     USBFS_1_CB_h2d_cls_ifc_08
    jmp     USBFS_1_CB_h2d_cls_ifc_09
    jmp     USBFS_1_CB_h2d_cls_ifc_10
    jmp     USBFS_1_CB_h2d_cls_ifc_11
    jmp     USBFS_1_CB_h2d_cls_ifc_12

USBFS_1_DT_h2d_cls_ifc_End:
USBFS_1_DT_h2d_cls_ifc_Size: equ (USBFS_1_DT_h2d_cls_ifc_End-USBFS_1_DT_h2d_cls_ifc) / 2
USBFS_1_DT_h2d_cls_ifc_Dispatch::
    CMP     [USBFS_1_Configuration], 0 ; Is the device configured?
    JNZ     .configured                ; Jump on configured
    JMP     USBFS_1_Not_Supported_Local_Hid  ; Stall the request if not configured
; Jump here if the device is configured
.configured:
    MOV     A, REG[USBFS_1_EP0DATA + bRequest]   ; Get the request number
    DISPATCHER USBFS_1_DT_h2d_cls_ifc, USBFS_1_DT_h2d_cls_ifc_Size, USBFS_1_Not_Supported_Local_Hid 

;-----------------------------------------------------------------------------
USBFS_1_DT_d2h_cls_ifc:
;-----------------------------------------------------------------------------

    jmp     USBFS_1_CB_d2h_cls_ifc_00
    jmp     USBFS_1_CB_d2h_cls_ifc_01
    jmp     USBFS_1_CB_d2h_cls_ifc_02
    jmp     USBFS_1_CB_d2h_cls_ifc_03

USBFS_1_DT_d2h_cls_ifc_End:
USBFS_1_DT_d2h_cls_ifc_Size: equ (USBFS_1_DT_d2h_cls_ifc_End-USBFS_1_DT_d2h_cls_ifc) / 2
USBFS_1_DT_d2h_cls_ifc_Dispatch::
    CMP     [USBFS_1_Configuration], 0 ; Is the device configured?
    JNZ     .configured                ; Jump on configured
    JMP     USBFS_1_Not_Supported_Local_Hid  ; Stall the request if not configured
; Jump here if the device is configured
.configured:
    MOV     A, REG[USBFS_1_EP0DATA + bRequest]   ; Get the request number
    DISPATCHER USBFS_1_DT_d2h_cls_ifc, USBFS_1_DT_d2h_cls_ifc_Size, USBFS_1_Not_Supported_Local_Hid 

IF (USB_CB_SRC_d2h_cls_ifc_00 & USB_NOT_SUPPORTED)
export  USBFS_1_CB_d2h_cls_ifc_00
USBFS_1_CB_d2h_cls_ifc_00:
ENDIF
IF (USB_CB_SRC_d2h_cls_ifc_01 & USB_NOT_SUPPORTED)
export  USBFS_1_CB_d2h_cls_ifc_01
USBFS_1_CB_d2h_cls_ifc_01:
ENDIF
IF (USB_CB_SRC_d2h_cls_ifc_02 & USB_NOT_SUPPORTED)
export  USBFS_1_CB_d2h_cls_ifc_02
USBFS_1_CB_d2h_cls_ifc_02:
ENDIF
IF (USB_CB_SRC_d2h_cls_ifc_03 & USB_NOT_SUPPORTED)
export  USBFS_1_CB_d2h_cls_ifc_03
USBFS_1_CB_d2h_cls_ifc_03:
ENDIF
IF (USB_CB_SRC_h2d_cls_ifc_00 & USB_NOT_SUPPORTED)
export  USBFS_1_CB_h2d_cls_ifc_00
USBFS_1_CB_h2d_cls_ifc_00:
ENDIF
IF (USB_CB_SRC_h2d_cls_ifc_01 & USB_NOT_SUPPORTED)
export  USBFS_1_CB_h2d_cls_ifc_01
USBFS_1_CB_h2d_cls_ifc_01:
ENDIF
IF (USB_CB_SRC_h2d_cls_ifc_02 & USB_NOT_SUPPORTED)
export  USBFS_1_CB_h2d_cls_ifc_02
USBFS_1_CB_h2d_cls_ifc_02:
ENDIF
IF (USB_CB_SRC_h2d_cls_ifc_03 & USB_NOT_SUPPORTED)
export  USBFS_1_CB_h2d_cls_ifc_03
USBFS_1_CB_h2d_cls_ifc_03:
ENDIF
IF (USB_CB_SRC_h2d_cls_ifc_04 & USB_NOT_SUPPORTED)
export  USBFS_1_CB_h2d_cls_ifc_04
USBFS_1_CB_h2d_cls_ifc_04:
ENDIF
IF (USB_CB_SRC_h2d_cls_ifc_05 & USB_NOT_SUPPORTED)
export  USBFS_1_CB_h2d_cls_ifc_05
USBFS_1_CB_h2d_cls_ifc_05:
ENDIF
IF (USB_CB_SRC_h2d_cls_ifc_06 & USB_NOT_SUPPORTED)
export  USBFS_1_CB_h2d_cls_ifc_06
USBFS_1_CB_h2d_cls_ifc_06:
ENDIF
IF (USB_CB_SRC_h2d_cls_ifc_07 & USB_NOT_SUPPORTED)
export  USBFS_1_CB_h2d_cls_ifc_07
USBFS_1_CB_h2d_cls_ifc_07:
ENDIF
IF (USB_CB_SRC_h2d_cls_ifc_08 & USB_NOT_SUPPORTED)
export  USBFS_1_CB_h2d_cls_ifc_08
USBFS_1_CB_h2d_cls_ifc_08:
ENDIF
IF (USB_CB_SRC_h2d_cls_ifc_09 & USB_NOT_SUPPORTED)
export  USBFS_1_CB_h2d_cls_ifc_09
USBFS_1_CB_h2d_cls_ifc_09:
ENDIF
IF (USB_CB_SRC_h2d_cls_ifc_10 & USB_NOT_SUPPORTED)
export  USBFS_1_CB_h2d_cls_ifc_10
USBFS_1_CB_h2d_cls_ifc_10:
ENDIF
IF (USB_CB_SRC_h2d_cls_ifc_11 & USB_NOT_SUPPORTED)
export  USBFS_1_CB_h2d_cls_ifc_11
USBFS_1_CB_h2d_cls_ifc_11:
ENDIF
IF (USB_CB_SRC_h2d_cls_ifc_12 & USB_NOT_SUPPORTED)
export  USBFS_1_CB_h2d_cls_ifc_12
USBFS_1_CB_h2d_cls_ifc_12:
ENDIF

USBFS_1_Not_Supported_Local_Hid:
    LJMP     USBFS_1_Not_Supported

USBFS_1_GetTableEntry_Local_Hid:
    LJMP     USBFS_1_GetTableEntry

;-----------------------------------------------
; Add custom application code for routines 
; redefined by USB_APP_SUPPLIED in USB_HID.INC
;-----------------------------------------------

   ;@PSoC_UserCode_BODY_1@ (Do not change this line.)
   ;---------------------------------------------------
   ; Insert your custom code below this banner
   ;---------------------------------------------------

   ;---------------------------------------------------
   ; Insert your custom code above this banner
   ;---------------------------------------------------
   ;@PSoC_UserCode_END@ (Do not change this line.)

; End of File USBFS_1_cls_hid.asm
