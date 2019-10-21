	cpu LMM
	.module main.c
	.area data(ram, con, rel)
_STATUS::
	.word 0
	.dbfile ./hbheader.h
	.dbsym e STATUS _STATUS I
	.area data(ram, con, rel)
	.dbfile ./hbheader.h
	.area text(rom, con, rel)
	.dbfile ./hbheader.h
	.dbfile ./main.c
	.dbfunc e Counter16_1_ISR _Counter16_1_ISR fV
_Counter16_1_ISR::
	.dbline -1
	or F,-64
	push A
	mov A,REG[0xd0]
	push A
	mov A,REG[0xd3]
	push A
	mov A,REG[0xd4]
	push A
	mov A,REG[0xd5]
	push A
	mov REG[0xd0],>__r0
	mov A,[__r0]
	push A
	mov A,[__r1]
	push A
	mov A,[__r2]
	push A
	mov A,[__r3]
	push A
	mov A,[__r4]
	push A
	mov A,[__r5]
	push A
	mov A,[__r6]
	push A
	mov A,[__r7]
	push A
	mov A,[__r8]
	push A
	mov A,[__r9]
	push A
	mov A,[__r10]
	push A
	mov A,[__r11]
	push A
	mov A,[__rX]
	push A
	mov A,[__rY]
	push A
	mov A,[__rZ]
	push A
	.dbline 32
; //----------------------------------------------------------------------------
; // USB to I2C Bridge 2007
; //----------------------------------------------------------------------------
; 
; #include <m8c.h>
; #include "PSoCAPI.h"
; #include "hbheader.h"
; #define SLAVE_ADDRESS 18
; 
; BYTE    txBuffer[32];  
; BYTE    rxBuffer[32]; 
; BYTE	cevapbuffer[32];
; BYTE    status;  
; BYTE *ptr;
; 
; WORD cnt;
; WORD acnt;
; WORD Timeout_d;
; void TX(unsigned char slad), RX(unsigned char slad2);
; 
; extern BYTE SOF_Flag;
; extern BYTE USBFS_1_INTERFACE_0_OUT_RPT_DATA[8];
; 
; BYTE OutReport, Count;
; 
; #pragma interrupt_handler Counter16_1_ISR
; void Counter16_1_ISR(void);
; 
; void dly(long int mS), enumerat(void), init_environment(void), shutdwn(void);
; 
; /* --------------------- Interrupt handlerlar --------------------------- */
; void Counter16_1_ISR() {Counter16_1_DisableInt(); Counter16_1_Stop(); DELAY_CLR;}	//100µSn..5sn lik Gecikme
	.dbline 32
	push X
	xcall _Counter16_1_DisableInt
	.dbline 32
	xcall _Counter16_1_Stop
	pop X
	.dbline 32
	mov REG[0xd0],>_STATUS
	mov A,[_STATUS+1]
	and A,-2
	mov REG[0xd0],>__r0
	mov [__r1],A
	mov REG[0xd0],>_STATUS
	mov A,[_STATUS]
	mov REG[0xd0],>__r0
	mov [__r0],A
	mov A,[__r1]
	push A
	mov A,[__r0]
	mov REG[0xd0],>_STATUS
	mov [_STATUS],A
	pop A
	mov [_STATUS+1],A
	.dbline -2
	.dbline 32
L2:
	mov REG[0xD0],>__r0
	pop A
	mov [__rZ],A
	pop A
	mov [__rY],A
	pop A
	mov [__rX],A
	pop A
	mov [__r11],A
	pop A
	mov [__r10],A
	pop A
	mov [__r9],A
	pop A
	mov [__r8],A
	pop A
	mov [__r7],A
	pop A
	mov [__r6],A
	pop A
	mov [__r5],A
	pop A
	mov [__r4],A
	pop A
	mov [__r3],A
	pop A
	mov [__r2],A
	pop A
	mov [__r1],A
	pop A
	mov [__r0],A
	pop A
	mov REG[213],A
	pop A
	mov REG[212],A
	pop A
	mov REG[211],A
	pop A
	mov REG[208],A
	pop A
	.dbline 0 ; func end
	reti
	.dbend
	.dbfunc e shutdwn _shutdwn fV
_shutdwn::
	.dbline -1
	.dbline 37
