;;*****************************************************************************
;;*****************************************************************************
;;  FILENAME: Counter16_1.asm
;;   Version: 2.5, Updated on 2006/05/15 at 14:54:04
;;  Generated by PSoC Designer ver 4.4  b1884 : 14 Jan, 2007
;;
;;  DESCRIPTION: Counter16 User Module software implementation file
;;               for the 22/24/27/29xxx PSoC family of devices
;;
;;  NOTE: User Module APIs conform to the fastcall16 convention for marshalling
;;        arguments and observe the associated "Registers are volatile" policy.
;;        This means it is the caller's responsibility to preserve any values
;;        in the X and A registers that are still needed after the API functions
;;        returns. For Large Memory Model devices it is also the caller's 
;;        responsibility to perserve any value in the CUR_PP, IDX_PP, MVR_PP and 
;;        MVW_PP registers. Even though some of these registers may not be modified
;;        now, there is no guarantee that will remain the case in future releases.
;;-----------------------------------------------------------------------------
;;  Copyright (c) Cypress MicroSystems 2000-2004. All Rights Reserved.
;;*****************************************************************************
;;*****************************************************************************

include "m8c.inc"
include "memory.inc"
include "Counter16_1.inc"

;-----------------------------------------------
;  Global Symbols
;-----------------------------------------------
export  Counter16_1_EnableInt
export _Counter16_1_EnableInt
export  Counter16_1_DisableInt
export _Counter16_1_DisableInt
export  Counter16_1_Start
export _Counter16_1_Start
export  Counter16_1_Stop
export _Counter16_1_Stop
export  Counter16_1_WritePeriod
export _Counter16_1_WritePeriod
export  Counter16_1_WriteCompareValue
export _Counter16_1_WriteCompareValue
export  Counter16_1_wReadCompareValue
export _Counter16_1_wReadCompareValue
export  Counter16_1_wReadCounter
export _Counter16_1_wReadCounter

; The following functions are deprecated and subject to omission in future releases
;
export  wCounter16_1_ReadCompareValue  ; deprecated
export _wCounter16_1_ReadCompareValue  ; deprecated
export  wCounter16_1_ReadCounter       ; deprecated
export _wCounter16_1_ReadCounter       ; deprecated


AREA usb_RAM (RAM,REL)

;-----------------------------------------------
;  Constant Definitions
;-----------------------------------------------

INPUT_REG_NULL:                equ 0x00    ; Clear the input register


;-----------------------------------------------
; Variable Allocation
;-----------------------------------------------


AREA UserModules (ROM, REL)

.SECTION
;-----------------------------------------------------------------------------
;  FUNCTION NAME: Counter16_1_EnableInt
;
;  DESCRIPTION:
;     Enables this counter's interrupt by setting the interrupt enable mask bit
;     associated with this User Module. This function has no effect until and
;     unless the global interrupts are enabled (for example by using the
;     macro M8C_EnableGInt).
;-----------------------------------------------------------------------------
;
;  ARGUMENTS:    None.
;  RETURNS:      Nothing.
;  SIDE EFFECTS: 
;    The A and X registers may be modified by this or future implementations
;    of this function.  The same is true for all RAM page pointer registers in
;    the Large Memory Model.  When necessary, it is the calling function's
;    responsibility to perserve their values across calls to fastcall16 
;    functions.
;
 Counter16_1_EnableInt:
_Counter16_1_EnableInt:
   RAM_PROLOGUE RAM_USE_CLASS_1
   Counter16_1_EnableInt_M
   RAM_EPILOGUE RAM_USE_CLASS_1
   ret

.ENDSECTION

.SECTION
;-----------------------------------------------------------------------------
;  FUNCTION NAME: Counter16_1_DisableInt
;
;  DESCRIPTION:
;     Disables this counter's interrupt by clearing the interrupt enable
;     mask bit associated with this User Module.
;-----------------------------------------------------------------------------
;
;  ARGUMENTS:    None
;  RETURNS:      Nothing
;  SIDE EFFECTS: 
;    The A and X registers may be modified by this or future implementations
;    of this function.  The same is true for all RAM page pointer registers in
;    the Large Memory Model.  When necessary, it is the calling function's
;    responsibility to perserve their values across calls to fastcall16 
;    functions.
;
 Counter16_1_DisableInt:
_Counter16_1_DisableInt:
   RAM_PROLOGUE RAM_USE_CLASS_1
   Counter16_1_DisableInt_M
   RAM_EPILOGUE RAM_USE_CLASS_1
   ret


.ENDSECTION

