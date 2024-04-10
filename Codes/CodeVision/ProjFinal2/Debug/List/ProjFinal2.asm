
;CodeVisionAVR C Compiler V3.12 Advanced
;(C) Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Build configuration    : Debug
;Chip type              : ATmega32
;Program type           : Application
;Clock frequency        : 8.000000 MHz
;Memory model           : Small
;Optimize for           : Size
;(s)printf features     : int, width
;(s)scanf features      : int, width
;External RAM size      : 0
;Data Stack size        : 512 byte(s)
;Heap size              : 0 byte(s)
;Promote 'char' to 'int': Yes
;'char' is unsigned     : Yes
;8 bit enums            : Yes
;Global 'const' stored in FLASH: Yes
;Enhanced function parameter passing: Yes
;Enhanced core instructions: On
;Automatic register allocation for global variables: On
;Smart register allocation: On

	#define _MODEL_SMALL_

	#pragma AVRPART ADMIN PART_NAME ATmega32
	#pragma AVRPART MEMORY PROG_FLASH 32768
	#pragma AVRPART MEMORY EEPROM 1024
	#pragma AVRPART MEMORY INT_SRAM SIZE 2048
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

	#define CALL_SUPPORTED 1

	.LISTMAC
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU USR=0xB
	.EQU UDR=0xC
	.EQU SPSR=0xE
	.EQU SPDR=0xF
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU EECR=0x1C
	.EQU EEDR=0x1D
	.EQU EEARL=0x1E
	.EQU EEARH=0x1F
	.EQU WDTCR=0x21
	.EQU MCUCR=0x35
	.EQU GICR=0x3B
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.EQU __SRAM_START=0x0060
	.EQU __SRAM_END=0x085F
	.EQU __DSTACK_SIZE=0x0200
	.EQU __HEAP_SIZE=0x0000
	.EQU __CLEAR_SRAM_SIZE=__SRAM_END-__SRAM_START+1

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDBMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ANDI R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ANDD2N
	ANDI R26,LOW(@0)
	ANDI R27,HIGH(@0)
	ANDI R24,BYTE3(@0)
	ANDI R25,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ORI  R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD2N
	ORI  R26,LOW(@0)
	ORI  R27,HIGH(@0)
	ORI  R24,BYTE3(@0)
	ORI  R25,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __CLRD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+(@1))
	LDI  R31,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	LDI  R22,BYTE3(2*@0+(@1))
	LDI  R23,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTW2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	LDI  R24,BYTE3(2*@0+(@1))
	LDI  R25,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+(@2))
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+(@3))
	LDI  R@1,HIGH(@2+(@3))
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+(@3))
	LDI  R@1,HIGH(@2*2+(@3))
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+(@1)
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+(@1)
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	LDS  R22,@0+(@1)+2
	LDS  R23,@0+(@1)+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+(@2)
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+(@3)
	LDS  R@1,@2+(@3)+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+(@1)
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	LDS  R24,@0+(@1)+2
	LDS  R25,@0+(@1)+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+(@1),R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	STS  @0+(@1)+2,R22
	STS  @0+(@1)+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+(@1),R0
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+(@1),R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+(@1),R@2
	STS  @0+(@1)+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTBSR
	STD  Y+@1,R@0
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	CALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	PUSH R26
	PUSH R27
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMRDW
	POP  R27
	POP  R26
	ICALL
	.ENDM

	.MACRO __CALL2EX
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	CALL __EEPROMRDD
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z
	MOVW R30,R0
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOVW R26,R@0
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	CALL __PUTDP1
	.ENDM


	.MACRO __GETB1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z+
	LD   R23,Z
	MOVW R30,R0
	.ENDM

	.MACRO __GETB2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R1,X+
	LD   R24,X+
	LD   R25,X
	MOVW R26,R0
	.ENDM

	.MACRO __GETBRSX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __GETBRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
	.ENDM

	.MACRO __LSLW8SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __PUTB2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
	.ENDM

	.MACRO __PUTWSRX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __MULBRR
	MULS R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRRU
	MUL  R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRR0
	MULS R@0,R@1
	.ENDM

	.MACRO __MULBRRU0
	MUL  R@0,R@1
	.ENDM

	.MACRO __MULBNWRU
	LDI  R26,@2
	MUL  R26,R@0
	MOVW R30,R0
	MUL  R26,R@1
	ADD  R31,R0
	.ENDM

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF __lcd_x=R5
	.DEF __lcd_y=R4
	.DEF __lcd_maxx=R7

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	JMP  __RESET
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00

_0x1F:
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0
_0x2000003:
	.DB  0x80,0xC0
_0x2020060:
	.DB  0x1
_0x2020000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0,0x49,0x4E,0x46
	.DB  0x0

__GLOBAL_INI_TBL:
	.DW  0x02
	.DW  __base_y_G100
	.DW  _0x2000003*2

	.DW  0x01
	.DW  __seed_G101
	.DW  _0x2020060*2

_0xFFFFFFFF:
	.DW  0

#define __GLOBAL_INI_TBL_PRESENT 1

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  GICR,R31
	OUT  GICR,R30
	OUT  MCUCR,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(__CLEAR_SRAM_SIZE)
	LDI  R25,HIGH(__CLEAR_SRAM_SIZE)
	LDI  R26,__SRAM_START
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
	BRNE __CLEAR_SRAM

;GLOBAL VARIABLES INITIALIZATION
	LDI  R30,LOW(__GLOBAL_INI_TBL*2)
	LDI  R31,HIGH(__GLOBAL_INI_TBL*2)
__GLOBAL_INI_NEXT:
	LPM  R24,Z+
	LPM  R25,Z+
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	LPM  R26,Z+
	LPM  R27,Z+
	LPM  R0,Z+
	LPM  R1,Z+
	MOVW R22,R30
	MOVW R30,R0
__GLOBAL_INI_LOOP:
	LPM  R0,Z+
	ST   X+,R0
	SBIW R24,1
	BRNE __GLOBAL_INI_LOOP
	MOVW R30,R22
	RJMP __GLOBAL_INI_NEXT
