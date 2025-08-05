abstract class GameObject {

  GameWorld gameWorld;

  GameObject(GameWorld _gameWorld) {
    gameWorld = _gameWorld;
  }

  void UpdateVelocity() {
  }
  void CheckPlayerCollision() {
  }
  void UpdateDirection() {
  }
  void CollideLevel() {
  }
  abstract void draw();
}
void DashedCircle(float radius, int dashWidth, int dashSpacing) {

  int steps = 200;
  int dashPeriod = dashWidth + dashSpacing;
  boolean lastDashed = false;

  for (int i = 0; i < steps; i++) {
    boolean curDashed = (i % dashPeriod) < dashWidth;
    if (curDashed && !lastDashed) {
      beginShape();
    }
    if (!curDashed && lastDashed) {
      endShape();
    }
    if (curDashed) {
      float theta = map(i, 0, steps, 0, TWO_PI);
      vertex(cos(theta) * radius, sin(theta) * radius);
    }
    lastDashed = curDashed;
  }
  if (lastDashed) {
    endShape();
  }
}



class Dust extends GameObject {

  PImage dustSprite = loadImage("dustSprite.png");
  PImage dustSprite_v2= loadImage("dustSprite_v2.png");
  PImage [] sprites = {dustSprite, dustSprite_v2};   //array of sprites for random drawing of dust 
  int dustSprite_index;  //the index that determines the dust sprite to be drawn
  PVector position; 
  float radius;
  boolean suckedIn;
  float dustRotation;

  Dust(GameWorld _gameWorld, float x, float y, float _dustRotation, int _dustSprite_index) {

    super(_gameWorld);
    position = new PVector(x, y); 
    dustRotation = _dustRotation;
    radius = 10;
    suckedIn = false;
    dustSprite_index= _dustSprite_index;
  }

  void UpdateVelocity(Roomba player1, Roomba player2) {

    PVector toRoomba1 = (player1.position.copy().sub(position.copy()));      //direction dust->player1
    toRoomba1.normalize();

    if (PVector.dist(player1.position, position) < player1.suctionRadius) {    //attraction to player1 if within suction reach      
      position.add(toRoomba1.mult(player1.suctionStrength));
    }

    PVector toRoomba2 = (player2.position.copy().sub(position.copy()));       //direction dust->player2
    toRoomba2.normalize();

    if (PVector.dist(player2.position, position) < player2.suctionRadius) {     //attraction to player2 if within suction reach      
      position.add(toRoomba2.mult(player2.suctionStrength));
    }
  }


  void draw() {

    pushStyle();
    imageMode(CENTER);
    pushMatrix();
    translate(position.x, position.y);
    rotate(radians(dustRotation));
    image(sprites[dustSprite_index], 0, 0);  


    popMatrix();
    popStyle();
  }
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////7////////end of dust code

class Roomba extends GameObject {

  float dampingFactor = 0.4;

  PVector position;
  PVector direction;
  PVector velocity;
  PVector stoss;
  float rotateSpeed;
  float speed;
  int radius;
  float maxSpeed;
  float accel;
  float suctionRadius;
  float mass;
  float suctionStrength;
  int type;

  boolean hasCat = false;

  color outlineColor = (0);

  int minFreq;

  PImage roombaSprite;
  PImage catOnTop = loadImage("neko_onTop.png");
  PImage specSprite; // sprite which defines type of roomba


  Roomba(GameWorld _gameWorld, float x, float y, PVector _direction, PImage _roombaSprite) {

    super(_gameWorld);
    position = new PVector(x, y);
    direction = _direction;
    velocity = new PVector (0.0, 0.0);
    stoss = new PVector (0.0, 0.0);
    speed = 0;
    roombaSprite = _roombaSprite;
  }  


  void UpdateVelocity(float deltaTimeSeconds, float up, float down) {


    float speed2 = (accel * (deltaTimeSeconds*deltaTimeSeconds)) * (up + down) ; //speed gets added by time-squared but only if a key is pressed
    speed += speed2;

    speed *= pow(dampingFactor, deltaTimeSeconds);

    if (speed > maxSpeed) {
      speed = maxSpeed;
    }


    velocity.x = direction.x * (speed);
    velocity.y = direction.y * (speed);


    stoss.mult(pow(dampingFactor, deltaTimeSeconds));

    if (stoss.mag() < 0.00001) {  
      stoss = new PVector (0, 0);
    }

    position.add(velocity).add(stoss);
  }


