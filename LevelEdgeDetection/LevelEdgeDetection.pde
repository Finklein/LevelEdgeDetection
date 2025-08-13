Interface Interface;


PImage level; //the collision image for the level
PImage displayLevel; //image that ist shown to the player
PImage selected; //image selected through dialog

void setup() {
  size(1280,720, P3D);
  surface.setTitle("LevelEdgeDetection");
  //surface.setResizable(true);
  surface.setLocation(100, 100);
  frameRate(60);   

  Interface = new GUI();
  
}

void draw() {
  Interface.draw();
}

void mouseClicked() {
  Interface.mouseClicked();
}

void keyPressed() {
  Interface.keyPressed();
}

void keyReleased() {
  Interface.keyReleased();
}

void mousePressed() {
  Interface.mousePressed();
}

void mouseReleased() {
  Interface.mouseReleased();
}

  /// let's the user choose an image to color the edges of
 void fileSelected(File selection) {
   
    if (selection == null) {
      println("Window was closed or the user hit cancel.");
      fileQueue.put(selection);
    } 
    else {
      println("User selected " + selection.getAbsolutePath());
      selected = loadImage(selection.getAbsolutePath());
      selected.resize(selected.width/4, selected.height/4);
      fileQueue.put(selection);
    }
}