__GLOBAL_INI_END:

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30
	LDI  R30,HIGH(__SRAM_END-__HEAP_SIZE)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)
	LDI  R29,HIGH(__SRAM_START+__DSTACK_SIZE)

	JMP  _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x260

	.CSEG
;/*******************************************************
;Ahmad Asadi 99463107 Final Project
;*******************************************************/
;#include <mega32.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;#include <alcd.h>
;#include <delay.h>
;#include <stdlib.h>
;#define ADC_VREF_TYPE ((1<<REFS1) | (1<<REFS0) | (0<<ADLAR))
;
;unsigned int read_adc(unsigned char adc_input){
; 0000 000A unsigned int read_adc(unsigned char adc_input){

	.CSEG
_read_adc:
; .FSTART _read_adc
; 0000 000B     ADMUX=adc_input | ADC_VREF_TYPE;
	ST   -Y,R26
;	adc_input -> Y+0
	LD   R30,Y
	ORI  R30,LOW(0xC0)
	OUT  0x7,R30
; 0000 000C     delay_us(10);
	__DELAY_USB 27
; 0000 000D     ADCSRA|=(1<<ADSC);
	SBI  0x6,6
; 0000 000E     while ((ADCSRA & (1<<ADIF))==0);
_0x3:
	SBIS 0x6,4
	RJMP _0x3
; 0000 000F     ADCSRA|=(1<<ADIF);
	SBI  0x6,4
; 0000 0010     return ADCW;
	IN   R30,0x4
	IN   R31,0x4+1
	JMP  _0x20A0001
; 0000 0011 }
; .FEND
;
;void T0Delay () {
; 0000 0013 void T0Delay () {
_T0Delay:
; .FSTART _T0Delay
; 0000 0014     TCNT0 = 128;
	LDI  R30,LOW(128)
	OUT  0x32,R30
; 0000 0015     TCCR0 = 0x05;
	LDI  R30,LOW(5)
	OUT  0x33,R30
; 0000 0016     while ((TIFR&0x1)==0);
_0x6:
	IN   R30,0x38
	SBRS R30,0
	RJMP _0x6
; 0000 0017     TCCR0 = 0;
	LDI  R30,LOW(0)
	OUT  0x33,R30
; 0000 0018     TIFR = 0x1;
	LDI  R30,LOW(1)
	OUT  0x38,R30
; 0000 0019 }
	RET
; .FEND
;
;int pressed1 (int press, int num, int key) {
; 0000 001B int pressed1 (int press, int num, int key) {
_pressed1:
; .FSTART _pressed1
; 0000 001C     if (press == 0) {
	ST   -Y,R27
	ST   -Y,R26
;	press -> Y+4
;	num -> Y+2
;	key -> Y+0
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	SBIW R30,0
	BRNE _0x9
; 0000 001D         num = num * 10;
	CALL SUBOPT_0x0
; 0000 001E         num = num + key;
; 0000 001F     }
; 0000 0020     return num;
_0x9:
	RJMP _0x20A0003
; 0000 0021 }
; .FEND
;
;int pressed2 (int press, int num, int key) {
; 0000 0023 int pressed2 (int press, int num, int key) {
_pressed2:
; .FSTART _pressed2
; 0000 0024     if (press == 1) {
	ST   -Y,R27
	ST   -Y,R26
;	press -> Y+4
;	num -> Y+2
;	key -> Y+0
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	SBIW R26,1
	BRNE _0xA
; 0000 0025         num = num * 10;
	CALL SUBOPT_0x0
; 0000 0026         num = num + key;
; 0000 0027     }
; 0000 0028     return num;
_0xA:
_0x20A0003:
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	ADIW R28,6
	RET
; 0000 0029 }
; .FEND
;
;int arithmatic (int numb1, int operation2, int numb2) {
; 0000 002B int arithmatic (int numb1, int operation2, int numb2) {
_arithmatic:
; .FSTART _arithmatic
; 0000 002C     int result = 0;
; 0000 002D     if (operation2 == 1){
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
	ST   -Y,R16
;	numb1 -> Y+6
;	operation2 -> Y+4
;	numb2 -> Y+2
;	result -> R16,R17
	__GETWRN 16,17,0
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	SBIW R26,1
	BRNE _0xB
; 0000 002E         result = numb1 / numb2;
	CALL SUBOPT_0x1
	CALL __DIVW21
	MOVW R16,R30
; 0000 002F     }
; 0000 0030     if (operation2 == 2){
_0xB:
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	SBIW R26,2
	BRNE _0xC
; 0000 0031         result = numb1 * numb2;
	CALL SUBOPT_0x1
	CALL __MULW12
	MOVW R16,R30
; 0000 0032     }
; 0000 0033     if (operation2 == 3){
_0xC:
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	SBIW R26,3
	BRNE _0xD
; 0000 0034         result = numb1 - numb2;
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	SUB  R30,R26
	SBC  R31,R27
	MOVW R16,R30
; 0000 0035     }
; 0000 0036     if (operation2 == 4){
_0xD:
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	SBIW R26,4
	BRNE _0xE
; 0000 0037         result = numb1 + numb2;
	CALL SUBOPT_0x1
	ADD  R30,R26
	ADC  R31,R27
	MOVW R16,R30
; 0000 0038     }
; 0000 0039     return result;
_0xE:
	MOVW R30,R16
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,8
	RET
; 0000 003A }
; .FEND
;
;char convert (int number) {
; 0000 003C char convert (int number) {
_convert:
; .FSTART _convert
; 0000 003D     if (number == 0) {
	ST   -Y,R27
	ST   -Y,R26
;	number -> Y+0
	LD   R30,Y
	LDD  R31,Y+1
	SBIW R30,0
	BRNE _0xF
; 0000 003E         return '0';
	LDI  R30,LOW(48)
	JMP  _0x20A0002
; 0000 003F     }
; 0000 0040     if (number == 1) {
_0xF:
	LD   R26,Y
	LDD  R27,Y+1
	SBIW R26,1
	BRNE _0x10
; 0000 0041         return '1';
	LDI  R30,LOW(49)
	JMP  _0x20A0002
; 0000 0042     }
; 0000 0043     if (number == 2) {
_0x10:
	LD   R26,Y
	LDD  R27,Y+1
	SBIW R26,2
	BRNE _0x11
; 0000 0044         return '2';
	LDI  R30,LOW(50)
	JMP  _0x20A0002
; 0000 0045     }
; 0000 0046     if (number == 3) {
_0x11:
	LD   R26,Y
	LDD  R27,Y+1
	SBIW R26,3
	BRNE _0x12
; 0000 0047         return '3';
	LDI  R30,LOW(51)
	JMP  _0x20A0002
; 0000 0048     }
; 0000 0049     if (number == 4) {
_0x12:
	LD   R26,Y
	LDD  R27,Y+1
	SBIW R26,4
	BRNE _0x13
; 0000 004A         return '4';
	LDI  R30,LOW(52)
	JMP  _0x20A0002
; 0000 004B     }
; 0000 004C     if (number == 5) {
_0x13:
	LD   R26,Y
	LDD  R27,Y+1
	SBIW R26,5
	BRNE _0x14
; 0000 004D         return '5';
	LDI  R30,LOW(53)
	JMP  _0x20A0002
; 0000 004E     }
; 0000 004F     if (number == 6) {
_0x14:
	LD   R26,Y
	LDD  R27,Y+1
	SBIW R26,6
	BRNE _0x15
; 0000 0050         return '6';
	LDI  R30,LOW(54)
	JMP  _0x20A0002
; 0000 0051     }
; 0000 0052     if (number == 7) {
_0x15:
	LD   R26,Y
	LDD  R27,Y+1
	SBIW R26,7
	BRNE _0x16
; 0000 0053         return '7';
	LDI  R30,LOW(55)
	JMP  _0x20A0002
; 0000 0054     }
; 0000 0055     if (number == 8) {
_0x16:
	LD   R26,Y
	LDD  R27,Y+1
	SBIW R26,8
	BRNE _0x17
; 0000 0056         return '8';
	LDI  R30,LOW(56)
	JMP  _0x20A0002
; 0000 0057     }
; 0000 0058     if (number == 9) {
_0x17:
	LD   R26,Y
	LDD  R27,Y+1
	SBIW R26,9
	BRNE _0x18
; 0000 0059         return '9';
	LDI  R30,LOW(57)
	RJMP _0x20A0002
; 0000 005A     }
; 0000 005B     return '&';
_0x18:
	LDI  R30,LOW(38)
	RJMP _0x20A0002
; 0000 005C }
; .FEND
;
;void printlcd (int result) {
; 0000 005E void printlcd (int result) {
_printlcd:
; .FSTART _printlcd
; 0000 005F     int digit[5];
; 0000 0060     int i = 0;
; 0000 0061     int j = 0;
; 0000 0062     char chary= '*';
; 0000 0063     while (result > 0) {
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,10
	CALL __SAVELOCR6
;	result -> Y+16
;	digit -> Y+6
;	i -> R16,R17
;	j -> R18,R19
;	chary -> R21
	CALL SUBOPT_0x2
	LDI  R21,42
_0x19:
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	CALL __CPW02
	BRGE _0x1B
; 0000 0064         digit[i] = result % 10;
	MOVW R30,R16
	MOVW R26,R28
	ADIW R26,6
	LSL  R30
	ROL  R31
	ADD  R30,R26
	ADC  R31,R27
	MOVW R22,R30
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __MODW21
	MOVW R26,R22
	ST   X+,R30
	ST   X,R31
; 0000 0065         i = i + 1;
	__ADDWRN 16,17,1
; 0000 0066         result = result / 10;
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __DIVW21
	STD  Y+16,R30
	STD  Y+16+1,R31
; 0000 0067     }
	RJMP _0x19
_0x1B:
; 0000 0068     for(j = i; j > 0; j--) {
	MOVW R18,R16
_0x1D:
	CLR  R0
	CP   R0,R18
	CPC  R0,R19
	BRGE _0x1E
; 0000 0069         chary = convert(digit[j - 1]);
	MOVW R30,R18
	SBIW R30,1
	MOVW R26,R28
	ADIW R26,6
	LSL  R30
	ROL  R31
	ADD  R26,R30
	ADC  R27,R31
	CALL __GETW1P
	MOVW R26,R30
	RCALL _convert
	MOV  R21,R30
; 0000 006A         lcd_putchar(chary);
	MOV  R26,R21
	RCALL _lcd_putchar
; 0000 006B     }
	__SUBWRN 18,19,1
	RJMP _0x1D
_0x1E:
; 0000 006C }
	CALL __LOADLOCR6
	ADIW R28,18
	RET
; .FEND
;
;void main(void){
; 0000 006E void main(void){
_main:
; .FSTART _main
; 0000 006F     int exp_pressed = 0;
; 0000 0070     int num1 = 0;
; 0000 0071     int num2 = 0;
; 0000 0072     int operation = 0;
; 0000 0073     int res = 0;
; 0000 0074 
; 0000 0075     int round = 0;
; 0000 0076     int lcdx = 0;
; 0000 0077     int x = 0;
; 0000 0078     char out[6];
; 0000 0079 
; 0000 007A     DDRA = 0b11111110; // pin 0 is input
	SBIW R28,16
	LDI  R24,10
	LDI  R26,LOW(6)
	LDI  R27,HIGH(6)
	LDI  R30,LOW(_0x1F*2)
	LDI  R31,HIGH(_0x1F*2)
	CALL __INITLOCB
;	exp_pressed -> R16,R17
;	num1 -> R18,R19
;	num2 -> R20,R21
;	operation -> Y+14
;	res -> Y+12
;	round -> Y+10
;	lcdx -> Y+8
;	x -> Y+6
;	out -> Y+0
	CALL SUBOPT_0x2
	__GETWRN 20,21,0
	LDI  R30,LOW(254)
	OUT  0x1A,R30
; 0000 007B     DDRC = 0b11111111; // all output for lcd
	LDI  R30,LOW(255)
	OUT  0x14,R30
; 0000 007C     DDRD = 0b00001111; // first 4 pin is output and other are input
	LDI  R30,LOW(15)
	OUT  0x11,R30
; 0000 007D 
; 0000 007E     PORTA=(0<<PORTA7) | (0<<PORTA6) | (0<<PORTA5) | (0<<PORTA4) | (0<<PORTA3) | (0<<PORTA2) | (0<<PORTA1) | (0<<PORTA0);
	LDI  R30,LOW(0)
	OUT  0x1B,R30
; 0000 007F     DDRB=(0<<DDB7) | (0<<DDB6) | (0<<DDB5) | (0<<DDB4) | (0<<DDB3) | (0<<DDB2) | (0<<DDB1) | (0<<DDB0);
	OUT  0x17,R30
; 0000 0080     PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (0<<PORTB4) | (0<<PORTB3) | (0<<PORTB2) | (0<<PORTB1) | (0<<PORTB0);
	OUT  0x18,R30
; 0000 0081     PORTC=(0<<PORTC7) | (0<<PORTC6) | (0<<PORTC5) | (0<<PORTC4) | (0<<PORTC3) | (0<<PORTC2) | (0<<PORTC1) | (0<<PORTC0);
	OUT  0x15,R30
; 0000 0082     PORTD=(0<<PORTD7) | (0<<PORTD6) | (0<<PORTD5) | (0<<PORTD4) | (0<<PORTD3) | (0<<PORTD2) | (0<<PORTD1) | (0<<PORTD0);
	OUT  0x12,R30
; 0000 0083 
; 0000 0084     TCCR0=(0<<WGM00) | (0<<COM01) | (0<<COM00) | (0<<WGM01) | (0<<CS02) | (0<<CS01) | (0<<CS00);
	OUT  0x33,R30
; 0000 0085     TCNT0=0x00;
	OUT  0x32,R30
; 0000 0086     OCR0=0x00;
	OUT  0x3C,R30
; 0000 0087 
; 0000 0088     TCCR1A=(0<<COM1A1) | (0<<COM1A0) | (0<<COM1B1) | (0<<COM1B0) | (0<<WGM11) | (0<<WGM10);
	OUT  0x2F,R30
; 0000 0089     TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (0<<WGM12) | (0<<CS12) | (0<<CS11) | (0<<CS10);
	OUT  0x2E,R30
; 0000 008A     TCNT1H=0x00;
	OUT  0x2D,R30
; 0000 008B     TCNT1L=0x00;
	OUT  0x2C,R30
; 0000 008C     ICR1H=0x00;
	OUT  0x27,R30
; 0000 008D     ICR1L=0x00;
	OUT  0x26,R30
; 0000 008E     OCR1AH=0x00;
	OUT  0x2B,R30
; 0000 008F     OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 0090     OCR1BH=0x00;
	OUT  0x29,R30
; 0000 0091     OCR1BL=0x00;
	OUT  0x28,R30
; 0000 0092 
; 0000 0093     ASSR=0<<AS2;
	OUT  0x22,R30
; 0000 0094     TCCR2=(0<<PWM2) | (0<<COM21) | (0<<COM20) | (0<<CTC2) | (0<<CS22) | (0<<CS21) | (0<<CS20);
	OUT  0x25,R30
; 0000 0095     TCNT2=0x00;
	OUT  0x24,R30
; 0000 0096     OCR2=0x00;
	OUT  0x23,R30
; 0000 0097 
; 0000 0098     TIMSK=(0<<OCIE2) | (0<<TOIE2) | (0<<TICIE1) | (0<<OCIE1A) | (0<<OCIE1B) | (0<<TOIE1) | (0<<OCIE0) | (0<<TOIE0);
	OUT  0x39,R30
; 0000 0099 
; 0000 009A     MCUCR=(0<<ISC11) | (0<<ISC10) | (0<<ISC01) | (0<<ISC00);
	OUT  0x35,R30
; 0000 009B     MCUCSR=(0<<ISC2);
	OUT  0x34,R30
; 0000 009C 
; 0000 009D     UCSRB=(0<<RXCIE) | (0<<TXCIE) | (0<<UDRIE) | (0<<RXEN) | (0<<TXEN) | (0<<UCSZ2) | (0<<RXB8) | (0<<TXB8);
	OUT  0xA,R30
; 0000 009E 
; 0000 009F     ACSR=(1<<ACD) | (0<<ACBG) | (0<<ACO) | (0<<ACI) | (0<<ACIE) | (0<<ACIC) | (0<<ACIS1) | (0<<ACIS0);
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 00A0 
; 0000 00A1     ADMUX=ADC_VREF_TYPE;
	LDI  R30,LOW(192)
	OUT  0x7,R30
; 0000 00A2     ADCSRA=(1<<ADEN) | (0<<ADSC) | (1<<ADATE) | (0<<ADIF) | (0<<ADIE) | (1<<ADPS2) | (1<<ADPS1) | (1<<ADPS0);
	LDI  R30,LOW(167)
	OUT  0x6,R30
; 0000 00A3     SFIOR=(0<<ADTS2) | (0<<ADTS1) | (0<<ADTS0);
	LDI  R30,LOW(0)
	OUT  0x30,R30
; 0000 00A4 
; 0000 00A5     SPCR=(0<<SPIE) | (0<<SPE) | (0<<DORD) | (0<<MSTR) | (0<<CPOL) | (0<<CPHA) | (0<<SPR1) | (0<<SPR0);
	OUT  0xD,R30
; 0000 00A6 
; 0000 00A7     TWCR=(0<<TWEA) | (0<<TWSTA) | (0<<TWSTO) | (0<<TWEN) | (0<<TWIE);
	OUT  0x36,R30
; 0000 00A8 
; 0000 00A9     lcd_init(16);
	LDI  R26,LOW(16)
	RCALL _lcd_init
; 0000 00AA 
; 0000 00AB     while (1) {
_0x20:
; 0000 00AC         PORTD = 0b00000001;
	LDI  R30,LOW(1)
	OUT  0x12,R30
; 0000 00AD         if (PIND.4==1) {
	SBIS 0x10,4
	RJMP _0x23
; 0000 00AE             num1 = pressed1 (exp_pressed, num1, 7);
	CALL SUBOPT_0x3
	LDI  R26,LOW(7)
	CALL SUBOPT_0x4
; 0000 00AF             num2 = pressed2 (exp_pressed, num2, 7);
	LDI  R26,LOW(7)
	CALL SUBOPT_0x5
; 0000 00B0             lcd_putchar('7');
	LDI  R26,LOW(55)
	CALL SUBOPT_0x6
; 0000 00B1             lcdx = lcdx + 1;
; 0000 00B2         }
; 0000 00B3         if (PIND.5==1) {
_0x23:
	SBIS 0x10,5
	RJMP _0x24
; 0000 00B4             num1 = pressed1 (exp_pressed, num1, 8);
	CALL SUBOPT_0x3
	LDI  R26,LOW(8)
	CALL SUBOPT_0x4
; 0000 00B5             num2 = pressed2 (exp_pressed, num2, 8);
	LDI  R26,LOW(8)
	CALL SUBOPT_0x5
; 0000 00B6             lcd_putchar('8');
	LDI  R26,LOW(56)
	CALL SUBOPT_0x6
; 0000 00B7             lcdx = lcdx + 1;
; 0000 00B8         }
; 0000 00B9         if (PIND.6==1) {
_0x24:
	SBIS 0x10,6
	RJMP _0x25
; 0000 00BA             num1 = pressed1 (exp_pressed, num1, 9);
	CALL SUBOPT_0x3
	LDI  R26,LOW(9)
	CALL SUBOPT_0x4
; 0000 00BB             num2 = pressed2 (exp_pressed, num2, 9);
	LDI  R26,LOW(9)
	CALL SUBOPT_0x5
; 0000 00BC             lcd_putchar('9');
	LDI  R26,LOW(57)
	CALL SUBOPT_0x6
; 0000 00BD             lcdx = lcdx + 1;
; 0000 00BE         }
; 0000 00BF         if (PIND.7==1) {
_0x25:
	SBIS 0x10,7
	RJMP _0x26
; 0000 00C0             operation = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CALL SUBOPT_0x7
; 0000 00C1             exp_pressed = 1;
; 0000 00C2             lcd_putchar('/');
	LDI  R26,LOW(47)
	CALL SUBOPT_0x6
; 0000 00C3             lcdx = lcdx + 1;
; 0000 00C4         }
; 0000 00C5         //delay_ms(20);
; 0000 00C6         T0Delay();
_0x26:
	RCALL _T0Delay
; 0000 00C7         PORTD = 0b00000010;
	LDI  R30,LOW(2)
	OUT  0x12,R30
; 0000 00C8         if (PIND.4==1) {
	SBIS 0x10,4
	RJMP _0x27
; 0000 00C9             num1 = pressed1 (exp_pressed, num1, 4);
	CALL SUBOPT_0x3
	LDI  R26,LOW(4)
	CALL SUBOPT_0x4
; 0000 00CA             num2 = pressed2 (exp_pressed, num2, 4);
	LDI  R26,LOW(4)
	CALL SUBOPT_0x5
; 0000 00CB             lcd_putchar('4');
	LDI  R26,LOW(52)
	CALL SUBOPT_0x6
; 0000 00CC             lcdx = lcdx + 1;
; 0000 00CD         }
; 0000 00CE         if (PIND.5==1) {
_0x27:
	SBIS 0x10,5
	RJMP _0x28
; 0000 00CF             num1 = pressed1 (exp_pressed, num1, 5);
	CALL SUBOPT_0x3
	LDI  R26,LOW(5)
	CALL SUBOPT_0x4
; 0000 00D0             num2 = pressed2 (exp_pressed, num2, 5);
	LDI  R26,LOW(5)
	CALL SUBOPT_0x5
; 0000 00D1             lcd_putchar('5');
	LDI  R26,LOW(53)
	CALL SUBOPT_0x6
; 0000 00D2             lcdx = lcdx + 1;
; 0000 00D3         }
; 0000 00D4         if (PIND.6==1) {
_0x28:
	SBIS 0x10,6
	RJMP _0x29
; 0000 00D5             num1 = pressed1 (exp_pressed, num1, 6);
	CALL SUBOPT_0x3
	LDI  R26,LOW(6)
	CALL SUBOPT_0x4
; 0000 00D6             num2 = pressed2 (exp_pressed, num2, 6);
	LDI  R26,LOW(6)
	CALL SUBOPT_0x5
; 0000 00D7             lcd_putchar('6');
	LDI  R26,LOW(54)
	CALL SUBOPT_0x6
; 0000 00D8             lcdx = lcdx + 1;
; 0000 00D9         }
; 0000 00DA         if (PIND.7==1) {
_0x29:
	SBIS 0x10,7
	RJMP _0x2A
; 0000 00DB             operation = 2;
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CALL SUBOPT_0x7
; 0000 00DC             exp_pressed = 1;
; 0000 00DD             lcd_putchar('*');
	LDI  R26,LOW(42)
	CALL SUBOPT_0x6
; 0000 00DE             lcdx = lcdx + 1;
; 0000 00DF         }
; 0000 00E0         PORTD = 0b00000100;
_0x2A:
	LDI  R30,LOW(4)
	OUT  0x12,R30
; 0000 00E1         //delay_ms(20);
; 0000 00E2         T0Delay();
	RCALL _T0Delay
; 0000 00E3         if (PIND.4==1) {
	SBIS 0x10,4
	RJMP _0x2B
; 0000 00E4             num1 = pressed1 (exp_pressed, num1, 1);
	CALL SUBOPT_0x3
	LDI  R26,LOW(1)
	CALL SUBOPT_0x4
; 0000 00E5             num2 = pressed2 (exp_pressed, num2, 1);
	LDI  R26,LOW(1)
	CALL SUBOPT_0x5
; 0000 00E6             lcd_putchar('1');
	LDI  R26,LOW(49)
	CALL SUBOPT_0x6
; 0000 00E7             lcdx = lcdx + 1;
; 0000 00E8         }
; 0000 00E9         if (PIND.5==1) {
_0x2B:
	SBIS 0x10,5
	RJMP _0x2C
; 0000 00EA             num1 = pressed1 (exp_pressed, num1, 2);
	CALL SUBOPT_0x3
	LDI  R26,LOW(2)
	CALL SUBOPT_0x4
; 0000 00EB             num2 = pressed2 (exp_pressed, num2, 2);
	LDI  R26,LOW(2)
	CALL SUBOPT_0x5
; 0000 00EC             lcd_putchar('2');
	LDI  R26,LOW(50)
	CALL SUBOPT_0x6
; 0000 00ED             lcdx = lcdx + 1;
; 0000 00EE         }
; 0000 00EF         if (PIND.6==1) {
_0x2C:
	SBIS 0x10,6
	RJMP _0x2D
; 0000 00F0             num1 = pressed1 (exp_pressed, num1, 3);
	CALL SUBOPT_0x3
	LDI  R26,LOW(3)
	CALL SUBOPT_0x4
; 0000 00F1             num2 = pressed2 (exp_pressed, num2, 3);
	LDI  R26,LOW(3)
	CALL SUBOPT_0x5
; 0000 00F2             lcd_putchar('3');
	LDI  R26,LOW(51)
	CALL SUBOPT_0x6
; 0000 00F3             lcdx = lcdx + 1;
; 0000 00F4         }
; 0000 00F5         if (PIND.7==1) {
_0x2D:
	SBIS 0x10,7
	RJMP _0x2E
; 0000 00F6             operation = 3;
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	CALL SUBOPT_0x7
; 0000 00F7             exp_pressed = 1;
; 0000 00F8             lcd_putchar('-');
	LDI  R26,LOW(45)
	CALL SUBOPT_0x6
; 0000 00F9             lcdx = lcdx + 1;
; 0000 00FA         }
; 0000 00FB         PORTD = 0b00001000;
_0x2E:
	LDI  R30,LOW(8)
	OUT  0x12,R30
; 0000 00FC         //delay_ms(20);
; 0000 00FD         T0Delay();
	RCALL _T0Delay
; 0000 00FE         if (PIND.4==1) {
	SBIS 0x10,4
	RJMP _0x2F
; 0000 00FF             exp_pressed = 0;
	CALL SUBOPT_0x2
; 0000 0100             num1 = 0;
; 0000 0101             num2 = 0;
	__GETWRN 20,21,0
; 0000 0102             operation = 0;
	LDI  R30,LOW(0)
	STD  Y+14,R30
	STD  Y+14+1,R30
; 0000 0103             res = 0;
	STD  Y+12,R30
	STD  Y+12+1,R30
; 0000 0104             lcd_clear();
	RCALL _lcd_clear
; 0000 0105             lcdx = 0;
	LDI  R30,LOW(0)
	STD  Y+8,R30
	STD  Y+8+1,R30
; 0000 0106             x = read_adc(0);
	CALL SUBOPT_0x8
; 0000 0107             x = x/4;
; 0000 0108             itoa(x, out);
; 0000 0109             out[2] = '.';
; 0000 010A             out[3] = 'C';
; 0000 010B             lcd_gotoxy(0, 1);
; 0000 010C             lcd_puts(out);
; 0000 010D             lcd_gotoxy(lcdx, 0);
; 0000 010E         }
; 0000 010F         if (PIND.5==1) {
_0x2F:
	SBIS 0x10,5
	RJMP _0x30
; 0000 0110             num1 = pressed1 (exp_pressed, num1, 0);
	CALL SUBOPT_0x3
	LDI  R26,LOW(0)
	CALL SUBOPT_0x4
; 0000 0111             num2 = pressed2 (exp_pressed, num2, 0);
	LDI  R26,LOW(0)
	CALL SUBOPT_0x5
; 0000 0112             lcd_putchar('0');
	LDI  R26,LOW(48)
	CALL SUBOPT_0x6
; 0000 0113             lcdx = lcdx + 1;
; 0000 0114         }
; 0000 0115         if (PIND.6==1) {
_0x30:
	SBIS 0x10,6
	RJMP _0x31
; 0000 0116             res = arithmatic (num1, operation, num2);
	ST   -Y,R19
	ST   -Y,R18
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	ST   -Y,R31
	ST   -Y,R30
	MOVW R26,R20
	RCALL _arithmatic
	STD  Y+12,R30
	STD  Y+12+1,R31
; 0000 0117             lcd_putchar('=');
	LDI  R26,LOW(61)
	RCALL _lcd_putchar
; 0000 0118             printlcd(res);
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	RCALL _printlcd
; 0000 0119             lcdx = lcdx + 1;
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	ADIW R30,1
	STD  Y+8,R30
	STD  Y+8+1,R31
; 0000 011A         }
; 0000 011B         if (PIND.7==1) {
_0x31:
	SBIS 0x10,7
	RJMP _0x32
; 0000 011C             operation = 4;
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	CALL SUBOPT_0x7
; 0000 011D             exp_pressed = 1;
; 0000 011E             lcd_putchar('+');
	LDI  R26,LOW(43)
	CALL SUBOPT_0x6
; 0000 011F             lcdx = lcdx + 1;
; 0000 0120         }
; 0000 0121         //delay_ms(20);
; 0000 0122         T0Delay();
_0x32:
	RCALL _T0Delay
; 0000 0123         round = round + 1;
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	ADIW R30,1
	STD  Y+10,R30
	STD  Y+10+1,R31
; 0000 0124         if (round == 10) {
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	SBIW R26,10
	BRNE _0x33
; 0000 0125             round = 0;
	LDI  R30,LOW(0)
	STD  Y+10,R30
	STD  Y+10+1,R30
; 0000 0126             x = read_adc(0);
	CALL SUBOPT_0x8
; 0000 0127             x = x/4;
; 0000 0128             itoa(x, out);
; 0000 0129             out[2] = '.';
; 0000 012A             out[3] = 'C';
; 0000 012B             lcd_gotoxy(0, 1);
; 0000 012C             lcd_puts(out);
; 0000 012D             lcd_gotoxy(lcdx, 0);
; 0000 012E         }
; 0000 012F     }
_0x33:
	RJMP _0x20
; 0000 0130 
; 0000 0131 }
_0x34:
	RJMP _0x34
; .FEND
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif

	.DSEG

	.CSEG
__lcd_write_nibble_G100:
; .FSTART __lcd_write_nibble_G100
	ST   -Y,R26
	IN   R30,0x15
	ANDI R30,LOW(0xF)
	MOV  R26,R30
	LD   R30,Y
	ANDI R30,LOW(0xF0)
	OR   R30,R26
	OUT  0x15,R30
	__DELAY_USB 13
	SBI  0x15,2
	__DELAY_USB 13
	CBI  0x15,2
	__DELAY_USB 13
	RJMP _0x20A0001
; .FEND
__lcd_write_data:
; .FSTART __lcd_write_data
	ST   -Y,R26
	LD   R26,Y
	RCALL __lcd_write_nibble_G100
    ld    r30,y
    swap  r30
    st    y,r30
	LD   R26,Y
	RCALL __lcd_write_nibble_G100
	__DELAY_USB 133
	RJMP _0x20A0001
; .FEND
_lcd_gotoxy:
; .FSTART _lcd_gotoxy
	ST   -Y,R26
	LD   R30,Y
	LDI  R31,0
	SUBI R30,LOW(-__base_y_G100)
	SBCI R31,HIGH(-__base_y_G100)
	LD   R30,Z
	LDD  R26,Y+1
	ADD  R26,R30
	RCALL __lcd_write_data
	LDD  R5,Y+1
	LDD  R4,Y+0
_0x20A0002:
	ADIW R28,2
	RET
; .FEND
_lcd_clear:
; .FSTART _lcd_clear
	LDI  R26,LOW(2)
	CALL SUBOPT_0x9
	LDI  R26,LOW(12)
	RCALL __lcd_write_data
	LDI  R26,LOW(1)
	CALL SUBOPT_0x9
	LDI  R30,LOW(0)
	MOV  R4,R30
	MOV  R5,R30
	RET
; .FEND
_lcd_putchar:
; .FSTART _lcd_putchar
	ST   -Y,R26
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BREQ _0x2000005
	CP   R5,R7
	BRLO _0x2000004
_0x2000005:
	LDI  R30,LOW(0)
	ST   -Y,R30
	INC  R4
	MOV  R26,R4
	RCALL _lcd_gotoxy
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BRNE _0x2000007
	RJMP _0x20A0001
_0x2000007:
_0x2000004:
	INC  R5
	SBI  0x15,0
	LD   R26,Y
	RCALL __lcd_write_data
	CBI  0x15,0
	RJMP _0x20A0001
; .FEND
_lcd_puts:
; .FSTART _lcd_puts
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
_0x2000008:
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LD   R30,X+
	STD  Y+1,R26
	STD  Y+1+1,R27
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x200000A
	MOV  R26,R17
	RCALL _lcd_putchar
	RJMP _0x2000008
_0x200000A:
	LDD  R17,Y+0
	ADIW R28,3
	RET
; .FEND
_lcd_init:
; .FSTART _lcd_init
	ST   -Y,R26
	IN   R30,0x14
	ORI  R30,LOW(0xF0)
	OUT  0x14,R30
	SBI  0x14,2
	SBI  0x14,0
	SBI  0x14,1
	CBI  0x15,2
	CBI  0x15,0
	CBI  0x15,1
	LDD  R7,Y+0
	LD   R30,Y
	SUBI R30,-LOW(128)
	__PUTB1MN __base_y_G100,2
	LD   R30,Y
	SUBI R30,-LOW(192)
	__PUTB1MN __base_y_G100,3
	LDI  R26,LOW(20)
	LDI  R27,0
	CALL _delay_ms
	CALL SUBOPT_0xA
	CALL SUBOPT_0xA
	CALL SUBOPT_0xA
	LDI  R26,LOW(32)
	RCALL __lcd_write_nibble_G100
	__DELAY_USW 200
	LDI  R26,LOW(40)
	RCALL __lcd_write_data
	LDI  R26,LOW(4)
	RCALL __lcd_write_data
	LDI  R26,LOW(133)
	RCALL __lcd_write_data
	LDI  R26,LOW(6)
	RCALL __lcd_write_data
	RCALL _lcd_clear
_0x20A0001:
	ADIW R28,1
	RET
; .FEND

	.CSEG
_itoa:
; .FSTART _itoa
	ST   -Y,R27
	ST   -Y,R26
    ld   r26,y+
    ld   r27,y+
    ld   r30,y+
    ld   r31,y+
    adiw r30,0
    brpl __itoa0
    com  r30
    com  r31
    adiw r30,1
    ldi  r22,'-'
    st   x+,r22
__itoa0:
    clt
    ldi  r24,low(10000)
    ldi  r25,high(10000)
    rcall __itoa1
    ldi  r24,low(1000)
    ldi  r25,high(1000)
    rcall __itoa1
    ldi  r24,100
    clr  r25
    rcall __itoa1
    ldi  r24,10
    rcall __itoa1
    mov  r22,r30
    rcall __itoa5
    clr  r22
    st   x,r22
    ret

__itoa1:
    clr	 r22
__itoa2:
    cp   r30,r24
    cpc  r31,r25
    brlo __itoa3
    inc  r22
    sub  r30,r24
    sbc  r31,r25
    brne __itoa2
__itoa3:
    tst  r22
    brne __itoa4
    brts __itoa5
    ret
__itoa4:
    set
__itoa5:
    subi r22,-0x30
    st   x+,r22
    ret
; .FEND

	.DSEG

	.CSEG

	.CSEG

	.CSEG

	.CSEG

	.DSEG
__base_y_G100:
	.BYTE 0x4
__seed_G101:
	.BYTE 0x4

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x0:
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	LDI  R26,LOW(10)
	LDI  R27,HIGH(10)
	CALL __MULW12
	STD  Y+2,R30
	STD  Y+2+1,R31
	LD   R30,Y
	LDD  R31,Y+1
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADD  R30,R26
	ADC  R31,R27
	STD  Y+2,R30
	STD  Y+2+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1:
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2:
	__GETWRN 16,17,0
	__GETWRN 18,19,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x3:
	ST   -Y,R17
	ST   -Y,R16
	ST   -Y,R19
	ST   -Y,R18
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:51 WORDS
SUBOPT_0x4:
	LDI  R27,0
	CALL _pressed1
	MOVW R18,R30
	ST   -Y,R17
	ST   -Y,R16
	ST   -Y,R21
	ST   -Y,R20
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x5:
	LDI  R27,0
	CALL _pressed2
	MOVW R20,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 14 TIMES, CODE SIZE REDUCTION:62 WORDS
SUBOPT_0x6:
	CALL _lcd_putchar
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	ADIW R30,1
	STD  Y+8,R30
	STD  Y+8+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x7:
	STD  Y+14,R30
	STD  Y+14+1,R31
	__GETWRN 16,17,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:34 WORDS
SUBOPT_0x8:
	LDI  R26,LOW(0)
	CALL _read_adc
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	CALL __DIVW21
	STD  Y+6,R30
	STD  Y+6+1,R31
	ST   -Y,R31
	ST   -Y,R30
	MOVW R26,R28
	ADIW R26,2
	CALL _itoa
	LDI  R30,LOW(46)
	STD  Y+2,R30
	LDI  R30,LOW(67)
	STD  Y+3,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(1)
	CALL _lcd_gotoxy
	MOVW R26,R28
	CALL _lcd_puts
	LDD  R30,Y+8
	ST   -Y,R30
	LDI  R26,LOW(0)
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x9:
	CALL __lcd_write_data
	LDI  R26,LOW(3)
	LDI  R27,0
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0xA:
	LDI  R26,LOW(48)
	CALL __lcd_write_nibble_G100
	__DELAY_USW 200
	RET


	.CSEG
_delay_ms:
	adiw r26,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0x7D0
	wdr
	sbiw r26,1
	brne __delay_ms0
__delay_ms1:
	ret

__ANEGW1:
	NEG  R31
	NEG  R30
	SBCI R31,0
	RET

__MULW12U:
	MUL  R31,R26
	MOV  R31,R0
	MUL  R30,R27
	ADD  R31,R0
	MUL  R30,R26
	MOV  R30,R0
	ADD  R31,R1
	RET

__MULW12:
	RCALL __CHKSIGNW
	RCALL __MULW12U
	BRTC __MULW121
	RCALL __ANEGW1
__MULW121:
	RET

__DIVW21U:
	CLR  R0
	CLR  R1
	LDI  R25,16
__DIVW21U1:
	LSL  R26
	ROL  R27
	ROL  R0
	ROL  R1
	SUB  R0,R30
	SBC  R1,R31
	BRCC __DIVW21U2
	ADD  R0,R30
	ADC  R1,R31
	RJMP __DIVW21U3
__DIVW21U2:
	SBR  R26,1
__DIVW21U3:
	DEC  R25
	BRNE __DIVW21U1
	MOVW R30,R26
	MOVW R26,R0
	RET

__DIVW21:
	RCALL __CHKSIGNW
	RCALL __DIVW21U
	BRTC __DIVW211
	RCALL __ANEGW1
__DIVW211:
	RET

__MODW21:
	CLT
	SBRS R27,7
	RJMP __MODW211
	COM  R26
	COM  R27
	ADIW R26,1
	SET
__MODW211:
	SBRC R31,7
	RCALL __ANEGW1
	RCALL __DIVW21U
	MOVW R30,R26
	BRTC __MODW212
	RCALL __ANEGW1
__MODW212:
	RET

__CHKSIGNW:
	CLT
	SBRS R31,7
	RJMP __CHKSW1
	RCALL __ANEGW1
	SET
__CHKSW1:
	SBRS R27,7
	RJMP __CHKSW2
	COM  R26
	COM  R27
	ADIW R26,1
	BLD  R0,0
	INC  R0
	BST  R0,0
__CHKSW2:
	RET

__GETW1P:
	LD   R30,X+
	LD   R31,X
	SBIW R26,1
	RET

__CPW02:
	CLR  R0
	CP   R0,R26
	CPC  R0,R27
	RET

__SAVELOCR6:
	ST   -Y,R21
__SAVELOCR5:
	ST   -Y,R20
__SAVELOCR4:
	ST   -Y,R19
__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR6:
	LDD  R21,Y+5
__LOADLOCR5:
	LDD  R20,Y+4
__LOADLOCR4:
	LDD  R19,Y+3
__LOADLOCR3:
	LDD  R18,Y+2
__LOADLOCR2:
	LDD  R17,Y+1
	LD   R16,Y
	RET

__INITLOCB:
__INITLOCW:
	ADD  R26,R28
	ADC  R27,R29
__INITLOC0:
	LPM  R0,Z+
	ST   X+,R0
	DEC  R24
	BRNE __INITLOC0
	RET

;END OF CODE MARKER
__END_OF_CODE:
