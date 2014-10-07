/*******
/* Copyright (c) 2014 Michael Madden
/* barred_out
/******/

import ddf.minim.*;

Cell[][] grid;
int cols = 6;
int rows = 100;
float sensitivity = 3.6;
float sensitivityDepth = cols/2.0;
float oscillateSpeed = 0.02;

String[] images;
float[] diff;
float threshold = 215.0;
float thresholdAngle = 1.0;
float thresholdSpeed = 0.005;
boolean reverseShading = false;
PImage img;
int useImage = 0;
int border = 1;

Minim minim;
AudioInput in;

void setup(){
  size(displayWidth,displayHeight);
  background(0);  
  minim = new Minim(this);
  in = minim.getLineIn();
  grid = new Cell[cols][rows];   
  for(int i = 0; i < cols; i++){
    for(int j = 0; j < rows; j++){
      grid[i][j] = new Cell(i,j);
    }
  }
  setupImage();
}

void setupImage(){
  diff = new float[width*height];
  img = loadImage("recursive3.png");
  img.resize(width, height);
  img.loadPixels();
  int loc, imgLoc;
  for (int x = 0; x < width; x++) {
    for (int y = 0; y < height; y++) {
      loc = x + y*width;
      imgLoc = x + y*img.width;
      if(x < border || x > width-border || y < border || y > height-border){
        diff[loc] = 255.0;
      }else{
        if(imgLoc < img.pixels.length){
          diff[loc] = brightness(img.pixels[imgLoc]);
        }
      }
    }
  }
}

void draw(){
  for(int i = 0; i < cols; i++){
    for(int j = 0 ; j < rows; j++){
      grid[i][j].oscillate();
      grid[i][j].display();
    }
  }
  if(useImage > 0){
    drawWithImage();
  }
}

void drawWithImage(){
  float currentThreshold;
  if(useImage == 2){
    oscillateThreshold();
    currentThreshold = threshold*sin(thresholdAngle);
    if(currentThreshold < 100){
      thresholdSpeed*=-1;
    }
  }else{
    currentThreshold = threshold-75;
  }
  
  loadPixels();
  color c;
  int loc;
  for (int x = 0; x < width; x++) {
    for (int y = 0; y < height; y++) {
      loc = x + y*width;
      if(diff[loc] > currentThreshold){
        c = reverseShading ? pixels[loc] : color(0);
      }else{
        c = reverseShading ? color(0) : pixels[loc];
      }
      pixels[loc] = c;
    }
  }
  updatePixels();
}

void oscillateThreshold(){
  thresholdAngle+=thresholdSpeed;
}

void stop(){
  in.close();
  minim.stop(); 
  super.stop();
}

void keyReleased(){
  float divisor = float(cols)/20.0;
  if(key == 'r'){
    rows++;
    recalibrateGrid();
  }else if(key == 'R'){
    rows--;
    if(rows < 0){
      rows = 0;
    }
    recalibrateGrid();
  }else if(key == 'c'){
    cols+=2;
    recalibrateGrid();
  }else if(key == 'C'){
    cols-=2;
    if(cols < 0){
      cols = 0;
    }
    recalibrateGrid();
  }else if(key == 's'){
    sensitivity+=divisor;    
  }else if(key == 'S'){
    sensitivity-=divisor;
    if(sensitivity <= 0){
      sensitivity = 0;
    }
  }else if(key == 'd'){
    sensitivityDepth-=divisor;
  }else if(key == 'D'){
    sensitivityDepth+=divisor;
    if(sensitivityDepth <= 0){
      sensitivityDepth = 0;
    }
  }else if(key == 't'){
    threshold+=5.0;
  }else if(key == 'T'){
    threshold-=5.0;
  }else if(key == 'i'){
    useImage++;
    if(useImage > 2){
      useImage = 0;
    }
  }else if(key == 'I'){
    reverseShading = !reverseShading;
  }else if(key == 'u'){
    thresholdSpeed/=2.0;
  }else if(key == 'U'){
    thresholdSpeed*=2.0;
  }else if(key == 'o'){
    oscillateSpeed+=0.02;
  }else if(key == 'O'){
    oscillateSpeed-=0.02;
  }
}

void recalibrateGrid(){
  grid = new Cell[cols][rows];
  for(int i = 0; i < cols; i++){
    for(int j = 0; j < rows; j++){
      grid[i][j] = new Cell(i,j);
    }
  }
}
