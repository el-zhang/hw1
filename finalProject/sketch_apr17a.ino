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
//int inByte = 0;         // incoming serial byte
int fsrPin = 0;     // the FSR and 10K pulldown are connected to a0
int fsrReading=0;     // the analog reading from the FSR resistor divider

void setup() {
  // put your setup code here, to run once:
  Serial.begin(9600);
  Serial.println("hello world");
}

void loop() {
  // put your main code here, to run repeatedly:
  imu::Vector<3> euler = bno.getVector(Adafruit_BNO055::VECTOR_EULER);
  imu::Vector<3> ACCELEROMETER = bno.getVector(Adafruit_BNO055::VECTOR_ACCELEROMETER);
  fsrReading = analogRead(fsrPin);  
  //firstSensor = map(euler.x(),0,240,100,700);

   // secondSensor = map(ACCELEROMETER.y(),-1,5,0,8); 

    //thirdSensor = map(analogRead(fsrPin),0,1000,100,255);
    Serial.println("123");
    Serial.println(firstSensor);
    Serial.println(secondSensor);
    Serial.println(thirdSensor);
}
