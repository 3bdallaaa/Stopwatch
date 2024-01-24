sbit LCD_RS at GPIOA_ODR.B0;
sbit LCD_EN at GPIOA_ODR.B1;
sbit LCD_D4 at GPIOA_ODR.B2;
sbit LCD_D5 at GPIOA_ODR.B3;
sbit LCD_D6 at GPIOA_ODR.B4;
sbit LCD_D7 at GPIOA_ODR.B5;

int milisecond = 0;
int second = 0;
int minute = 0;
int print = 0;
int counter = 0;


void initializeEXTI()
{
  RCC_APB2ENR = 0x0009; //Enable AFIO, GPIOB

  AFIO_EXTICR1 = 0x0111;              // PB0,1,2 as External interrupts
  EXTI_RTSR = 0x0007;                 // Set interrupt on Rising edge for PB0,1,2
  EXTI_IMR |= 0x0007;                 // Set mask

  NVIC_IntEnable(IVT_INT_EXTI0);      // Enable External interrupt
  NVIC_IntEnable(IVT_INT_EXTI1);
  NVIC_IntEnable(IVT_INT_EXTI2);

  EnableInterrupts();                 // Enables the processor interrupt.
}


void initializeTimer()
{
    RCC_APB1ENR.TIM2EN = 1; //Enable APB bus for Timer 2
    TIM2_CR1.CEN = 0;   //Stop Timer 2
    TIM2_PSC = 0;  //Prescaler is OFF
    TIM2_ARR = 7999;   //1 ms
    NVIC_IntEnable(IVT_INT_TIM2);
    TIM2_DIER.UIE = 1;
    TIM2_CR1.CEN = 1;   //Re-enable the counter
}

void timerInterruptFunction() iv IVT_INT_TIM2
{
    TIM2_SR.UIF = 0;  //Flag
    counter++;
    if (counter==100)
    {
        counter = 0;
        milisecond+=100;
        if (milisecond == 1000)
        {
            milisecond = 0;
            second++;
            if (second == 60)
            {
                second = 0;
                minute++;
            }
        }
        print = 1;
    }
}

void STRAT() iv IVT_INT_EXTI0
{
    EXTI_PR = 0x0001;   // Clear PB0 flag by writing 1 to it
    TIM2_CR1.CEN = 1;
    print = 1;
}

void PAUSE() iv IVT_INT_EXTI1
{
     EXTI_PR = 0x0002;   // Clear PB1 flag
     TIM2_CR1.CEN = 0;   //stop counter
}

void RESET() iv IVT_INT_EXTI2
{
    EXTI_PR = 0x0004;   // Clear PB2 flag
    TIM2_CR1.CEN = 0;   //stop counter
    milisecond = 0;
    second =0;
    minute = 0;
    print = 1;
}


void main()
{
     char str[20];

     GPIO_Config(&GPIOB_BASE, _GPIO_PINMASK_0, _GPIO_CFG_DIGITAL_INPUT);
     GPIO_Config(&GPIOB_BASE, _GPIO_PINMASK_1, _GPIO_CFG_DIGITAL_INPUT);
     GPIO_Config(&GPIOB_BASE, _GPIO_PINMASK_2, _GPIO_CFG_DIGITAL_INPUT);
     GPIO_Config(&GPIOA_BASE, _GPIO_PINMASK_0, _GPIO_CFG_DIGITAL_OUTPUT);

     LCD_init();
     Lcd_Cmd(_LCD_CURSOR_OFF);
     LCD_out(1,1, "Stopwatch:");

     initializeEXTI();
     initializeTimer();

     while(1)
     {
         if(print == 1)
         {
           sprintf(str, "%02d:%02d:%03d", minute, second, milisecond);
           LCD_out(2, 1, str);
           print = 0;
         }
     }
}