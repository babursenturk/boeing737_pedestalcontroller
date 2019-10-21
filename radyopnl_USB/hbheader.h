	//AÇIKLAMALAR

#define BSET_0   0x0001
#define BSET_1   0x0002
#define BSET_2   0x0004
#define BSET_3   0x0008
#define BSET_4   0x0010
#define BSET_5   0x0020
#define BSET_6   0x0040
#define BSET_7   0x0080
#define BSET_8   0x0100
#define BSET_9   0x0200
#define BSET_10  0x0400
#define BSET_11  0x0800
#define BSET_12  0x1000
#define BSET_13  0x2000
#define BSET_14  0x4000
#define BSET_15  0x8000

#define BCLR_0   0xFFFE
#define BCLR_1   0xFFFD
#define BCLR_2   0xFFFB
#define BCLR_3   0xFFF7
#define BCLR_4   0xFFEF
#define BCLR_5   0xFFDF
#define BCLR_6   0xFFBF
#define BCLR_7   0xFF7F
#define BCLR_8   0xFEFF
#define BCLR_9   0xFDFF
#define BCLR_10  0xFBFF
#define BCLR_11  0xF7FF
#define BCLR_12  0xEFFF
#define BCLR_13  0xDFFF
#define BCLR_14  0xBFFF
#define BCLR_15  0x7FFF

int STATUS = 0;

#define DELAY_SET				STATUS|=BSET_0
#define DELAY_CLR				STATUS&=BCLR_0
#define DELAY_INVOKE			(STATUS&BSET_0)