; 
; /* ------------------- Initalizasyon rutinleri -------------------------- */
; 
; void shutdwn()
; {	USBFS_1_Stop(); I2CHW_1_Stop();}
	.dbline 37
	push X
	xcall _USBFS_1_Stop
	.dbline 37
	xcall _I2CHW_1_Stop
	pop X
	.dbline -2
	.dbline 37
L3:
	.dbline 0 ; func end
	ret
	.dbend
	.dbfunc e init_environment _init_environment fV
_init_environment::
	.dbline -1
	.dbline 40
; 
; void init_environment()
; {  	M8C_EnableGInt;	USBFS_1_Start(0, USB_5V_OPERATION);
	.dbline 40
		or  F, 01h

	.dbline 40
	push X
	mov X,3
	mov A,0
	xcall _USBFS_1_Start
	.dbline 41
; 	I2CHW_1_Start();I2CHW_1_EnableMstr();I2CHW_1_EnableInt();}
	xcall _I2CHW_1_Start
	.dbline 41
	xcall _I2CHW_1_EnableMstr
	.dbline 41
	xcall _I2CHW_1_EnableInt
	pop X
	.dbline -2
	.dbline 41
L4:
	.dbline 0 ; func end
	ret
	.dbend
	.dbfunc e enumerat _enumerat fV
_enumerat::
	.dbline -1
	.dbline 44
; 
; void enumerat()
; {
L6:
	.dbline 45
L7:
	.dbline 45
; 	while (!USBFS_1_bGetConfiguration());
	push X
	xcall _USBFS_1_bGetConfiguration
	mov REG[0xd0],>__r0
	pop X
	cmp A,0
	jz L6
	.dbline 46
; 	USBFS_1_LoadInEP(3, rxBuffer, 1, USB_NO_TOGGLE);
	push X
	mov A,0
	push A
	push A
	mov A,1
	push A
	mov A,>_rxBuffer
	push A
	mov A,<_rxBuffer
	push A
	mov A,3
	push A
	xcall _USBFS_1_LoadInEP
	add SP,-6
	pop X
	.dbline 48
; 	
; 	USBFS_1_INT_REG |= USBFS_1_INT_SOF_MASK; PRT2DR|=BSET_6; //Enumeration complete! :)
	or REG[0xdf],2
	.dbline 48
	or REG[0x8],64
	.dbline 49
; 	USBFS_1_EnableOutEP(2);}
	push X
	mov A,2
	xcall _USBFS_1_EnableOutEP
	pop X
	.dbline -2
	.dbline 49
L5:
	.dbline 0 ; func end
	ret
	.dbend
	.dbfunc e init_delay_counter _init_delay_counter fV
;             DC -> X-11
;            mSn -> X-7
_init_delay_counter::
	.dbline -1
	push X
	mov X,SP
	.dbline 52
; 
; void init_delay_counter(long int mSn, long int DC)
; {   Counter16_1_WritePeriod(mSn); Counter16_1_WriteCompareValue(DC); Counter16_1_EnableInt();DELAY_SET; Counter16_1_Start();}
	.dbline 52
	mov REG[0xd0],>__r0
	mov A,[X-4]
	mov [__r1],A
	mov A,[X-5]
	push X
	push A
	mov A,[__r1]
	pop X
	xcall _Counter16_1_WritePeriod
	pop X
	.dbline 52
	mov REG[0xd0],>__r0
	mov A,[X-8]
	mov [__r1],A
	mov A,[X-9]
	push X
	push A
	mov A,[__r1]
	pop X
	xcall _Counter16_1_WriteCompareValue
	.dbline 52
	xcall _Counter16_1_EnableInt
	pop X
	.dbline 52
	mov REG[0xd0],>_STATUS
	or [_STATUS+1],1
	.dbline 52
	push X
	xcall _Counter16_1_Start
	pop X
	.dbline -2
	.dbline 52
L9:
	pop X
	.dbline 0 ; func end
	ret
	.dbsym l DC -11 L
	.dbsym l mSn -7 L
	.dbend
	.dbfunc e main _main fV
;              x -> X+0
_main::
	.dbline -1
	push X
	mov X,SP
	add SP,1
	.dbline 56
; /* ---------------------------------------------------------------------- */
; 
; void main()
; {	char x;
	.dbline 57
; 	init_environment();
	xcall _init_environment
	.dbline 58
; 	enumerat();
	xcall _enumerat
	.dbline 60
; 
;  	dly(10000);
	mov A,0
	push A
	push A
	mov A,39
	push A
	mov A,16
	push A
	xcall _dly
	.dbline 67
; // 	while (!USBFS_1_bGetConfiguration());
; //	USBFS_1_LoadInEP(1, rxBuffer, 1, USB_NO_TOGGLE);
; //	
; //	USBFS_1_INT_REG |= USBFS_1_INT_SOF_MASK;
; //	PRT2DR = 0b00010000;	//Ack TAMAM!
; //	USBFS_1_EnableOutEP(4);
; 	txBuffer[6] = 15; txBuffer[7] = 00; txBuffer[8] = 2;
	mov REG[0xd0],>_txBuffer
	mov [_txBuffer+6],15
	.dbline 67
	mov [_txBuffer+7],0
	.dbline 67
	mov [_txBuffer+8],2
	.dbline 69
; 	
; 	cnt=0; acnt=0; Timeout_d=0;
	mov REG[0xd0],>_cnt
	mov [_cnt+1],0
	mov [_cnt],0
	.dbline 69
	mov REG[0xd0],>_acnt
	mov [_acnt+1],0
	mov [_acnt],0
	.dbline 69
	mov REG[0xd0],>_Timeout_d
	mov [_Timeout_d+1],0
	mov [_Timeout_d],0
	.dbline 70
; 	dly(50000);
	mov A,0
	push A
	push A
	mov A,-61
	push A
	mov A,80
	push A
	xcall _dly
	add SP,-8
	xjmp L15
L14:
	.dbline 73
; 	// HABERLESME OK!!! SELCUK 26.02.2008
; 	
; 	while(1) {
	.dbline 74
	mov REG[0xd0],>_Timeout_d
	mov A,[_Timeout_d+1]
	mov REG[0xd0],>__r0
	mov [__r3],A
	mov REG[0xd0],>_Timeout_d
	mov A,[_Timeout_d]
	mov REG[0xd0],>__r0
	mov [__r1],0
	mov [__r0],0
	cmp [__r0],0
	jnz L17
	cmp [__r1],0
	jnz L17
	cmp A,-61
	jnz L17
	cmp [__r3],80
	jnz L17
X1:
	.dbline 74
	.dbline 74
	mov A,REG[0x10]
	mov REG[0xd0],>__r0
	mov [__r0],A
	and [__r0],127
	mov A,[__r0]
	mov REG[0x10],A
	.dbline 74
	mov REG[0xd0],>_Timeout_d
	mov [_Timeout_d+1],0
	mov [_Timeout_d],0
	.dbline 74
	xcall _shutdwn
	.dbline 74
	mov A,0
	push A
	push A
	mov A,39
	push A
	mov A,16
	push A
	xcall _dly
	add SP,-4
	.dbline 74
	xcall _init_environment
	.dbline 74
	xcall _enumerat
	.dbline 74
	xjmp L18
L17:
	.dbline 74
; 		if	(Timeout_d==50000) {PRT4DR&=BCLR_7; Timeout_d=0; shutdwn(); dly(10000); init_environment(); enumerat();} else {Timeout_d++;}
	.dbline 74
	mov REG[0xd0],>_Timeout_d
	inc [_Timeout_d+1]
	adc [_Timeout_d],0
	.dbline 74
L18:
	.dbline 76
; 
; 		if (SOF_Flag) {	//buraya 1mSn de bir gelio birader...
	mov REG[0xd0],>_SOF_Flag
	cmp [_SOF_Flag],0
	jz L19
	.dbline 76
	.dbline 77
; 			SOF_Flag = 0; Timeout_d=0;
	mov [_SOF_Flag],0
	.dbline 77
	mov REG[0xd0],>_Timeout_d
	mov [_Timeout_d+1],0
	mov [_Timeout_d],0
	.dbline 80
; 			//rxBuffer[0]=2; rxBuffer[1]=8;	//PC ye gidecek bunnar.
; 			//PRT0DR|=BSET_1; TX(18);PRT0DR&=BCLR_1; 
; 				TX(18);
	mov A,18
	push A
	xcall _TX
	.dbline 81
; 				RX(18); 
	mov A,18
	push A
	xcall _RX
	add SP,-2
	.dbline 82
; 				TX(18);
	mov A,18
	push A
	xcall _TX
	.dbline 83
; 				RX(18); 
	mov A,18
	push A
	xcall _RX
	add SP,-2
	.dbline 84
; 				cevapbuffer[0]=rxBuffer[0];cevapbuffer[1]=rxBuffer[1];cevapbuffer[2]=rxBuffer[2];cevapbuffer[3]=rxBuffer[3];
	mov REG[0xd0],>_rxBuffer
	mov A,[_rxBuffer]
	mov REG[0xd0],>_cevapbuffer
	mov [_cevapbuffer],A
	.dbline 84
	mov REG[0xd0],>_rxBuffer
	mov A,[_rxBuffer+1]
	mov REG[0xd0],>_cevapbuffer
	mov [_cevapbuffer+1],A
	.dbline 84
	mov REG[0xd0],>_rxBuffer
	mov A,[_rxBuffer+2]
	mov REG[0xd0],>_cevapbuffer
	mov [_cevapbuffer+2],A
	.dbline 84
	mov REG[0xd0],>_rxBuffer
	mov A,[_rxBuffer+3]
	mov REG[0xd0],>_cevapbuffer
	mov [_cevapbuffer+3],A
	.dbline 85
; 				cevapbuffer[18]=rxBuffer[4]; //bu sol sag datasii
	mov REG[0xd0],>_rxBuffer
	mov A,[_rxBuffer+4]
	mov REG[0xd0],>_cevapbuffer
	mov [_cevapbuffer+18],A
	.dbline 87
; 
; 				TX(10);
	mov A,10
	push A
	xcall _TX
	.dbline 88
; 				RX(10);	// dikkat bura tehlikeli. ilgili cihazdan yanit gelmez ise, önceki degerleri gelmis gibi yollarrr...
	mov A,10
	push A
	xcall _RX
	add SP,-2
	.dbline 89
; 				TX(10);
	mov A,10
	push A
	xcall _TX
	.dbline 90
; 				RX(10);	// dikkat bura tehlikeli. ilgili cihazdan yanit gelmez ise, önceki degerleri gelmis gibi yollarrr...
	mov A,10
	push A
	xcall _RX
	add SP,-2
	.dbline 91
; 				cevapbuffer[4]=rxBuffer[0];cevapbuffer[5]=rxBuffer[1];cevapbuffer[6]=rxBuffer[2];cevapbuffer[7]=rxBuffer[3];
	mov REG[0xd0],>_rxBuffer
	mov A,[_rxBuffer]
	mov REG[0xd0],>_cevapbuffer
	mov [_cevapbuffer+4],A
	.dbline 91
	mov REG[0xd0],>_rxBuffer
	mov A,[_rxBuffer+1]
	mov REG[0xd0],>_cevapbuffer
	mov [_cevapbuffer+5],A
	.dbline 91
	mov REG[0xd0],>_rxBuffer
	mov A,[_rxBuffer+2]
	mov REG[0xd0],>_cevapbuffer
	mov [_cevapbuffer+6],A
	.dbline 91
	mov REG[0xd0],>_rxBuffer
	mov A,[_rxBuffer+3]
	mov REG[0xd0],>_cevapbuffer
	mov [_cevapbuffer+7],A
	.dbline 93
; 
; 				TX(13);
	mov A,13
	push A
	xcall _TX
	.dbline 94
; 				RX(13);	// dikkat bura tehlikeli. ilgili cihazdan yanit gelmez ise, önceki degerleri gelmis gibi yollarrr...
	mov A,13
	push A
	xcall _RX
	add SP,-2
	.dbline 95
; 				TX(13);
	mov A,13
	push A
	xcall _TX
	.dbline 96
; 				RX(13);	// dikkat bura tehlikeli. ilgili cihazdan yanit gelmez ise, önceki degerleri gelmis gibi yollarrr...
	mov A,13
	push A
	xcall _RX
	add SP,-2
	.dbline 97
; 				cevapbuffer[8]=rxBuffer[0];cevapbuffer[9]=rxBuffer[1];cevapbuffer[10]=rxBuffer[2];cevapbuffer[11]=rxBuffer[3]; cevapbuffer[12]=rxBuffer[4];
	mov REG[0xd0],>_rxBuffer
	mov A,[_rxBuffer]
	mov REG[0xd0],>_cevapbuffer
	mov [_cevapbuffer+8],A
	.dbline 97
	mov REG[0xd0],>_rxBuffer
	mov A,[_rxBuffer+1]
	mov REG[0xd0],>_cevapbuffer
	mov [_cevapbuffer+9],A
	.dbline 97
	mov REG[0xd0],>_rxBuffer
	mov A,[_rxBuffer+2]
	mov REG[0xd0],>_cevapbuffer
	mov [_cevapbuffer+10],A
	.dbline 97
	mov REG[0xd0],>_rxBuffer
	mov A,[_rxBuffer+3]
	mov REG[0xd0],>_cevapbuffer
	mov [_cevapbuffer+11],A
	.dbline 97
	mov REG[0xd0],>_rxBuffer
	mov A,[_rxBuffer+4]
	mov REG[0xd0],>_cevapbuffer
	mov [_cevapbuffer+12],A
	.dbline 99
; 
; 				TX(19);
	mov A,19
	push A
	xcall _TX
	.dbline 100
; 				RX(19);	// dikkat bura tehlikeli. ilgili cihazdan yanit gelmez ise, önceki degerleri gelmis gibi yollarrr...
	mov A,19
	push A
	xcall _RX
	add SP,-2
	.dbline 101
; 				TX(19);
	mov A,19
	push A
	xcall _TX
	.dbline 102
; 				RX(19);	// dikkat bura tehlikeli. ilgili cihazdan yanit gelmez ise, önceki degerleri gelmis gibi yollarrr...
	mov A,19
	push A
	xcall _RX
	add SP,-2
	.dbline 103
; 				cevapbuffer[13]=rxBuffer[0];cevapbuffer[14]=rxBuffer[1];cevapbuffer[15]=rxBuffer[2];cevapbuffer[16]=rxBuffer[3]; cevapbuffer[17]=rxBuffer[4];
	mov REG[0xd0],>_rxBuffer
	mov A,[_rxBuffer]
	mov REG[0xd0],>_cevapbuffer
	mov [_cevapbuffer+13],A
	.dbline 103
	mov REG[0xd0],>_rxBuffer
	mov A,[_rxBuffer+1]
	mov REG[0xd0],>_cevapbuffer
	mov [_cevapbuffer+14],A
	.dbline 103
	mov REG[0xd0],>_rxBuffer
	mov A,[_rxBuffer+2]
	mov REG[0xd0],>_cevapbuffer
	mov [_cevapbuffer+15],A
	.dbline 103
	mov REG[0xd0],>_rxBuffer
	mov A,[_rxBuffer+3]
	mov REG[0xd0],>_cevapbuffer
	mov [_cevapbuffer+16],A
	.dbline 103
	mov REG[0xd0],>_rxBuffer
	mov A,[_rxBuffer+4]
	mov REG[0xd0],>_cevapbuffer
	mov [_cevapbuffer+17],A
	.dbline 105
; 
; 				TX(17);
	mov A,17
	push A
	xcall _TX
	.dbline 106
; 				RX(17);	// dikkat bura tehlikeli. ilgili cihazdan yanit gelmez ise, önceki degerleri gelmis gibi yollarrr...
	mov A,17
	push A
	xcall _RX
	add SP,-2
	.dbline 107
; 				TX(17);
	mov A,17
	push A
	xcall _TX
	.dbline 108
; 				RX(17);	// dikkat bura tehlikeli. ilgili cihazdan yanit gelmez ise, önceki degerleri gelmis gibi yollarrr...
	mov A,17
	push A
	xcall _RX
	add SP,-2
	.dbline 109
; 				cevapbuffer[21]=rxBuffer[0];cevapbuffer[22]=rxBuffer[1];cevapbuffer[23]=rxBuffer[2];cevapbuffer[24]=rxBuffer[3]; cevapbuffer[25]=rxBuffer[4];
	mov REG[0xd0],>_rxBuffer
	mov A,[_rxBuffer]
	mov REG[0xd0],>_cevapbuffer
	mov [_cevapbuffer+21],A
	.dbline 109
	mov REG[0xd0],>_rxBuffer
	mov A,[_rxBuffer+1]
	mov REG[0xd0],>_cevapbuffer
	mov [_cevapbuffer+22],A
	.dbline 109
	mov REG[0xd0],>_rxBuffer
	mov A,[_rxBuffer+2]
	mov REG[0xd0],>_cevapbuffer
	mov [_cevapbuffer+23],A
	.dbline 109
	mov REG[0xd0],>_rxBuffer
	mov A,[_rxBuffer+3]
	mov REG[0xd0],>_cevapbuffer
	mov [_cevapbuffer+24],A
	.dbline 109
	mov REG[0xd0],>_rxBuffer
	mov A,[_rxBuffer+4]
	mov REG[0xd0],>_cevapbuffer
	mov [_cevapbuffer+25],A
	.dbline 112
; 
; 
; 				TX(21);
	mov A,21
	push A
	xcall _TX
	.dbline 113
; 				RX(21);	// dikkat bura tehlikeli. ilgili cihazdan yanit gelmez ise, önceki degerleri gelmis gibi yollarrr...
	mov A,21
	push A
	xcall _RX
	add SP,-2
	.dbline 114
; 				TX(21);
	mov A,21
	push A
	xcall _TX
	.dbline 115
; 				RX(21);	// dikkat bura tehlikeli. ilgili cihazdan yanit gelmez ise, önceki degerleri gelmis gibi yollarrr...
	mov A,21
	push A
	xcall _RX
	add SP,-2
	.dbline 116
; 				cevapbuffer[19]=rxBuffer[0];cevapbuffer[20]=rxBuffer[1];
	mov REG[0xd0],>_rxBuffer
	mov A,[_rxBuffer]
	mov REG[0xd0],>_cevapbuffer
	mov [_cevapbuffer+19],A
	.dbline 116
	mov REG[0xd0],>_rxBuffer
	mov A,[_rxBuffer+1]
	mov REG[0xd0],>_cevapbuffer
	mov [_cevapbuffer+20],A
	.dbline 119
; 
; 							
; 				if (USBFS_1_bGetEPAckState(2)) {
	push X
	mov A,2
	xcall _USBFS_1_bGetEPAckState
	mov REG[0xd0],>__r0
	pop X
	cmp A,0
	jz L66
	.dbline 119
	.dbline 120
; 					Count = USBFS_1_bReadOutEP(2, txBuffer, 32);		// PC ne yollamis bak bi.
	push X
	mov A,0
	push A
	mov A,32
	push A
	mov A,>_txBuffer
	push A
	mov A,<_txBuffer
	push A
	mov A,2
	push A
	xcall _USBFS_1_bReadOutEP
	add SP,-5
	pop X
	mov REG[0xd0],>_Count
	mov [_Count],A
	.dbline 121
; 					USBFS_1_EnableOutEP(2);}
	push X
	mov A,2
	xcall _USBFS_1_EnableOutEP
	pop X
	.dbline 121
	xjmp L71
L66:
	.dbline 122
; 				else {acnt++; if (acnt==500) {USBFS_1_DisableOutEP(2);USBFS_1_EnableOutEP(2); acnt=0;}}
	.dbline 122
	mov REG[0xd0],>_acnt
	inc [_acnt+1]
	adc [_acnt],0
	.dbline 122
	cmp [_acnt],1
	jnz L71
	cmp [_acnt+1],-12
	jnz L71
X2:
	.dbline 122
	.dbline 122
	push X
	mov A,2
	xcall _USBFS_1_DisableOutEP
	.dbline 122
	mov A,2
	xcall _USBFS_1_EnableOutEP
	pop X
	.dbline 122
	mov REG[0xd0],>_acnt
	mov [_acnt+1],0
	mov [_acnt],0
	.dbline 122
	.dbline 122
	xjmp L71
L70:
	.dbline 124
	.dbline 124
	mov REG[0xd0],>_cnt
	inc [_cnt+1]
	adc [_cnt],0
	.dbline 124
L71:
	.dbline 124
; 
; 				while(!USBFS_1_bGetEPAckState(3)&&(cnt<5000)){cnt++;}
	push X
	mov A,3
	xcall _USBFS_1_bGetEPAckState
	pop X
	cmp A,0
	jnz L73
	mov REG[0xd0],>_cnt
	mov A,[_cnt+1]
	sub A,-120
	mov A,[_cnt]
	sbb A,19
	jc L70
X3:
L73:
	.dbline 126
; 				//USBFS_1_LoadInEP(3, rxBuffer, 32, USB_TOGGLE);		// PCye gonder getsin.
; 					USBFS_1_LoadInEP(3, cevapbuffer, 32, USB_TOGGLE);		// PCye gonder getsin.
	push X
	mov A,1
	push A
	mov A,0
	push A
	mov A,32
	push A
	mov A,>_cevapbuffer
	push A
	mov A,<_cevapbuffer
	push A
	mov A,3
	push A
	xcall _USBFS_1_LoadInEP
	add SP,-6
	pop X
	.dbline 127
; 				cnt=0;
	mov REG[0xd0],>_cnt
	mov [_cnt+1],0
	mov [_cnt],0
	.dbline 129
; 		
; }//SOF_Flag kapa
L19:
	.dbline 130
L15:
	.dbline 73
	xjmp L14
X0:
	.dbline -2
	.dbline 131
; }//while kapa
; }//main kapa
L10:
	add SP,-1
	pop X
	.dbline 0 ; func end
	jmp .
	.dbsym l x 0 c
	.dbend
	.dbfunc e dly _dly fV
