class StageMenu extends GameMode {
  java.util.LinkedList<Button> stageButtons; 
  int stageType; //variable to store which stage was chosen

  PImage titleScreen;
  PImage none;
  Button stage1;
  Button stage2;
  Button stage3;

  Button next;

  PImage stageThumb1;
  PImage stageThumb2;
  PImage stageThumb3;
  PImage roombaSelectMenu;

  PImage nextSelected;
  PImage buttonStageSelected;

  int scaleFacWidth;
  int scaleFacHeight;
  int widthres;
  int hight;

  StageMenu() {

    titleScreen = loadImage("bg_screen.png");
    stageThumb1= loadImage("level_1_thumb.png");
    stageThumb2= loadImage("level_2_thumb.png");
    stageThumb3= loadImage("level_3_thumb.png");
    roombaSelectMenu = loadImage("roombaSelectionButton.png");

    nextSelected = loadImage("startButtonSelected.png");
    buttonStageSelected = loadImage("level_selected.png");


    scaleFacWidth =stageThumb1.width/3;
    scaleFacHeight =stageThumb1.height/3;
    hight= height/3;
    widthres = (width/2)-(scaleFacWidth/2);

    stage1=new Button(widthres-400, hight, scaleFacWidth, scaleFacHeight, "LIVING ROOM", widthres-400, hight-10, true, 1, stageThumb1, buttonStageSelected );
    stage2=new Button(widthres, hight, scaleFacWidth, scaleFacHeight, "KITCHEN", widthres, hight-10, false, 2, stageThumb2, buttonStageSelected);
    stage3=new Button(widthres+400, hight, scaleFacWidth, scaleFacHeight, "BATHROOM", widthres+400, hight-10, false, 3, stageThumb3, buttonStageSelected);

    next = new Button(widthres, hight+250, scaleFacWidth, scaleFacHeight, "", widthres, hight+190, false, 1, roombaSelectMenu, nextSelected);

    stageButtons = new java.util.LinkedList<Button>();
    stageButtons.add(stage1);
    stageButtons.add(stage2);
    stageButtons.add(stage3);
  }
  void draw() {


    pushStyle();

    image(titleScreen, 0, 0);
    titleScreen.resize(1344, 756);
    fill(255);
    textAlign(CENTER, CENTER);
    textSize(64);

    text("CHOOSE YOUR STAGE", width/2, height/6);
    popStyle();
    for (Button a : stageButtons) {

      a.draw();
    }

    next.draw();
  }
  void mouseClicked() {
    for (Button a : stageButtons) {

      if (a.overRect()==true) {
        buttonClicked(stageButtons);
      }
    }


    if (next.overRect()==true) {

      for (Button a : stageButtons) {
        if (a.pressed==true) {


        }
      }
    }
  }
}
class Button {
  float x;
  float y;
  int rectWidth;
  int rectHeight;
  String text;
  float textX;
  float textY;
  boolean pressed;

  int type; //stores the stage or Roomba type
  PImage buttonImage;
  PImage buttonSelected;



  //general button for start, back , stages etc.
  Button(float _x, float _y, int _rectWidth, int _rectHeight, String _text, float _textX, float _textY, boolean _pressed, int _type, PImage _buttonImage, PImage _buttonSelected) {
    x=_x;
    y=_y;
    rectWidth = _rectWidth;
    rectHeight = _rectHeight;
    text = _text;
    textX = _textX;
    textY = _textY;


    pressed=_pressed;
    type=_type;
    buttonImage = _buttonImage;
    buttonSelected = _buttonSelected;
  }

  void draw() {
    pushStyle();


    noStroke();
    buttonImage.resize(rectWidth, rectHeight);
    image(buttonImage, x, y);
    if (pressed==true) {
      buttonSelected.resize(rectWidth, rectHeight);
      image(buttonSelected, x, y);
    }
    if ( overRect()==true) {
      buttonSelected.resize(rectWidth, rectHeight);
      image(buttonSelected, x, y);
    }
    
    textSize(25);
    text(text, textX, textY);

    popStyle();
  }

  //test if mouse is over the button
  boolean overRect() {
    if (mouseX >= x && mouseX <= x+rectWidth && 
      mouseY >= y && mouseY <= y+rectHeight) {

      return true;
    } else {

      return false;
    }
  }
}

//sets pressed to true and plays a click sound
void buttonClicked( java.util.LinkedList<Button> buttons ) {
  for (Button b : buttons) {

    if (b.overRect()==true) {
      b.pressed=true;

      for (Button a_1 : buttons) {
        if (b!=a_1 && a_1.pressed==true) {
          a_1.pressed=false;
        }
      }
    }
  }
}
