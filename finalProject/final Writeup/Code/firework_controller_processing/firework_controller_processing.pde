import processing.serial.*;

Serial myPort;                       // The serial port
int[] serialInArray = new int[3];    // the array to put three variables in
int serialCount = 0;                 // A count of how many bytes we receive
int xpos, ysp, zcolor;               // define variables
boolean firstContact = false;        //define false first

Firework[] fs = new Firework[10];    // create class to control each firework
boolean once;

void setup() {
  size(2000, 2000);
  smooth();
  for (int i = 0; i < fs.length; i++) {
    fs[i] = new Firework();
  }
  String portName = Serial.list()[1];
  myPort = new Serial(this, portName, 9600);
}  
// setup window, pull out the port using communicating with Arduino


void draw() {
  noStroke();
  fill(0);
  rect(0, 0, width, height);
  for (int i = 0; i < fs.length; i++) {
    fs[i].draw();
  }  
  // setup background, color black, draw a firework when the condition is met

  if (ysp>12 && ysp<200) {
    once = false;
    for (int i = 0; i < fs.length; i++) {
      if ((fs[i].hidden)&&(!once)) {
        fs[i].launch();
        once = true;
        delay(100);
      } else {
      };
    }
  };
  // when the z-axis acceleration is between (12,200), trigger a firework
}



class Firework {
  float x, y, oldX, oldY, ySpeed, targetX, targetY, explodeTimer;
  float flareWeight, flareAngle;
  int flareAmount, duration;
  boolean launched, exploded, hidden;
  color flare;
  // define variables
  Firework() {
    launched = false;
    exploded = false;
    hidden = true;
  }
  // define conditions
  void draw() {
    if ((launched)&&(!exploded)&&(!hidden)) {
      launchMaths();
      strokeWeight(4);
      colorMode(HSB, 255);
      stroke(0, 0, 255);
      line(x, y, oldX, oldY);
    }
    // when the firework is flying up, draw it as a white point
    if ((!launched)&&(exploded)&&(!hidden)) {
      explodeMaths();
      strokeWeight(flareWeight);
      stroke(flare);
      for (float i = 0; i < 2*flareAmount + 1; i++) {
        pushMatrix();
        translate(x, y);
        point(sin(radians(i*flareAngle))*explodeTimer, cos(radians(i*flareAngle))*explodeTimer);
        popMatrix();
      }
      // when exploding, draw flares around the explod point
    }
    if ((!launched)&&(!exploded)&&(hidden)) {
      // when disappearing, do nothing
    }
    //println(xpos + "\t" + ysp + "\t" + zcolor); for debugging
  }
  
  void launch() {
    x = oldX = map(xpos, 0, 180, 100, 1900) + ((random(5)*10) - 25); // control the firework start point by the x-axis angle, using map
    y = oldY = height;
    targetX = map(xpos, 0, 180, 100, 2000);
    targetY = random(200, 1500);  // decide position
    ySpeed = map(ysp, 0, 40, 0, 3)+12;  // control the firework flying speed by z-axis acceleration, using map
    colorMode(HSB, 255);   // in HSB mode, it is possible to control color with one variable and gets a colorful output, RGB just gives you greyscale
    flare = color(zcolor, zcolor, zcolor);  //control color by FSR value
    flareAmount = 36; 
    flareWeight = ceil(random(4, 8));  // the width of each flare
    duration = ceil(random(4))*30 + 200;  // time stay on screen
    flareAngle = 360/flareAmount;  // calculating angle
    launched = true;
    exploded = false;
    hidden = false;  // condition
  }
  void launchMaths() {
    oldX = x;
    oldY = y;
    if (dist(x, y, targetX, targetY) > 6) {
      x += (targetX - x)/2;
      y += -ySpeed;
    } else {
      explode();
    }
  } // launching behavior
  void explode() {
    explodeTimer = 0.2;
    launched = false;
    exploded = true;
    hidden = false;
  }  // time explode
  void explodeMaths() {
    if (explodeTimer < duration) {
      explodeTimer+= 0.4;
    } else {
      hide();
    }    
  }  // decide when to hide
  void hide() {
    launched = false;
    exploded = false;
    hidden = true;
  }  //define hide
}  

void serialEvent(Serial myPort) {
  int inByte = myPort.read();
  // read a byte from the serial port:
  if (firstContact == false) {
    if (inByte == 'A') {
      myPort.clear();          // clear the serial port buffer
      firstContact = true;     // you've had first contact from the microcontroller
      myPort.write('A');       // ask for more
    }
  } else {
    serialInArray[serialCount] = inByte;      // Add the latest byte from the serial port to array:
    serialCount++;
 
    if (serialCount > 2 ) {
      xpos = serialInArray[0];
      ysp = serialInArray[1];
      zcolor = serialInArray[2];
      // reading three values in an array
      // print the values (for debugging purposes only):
      //println(xpos + "\t" + ysp + "\t" + zcolor);  // print the values (for debugging purposes only):
      myPort.write('A');  // Send a capital A to request new sensor readings:
      serialCount = 0;  // Reset serialCount:
    }
  }
}