.SECTION
;-----------------------------------------------------------------------------
;  FUNCTION NAME: Counter16_1_Start
;
;  DESCRIPTION:
;     Sets the start bit in the Control register of this user module.  The
;     counter will begin counting on the next input clock as soon as the
;     enable input is asserted high.
;-----------------------------------------------------------------------------
;
;  ARGUMENTS:    None
;  RETURNS:      Nothing
;  SIDE EFFECTS: 
;    The A and X registers may be modified by this or future implementations
;    of this function.  The same is true for all RAM page pointer registers in
;    the Large Memory Model.  When necessary, it is the calling function's
;    responsibility to perserve their values across calls to fastcall16 
;    functions.
;
 Counter16_1_Start:
_Counter16_1_Start:
   RAM_PROLOGUE RAM_USE_CLASS_1
   Counter16_1_Start_M
   RAM_EPILOGUE RAM_USE_CLASS_1
   ret


.ENDSECTION

.SECTION
;-----------------------------------------------------------------------------
;  FUNCTION NAME: Counter16_1_Stop
;
;  DESCRIPTION:
;     Disables counter operation by clearing the start bit in the Control
;     register of the LSB block.
;-----------------------------------------------------------------------------
;
;  ARGUMENTS:    None
;  RETURNS:      Nothing
;  SIDE EFFECTS: 
;    The A and X registers may be modified by this or future implementations
;    of this function.  The same is true for all RAM page pointer registers in
;    the Large Memory Model.  When necessary, it is the calling function's
;    responsibility to perserve their values across calls to fastcall16 
;    functions.
;
 Counter16_1_Stop:
_Counter16_1_Stop:
   RAM_PROLOGUE RAM_USE_CLASS_1
   Counter16_1_Stop_M
   RAM_EPILOGUE RAM_USE_CLASS_1
   ret


.ENDSECTION

.SECTION
;-----------------------------------------------------------------------------
;  FUNCTION NAME: Counter16_1_WritePeriod
;
;  DESCRIPTION:
;     Write the 16-bit period value into the Period register (DR1).
;-----------------------------------------------------------------------------
;
;  ARGUMENTS: fastcall16 WORD wPeriodValue (LSB in A, MSB in X)
;  RETURNS:   Nothing
;  SIDE EFFECTS:
;    If the counter user module is stopped, then this value will also be
;    latched into the Count registers (DR0).
;     
;    The A and X registers may be modified by this or future implementations
;    of this function.  The same is true for all RAM page pointer registers in
;    the Large Memory Model.  When necessary, it is the calling function's
;    responsibility to perserve their values across calls to fastcall16 
;    functions.
;
 Counter16_1_WritePeriod:
_Counter16_1_WritePeriod:
   RAM_PROLOGUE RAM_USE_CLASS_1
   mov   reg[Counter16_1_PERIOD_LSB_REG], A
   mov   A, X
   mov   reg[Counter16_1_PERIOD_MSB_REG], A
   RAM_EPILOGUE RAM_USE_CLASS_1
   ret


.ENDSECTION

.SECTION
;-----------------------------------------------------------------------------
;  FUNCTION NAME: Counter16_1_WriteCompareValue
;
;  DESCRIPTION:
;     Writes compare value into the Compare register (DR2).
;-----------------------------------------------------------------------------
;
;  ARGUMENTS:    fastcall16 WORD wCompareValue (LSB in A, MSB in X)
;  RETURNS:      Nothing
;  SIDE EFFECTS: 
;    The A and X registers may be modified by this or future implementations
;    of this function.  The same is true for all RAM page pointer registers in
;    the Large Memory Model.  When necessary, it is the calling function's
;    responsibility to perserve their values across calls to fastcall16 
;    functions.
;
 Counter16_1_WriteCompareValue:
_Counter16_1_WriteCompareValue:
   RAM_PROLOGUE RAM_USE_CLASS_1
   mov   reg[Counter16_1_COMPARE_LSB_REG], A
   mov   A, X
   mov   reg[Counter16_1_COMPARE_MSB_REG], A
   RAM_EPILOGUE RAM_USE_CLASS_1
   ret


.ENDSECTION

.SECTION
;-----------------------------------------------------------------------------
;  FUNCTION NAME: Counter16_1_wReadCompareValue
;
;  DESCRIPTION:
;     Reads the Compare registers.
;-----------------------------------------------------------------------------
;
;  ARGUMENTS:    None
;  RETURNS:      fastcall16 WORD wCompareValue (value of DR2 in the X & A registers)
;  SIDE EFFECTS: 
;    The A and X registers may be modified by this or future implementations
;    of this function.  The same is true for all RAM page pointer registers in
;    the Large Memory Model.  When necessary, it is the calling function's
;    responsibility to perserve their values across calls to fastcall16 
;    functions.
;
 Counter16_1_wReadCompareValue:
_Counter16_1_wReadCompareValue:
 wCounter16_1_ReadCompareValue:                  ; this name deprecated
