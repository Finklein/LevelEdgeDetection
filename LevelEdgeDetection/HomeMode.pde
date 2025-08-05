class HomeMode extends GameMode {

  java.util.LinkedList<Button> buttons_A; 
  java.util.LinkedList<Button> buttons_B; 

  PImage bgImage;
  PImage controls_p1;
  PImage controls_p2;
  PImage button_p1;
  PImage button_p2;
  PImage button_selected;
  PImage startButton;
  PImage startButtonSelected;
  PImage backButton;
  PImage speedySprite_p1;
  PImage heavySprite_p1;
  PImage succSprite_p1;
  PImage speedySprite_p2;
  PImage heavySprite_p2;
  PImage succSprite_p2;
  PImage buttonSelected;
  PImage backButtonSelected;

  int typeP1; //variable to store Roomba type Player 1 chooses
  int typeP2; //variable to store Roomba type player 2 chosses
  int stageType;

  Button A1;
  Button A2;
  Button A3;

  Button B1;
  Button B2;
  Button B3;

  Button start;
  Button back;
  
  float buttonsHeight;
  int buttonsSize;


  HomeMode(int _stageType) {

    button_p1=loadImage("button_p1.png");
    button_p2=loadImage("button_p2.png");
    buttonSelected = loadImage("buttonSelected.png");

    startButton = loadImage("startButton.png");
    startButtonSelected = loadImage("startButtonSelected.png");

    backButton = loadImage("back_button.png");
    backButtonSelected = loadImage("startButtonSelected.png");
    
    speedySprite_p1 = loadImage("roombaSpriteSpeedy_p1.png");
    succSprite_p1 = loadImage("roombaSpriteSucc_p1.png");
    heavySprite_p1 = loadImage("roombaSpriteHeavy_p1.png");

    speedySprite_p1.resize(100, 100);
    succSprite_p1.resize(150, 150);
    heavySprite_p1.resize(200, 200);

    speedySprite_p2 = loadImage("roombaSpriteSpeedy_p2.png");
    succSprite_p2 = loadImage("roombaSpriteSucc_p2.png");
    heavySprite_p2 = loadImage("roombaSpriteHeavy_p2.png");

    speedySprite_p2.resize(100, 100);
    succSprite_p2.resize(150, 150);
    heavySprite_p2.resize(200, 200);

    buttonsHeight = height/4;
    buttonsSize = 100;

    A1= new ButtonRoomba(width/8, buttonsHeight, buttonsSize, buttonsSize, "SPEEDY", width/8, buttonsHeight, true, 1, button_p1, speedySprite_p1, int(2.9*width/10), buttonSelected);
    A2 = new ButtonRoomba(2*width/8, buttonsHeight, buttonsSize, buttonsSize, "SUCC", 2*width/8, buttonsHeight, false, 2, button_p1, succSprite_p1, int(2.9*width/10), buttonSelected);
    A3 = new ButtonRoomba(3*width/8, buttonsHeight, buttonsSize, buttonsSize, "HEAVY", 3*width/8, buttonsHeight, false, 3, button_p1, heavySprite_p1, int(2.9*width/10), buttonSelected);

    B1 = new ButtonRoomba(4.5*width/8, buttonsHeight, buttonsSize, buttonsSize, "SPEEDY", 4.5*width/8, buttonsHeight, true, 1, button_p2, speedySprite_p2, int(7.3*width/10), buttonSelected);
    B2 = new ButtonRoomba(5.5*width/8, buttonsHeight, buttonsSize, buttonsSize, "SUCC", 5.5*width/8, buttonsHeight, false, 2, button_p2, succSprite_p2, int(7.3*width/10), buttonSelected);
    B3 = new ButtonRoomba(6.5*width/8, buttonsHeight, buttonsSize, buttonsSize, "HEAVY", 6.5*width/8, buttonsHeight, false, 3, button_p2, heavySprite_p2, int(7.3*width/10), buttonSelected);

    start = new Button(46*width/100, 51.5*height/100, int(1.2*startButton.width/3), int(1.2*startButton.height/3), "", 6.5*width/8, height/4, false, 3, startButton, startButtonSelected);
    back = new Button(width/25, height/15, backButton.width/3, backButton.height/3, "", 6.5*width/8, height/4, false, 3, backButton, backButtonSelected);

    buttons_A = new java.util.LinkedList<Button>();
    buttons_B = new java.util.LinkedList<Button>();

    buttons_A.add(A1);
    buttons_A.add(A2);
    buttons_A.add(A3);

    buttons_B.add(B1);
    buttons_B.add(B2);
    buttons_B.add(B3);

    bgImage =loadImage("bg_screen.png");

    controls_p1=loadImage("controls_p1.png");
    controls_p2=loadImage("controls_p2.png");

    controls_p1.resize(int(2*controls_p1.width/3), int(2*controls_p1.height/3));
    controls_p2.resize(2*controls_p2.width/3, 2*controls_p2.height/3);

    stageType=_stageType;
  }

  void draw() { 

    image(bgImage, 0, 0);
    bgImage.resize(1280, 720);

    fill(255);
    
    pushStyle();
    textAlign(CENTER,CENTER);
    textSize(60);
    text("Choose your Roomba", width/2, height/12);
    
    popStyle();
    pushStyle();

    for (Button a : buttons_A) {

      a.draw();
    }

    for (Button b : buttons_B) {

      b.draw();
    }

    fill(255, 0, 0);
    textSize(30);
    text("PLAYER 1", width/8, height/5);


    fill(0, 0, 255);
    textSize(30);
    text("PLAYER 2", 4.5*width/8, height/5);

    //start button and back button
    start.draw();
    back.draw();


    //controls explanation images

    image(controls_p1, width/10, 2.3*height/3);
    image(controls_p2, 1.7*width/3, 2.3*height/3);
    popStyle();
  }

  void mouseClicked() {

//check if button is pressed
    for (Button a : buttons_A) {

      if (a.overRect()==true) {
        buttonClicked(buttons_A);
      }
    }

    for (Button b : buttons_B) {

      if (b.overRect()==true) {
        buttonClicked(buttons_B);
      }
    }
    if (start.overRect()==true) {
      
      for (Button a : buttons_A) {
        if (a.pressed==true) {

          typeP1=a.type; // saves the type of Roomba that was chosen
        }
      }

      for (Button b : buttons_B) {
        if (b.pressed==true) {
          typeP2=b.type;
        }
      }

      gameMode = new CleanUpGame(typeP1, typeP2, stageType);
    }

    if (back.overRect()==true) {
      gameMode = new StageMenu(); //going back to selecting a stage
    }
  }

}

//Button for the Roomba selection that shows the image of the roomba when pressed
class ButtonRoomba extends Button {

  PImage selectedRoomba;
  int roombaPos;

  ButtonRoomba( float _x, float _y, int _rectWidth, int _rectHeight, String _text, float _textX, float _textY, boolean _pressed, int _type, PImage _buttonImage, PImage _selectedRoomba, int _roombaPos, PImage _buttonSelected) {
    super( _x, _y, _rectWidth, _rectHeight, _text, _textX, _textY, _pressed, _type, _buttonImage, _buttonSelected);
    selectedRoomba = _selectedRoomba;
    roombaPos=_roombaPos;
  }

  void draw() {
    pushStyle();
    noStroke();
    buttonImage.resize(rectWidth, rectHeight);
    image(buttonImage, x, y);
    if (pressed==true) {
      buttonSelected.resize(rectWidth, rectHeight);
      image(buttonSelected, x, y);
      pushStyle();
      imageMode(CENTER);
      image(selectedRoomba, roombaPos, 5.5*height/10);
      popStyle();
    }

    textSize(28);
    text(text, textX, textY);

    popStyle();
  }
   
}
