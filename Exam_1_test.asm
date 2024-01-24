_initializeEXTI:
;Exam_1_test.c,15 :: 		void initializeEXTI()
SUB	SP, SP, #4
STR	LR, [SP, #0]
;Exam_1_test.c,17 :: 		RCC_APB2ENR = 0x0009; //Enable AFIO, GPIOB
MOVS	R1, #9
MOVW	R0, #lo_addr(RCC_APB2ENR+0)
MOVT	R0, #hi_addr(RCC_APB2ENR+0)
STR	R1, [R0, #0]
;Exam_1_test.c,19 :: 		AFIO_EXTICR1 = 0x0111;              // PB0,1,2 as External interrupts
MOVW	R1, #273
MOVW	R0, #lo_addr(AFIO_EXTICR1+0)
MOVT	R0, #hi_addr(AFIO_EXTICR1+0)
STR	R1, [R0, #0]
;Exam_1_test.c,20 :: 		EXTI_RTSR = 0x0007;                 // Set interrupt on Rising edge for PB0,1,2
MOVS	R1, #7
MOVW	R0, #lo_addr(EXTI_RTSR+0)
MOVT	R0, #hi_addr(EXTI_RTSR+0)
STR	R1, [R0, #0]
;Exam_1_test.c,21 :: 		EXTI_IMR |= 0x0007;                 // Set mask
MOVW	R0, #lo_addr(EXTI_IMR+0)
MOVT	R0, #hi_addr(EXTI_IMR+0)
LDR	R0, [R0, #0]
ORR	R1, R0, #7
MOVW	R0, #lo_addr(EXTI_IMR+0)
MOVT	R0, #hi_addr(EXTI_IMR+0)
STR	R1, [R0, #0]
;Exam_1_test.c,23 :: 		NVIC_IntEnable(IVT_INT_EXTI0);      // Enable External interrupt
MOVW	R0, #22
BL	_NVIC_IntEnable+0
;Exam_1_test.c,24 :: 		NVIC_IntEnable(IVT_INT_EXTI1);
MOVW	R0, #23
BL	_NVIC_IntEnable+0
;Exam_1_test.c,25 :: 		NVIC_IntEnable(IVT_INT_EXTI2);
MOVW	R0, #24
BL	_NVIC_IntEnable+0
;Exam_1_test.c,27 :: 		EnableInterrupts();                 // Enables the processor interrupt.
BL	_EnableInterrupts+0
;Exam_1_test.c,28 :: 		}
L_end_initializeEXTI:
LDR	LR, [SP, #0]
ADD	SP, SP, #4
BX	LR
; end of _initializeEXTI
_initializeTimer:
;Exam_1_test.c,31 :: 		void initializeTimer()
SUB	SP, SP, #4
STR	LR, [SP, #0]
;Exam_1_test.c,33 :: 		RCC_APB1ENR.TIM2EN = 1; //Enable APB bus for Timer 2
MOVS	R1, #1
SXTB	R1, R1
MOVW	R0, #lo_addr(RCC_APB1ENR+0)
MOVT	R0, #hi_addr(RCC_APB1ENR+0)
STR	R1, [R0, #0]
;Exam_1_test.c,34 :: 		TIM2_CR1.CEN = 0;   //Stop Timer 2
MOVS	R1, #0
SXTB	R1, R1
MOVW	R0, #lo_addr(TIM2_CR1+0)
MOVT	R0, #hi_addr(TIM2_CR1+0)
STR	R1, [R0, #0]
;Exam_1_test.c,35 :: 		TIM2_PSC = 0;  //Prescaler is OFF
MOVS	R1, #0
MOVW	R0, #lo_addr(TIM2_PSC+0)
MOVT	R0, #hi_addr(TIM2_PSC+0)
STR	R1, [R0, #0]
;Exam_1_test.c,36 :: 		TIM2_ARR = 7999;   //1 ms
MOVW	R1, #7999
MOVW	R0, #lo_addr(TIM2_ARR+0)
MOVT	R0, #hi_addr(TIM2_ARR+0)
STR	R1, [R0, #0]
;Exam_1_test.c,37 :: 		NVIC_IntEnable(IVT_INT_TIM2);
MOVW	R0, #44
BL	_NVIC_IntEnable+0
;Exam_1_test.c,38 :: 		TIM2_DIER.UIE = 1;
MOVS	R1, #1
SXTB	R1, R1
MOVW	R0, #lo_addr(TIM2_DIER+0)
MOVT	R0, #hi_addr(TIM2_DIER+0)
STR	R1, [R0, #0]
;Exam_1_test.c,39 :: 		TIM2_CR1.CEN = 1;   //Re-enable the counter
MOVW	R0, #lo_addr(TIM2_CR1+0)
MOVT	R0, #hi_addr(TIM2_CR1+0)
STR	R1, [R0, #0]
;Exam_1_test.c,40 :: 		}
L_end_initializeTimer:
LDR	LR, [SP, #0]
ADD	SP, SP, #4
BX	LR
; end of _initializeTimer
_timerInterruptFunction:
;Exam_1_test.c,42 :: 		void timerInterruptFunction() iv IVT_INT_TIM2
;Exam_1_test.c,44 :: 		TIM2_SR.UIF = 0;  //Flag
MOVS	R1, #0
SXTB	R1, R1
MOVW	R0, #lo_addr(TIM2_SR+0)
MOVT	R0, #hi_addr(TIM2_SR+0)
STR	R1, [R0, #0]
;Exam_1_test.c,45 :: 		counter++;
MOVW	R1, #lo_addr(_counter+0)
MOVT	R1, #hi_addr(_counter+0)
LDRSH	R0, [R1, #0]
ADDS	R0, R0, #1
SXTH	R0, R0
STRH	R0, [R1, #0]
;Exam_1_test.c,46 :: 		if (counter==100)
CMP	R0, #100
IT	NE
BNE	L_timerInterruptFunction0
;Exam_1_test.c,48 :: 		counter = 0;
MOVS	R1, #0
SXTH	R1, R1
MOVW	R0, #lo_addr(_counter+0)
MOVT	R0, #hi_addr(_counter+0)
STRH	R1, [R0, #0]
;Exam_1_test.c,49 :: 		milisecond+=100;
MOVW	R1, #lo_addr(_milisecond+0)
MOVT	R1, #hi_addr(_milisecond+0)
LDRSH	R0, [R1, #0]
ADDS	R0, #100
SXTH	R0, R0
STRH	R0, [R1, #0]
;Exam_1_test.c,50 :: 		if (milisecond == 1000)
CMP	R0, #1000
IT	NE
BNE	L_timerInterruptFunction1
;Exam_1_test.c,52 :: 		milisecond = 0;
MOVS	R1, #0
SXTH	R1, R1
MOVW	R0, #lo_addr(_milisecond+0)
MOVT	R0, #hi_addr(_milisecond+0)
STRH	R1, [R0, #0]
;Exam_1_test.c,53 :: 		second++;
MOVW	R1, #lo_addr(_second+0)
MOVT	R1, #hi_addr(_second+0)
LDRSH	R0, [R1, #0]
ADDS	R0, R0, #1
SXTH	R0, R0
STRH	R0, [R1, #0]
;Exam_1_test.c,54 :: 		if (second == 60)
CMP	R0, #60
IT	NE
BNE	L_timerInterruptFunction2
;Exam_1_test.c,56 :: 		second = 0;
MOVS	R1, #0
SXTH	R1, R1
MOVW	R0, #lo_addr(_second+0)
MOVT	R0, #hi_addr(_second+0)
STRH	R1, [R0, #0]
;Exam_1_test.c,57 :: 		minute++;
MOVW	R1, #lo_addr(_minute+0)
MOVT	R1, #hi_addr(_minute+0)
LDRSH	R0, [R1, #0]
ADDS	R0, R0, #1
STRH	R0, [R1, #0]
;Exam_1_test.c,58 :: 		}
L_timerInterruptFunction2:
;Exam_1_test.c,59 :: 		}
L_timerInterruptFunction1:
;Exam_1_test.c,60 :: 		print = 1;
MOVS	R1, #1
SXTH	R1, R1
MOVW	R0, #lo_addr(_print+0)
MOVT	R0, #hi_addr(_print+0)
STRH	R1, [R0, #0]
;Exam_1_test.c,61 :: 		}
L_timerInterruptFunction0:
;Exam_1_test.c,62 :: 		}
L_end_timerInterruptFunction:
BX	LR
; end of _timerInterruptFunction
_STRAT:
;Exam_1_test.c,64 :: 		void STRAT() iv IVT_INT_EXTI0
;Exam_1_test.c,66 :: 		EXTI_PR = 0x0001;   // Clear PB0 flag by writing 1 to it
MOVS	R1, #1
MOVW	R0, #lo_addr(EXTI_PR+0)
MOVT	R0, #hi_addr(EXTI_PR+0)
STR	R1, [R0, #0]
;Exam_1_test.c,67 :: 		TIM2_CR1.CEN = 1;
MOVS	R1, #1
SXTB	R1, R1
MOVW	R0, #lo_addr(TIM2_CR1+0)
MOVT	R0, #hi_addr(TIM2_CR1+0)
STR	R1, [R0, #0]
;Exam_1_test.c,68 :: 		print = 1;
MOVS	R1, #1
SXTH	R1, R1
MOVW	R0, #lo_addr(_print+0)
MOVT	R0, #hi_addr(_print+0)
STRH	R1, [R0, #0]
;Exam_1_test.c,69 :: 		}
L_end_STRAT:
BX	LR
; end of _STRAT
_PAUSE:
;Exam_1_test.c,71 :: 		void PAUSE() iv IVT_INT_EXTI1
;Exam_1_test.c,73 :: 		EXTI_PR = 0x0002;   // Clear PB1 flag
MOVS	R1, #2
MOVW	R0, #lo_addr(EXTI_PR+0)
MOVT	R0, #hi_addr(EXTI_PR+0)
STR	R1, [R0, #0]
;Exam_1_test.c,74 :: 		TIM2_CR1.CEN = 0;   //stop counter
MOVS	R1, #0
SXTB	R1, R1
MOVW	R0, #lo_addr(TIM2_CR1+0)
MOVT	R0, #hi_addr(TIM2_CR1+0)
STR	R1, [R0, #0]
;Exam_1_test.c,75 :: 		}
L_end_PAUSE:
BX	LR
; end of _PAUSE
_RESET:
;Exam_1_test.c,77 :: 		void RESET() iv IVT_INT_EXTI2
;Exam_1_test.c,79 :: 		EXTI_PR = 0x0004;   // Clear PB2 flag
MOVS	R1, #4
MOVW	R0, #lo_addr(EXTI_PR+0)
MOVT	R0, #hi_addr(EXTI_PR+0)
STR	R1, [R0, #0]
;Exam_1_test.c,80 :: 		TIM2_CR1.CEN = 0;   //stop counter
MOVS	R1, #0
SXTB	R1, R1
MOVW	R0, #lo_addr(TIM2_CR1+0)
MOVT	R0, #hi_addr(TIM2_CR1+0)
STR	R1, [R0, #0]
;Exam_1_test.c,81 :: 		milisecond = 0;
MOVS	R1, #0
SXTH	R1, R1
MOVW	R0, #lo_addr(_milisecond+0)
MOVT	R0, #hi_addr(_milisecond+0)
STRH	R1, [R0, #0]
;Exam_1_test.c,82 :: 		second =0;
MOVS	R1, #0
SXTH	R1, R1
MOVW	R0, #lo_addr(_second+0)
MOVT	R0, #hi_addr(_second+0)
STRH	R1, [R0, #0]
;Exam_1_test.c,83 :: 		minute = 0;
MOVS	R1, #0
SXTH	R1, R1
MOVW	R0, #lo_addr(_minute+0)
MOVT	R0, #hi_addr(_minute+0)
STRH	R1, [R0, #0]
;Exam_1_test.c,84 :: 		print = 1;
MOVS	R1, #1
SXTH	R1, R1
MOVW	R0, #lo_addr(_print+0)
MOVT	R0, #hi_addr(_print+0)
STRH	R1, [R0, #0]
;Exam_1_test.c,85 :: 		}
L_end_RESET:
BX	LR
; end of _RESET
_main:
;Exam_1_test.c,88 :: 		void main()
SUB	SP, SP, #20
;Exam_1_test.c,92 :: 		GPIO_Config(&GPIOB_BASE, _GPIO_PINMASK_0, _GPIO_CFG_DIGITAL_INPUT);
MOV	R2, #66
MOVW	R1, #1
MOVW	R0, #lo_addr(GPIOB_BASE+0)
MOVT	R0, #hi_addr(GPIOB_BASE+0)
BL	_GPIO_Config+0
;Exam_1_test.c,93 :: 		GPIO_Config(&GPIOB_BASE, _GPIO_PINMASK_1, _GPIO_CFG_DIGITAL_INPUT);
MOV	R2, #66
MOVW	R1, #2
MOVW	R0, #lo_addr(GPIOB_BASE+0)
MOVT	R0, #hi_addr(GPIOB_BASE+0)
BL	_GPIO_Config+0
;Exam_1_test.c,94 :: 		GPIO_Config(&GPIOB_BASE, _GPIO_PINMASK_2, _GPIO_CFG_DIGITAL_INPUT);
MOV	R2, #66
MOVW	R1, #4
MOVW	R0, #lo_addr(GPIOB_BASE+0)
MOVT	R0, #hi_addr(GPIOB_BASE+0)
BL	_GPIO_Config+0
;Exam_1_test.c,95 :: 		GPIO_Config(&GPIOA_BASE, _GPIO_PINMASK_0, _GPIO_CFG_DIGITAL_OUTPUT);
MOVW	R2, #20
MOVT	R2, #8
MOVW	R1, #1
MOVW	R0, #lo_addr(GPIOA_BASE+0)
MOVT	R0, #hi_addr(GPIOA_BASE+0)
BL	_GPIO_Config+0
;Exam_1_test.c,97 :: 		LCD_init();
BL	_Lcd_Init+0
;Exam_1_test.c,98 :: 		Lcd_Cmd(_LCD_CURSOR_OFF);
MOVS	R0, #12
BL	_Lcd_Cmd+0
;Exam_1_test.c,99 :: 		LCD_out(1,1, "Stopwatch:");
MOVW	R0, #lo_addr(?lstr1_Exam_1_test+0)
MOVT	R0, #hi_addr(?lstr1_Exam_1_test+0)
MOV	R2, R0
MOVS	R1, #1
MOVS	R0, #1
BL	_Lcd_Out+0
;Exam_1_test.c,101 :: 		initializeEXTI();
BL	_initializeEXTI+0
;Exam_1_test.c,102 :: 		initializeTimer();
BL	_initializeTimer+0
;Exam_1_test.c,104 :: 		while(1)
L_main3:
;Exam_1_test.c,106 :: 		if(print == 1)
MOVW	R0, #lo_addr(_print+0)
MOVT	R0, #hi_addr(_print+0)
LDRSH	R0, [R0, #0]
CMP	R0, #1
IT	NE
BNE	L_main5
;Exam_1_test.c,108 :: 		sprintf(str, "%02d:%02d:%03d", minute, second, milisecond);
MOVW	R0, #lo_addr(_milisecond+0)
MOVT	R0, #hi_addr(_milisecond+0)
LDRSH	R4, [R0, #0]
MOVW	R0, #lo_addr(_second+0)
MOVT	R0, #hi_addr(_second+0)
LDRSH	R3, [R0, #0]
MOVW	R0, #lo_addr(_minute+0)
MOVT	R0, #hi_addr(_minute+0)
LDRSH	R2, [R0, #0]
MOVW	R1, #lo_addr(?lstr_2_Exam_1_test+0)
MOVT	R1, #hi_addr(?lstr_2_Exam_1_test+0)
ADD	R0, SP, #0
PUSH	(R4)
PUSH	(R3)
PUSH	(R2)
PUSH	(R1)
PUSH	(R0)
BL	_sprintf+0
ADD	SP, SP, #20
;Exam_1_test.c,109 :: 		LCD_out(2, 1, str);
ADD	R0, SP, #0
MOV	R2, R0
MOVS	R1, #1
MOVS	R0, #2
BL	_Lcd_Out+0
;Exam_1_test.c,110 :: 		print = 0;
MOVS	R1, #0
SXTH	R1, R1
MOVW	R0, #lo_addr(_print+0)
MOVT	R0, #hi_addr(_print+0)
STRH	R1, [R0, #0]
;Exam_1_test.c,111 :: 		}
L_main5:
;Exam_1_test.c,112 :: 		}
IT	AL
BAL	L_main3
;Exam_1_test.c,113 :: 		}
L_end_main:
L__main_end_loop:
B	L__main_end_loop
; end of _main