;             mS -> X-7
_dly::
	.dbline -1
	push X
	mov X,SP
	.dbline 133
	.dbline 133
	mov REG[0xd0],>__r0
	mov A,0
	push A
	push A
	push A
	mov A,2
	push A
	mov A,[X-7]
	push A
	mov A,[X-6]
	push A
	mov A,[X-5]
	push A
	mov A,[X-4]
	push A
	xcall __divmod_32X32_32
	pop A
	mov [__r3],A
	pop A
	mov [__r2],A
	pop A
	mov [__r1],A
	pop A
	add SP,-4
	push A
	mov A,[__r1]
	push A
	mov A,[__r2]
	push A
	mov A,[__r3]
	push A
	mov A,[X-7]
	push A
	mov A,[X-6]
	push A
	mov A,[X-5]
	push A
	mov A,[X-4]
	push A
	xcall _init_delay_counter
	add SP,-8
L75:
	.dbline 133
L76:
	.dbline 133
; 
; void dly(long int mS){init_delay_counter(mS,mS/2); while (DELAY_INVOKE);{}}
	mov REG[0xd0],>_STATUS
	mov A,[_STATUS+1]
	and A,1
	mov REG[0xd0],>__r0
	mov [__r1],A
	mov REG[0xd0],>_STATUS
	mov A,[_STATUS]
	and A,0
	mov REG[0xd0],>__r0
	cmp A,0
	jnz L75
	cmp [__r1],0
	jnz L75
