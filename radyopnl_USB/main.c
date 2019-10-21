//----------------------------------------------------------------------------
// USB to I2C Bridge 2007
//----------------------------------------------------------------------------

#include <m8c.h>
#include "PSoCAPI.h"
#include "hbheader.h"
#define SLAVE_ADDRESS 18

BYTE    txBuffer[32];  
BYTE    rxBuffer[32]; 
BYTE	cevapbuffer[32];
BYTE    status;  
BYTE *ptr;

WORD cnt;
WORD acnt;
WORD Timeout_d;
void TX(unsigned char slad), RX(unsigned char slad2);

extern BYTE SOF_Flag;
extern BYTE USBFS_1_INTERFACE_0_OUT_RPT_DATA[8];

BYTE OutReport, Count;

#pragma interrupt_handler Counter16_1_ISR
void Counter16_1_ISR(void);

void dly(long int mS), enumerat(void), init_environment(void), shutdwn(void);

/* --------------------- Interrupt handlerlar --------------------------- */
void Counter16_1_ISR() {Counter16_1_DisableInt(); Counter16_1_Stop(); DELAY_CLR;}	//100µSn..5sn lik Gecikme

/* ------------------- Initalizasyon rutinleri -------------------------- */

void shutdwn()
{	USBFS_1_Stop(); I2CHW_1_Stop();}

void init_environment()
{  	M8C_EnableGInt;	USBFS_1_Start(0, USB_5V_OPERATION);
	I2CHW_1_Start();I2CHW_1_EnableMstr();I2CHW_1_EnableInt();}

void enumerat()
{
	while (!USBFS_1_bGetConfiguration());
	USBFS_1_LoadInEP(3, rxBuffer, 1, USB_NO_TOGGLE);
	
	USBFS_1_INT_REG |= USBFS_1_INT_SOF_MASK; PRT2DR|=BSET_6; //Enumeration complete! :)
	USBFS_1_EnableOutEP(2);}

void init_delay_counter(long int mSn, long int DC)
{   Counter16_1_WritePeriod(mSn); Counter16_1_WriteCompareValue(DC); Counter16_1_EnableInt();DELAY_SET; Counter16_1_Start();}
/* ---------------------------------------------------------------------- */

