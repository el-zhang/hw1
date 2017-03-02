
/*
>> Pulse Sensor Amped 1.1 <<
This code is for Pulse Sensor Amped by Joel Murphy and Yury Gitman
    www.pulsesensor.com 



//  VARIABLES
int pulsePin = A0;                
int blinkPin = 13;                
int fadePin = 5; 
int fadeRate = 0;                
int speaker = 2;                  
const int buttonPin = 4;     
int buttonState = 0;  




volatile int BPM;                 
volatile int Signal;               
volatile int IBI = 600;             
volatile boolean Pulse = false;    
volatile boolean QS = false;        





void setup(){
  pinMode(blinkPin,OUTPUT);         
  pinMode(buttonPin, INPUT);
  Serial.begin(115200);            
  interruptSetup();                

}



void loop(){


  buttonState = digitalRead(buttonPin);
  
  int pitch = map (BPM,60,160,120,1500);
  
  if (buttonState == HIGH) {
    
    if (QS == true){                      
        fadeRate = 255;                  
        QS = false;                      
        tone(speaker,pitch);              
    
       }


  ledFadeToBeat();

  delay(20);                         

  Serial.println(pitch);
  
  }else {
    noTone(2);
    digitalWrite(5, LOW);
  }
  
}

void ledFadeToBeat(){
    fadeRate = fadeRate - 15;                 
    fadeRate = constrain(fadeRate,0,255);   
    if(fadeRate == 0){ noTone(speaker); }
    analogWrite(fadePin,fadeRate);          
  }



