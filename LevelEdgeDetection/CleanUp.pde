GameMode gameMode;

//import ddf.minim.*;
//import ddf.minim.ugens.*;
//import ddf.minim.spi.*;

PImage level; //the collision image for the level
PImage displayLevel; //image that ist shown to the player
int [][]dImage = new int [1280][720]; //array for saving the image for collision detection


void setup() {
  size(1280,720, P3D);
  frameRate(60);   
  gameMode = new GUI();
  
}

void draw() {
  gameMode.draw();
}

void mouseClicked() {
  gameMode.mouseClicked();
}

void keyPressed() {
  gameMode.keyPressed();
}

void keyReleased() {
  gameMode.keyReleased();
}

void mousePressed() {
  gameMode.mousePressed();
}

void mouseReleased() {
  gameMode.mouseReleased();
}