X4:
	.dbline 133
	.dbline 133
	.dbline -2
	.dbline 133
L74:
	pop X
	.dbline 0 ; func end
	ret
	.dbsym l mS -7 L
	.dbend
	.dbfunc e TX _TX fV
;           slad -> X-4
_TX::
	.dbline -1
	push X
	mov X,SP
	.dbline 135
	.dbline 136
	push X
	mov A,0
	push A
	mov A,32
	push A
	mov A,>_txBuffer
	push A
	mov A,<_txBuffer
	push A
	mov A,[X-4]
	push A
	xcall _I2CHW_1_bWriteBytes
	add SP,-5
	.dbline 137
	xcall _I2CHW_1_bReadI2CStatus
	mov REG[0xd0],>__r0
	pop X
	cmp A,64
	jnz L79
	.dbline 137
	.dbline 137
	push X
	xcall _I2CHW_1_ClrWrStatus
	pop X
	.dbline 137
L79:
	.dbline -2
	.dbline 138
; void TX(unsigned char slad)  
; {
;         I2CHW_1_bWriteBytes(slad, txBuffer, 32, I2CHW_1_CompleteXfer);
;         if (I2CHW_1_bReadI2CStatus() == I2CHW_WR_COMPLETE) {I2CHW_1_ClrWrStatus();}
; }
L78:
	pop X
	.dbline 0 ; func end
	ret
	.dbsym l slad -4 c
	.dbend
	.dbfunc e RX _RX fV
