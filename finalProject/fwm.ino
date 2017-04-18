#include <Wire.h>
#include <Adafruit_Sensor.h>
#include <Adafruit_BNO055.h>
#include <utility/imumaths.h>
#define BNO055_SAMPLERATE_DELAY_MS (100)
Adafruit_BNO055 bno = Adafruit_BNO055();

int firstSensor = 0;    // first analog sensor-startpoint-posX
int secondSensor = 0;   // second analog sensor-speed-accely
int thirdSensor = 0;    // digital sensor-pressure-color
int forthSensor = 0; 
int inByte = 0;         // incoming serial byte
int fsrPin = 0;     // the FSR and 10K pulldown are connected to a0
int fsrReading;     // the analog reading from the FSR resistor divider

void setup() {
  // start serial port at 9600 bps:
  Serial.begin(9600);
  pinMode(A0,INPUT);
  pinMode(A4,INPUT);
  pinMode(A5,INPUT);
   while (!Serial) {
    ; // wait for serial port to connect. Needed for native USB port only
  }
  establishContact();  // send a byte to establish contact until receiver responds
}

void loop() {
  // if we get a valid byte, read analog ins:
  imu::Vector<3> euler = bno.getVector(Adafruit_BNO055::VECTOR_EULER);
  imu::Vector<3> ACCELEROMETER = bno.getVector(Adafruit_BNO055::VECTOR_ACCELEROMETER);
  fsrReading = analogRead(fsrPin);  
  if (Serial.available() > 0) {
    inByte = Serial.read();
   
    firstSensor = map(euler.x(),0,240,100,700);

    secondSensor = map(ACCELEROMETER.y(),-1,5,0,8); 

    thirdSensor = map(analogRead(fsrPin),0,1000,100,255);

//    forthSensor = analogRead(A1);
    

    Serial.write(firstSensor);
    Serial.write(secondSensor);
    Serial.write(thirdSensor);
 
    //Serial.write(forthSensor);
}
    Serial.print(firstSensor);
    Serial.print(secondSensor);
    Serial.print(thirdSensor);
  

}

void establishContact() {
  while (Serial.available() <= 0) {
  Serial.println("A");   // send a capital A
  delay(300);
  }
}


