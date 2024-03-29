; Generated by PSoC Designer ver 4.4  b1884 : 14 Jan, 2007
;
; I2CHW_1SDA address and mask equates
I2CHW_1SDA_Data_ADDR:	equ	4h
I2CHW_1SDA_DriveMode_0_ADDR:	equ	104h
I2CHW_1SDA_DriveMode_1_ADDR:	equ	105h
I2CHW_1SDA_DriveMode_2_ADDR:	equ	7h
I2CHW_1SDA_GlobalSelect_ADDR:	equ	6h
I2CHW_1SDA_IntCtrl_0_ADDR:	equ	106h
I2CHW_1SDA_IntCtrl_1_ADDR:	equ	107h
I2CHW_1SDA_IntEn_ADDR:	equ	5h
I2CHW_1SDA_MASK:	equ	20h
I2CHW_1SDA_MUXBusCtrl_ADDR:	equ	1d9h
; I2CHW_1SDA_Data access macros
;   GetI2CHW_1SDA_Data macro, return in a
macro GetI2CHW_1SDA_Data
	mov		a,[Port_1_Data_SHADE]
	and		a, 20h
endm
;   SetI2CHW_1SDA_Data macro
macro SetI2CHW_1SDA_Data
	or		[Port_1_Data_SHADE], 20h
	mov		reg[Port_1_Data], [Port_1_Data_SHADE]
endm
;   SetI2CHW_1SDA_Data macro
macro ClearI2CHW_1SDA_Data
	and		[Port_1_Data_SHADE], ~20h
	mov		reg[Port_1_Data], [Port_1_Data_SHADE]
endm

; I2CHW_1SCL address and mask equates
I2CHW_1SCL_Data_ADDR:	equ	4h
I2CHW_1SCL_DriveMode_0_ADDR:	equ	104h
I2CHW_1SCL_DriveMode_1_ADDR:	equ	105h
I2CHW_1SCL_DriveMode_2_ADDR:	equ	7h
I2CHW_1SCL_GlobalSelect_ADDR:	equ	6h
I2CHW_1SCL_IntCtrl_0_ADDR:	equ	106h
I2CHW_1SCL_IntCtrl_1_ADDR:	equ	107h
I2CHW_1SCL_IntEn_ADDR:	equ	5h
I2CHW_1SCL_MASK:	equ	80h
I2CHW_1SCL_MUXBusCtrl_ADDR:	equ	1d9h
; I2CHW_1SCL_Data access macros
;   GetI2CHW_1SCL_Data macro, return in a
macro GetI2CHW_1SCL_Data
	mov		a,[Port_1_Data_SHADE]
	and		a, 80h
endm
;   SetI2CHW_1SCL_Data macro
macro SetI2CHW_1SCL_Data
	or		[Port_1_Data_SHADE], 80h
	mov		reg[Port_1_Data], [Port_1_Data_SHADE]
endm
;   SetI2CHW_1SCL_Data macro
macro ClearI2CHW_1SCL_Data
	and		[Port_1_Data_SHADE], ~80h
	mov		reg[Port_1_Data], [Port_1_Data_SHADE]
endm

