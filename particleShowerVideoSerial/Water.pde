// A simple Particle class

class Water {
  
  PVector position;
  PVector velocity;
  PVector acceleration;
  float lifespan;
  float sz;

  Water(PVector loc) {
    acceleration = new PVector(0, 0);
    velocity = PVector.random2D();//(0,-1);//(random(-1, 1), random(-2, 0));
    velocity.mult(random(1,4));
    position = loc.copy();
    lifespan = 190.0;
    sz = 10;
  }


  // method to add gravity force from sketch
  void applyForce(PVector force){
   acceleration.add(force); 
  }

  // Method to update position
  void update() {
    velocity.add(acceleration);
    position.add(velocity);
    //reset acceleration
    acceleration.set(0,0);
    lifespan -= 1.0;
  }

  // Method to display
  void display() {
    //stroke(255, lifespan);
    // get the waters position on the video feed
    float x = position.x/rows;//videoScale;
    float y = position.y/videoScale;
    color c = video.get(floor(x),floor(y));
    fill(c);
    ellipse(width-position.x, position.y, sz, sz);
  }

  // Is the particle still useful?
  boolean isDead() {
    if (lifespan < 0.0) {
      return true;
    } else {
      return false;
    }
  }
}