;          slad2 -> X-4
_RX::
	.dbline -1
	push X
	mov X,SP
	add SP,2
	.dbline 141
;         
; void RX(unsigned char slad2)
; {		cnt=0;
	.dbline 141
	mov REG[0xd0],>_cnt
	mov [_cnt+1],0
	mov [_cnt],0
	.dbline 142
;   		I2CHW_1_fReadBytes(slad2, rxBuffer, 32, I2CHW_1_CompleteXfer);
	push X
	mov A,0
	push A
	mov A,32
	push A
	mov A,>_rxBuffer
	push A
	mov A,<_rxBuffer
	push A
	mov A,[X-4]
	push A
	xcall _I2CHW_1_fReadBytes
	add SP,-5
	pop X
L82:
	.dbline 143
L83:
	.dbline 143
;    		while((!I2CHW_1_bReadI2CStatus() & I2CHW_RD_COMPLETE)&&(cnt<1000));  
	push X
	xcall _I2CHW_1_bReadI2CStatus
	mov REG[0xd0],>__r0
	pop X
	cmp A,0
	jnz L87
	mov [X+1],1
	mov [X+0],0
	xjmp L88
L87:
	mov [X+1],0
	mov [X+0],0
L88:
	mov REG[0xd0],>__r0
	mov A,[X+1]
	and A,4
	mov [__r1],A
	mov A,[X+0]
	and A,0
	cmp A,0
	jnz X5
	cmp [__r1],0
	jz L86
X5:
	mov REG[0xd0],>_cnt
	mov A,[_cnt+1]
	sub A,-24
	mov A,[_cnt]
	sbb A,3
	jc L82
X6:
L86:
	.dbline 144
;         I2CHW_1_ClrRdStatus();cnt++;
	push X
	xcall _I2CHW_1_ClrRdStatus
	pop X
	.dbline 144
	mov REG[0xd0],>_cnt
	inc [_cnt+1]
	adc [_cnt],0
	.dbline -2
	.dbline 145
; }  
L81:
	add SP,-2
	pop X
	.dbline 0 ; func end
	ret
	.dbsym l slad2 -4 c
	.dbend
	.area data(ram, con, rel)
	.dbfile ./main.c
