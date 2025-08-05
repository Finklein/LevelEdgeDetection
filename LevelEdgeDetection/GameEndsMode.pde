class GameEndsMode extends GameMode {

  int winner;
  String title;
  color backgroundColor;
  int points_p1;
  int points_p2;
  PImage endscreen_1 = loadImage("endscreen_1.png");
  PImage endscreen_2 = loadImage("endscreen_2.png");
  PImage neutral = loadImage("bg_screen.png");
  PImage bg_p1= loadImage("bgResult_p1.png");
  PImage bg_p2= loadImage("bgResult_p2.png");


  GameEndsMode(String _title, color _backgroundColor, int _winner, int _points_p1, int _points_p2) {
    title = _title;
    backgroundColor = _backgroundColor;
    winner = _winner;
    points_p1 = _points_p1;
    points_p2 = _points_p2;

    endscreen_1.resize(1280, 720);
    endscreen_2.resize(1280, 720);
    neutral.resize(1280, 720);
  }
  void draw() {    
    pushStyle();

    if (winner==1) {
      image(endscreen_1, 0, 0);
    }
    if (winner==2) { 
      image(endscreen_2, 0, 0);
    }
    if (winner==0) {    
      image(neutral, 0, 0);
    }
    pushStyle();
    imageMode(CENTER);
    image(bg_p1, width/4, height/2);
    image(bg_p2, width-(width/4), height/2);
    popStyle();

    textAlign(CENTER, CENTER);
    textSize(80);
    text(title, width/2, height/4);
    textSize(48);

    text("Player 1 Score : " + points_p1, width/4, height/2);

    text("Player 2 Score : " + points_p2, width-(width/4), height/2);

    if (millis() % 1200 < 800) {
      text("Press SPACE to continue.", width/2, height*3/4);
    }
    popStyle();
  }
  void mouseClicked() {
    gameMode = new StageMenu();
  }
  void keyPressed() {
    if (key==' ') {
      gameMode = new StageMenu();
    }
  }
}
