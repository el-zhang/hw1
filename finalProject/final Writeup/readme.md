#### Firework controller

##### Project description
I made a controller for the user to play with in order to trigget their own firework output on the display.
How the fireworks will be shown on the screen is quite controlled by the user: press the FSR with different power to decide color of the firework, move waist from side to side to decide where on the screen the firework appear, then wave the controller in a certain range of the speed to trigger a firework, and the accel of waving will decide the firework's flying speed. Several fireworks can be displayed on the screen at the same time.

##### Choice of hardware and software
In the project, I want to make something people can hold in hand and wave to trigger fireworks, so I came up with the idea of using their movement to control. As I want some beautiful fireworks, one more thing need to be measured during their holding and waving, it could be force or temperature, and I chose force, for people may have different basic body temperature which may cause troubles. there are three main varieties I need to measure: the x-axis angle, the z-axis acceleration, and the force. So I chose BNO055 which can sense angle and acceleration at the same time. As my controller is a quite square, I chose a square FSR.

##### Parts list
Adafruit BNO055 Absolute Orientation Sensor
Square Force-Sensitive Resistor (FSR) - Interlink 406
