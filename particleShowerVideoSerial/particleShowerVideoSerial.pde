import processing.video.*;
import processing.serial.*;

ArrayList<Water> drops;

int videoScale = 20;
int cols, rows;
Capture video;

// Serial setup
Serial port;
String myString = null;
int nl = 10;
float myVal = 500;  // Default value
float psz = 20;     // Will be mapped from serial input

void setup() {
  fullScreen();
  //size(600,400);
  background(0);
  noStroke();

  rows = height / videoScale;
  cols = rows / 2;

  video = new Capture(this, cols, rows);
  video.start();

  // Initialize Serial port
  String portName = Serial.list()[3]; // port 3 for mac
  port = new Serial(this, portName, 9600);
  println("Using port: " + portName);

  drops = new ArrayList<Water>();
  addParticle();
}

void captureEvent(Capture video) {
  video.read();
}

void addParticle() {
  drops.add(new Water(new PVector(width / 2, 50)));
  for (int i = 0; i < 2; i++) {
    drops.add(new Water(new PVector(random(width / 2 - 60, width / 2 + 60), 50)));
    drops.add(new Water(new PVector(random(width / 2 - 60, width / 2 + 60), 50)));
    drops.add(new Water(new PVector(width / 2, 50 + 60)));
  }
}

void draw() {
  // Serial read
  while (port.available() > 0) {
    myString = port.readStringUntil(nl);
    println(myString);
    if (myString != null) {
      myVal = float(trim(myString));  // Convert to float
      //println("Raw sensor value: " + myVal);
    }
  }

  // Map serial input to size range
  psz = map(myVal, 200, 600, 10, 140);
  psz = constrain(psz, 10, 140);

  addParticle();
  PVector gravity = new PVector(0, 0.3);

  for (int i = drops.size() - 1; i >= 0; i--) {
    Water p = drops.get(i);
    p.applyForce(gravity);
    p.update();
    p.sz = psz;
    p.display();
    if (p.isDead()) {
      drops.remove(i);
    }
  }
}
