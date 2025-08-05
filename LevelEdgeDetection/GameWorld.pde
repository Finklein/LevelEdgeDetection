class GameWorld {

  java.util.LinkedList<GameObject> gameObjects; 
  java.util.LinkedList<Dust> dustObjects;
  java.util.LinkedList<Dust> dustToKeep;// all game objects
  java.util.LinkedList<PowerUp> powerUps;

  Roomba player1;
  Roomba player2;
  Roomba reference;
  int typeP1;
  int typeP2;
  int stageType;
  PVector startPosP1;
  PVector startPosP2;
  PVector startDirP1;
  PVector startDirP2;

  int points_p1 = 0;
  int points_p2 = 0;

  int counter = 0; //image stuff
  int i = 0;

  float roundTime = 45; //Timer stuff
  float millisInstanced = millis();
  float remainingTime;
  float lastTicked;
  boolean secondTick = false;

  ///////////////////item effects
  float secondsPickedUp = roundTime*2;
  float secondsPickedUp2 = roundTime*2;  //when was the powerUp picked up, start with any value higher than the roundtime
  float itemTimeActive;
  float itemTimeActive2;

  /////////////item Spawning
  int xCord = int(random(0, width));
  int yCord = int(random(0, height));  
  int minWallDist = 100;
  int maxItems = 2;
  float itemSpawnRate = 10; //1 is a good value for gameplay, 20 a good one for testing

  PImage dustSprite = loadImage("dustSprite.png");
  
  PImage level_3_top = loadImage("room_3_design_ontop.png"); //image that is drawn over the roombas

  ///////////sound stuff
  float maxRoombaLoudness = 0.1; 


  GameWorld(int _typeP1, int _typeP2, int _stageType) {

    typeP1=_typeP1;
    typeP2=_typeP2;
    stageType = _stageType;

    switch(stageType) {
    case 1:
      level = loadImage("room_1_collision.png");
      displayLevel = loadImage("room_1_design.png");
      startPosP1 = new PVector(80, 630);
      startPosP2 = new PVector(1200, 80);
      startDirP1 = new PVector(0, -1);
      startDirP2 = new PVector(0, 1);
      break;

    case 2:
      level = loadImage("room_2_collision.png");
      displayLevel = loadImage("room_2_design.png");
      startPosP1 = new PVector(80, 630);
      startPosP2 = new PVector(1200, 630);
      startDirP1 = new PVector(0, -1);
      startDirP2 = new PVector(0, -1);
      break;

    case 3:
      level = loadImage("room_3_collision.png");
      displayLevel = loadImage("room_3_design.png");
      startPosP1 = new PVector(80, 645);
      startPosP2 = new PVector(1200, 645);
      startDirP1 = new PVector(0, -1);
      startDirP2 = new PVector(0, -1);
      break;
    }

    displayLevel.resize(1280, 720);
    level.resize(1280, 720);
    level.loadPixels();
    level_3_top.resize(1280, 720);

    PImage roomba_p1_sprite = loadImage("roombaSprite_p1.png");
    PImage roomba_p2_sprite = loadImage("roombaSprite_p2.png");

    gameObjects = new java.util.LinkedList<GameObject>();
    dustObjects = new java.util.LinkedList<Dust>();    
    powerUps = new java.util.LinkedList<PowerUp>();

    player1 = spawnPlayer(typeP1, startPosP1, startDirP1, roomba_p1_sprite);
    player2 = spawnPlayer(typeP2, startPosP2, startDirP2, roomba_p2_sprite);

    gameObjects.add(player1);
    gameObjects.add(player2);

    directionImage();
    dircetionColorsImage();
    spawnDust();
  }

  Roomba spawnPlayer(int type, PVector startPos, PVector startDir, PImage sprite) {


    switch (type) {
    case 1:
      return new RoombaSpeedy(this, startPos.x, startPos.y, startDir, sprite);  

    case 2:
      return new RoombaSucc(this, startPos.x, startPos.y, startDir, sprite);

    default:
      return new RoombaHeavy(this, startPos.x, startPos.y, startDir, sprite);
    }
  }


  void animate(float deltaTimeSeconds, float up_p1, float down_p1, float left_p1, float right_p1, 
    float up_p2, float down_p2, float left_p2, float right_p2 ) {


    player1.UpdateVelocity(deltaTimeSeconds, up_p1, down_p1);
    player2.UpdateVelocity(deltaTimeSeconds, up_p2, down_p2);

    player1.UpdateDirection(left_p1, right_p1, deltaTimeSeconds);
    player2.UpdateDirection(left_p2, right_p2, deltaTimeSeconds);

    player1.CollideLevel();
    player2.CollideLevel();

    player1.CheckPlayerCollision(player2);



    HandlePowerUps(deltaTimeSeconds);
    HandleDust();    
    ResetCheck();
    CheckGameEnd();
  }


  void draw() {     
    pushStyle();
    pushMatrix();

   
    image(displayLevel, 0, 0);


    //Draw Dust
    for (GameObject d : dustObjects) {
      d.draw();
    }
    // Draw PowerUps
    for (PowerUp p : powerUps) {
      p.draw();
    }

    //Draw Players
    for (GameObject o : gameObjects) {
      o.draw();
    }  

    //Scoreboard:
    remainingTime = int(roundTime - Timer());
    textAlign(CENTER,CENTER);
    fill(255);
    textSize(35);
    fill(255, 0, 0);
    text("Player 1 : " + points_p1, width/10, height/80);
    fill(0, 0, 255);
    text("Player 2 : " + points_p2, 8.5*width/10, height/80);
    fill(255);


    if (int(roundTime - Timer()) <= 10) { //if under 10 seconds, 

      if (int(roundTime - Timer()) % 2 == 1) { //TimeCounter will blink red every 2 seconds
        fill(255, 255, 0); //color of winner? other color than red?
      }

      if ((millis() - lastTicked) > 1000) { //and play a sound

        if (!secondTick) {
          secondTick = true;
        } else {
          secondTick = false;
        }

        lastTicked = millis();
      }
    }   
    text(int(roundTime - Timer()), width/2, 10);  

    if ( stageType==3) {
      image(level_3_top, 0, 0);
    }

    popStyle();
    popMatrix();
  }


  void CheckGameEnd() {

    if (remainingTime <= 0 || dustObjects.size() == 0) {   


      if (points_p1>points_p2) {
        gameMode = new GameEndsMode("You Win, Player 1", color(255, 0, 0), 1, points_p1, points_p2);
      } 
      if (points_p2>points_p1) {
        gameMode = new GameEndsMode("You Win, Player 2", color(0, 255, 0), 2, points_p1, points_p2);
      }
      if (points_p2==points_p1) {
        gameMode = new GameEndsMode("DRAW!!!", color(125), 0, points_p1, points_p2);
      }
    }
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
            || player1.position.dist(new PVector(x, y)) < dustSprite.height + (player1.radius+player2.radius)/2
            || player2.position.dist(new PVector(x, y)) < dustSprite.height + (player1.radius+player2.radius)/2
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

  void HandleDust() { //bewegung, kollision und löschen von staub

    java.util.LinkedList<Dust>dustToKeep = new java.util.LinkedList<Dust>();  

    for (Dust d : dustObjects) {   

      d.UpdateVelocity(player1, player2);

      testDustCollision(player1, player2, d);

      if ( !d.suckedIn) {

        dustToKeep.add(d);
      } 

      dustObjects = dustToKeep;
    }
  }

  void testDustCollision(Roomba player1, Roomba player2, Dust dust) {

    if (PVector.dist(player1.position, dust.position) < player1.radius * 0.65) {

      dust.suckedIn = true;
      points_p1 += 1;
    }

    if (PVector.dist(player2.position, dust.position) < player2.radius * 0.65) {

      dust.suckedIn = true;

      points_p2 += 1;
    }
  }


  int Timer() {
    int secondsPassed = int((millis() - millisInstanced )/1000);
    return secondsPassed;
  }


  void HandlePowerUps(float deltaTimeSeconds) { //bewegung, kollision und löschen von powerUps

    if (powerUps.size() < maxItems && random(1) < itemSpawnRate * deltaTimeSeconds) {
      SpawnPowerUp();
    }

    java.util.LinkedList<PowerUp>powerUpsToKeep = new java.util.LinkedList<PowerUp>();  

    if (powerUps.size() > 0) {
      for (PowerUp p : powerUps) {

        p.UpdateVelocity(player1, player2);     
        testPowerUpCollision(player1, player2, p);

        p.outline += 15*deltaTimeSeconds;
        if (p.outline > p.maxOutline) {
          p.outline = p.minOutline;
        }

        if (!p.suckedIn) {  

          powerUpsToKeep.add(p);
        }
      }
      powerUps = powerUpsToKeep;
    }
  }


  void SpawnPowerUp() { //mit globalem bool lösen? und nacheinander die abfragen tötigen solang dieser true ist?

    int checkPlace = 0;

    xCord = int(random(50, width-50)); //random placement in whole map
    yCord = int(random(50, height-50));


    PVector powerUpPosition = new PVector(xCord, yCord);

    for (i = 0; i < minWallDist; i++)

    try { 
      if (dImage[xCord-i][yCord-i]!=color(0)
        && dImage[xCord+i][yCord+i]!=color(0) 
        && dImage[xCord-i][yCord+i]!=color(0)
        && dImage[xCord+i][yCord-i]!=color(0)
        && dImage[xCord][yCord]!=color(0)
        ) { 

        checkPlace += 1; 
        if (checkPlace == minWallDist) {
        }

        if ( checkPlace == minWallDist 
          && powerUpPosition.dist(player1.position) > minWallDist*2 
          && powerUpPosition.dist(player2.position) > minWallDist*2) {

          PowerUp powerUp = new PowerUp(this, xCord, yCord, int(random(1, 4.9)), false) ;
          powerUps.add(powerUp);

          /*  if (powerUp.type == 3) { //geräusch beim spawnen der katze?
           meow3.rewind();
           meow3.play();
           }
           */
        }
      } else {
        break;
      }
    }
    catch(Exception e) {
    }
  }


  void testPowerUpCollision(Roomba player1, Roomba player2, PowerUp powerUp) {

    if (PVector.dist(player1.position, powerUp.position) < player1.radius * 0.65) {

      secondsPickedUp = remainingTime;
      itemTimeActive = powerUp.timeActive; 
      PowerUpEffects(player1, powerUp);
    }

    if (PVector.dist(player2.position, powerUp.position) < player2.radius * 0.65) {


      secondsPickedUp2 = remainingTime;      
      itemTimeActive2 = powerUp.timeActive; 
      PowerUpEffects(player2, powerUp);
    }
  }


  void PowerUpEffects(Roomba player, PowerUp powerUp) { 

    ResetStats(player, player.type);
    //sammelt man 2 items, verliert das erste seinen effekt!
    player.outlineColor = powerUp.outlineColor;

    switch(powerUp.type) 
    {
    case 1:
      println("extra Succcccc");
      player.accel *= 0.75;
      player.suctionRadius *= 1.5;
      player.suctionStrength *= 1.7; 
      break;

    case 2:
      println("plusSpeed");
      player.accel *= 2;
      player.rotateSpeed *= 1.3;
      player.maxSpeed *= 2;
      player.minFreq += 50;

      break;

    case 3:
      println("plusGATO");
      player.mass *= 2;
      player.accel *= 0.6;
      player.maxSpeed *= 0.4;
      player.hasCat = true;
      break;

    case 4:
      println("plusWUMMS");
      player.mass *= 4;
      player.accel *= 1.2;

      break;
    }

    powerUp.suckedIn = true;
  }


  void ResetCheck() { 

    if (!PowerUpTimer(itemTimeActive, secondsPickedUp)) {
      ResetStats(player1, player1.type);
    }
    if (!PowerUpTimer(itemTimeActive2, secondsPickedUp2)) {
      ResetStats(player2, player2.type);
    }
  }


  void ResetStats(Roomba player, int type) {

    switch(type)
    {
    case 1:
      reference = new RoombaSpeedy(this, 0, 0, new PVector(0, 0), dustSprite);
      break;

    case 2:
      reference = new RoombaSucc(this, 0, 0, new PVector(0, 0), dustSprite);
      break;

    case 3:
      reference = new RoombaHeavy(this, 0, 0, new PVector(0, 0), dustSprite);
      break;
    }

    if (player.hasCat) { //if the player had the cat item, reset that

      player.hasCat = false;
    }

    player.rotateSpeed = reference.rotateSpeed;   
    player.accel = reference.accel;
    player.suctionRadius = reference.suctionRadius;
    player.mass = reference.mass;
    player.suctionStrength = reference.suctionStrength;
    player.maxSpeed = reference.maxSpeed;
    player.outlineColor = (0);
    player.minFreq = reference.minFreq;
  }


  boolean PowerUpTimer(float timeActive, float secondsPickedUp) {

    if (remainingTime < secondsPickedUp - timeActive) {
      //println(" es ist deaktiviert");
      return false;
    } else {     
      //println("es ist aktiviert");
      return true;
    }
  }
}