  void CheckPlayerCollision(Roomba otherRoomba) { 

    float distance = PVector.dist(position, otherRoomba.position);

    PVector movement_p1 = velocity.copy().add(stoss);
    PVector otherMovement_p2 = otherRoomba.velocity.copy().add(otherRoomba.stoss);  //gesamtBewegung der Spieler (eigenbewegung + bewegung von stössen)


    if (distance < (radius + otherRoomba.radius)) {


      float nx = (position.x - otherRoomba.position.x) / distance; 
      float ny = (position.y - otherRoomba.position.y) / distance;
      float p = 2 * (otherMovement_p2.x * nx + otherMovement_p2.y * ny - movement_p1.x * nx - movement_p1.y * ny) / (otherRoomba.mass + mass);


      PVector v1 = new PVector ((movement_p1.x + p * otherRoomba.mass * nx), (movement_p1.y + p * otherRoomba.mass * ny ));
      PVector v2 = new PVector ((otherMovement_p2.x - p * mass * nx), (otherMovement_p2.y - p * mass * ny ));

      otherRoomba.speed = 0;
      speed = 0;

      stoss = v1;
      otherRoomba.stoss = v2;
    }
  }


  void UpdateDirection(float left, float right, float deltaTimeSeconds) {


    direction.rotate(rotateSpeed * (left + right) * deltaTimeSeconds);
  }


  //collision with the colored collision image
  void CollideLevel() {
    PVector priorVelocity = velocity.copy().add(stoss.copy());
    //collision with a wall on the left
    for (int i =0; i<=radius; i++) {
      if (dImage[(int)position.x-i][(int)position.y]==color(0, 255, 0) ) {

        if (priorVelocity.x < 0) {                            
          stoss.x = priorVelocity.x*-1+0.25;
        }
        speed = 0;
        stoss.y = priorVelocity.y;
      }
    }
    //collision with a wall on the right
    for (int i =0; i<=radius; i++) {
      if (dImage[(int)position.x+i][(int)position.y]==color(0, 255, 255) ) {

        if (priorVelocity.x > 0) {                            
          stoss.x = priorVelocity.x*-1-0.25;
        }
        speed = 0;
        stoss.y = priorVelocity.y;
      }
    }
    //collision with wall facing up
    for (int i =0; i<=radius; i++) {
      if (dImage[(int)position.x][(int)position.y+i]==color(255, 255, 0) ) {

        if (priorVelocity.y > 0) {                            
          stoss.y = priorVelocity.y*-1-0.25;
        }
        speed = 0;
        stoss.x = priorVelocity.x;
      }
    }
    //collision with wall facing down
    for (int i =0; i<=radius; i++) {
      if (dImage[(int)position.x][(int)position.y-i]==color(255, 0, 0) ) {

        if (priorVelocity.y < 0) {                            
          stoss.y = priorVelocity.y*-1+0.25;
        }
        speed = 0;
        stoss.x = priorVelocity.x;
      }
    }
  }

  void draw() {
    pushStyle();
    imageMode(CENTER);

    pushMatrix();
    translate(position.x, position.y);
    rotate(direction.heading());    

    ellipseMode(RADIUS);
    //fill(0);
    roombaSprite.resize(int(radius*2.5), int(radius*2.5));
    image(roombaSprite, 0, 0);
    specSprite.resize(int(radius*2.5), int(radius*2.5));
    image(specSprite, 0, 0);


    if (hasCat) {

      catOnTop.resize(int(radius*2.5), int(radius*2.5));
      image(catOnTop, 0, 0);
    }


    noFill(); 
    stroke(outlineColor);
    DashedCircle(suctionRadius, 5, 5);

    popMatrix();
    popStyle();
  }
} 

class RoombaSpeedy extends Roomba {


