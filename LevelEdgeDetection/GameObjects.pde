abstract class GameObject {

  GameWorld gameWorld;

  GameObject(GameWorld _gameWorld) {
    gameWorld = _gameWorld;
  }
  void CollideLevel() {
  }
  abstract void draw();
}



class Dust extends GameObject {

  PImage dustSprite = loadImage("dustSprite.png");
  PImage dustSprite_v2= loadImage("dustSprite_v2.png");
  PImage [] sprites = {dustSprite, dustSprite_v2};   //array of sprites for random drawing of dust 
  int dustSprite_index;  //the index that determines the dust sprite to be drawn
  PVector position; 
  float radius;
  float dustRotation;

  Dust(GameWorld _gameWorld, float x, float y, float _dustRotation, int _dustSprite_index) {

    super(_gameWorld);
    position = new PVector(x, y); 
    dustRotation = _dustRotation;
    radius = 10;
    dustSprite_index= _dustSprite_index;
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
