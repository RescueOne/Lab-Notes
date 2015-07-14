////////////////////////////////////////////////
// TINAH Template Program - UBC Engineering Physics 253
// (nakane, 2015 Jan 2)  - Updated for use in Arduino IDE (1.0.6)
/////////////////////////////////////////////////

#include <phys253.h>          
#include <LiquidCrystal.h>    

void setup()
{  
  #include <phys253setup.txt>
  Serial.begin(9600) ;
  
}

void loop()
{
  int MOTOR = 0;
  
  while (true) {
    double knob6 = knob(6);
    double knob7 = knob(7);
    int speedM = (knob6/2.0)-254.5;
    int angle = floor(knob6/(1023/180));
    if (angle >= 180) {angle = 180;}
    motor.speed(MOTOR, speedM);
    RCServo1.write(angle);
    LCD.setCursor(0,0); LCD.print("      "); 
    LCD.setCursor(0,0); LCD.print(speedM);
    LCD.setCursor(0,1); LCD.print("      "); 
    LCD.setCursor(0,1); LCD.print(angle);
  }
}