  RoombaSpeedy(GameWorld _gameWorld, float x, float y, PVector _direction, PImage _roombaSprite) {

    super(_gameWorld, x, y, _direction, _roombaSprite);

    rotateSpeed = 4;
    radius = 25;
    accel = 190;
    suctionRadius = 45;
    mass = 0.8;
    suctionStrength = 1.1;
    type = 1;

    maxSpeed = 12;

    minFreq = 150;
    specSprite= loadImage("roombaSpeedy.png");
  }
}

class RoombaSucc extends Roomba {


  RoombaSucc(GameWorld _gameWorld, float x, float y, PVector _direction, PImage _roombaSprite) {

    super(_gameWorld, x, y, _direction, _roombaSprite);

    rotateSpeed = 3;
    radius = 30;
    accel = 150;
    suctionRadius = 65;
    mass = 1;
    suctionStrength = 1.4;
    type = 2;

    maxSpeed = 10;
    minFreq = 120;
    specSprite= loadImage("roombaSucc.png");
  }
}

class RoombaHeavy extends Roomba {


  RoombaHeavy(GameWorld _gameWorld, float x, float y, PVector _direction, PImage _roombaSprite) {

    super(_gameWorld, x, y, _direction, _roombaSprite);

    rotateSpeed = 2;
    radius = 35;
    accel = 100;
    suctionRadius = 55;
    mass = 10;
    suctionStrength = 1.5;
    type = 3;


    maxSpeed = 6;
    minFreq = 100;
    specSprite= loadImage("roombaHeavy.png");
  }
}


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////end of roomba code

class PowerUp extends GameObject { 

  PImage itemSprite_speed = loadImage("speed_powerUp.png"); 
  PImage itemSprite_suck = loadImage("suck_powerUp.png"); 
  PImage itemSprite_punch = loadImage("punch_powerUp.png"); 
  PImage itemSprite_neko = loadImage("neko_powerUp.png"); 
  PVector position;
  boolean suckedIn = false;
  float timeActive;
  int type;

  float minOutline;
  float maxOutline;
  float outline;
  color outlineColor = color(0);

  PowerUp(GameWorld _gameWorld, float x, float y, int _type, boolean _suckedIn) {

    super(_gameWorld);
    position = new PVector (x, y);
    suckedIn = _suckedIn;
    timeActive = 5;
    type = _type;

    minOutline = 30;
    maxOutline = 55;
    outline = minOutline;
  }

  void UpdateVelocity(Roomba player1, Roomba player2) {

    PVector toRoomba1 = (player1.position.copy().sub(position.copy()));      //direction item->player1
    toRoomba1.normalize();

    if (PVector.dist(player1.position, position) < player1.suctionRadius) {    //attraction to player1 if within suction reach      
      position.add(toRoomba1.mult(player1.suctionStrength));
    }

    PVector toRoomba2 = (player2.position.copy().sub(position.copy()));       //direction item->player2
    toRoomba2.normalize();

    if (PVector.dist(player2.position, position) < player2.suctionRadius) {     //attraction to player2 if within suction reach      
      position.add(toRoomba2.mult(player2.suctionStrength));
    }
  } 
  void draw() {

    pushStyle();
    imageMode(CENTER);
    pushMatrix();
    translate(position.x, position.y);
    strokeWeight(1.5);

    switch(type) {  

    case 1 :  

      itemSprite_suck.resize(50, 50);
      image(itemSprite_suck, 0, 0);
      outlineColor = color(0, 255, 255);
      break;

    case 2 :
      itemSprite_speed.resize(50, 50);
      image(itemSprite_speed, 0, 0);
      outlineColor = color(255, 0, 0);
      break;

    case 3 :
      itemSprite_neko.resize(50, 50);
      image(itemSprite_neko, 0, 0);
      outlineColor = color(0, 0, 0);
      break;

    case 4 :
      itemSprite_punch.resize(50, 50);
      image(itemSprite_punch, 0, 0);
      outlineColor = color(255, 255, 50);
      break;
    }

    noFill();
    //ellipse(0, 0, outline, outline);  //Halo effect for power ups
    //ellipse(0, 0, outline+15, outline+15);
    stroke(outlineColor);
    DashedCircle(outline, 4, 10);
    DashedCircle(outline-15, 5, 5);

    popMatrix();
    popStyle();
  }
} 
