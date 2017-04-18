import processing.serial.*;

Serial myPort;                       // The serial port
int[] serialInArray = new int[3];    // Where we'll put what we receive
int serialCount = 0;                 // A count of how many bytes we receive
int xpos, ysp, zcolor;   
boolean firstContact = false; 


ArrayList<Fire> hanabi = new ArrayList();

final int FIRE_COUNT = 1000;
final float X = 200;
final float Y = 50;

final float G = 0.04;

/*
///////

  setup
   
//////
*/
void setup()
{
   size(400,400);

   

   String portName = Serial.list()[1];
   myPort = new Serial(this, portName, 9600);
}

void serialEvent(Serial myPort) {
  // read a byte from the serial port:
  int inByte = myPort.read();
  // if this is the first byte received, and it's an A,
  // clear the serial buffer and note that you've
  // had first contact from the microcontroller.
  // Otherwise, add the incoming byte to the array:
  if (firstContact == false) {
    if (inByte == 'A') {
      myPort.clear();          // clear the serial port buffer
      firstContact = true;     // you've had first contact from the microcontroller
      myPort.write('A');       // ask for more
    }
  }
  else {
    // Add the latest byte from the serial port to array:
    serialInArray[serialCount] = inByte;
    serialCount++;

    // If we have 3 bytes:
    if (serialCount > 2 ) {
      xpos = serialInArray[0];
      ysp = serialInArray[1];
      zcolor = serialInArray[2];

      // print the values (for debugging purposes only):
      println(xpos + "\t" + ysp + "\t" + zcolor);

      // Send a capital A to request new sensor readings:
      myPort.write('A');
      // Reset serialCount:
      serialCount = 0;
    }
  }
}


void draw()
{ noStroke();
  fill(0,40);
  rect(0,0,width,height);
  
  fill(200);

  
  for(Fire fire : hanabi){ 
    fire.vx += 0;
    fire.vy += G;
    
    fire.x += fire.vx;
    fire.y += fire.vy;
    
    if(fire.lifetime-50>0){
      noStroke();
      fill(fire.col, // RGB
         fire.lifetime-50); //Alpha
        
      ellipse(fire.x,fire.y,4,4); // draw the fire
      fire.lifetime -= 0.5; // decrease lifetime
    }else{
    }
  }
      println(xpos + "\t" + ysp + "\t" + zcolor);
}

void mousePressed()
{
    hanabi.clear();

    color c = color(zcolor,zcolor,zcolor);
    
    for(int i=0; i<FIRE_COUNT; i++){
     float r = random(0,TWO_PI);
     float R = random(0,2);
     
     hanabi.add(new Fire(mouseX,mouseY,R*sin(r),R*cos(r),c));
   }

}

class Fire{
  float x;
  float y;
  float vx;
  float vy;
  
  color col;
  
  float lifetime = 100;
  
  Fire(float x, float y, float vx, float vy, color col){
    this.x = x;
    this.y = y;
    this.vx = vx;
    this.vy = vy;
    this.col = col;
  }
} 
  