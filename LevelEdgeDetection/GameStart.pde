class GameStart extends GameMode {
  PFont pixel;
  PImage titleScreen;

  GameStart() {
    pixel = createFont("Menuetto.ttf", 80); 
    titleScreen= loadImage("Clean_Up_titlescreen.png");
  }
  void draw() {


    pushStyle();
    background (#000080);
    image(titleScreen, 0, 0);
    titleScreen.resize(1344, 756);
    fill(255);
    if (millis() % 1200 < 800) {
      textAlign(CENTER, CENTER);
      textSize(64);
      textFont(pixel);
      text("GAME START", width/2, height-height/4);
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