_Count::
	.byte 0
	.dbsym e Count _Count c
	.area data(ram, con, rel)
	.dbfile ./main.c
_OutReport::
	.byte 0
	.dbsym e OutReport _OutReport c
	.area data(ram, con, rel)
	.dbfile ./main.c
_Timeout_d::
	.byte 0,0
	.dbsym e Timeout_d _Timeout_d i
	.area data(ram, con, rel)
	.dbfile ./main.c
_acnt::
	.byte 0,0
	.dbsym e acnt _acnt i
	.area data(ram, con, rel)
	.dbfile ./main.c
_cnt::
	.byte 0,0
	.dbsym e cnt _cnt i
	.area data(ram, con, rel)
	.dbfile ./main.c
_ptr::
	.byte 0,0
	.dbsym e ptr _ptr pc
	.area data(ram, con, rel)
	.dbfile ./main.c
_status::
	.byte 0
	.dbsym e status _status c
	.area data(ram, con, rel)
	.dbfile ./main.c
_cevapbuffer::
	.word 0,0,0,0,0
	.word 0,0,0,0,0
	.word 0,0,0,0,0
	.byte 0,0
	.dbsym e cevapbuffer _cevapbuffer A[32:32]c
	.area data(ram, con, rel)
	.dbfile ./main.c
_rxBuffer::
	.word 0,0,0,0,0
	.word 0,0,0,0,0
	.word 0,0,0,0,0
	.byte 0,0
	.dbsym e rxBuffer _rxBuffer A[32:32]c
	.area data(ram, con, rel)
	.dbfile ./main.c
_txBuffer::
	.word 0,0,0,0,0
	.word 0,0,0,0,0
	.word 0,0,0,0,0
	.byte 0,0
	.dbsym e txBuffer _txBuffer A[32:32]c