_wCounter16_1_ReadCompareValue:                  ; this name deprecated
   RAM_PROLOGUE RAM_USE_CLASS_1
   mov   A, reg[Counter16_1_COMPARE_MSB_REG]
   mov   X, A
   mov   A, reg[Counter16_1_COMPARE_LSB_REG]
   RAM_EPILOGUE RAM_USE_CLASS_1
   ret


.ENDSECTION

.SECTION
;-----------------------------------------------------------------------------
;  FUNCTION NAME: Counter16_1_wReadCounter
;
;  DESCRIPTION:
;     Returns the value in the Count register (DR0), preserving the value in
;     the compare register (DR2). Interrupts are prevented during the transfer
;     from the Count to the Compare registers by holding the clock low in
;     the MSB PSoC block.
;-----------------------------------------------------------------------------
;
;  ARGUMENTS: None
;  RETURNS:   fastcall16 WORD wCount (value of DR0 in the X & A registers)
;  SIDE EFFECTS:
;     1) The user module is stopped momentarily and one or more counts may be missed.
;     2) The A and X registers may be modified by this or future implementations
;        of this function.  The same is true for all RAM page pointer registers in
;        the Large Memory Model.  When necessary, it is the calling function's
;        responsibility to perserve their values across calls to fastcall16 
;        functions.
;
 Counter16_1_wReadCounter:
_Counter16_1_wReadCounter:
 wCounter16_1_ReadCounter:                       ; this name deprecated
_wCounter16_1_ReadCounter:                       ; this name deprecated

   bOrigCompareValue:      EQU   0                  ; Frame offset to temp Compare store
   bOrigControlReg:        EQU   2                  ; Frame offset to temp CR0     store
   bOrigClockSetting:      EQU   3                  ; Frame offset to temp Input   store
   wCounter:               EQU   4                  ; Frame offset to temp Count   store
   STACK_FRAME_SIZE:       EQU   6                  ; max stack frame size is 6 bytes

   RAM_PROLOGUE RAM_USE_CLASS_2
   mov   X, SP                                      ; X <-  stack frame pointer
   mov   A, reg[Counter16_1_COMPARE_MSB_REG]     ; Save the Compare register on the stack
   push  A                                          ;
   mov   A, reg[Counter16_1_COMPARE_LSB_REG]     ;
   push  A                                          ;   -stack frame now 2 bytes-
   mov   A, reg[Counter16_1_CONTROL_LSB_REG]     ; Save CR0 (running or stopped state)
   push  A                                          ;   -stack frame now 3 bytes-
   Counter16_1_Stop_M                            ; Disable (stop) the Counter if running
   M8C_SetBank1                                     ;
   mov   A, reg[Counter16_1_INPUT_LSB_REG]       ; save the LSB clock input setting
   push  A                                          ;   on the stack (now 4 bytes) and ...
                                                    ;   hold the clock low:
   mov   reg[Counter16_1_INPUT_LSB_REG], INPUT_REG_NULL
   M8C_SetBank0                                     ; Extract the Count via DR2 register
   mov   A, reg[Counter16_1_COUNTER_MSB_REG]     ; DR2 <- DR0 (in the MSB block)
   mov   A, reg[Counter16_1_COMPARE_MSB_REG]     ; Stash the Count MSB on the stack
   push  A                                          ;   -stack frame is now 5 bytes
   mov   A, reg[Counter16_1_COUNTER_LSB_REG]     ; DR2 <- DR0 (in the LSB block)
   mov   A, reg[Counter16_1_COMPARE_LSB_REG]     ; Stash the Count LSB on the stack
   push  A                                          ;   -stack frame is now 6 bytes-
   mov   A, [X+bOrigCompareValue]                   ; Restore the Compare MSB register
   mov   reg[Counter16_1_COMPARE_MSB_REG], A     ;
   mov   A, [X+bOrigCompareValue+1]                 ; Restore the Compare LSB register
   mov   reg[Counter16_1_COMPARE_LSB_REG], A     ;
   M8C_SetBank1                                     ; ---Restore the counter operation
   mov   A, [X+bOrigClockSetting]                   ; Grab the LSB clock setting...
   mov   reg[Counter16_1_INPUT_LSB_REG], A       ;   and restore it
   M8C_SetBank0                                     ; Now re-enable (start) the counter
   mov   A, [X+bOrigControlReg]                     ;   if it was running when
   mov   reg[Counter16_1_CONTROL_LSB_REG], A     ;   this function was first called
   pop   A                                          ; Setup the return value
   pop   X                                          ;
   ADD   SP, -(STACK_FRAME_SIZE-2)                  ; Zap remainder of stack frame
   RAM_EPILOGUE RAM_USE_CLASS_2
   ret

.ENDSECTION

; End of File Counter16_1.asm
