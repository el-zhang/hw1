#include <Wire.h>
#include <Adafruit_Sensor.h>
#include <Adafruit_BNO055.h>
#include <utility/imumaths.h> // include library

#define BNO055_SAMPLERATE_DELAY_MS (100)

Adafruit_BNO055 bno = Adafruit_BNO055(); //Setup BNO055


int xangle = 0;    // BNO055 x-axis angle
int zacceleration = 0;   // BNO055 z-axis acceleration
int force = 0;    // FSR
int inByte = 0;         // incoming serial byte


void setup()
{
  Serial.begin(9600);
  while (!Serial) {
    ; // wait for serial port to connect. Needed for native USB port only
  }

  Serial.println("Orientation Sensor Raw Data Test"); Serial.println("");

  if (!bno.begin())
  {
    Serial.print("Ooops, no BNO055 detected ... Check your wiring or I2C ADDR!");
    while (1);
  }
  
// check whether BNO055 is working

  delay(1000);

  bno.setExtCrystalUse(true);

  establishContact();
}

void loop()
{
  if (Serial.available() > 0) {
    imu::Vector<3> euler = bno.getVector(Adafruit_BNO055::VECTOR_EULER);
    imu::Vector<3> accelerometer = bno.getVector(Adafruit_BNO055::VECTOR_ACCELEROMETER);

    // setup angle and acceleration measurement in BNO055
    
    inByte = Serial.read();
    // read input
    xangle = euler.x();
    // read x-axis angle
    delay(10);
    // delay 10ms to let the ADC recover:
    zacceleration = accelerometer.z();
    // read z-axis accleration
    force = analogRead(A0)/4;
    // read force from FSR and map it to one forth for color control
    Serial.write(firstSensor);
    Serial.write(secondSensor);
    Serial.write(thirdSensor);
    // send sensor values:
  }
}

void establishContact() {
 while (Serial.available() <= 0) {
 Serial.print('A'); // send a capital A
 delay(300);
 }
} // checking communication with processing