void main()
{	char x;
	init_environment();
	enumerat();

 	dly(10000);
// 	while (!USBFS_1_bGetConfiguration());
//	USBFS_1_LoadInEP(1, rxBuffer, 1, USB_NO_TOGGLE);
//	
//	USBFS_1_INT_REG |= USBFS_1_INT_SOF_MASK;
//	PRT2DR = 0b00010000;	//Ack TAMAM!
//	USBFS_1_EnableOutEP(4);
	txBuffer[6] = 15; txBuffer[7] = 00; txBuffer[8] = 2;
	
	cnt=0; acnt=0; Timeout_d=0;
	dly(50000);
	// HABERLESME OK!!! SELCUK 26.02.2008
	
	while(1) {
		if	(Timeout_d==50000) {PRT4DR&=BCLR_7; Timeout_d=0; shutdwn(); dly(10000); init_environment(); enumerat();} else {Timeout_d++;}

		if (SOF_Flag) {	//buraya 1mSn de bir gelio birader...
			SOF_Flag = 0; Timeout_d=0;
			//rxBuffer[0]=2; rxBuffer[1]=8;	//PC ye gidecek bunnar.
			//PRT0DR|=BSET_1; TX(18);PRT0DR&=BCLR_1; 
			// COMM1=18,  COMM2=16, NAV1=10, NAV2=17, SQUAWK=13, ADF=19, RUDTRM=21
				TX(18);
				RX(18); 
				TX(18);
				RX(18); 
				cevapbuffer[0]=rxBuffer[0];cevapbuffer[1]=rxBuffer[1];cevapbuffer[2]=rxBuffer[2];cevapbuffer[3]=rxBuffer[3];
				cevapbuffer[18]=rxBuffer[4]; //bu sol sag datasii

				TX(10);
				RX(10);	// dikkat bura tehlikeli. ilgili cihazdan yanit gelmez ise, önceki degerleri gelmis gibi yollarrr...
				TX(10);
				RX(10);	// dikkat bura tehlikeli. ilgili cihazdan yanit gelmez ise, önceki degerleri gelmis gibi yollarrr...
				cevapbuffer[4]=rxBuffer[0];cevapbuffer[5]=rxBuffer[1];cevapbuffer[6]=rxBuffer[2];cevapbuffer[7]=rxBuffer[3];

				TX(13);
				RX(13);	// dikkat bura tehlikeli. ilgili cihazdan yanit gelmez ise, önceki degerleri gelmis gibi yollarrr...
				TX(13);
				RX(13);	// dikkat bura tehlikeli. ilgili cihazdan yanit gelmez ise, önceki degerleri gelmis gibi yollarrr...
				cevapbuffer[8]=rxBuffer[0];cevapbuffer[9]=rxBuffer[1];cevapbuffer[10]=rxBuffer[2];cevapbuffer[11]=rxBuffer[3]; cevapbuffer[12]=rxBuffer[4];

				TX(19);
				RX(19);	// dikkat bura tehlikeli. ilgili cihazdan yanit gelmez ise, önceki degerleri gelmis gibi yollarrr...
				TX(19);
				RX(19);	// dikkat bura tehlikeli. ilgili cihazdan yanit gelmez ise, önceki degerleri gelmis gibi yollarrr...
				cevapbuffer[13]=rxBuffer[0];cevapbuffer[14]=rxBuffer[1];cevapbuffer[15]=rxBuffer[2];cevapbuffer[16]=rxBuffer[3]; cevapbuffer[17]=rxBuffer[4];

				TX(17);
				RX(17);	// dikkat bura tehlikeli. ilgili cihazdan yanit gelmez ise, önceki degerleri gelmis gibi yollarrr...
				TX(17);
				RX(17);	// dikkat bura tehlikeli. ilgili cihazdan yanit gelmez ise, önceki degerleri gelmis gibi yollarrr...
				cevapbuffer[21]=rxBuffer[0];cevapbuffer[22]=rxBuffer[1];cevapbuffer[23]=rxBuffer[2];cevapbuffer[24]=rxBuffer[3]; cevapbuffer[25]=rxBuffer[4];


				TX(21);
				RX(21);	// dikkat bura tehlikeli. ilgili cihazdan yanit gelmez ise, önceki degerleri gelmis gibi yollarrr...
				TX(21);
				RX(21);	// dikkat bura tehlikeli. ilgili cihazdan yanit gelmez ise, önceki degerleri gelmis gibi yollarrr...
				cevapbuffer[19]=rxBuffer[0];cevapbuffer[20]=rxBuffer[1];

							
				if (USBFS_1_bGetEPAckState(2)) {
					Count = USBFS_1_bReadOutEP(2, txBuffer, 32);		// PC ne yollamis bak bi.
					USBFS_1_EnableOutEP(2);}
				else {acnt++; if (acnt==500) {USBFS_1_DisableOutEP(2);USBFS_1_EnableOutEP(2); acnt=0;}}

				while(!USBFS_1_bGetEPAckState(3)&&(cnt<5000)){cnt++;}
				//USBFS_1_LoadInEP(3, rxBuffer, 32, USB_TOGGLE);		// PCye gonder getsin.
					USBFS_1_LoadInEP(3, cevapbuffer, 32, USB_TOGGLE);		// PCye gonder getsin.
				cnt=0;
		
}//SOF_Flag kapa
}//while kapa
}//main kapa

void dly(long int mS){init_delay_counter(mS,mS/2); while (DELAY_INVOKE);{}}
void TX(unsigned char slad)  
{
        I2CHW_1_bWriteBytes(slad, txBuffer, 32, I2CHW_1_CompleteXfer);
        if (I2CHW_1_bReadI2CStatus() == I2CHW_WR_COMPLETE) {I2CHW_1_ClrWrStatus();}
}
        
void RX(unsigned char slad2)
{		cnt=0;
  		I2CHW_1_fReadBytes(slad2, rxBuffer, 32, I2CHW_1_CompleteXfer);
   		while((!I2CHW_1_bReadI2CStatus() & I2CHW_RD_COMPLETE)&&(cnt<1000));  
        I2CHW_1_ClrRdStatus();cnt++;
}  