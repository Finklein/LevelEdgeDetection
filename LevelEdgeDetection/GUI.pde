class GUI extends Interface {
  int stageType; //variable to store which stage was chosen
  
  java.util.LinkedList<Button> displayButtons;

  PImage titleScreen;
  PImage none;

  Button next;
  Button loadDispImg;
  
  Button ColImg;
  Button DispImg;
  Button ShowDust;
  
  PImage roombaSelectMenu;
  PImage button_red;
  PImage button_blue;
  
  PImage button_sq_b;
  PImage button_sq_r;

  PImage nextSelected;
  PImage buttonSelected;
  PImage button_p2_selected;

  int scaleFacWidth;
  int scaleFacHeight;
  int widthres;
  int hight;

  int counter = 0; //image stuff
  int i = 0;

  PImage cImage; //collision image in PImageformat
  // PImage selected; //image selected through dialog
  //int [][]dImage = new int [1280][720]; //array for saving the image for collision detection


  GUI() {

    titleScreen = loadImage("bg_screen.png");
    roombaSelectMenu = loadImage("roombaSelectionButton.png");
    button_blue = loadImage("bgResult_p1.png");
    button_red = loadImage("bgResult_p2.png");
    
    button_sq_r = loadImage("button_p1.png");
    button_sq_b = loadImage("button_p2.png");

    level = loadImage("room_3_collision.png");
    level.resize(1280/4, 720/4);

    nextSelected = loadImage("startButtonSelected.png");
    buttonSelected = loadImage("buttonSelected.png");
    button_p2_selected = loadImage("button_p2_selected.png");


    scaleFacWidth =width/6;
    scaleFacHeight =height/6;
    hight= height/3;
    widthres = (width/2)-(scaleFacWidth/2);

    next = new Button(width/8, height*2/3, button_blue.width/4, button_blue.height/4 , "Create Collision Image", width/3.3, height*2.8/4, 25 ,false, button_blue.height/2 , button_blue, nextSelected);
    loadDispImg = new Button(width/8, height*5/6, button_red.width/4,button_red.height/4, "Load Display Image", width/3.3, height*7/8, 25, false, button_red.height/2, button_red, button_p2_selected);
    
    ColImg = new Button(width/1.8, height*2/3, button_sq_r.width/8, button_sq_r.height/8, "Show Collision Image", width/1.6, height*3/4.2, 25, false, 1, button_sq_r, buttonSelected);
    DispImg = new Button(width/1.8, height*3/4, button_sq_r.width/8, button_sq_r.height/8, "Show Display Image",  width/1.6, height*5/6.3, 25, false, 1, button_sq_b, buttonSelected);
    ShowDust = new Button(width/1.8, height*5/6, button_sq_r.width/8, button_sq_r.height/8, "Show Dust",  width/1.6, height*7/8, 25, false, 1, button_sq_r, buttonSelected);

    cImage = loadImage("room_3_collision.png");
    cImage.resize(cImage.width/4, cImage.height/4);

    selected = loadImage("room_3_collision.png");
    selected.resize(selected.width/4, selected.height/4);
    
    
    displayButtons = new java.util.LinkedList<Button>();
    displayButtons.add(ColImg);
    displayButtons.add(DispImg);
    displayButtons.add(ShowDust);


    //directionImage();
    //dircetionColorsImage();
  }
  void draw() {


    pushStyle();

    image(titleScreen, 0, 0);
    titleScreen.resize(width, height);
    fill(255);
    textAlign(CENTER, CENTER);
    textSize(64);

    if (selected!=null) {
      image(selected, (width/4) - level.width/2, height/4);
    }

    text("Level Edge Detection", width/2, height/8);
    //image(level, (width/4) - level.width/2, height/4);
    image(cImage, (width/1.8), height/4);
    popStyle();

    next.draw();
    loadDispImg.draw();
    for (Button a : displayButtons) {

      a.draw();
    }
  }

  void dircetionColorsImage(PImage selected, PImage cImage) {
    int [][]dImage = new int [selected.width][selected.height]; //array for saving the image for collision detection
    //cImage = selected.copy();

    //calculation where the walls are and writing it in a 2D array and coloring horizontal walls black and vertical walls white
    for (int y =0; y<selected.height; y++) {
      for (int x=0; x<selected.width; x++) {
        if (selected.get(x, y)==color(0, 0, 0, 0)&&selected.get(x+1, y)==color(0, 0, 0, 0)) {
          dImage [x][y]=color(0, 0, 0, 0);
          cImage.set(x, y, dImage[x][y]);
          counter++;
        } else {
          dImage [x][y]=color(abs(red(selected.get(x, y))-red(selected.get(x+1, y))));
          cImage.set(x, y, dImage[x][y]);

          // println(counter, (abs(red(level.get(x, y))-red(level.get(x+1, y)))), x, y, red(level.get(x+1, y)), red(level.get(1, y)) );
          counter++;
        }
      }
    }
    counter = 0;

    //taking the image from above to color the walls in four different colors to know in which direction the Roomba has to be pushed back when colliding with a wall
    for (int y =0; y<selected.height; y++) {
      for (int x=0; x<selected.width; x++) {
        try {
          if (dImage[x][y]==color(255) && dImage[x+1][y]==color(0, 0, 0, 0)) {
            dImage[x][y]=color(0, 255, 0);
            cImage.set(x, y, dImage[x][y]);
          } else if (dImage[x][y]==color(255) && dImage[x-1][y]==color(0, 0, 0, 0)) {
            dImage[x][y]=color(0, 255, 255);
            cImage.set(x, y, dImage[x][y]);
          } else if (dImage[x][y]==color(0) && dImage[x][y+1]==color(0, 0, 0, 0)) {
            dImage[x][y]=color(255, 0, 0);
            cImage.set(x, y, dImage[x][y]);
          } else if (dImage[x][y]==color(0) && dImage[x][y-1]==color(0, 0, 0, 0)) {
            dImage[x][y]=color(255, 255, 0);
            cImage.set(x, y, dImage[x][y]);
          }
        }
        catch(Exception e) {
          continue;
        }
      }
    }
    println("changed direction image");
  }

  void mouseClicked() {
    for (Button a : displayButtons) {

      if (a.overRect()==true) {
        buttonClicked(displayButtons);
      }
    }


    if (next.overRect()==true) {
      selectInput("Select an image to process:", "fileSelected");
      cImage = selected.copy();
      dircetionColorsImage(selected, cImage);
    }
  }

  /// let's the user choose an image to color the edges of
  void fileSelected(File selection) {
    if (selection == null) {
      println("Window was closed or the user hit cancel.");
    } else {
      println("User selected " + selection.getAbsolutePath());
      selected = loadImage(selection.getAbsolutePath());
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
  int textSize;
  boolean pressed;

  int type; //stores the stage or Roomba type
  PImage buttonImage;
  PImage buttonSelected;



  //general button for start, back , stages etc.
  Button(float _x, float _y, int _rectWidth, int _rectHeight, String _text, float _textX, float _textY, int _textSize, boolean _pressed, int _type, PImage _buttonImage, PImage _buttonSelected) {
    x=_x;
    y=_y;
    rectWidth = _rectWidth;
    rectHeight = _rectHeight;
    text = _text;
    textX = _textX;
    textY = _textY;
    textSize = _textSize;


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

    textSize(textSize);
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
      if(b.pressed == true){
       b.pressed = false; 
      }else{
      b.pressed=true;

      //for (Button a_1 : buttons) {
     //   if (b!=a_1 && a_1.pressed==true) {
      //    a_1.pressed=false;
       // }
     // }
      }
    }
  }
}
