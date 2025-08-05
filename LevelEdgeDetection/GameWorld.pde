class GameWorld {

  java.util.LinkedList<GameObject> gameObjects; 
  java.util.LinkedList<Dust> dustObjects;
  java.util.LinkedList<Dust> dustToKeep;// all game objects

  int typeP1;
  int typeP2;
  int stageType;

  int counter = 0; //image stuff
  int i = 0;

  /////////////item Spawning
  int xCord = int(random(0, width));
  int yCord = int(random(0, height));  
  int minWallDist = 100;
  int maxItems = 2;
  float itemSpawnRate = 10; //1 is a good value for gameplay, 20 a good one for testing

  PImage dustSprite = loadImage("dustSprite.png");
  
  PImage level_3_top = loadImage("room_3_design_ontop.png"); //image that is drawn over the roombas


  GameWorld(int _typeP1, int _typeP2, int _stageType) {

    typeP1=_typeP1;
    typeP2=_typeP2;
    stageType = _stageType;

    switch(stageType) {
    case 1:
      level = loadImage("room_1_collision.png");
      displayLevel = loadImage("room_1_design.png");
      break;

    case 2:
      level = loadImage("room_2_collision.png");
      displayLevel = loadImage("room_2_design.png");
      break;

    case 3:
      level = loadImage("room_3_collision.png");
      displayLevel = loadImage("room_3_design.png");
      break;
    }

    displayLevel.resize(1280, 720);
    level.resize(1280, 720);
    level.loadPixels();
    level_3_top.resize(1280, 720);


    gameObjects = new java.util.LinkedList<GameObject>();
    dustObjects = new java.util.LinkedList<Dust>();

    directionImage();
    dircetionColorsImage();
    spawnDust();
  }

  void draw() {     
    pushStyle();
    pushMatrix();

   
    image(displayLevel, 0, 0);


    //Draw Dust
    for (GameObject d : dustObjects) {
      d.draw();
    }

    popStyle();
    popMatrix();
  }

//calculation where the walls are and writing it in a 2D array and coloring horizontal walls black and vertical walls white
  void directionImage() {

    for (int y =0; y<level.height; y++) {
      for (int x=0; x<level.width; x++) {
        if (level.get(x, y)==color(0, 0, 0, 0)&&level.get(x+1, y)==color(0, 0, 0, 0)) {
          dImage [x][y]=color(0, 0, 0, 0);
          counter++;
        } else {
          dImage [x][y]=color(abs(red(level.get(x, y))-red(level.get(x+1, y))));

          // println(counter, (abs(red(level.get(x, y))-red(level.get(x+1, y)))), x, y, red(level.get(x+1, y)), red(level.get(1, y)) );
          counter++;
        }
      }
    }
    counter = 0;
  }

//taking the image from above to color the walls in four different colors to know in which direction the Roomba has to be pushed back when colliding with a wall

  void dircetionColorsImage() {
    for (int y =0; y<level.height; y++) {
      for (int x=0; x<level.width; x++) {
        try {
          if (dImage[x][y]==color(255) && dImage[x+1][y]==color(0, 0, 0, 0)) {
            dImage[x][y]=color(0, 255, 0);
          } else if (dImage[x][y]==color(255) && dImage[x-1][y]==color(0, 0, 0, 0)) {
            dImage[x][y]=color(0, 255, 255);
          } else if (dImage[x][y]==color(0) && dImage[x][y+1]==color(0, 0, 0, 0)) {
            dImage[x][y]=color(255, 0, 0);
          } else if (dImage[x][y]==color(0) && dImage[x][y-1]==color(0, 0, 0, 0)) {
            dImage[x][y]=color(255, 255, 0);
          }
        }
        catch(Exception e) {
          continue;
        }
      }
    }
  }

//filling the level up with dust while taking into consideration where the Roomba and walls are 
  void spawnDust() {

    Dust dust;

    for (int x = 0; x<1210; x+=50) {
      for (int y = 0; y<720; y+=50) {

        try {
          if ( dImage[x-(dustSprite.height/3)][y-(dustSprite.height/3)]==color(0)
            || dImage[x+(dustSprite.height/3)][y+(dustSprite.height/3)]==color(0) 
            || dImage[x-(dustSprite.height/3)][y+(dustSprite.height/3)]==color(0)
            || dImage[x+(dustSprite.height/3)][y-(dustSprite.height/3)]==color(0)
            || dImage[x][y]==color(0)
            ) {
          } else {
            dust = new Dust(this, x+random(-5, 5), y+random(-5, 5), random(360), int (random(2)));
            dustObjects.add(dust);
            i++;
          }
        }
        catch(Exception e) {
          continue;
        }
      }
    }
  } 
}
