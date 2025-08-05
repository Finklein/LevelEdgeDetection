class CleanUpGame extends GameMode {

  GameWorld gameWorld;

  // UI attributes ===================================================================

  // last time draw() was called - for animations
  int millisDrawWasLastCalled;
  
  
  float left_p1 = 0;
  float right_p1 = 0;
  float down_p1 = 0;
  float up_p1 = 0;

  float left_p2 = 0;
  float right_p2 = 0;
  float down_p2 = 0;
  float up_p2 = 0;
  
  int typeP1;
  int typeP2;
  int stageType;

  // constructor and methods =========================================================

  CleanUpGame(int _typeP1, int _typeP2, int _stageType) {
    typeP1=_typeP1;
    typeP2=_typeP2;
    stageType=_stageType;
    
    millisDrawWasLastCalled = millis();    
    gameWorld = new GameWorld(typeP1,typeP2,stageType);


  }

  void draw() {

    int millisNow = millis();
    float timeElapsed = (millisNow - millisDrawWasLastCalled) / 1000.0; // since the last frame, in seconds.

    // draw, in the Processing world, includes updating the game state - hence, animate all objects from draw()
    gameWorld.draw();

    gameWorld.animate(timeElapsed, up_p1, down_p1, left_p1, right_p1, 
                                   up_p2, down_p2, left_p2, right_p2);
                                  

    millisDrawWasLastCalled = millisNow; 
    
  }
  
  void  keyPressed()
{
  if (keyCode == 'D') //first players buttons
  {
    right_p1 = 1;
  }
  if (keyCode == 'A')
  {
    left_p1 = -1;
  }
  if (keyCode == 'W')
  {
    up_p1 = 1;
  }
  if (keyCode == 'S') 
  {
    down_p1 = -1;
  }

  if (keyCode == RIGHT) //second players buttons
  {
    right_p2 = 1;
  }
  if (keyCode == LEFT)
  {
    left_p2 = -1;
  }
  if (keyCode == UP)
  {
    up_p2 = 1;
  }
  if (keyCode == DOWN) 
  {
    down_p2 = -1;
  }
}

void keyReleased()
{
  // Reset our key states to 0 when released.
  if (keyCode == 'D')
  {
    right_p1 = 0;
  }
  if (keyCode == 'A')
  {
    left_p1 = 0;
  }
  if (keyCode == 'W')
  {
    up_p1 = 0;
  }
  if (keyCode == 'S')  
  {
    down_p1 = 0;
  }   

  if (keyCode == RIGHT) //second players buttons
  {
    right_p2 = 0;
  }
  if (keyCode == LEFT)
  {
    left_p2 = 0;
  }
  if (keyCode == UP)
  {
    up_p2 = 0;
  }
  if (keyCode == DOWN) 
  {
    down_p2 = 0;
  }
}

}
