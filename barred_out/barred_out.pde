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

String[] images;
float[] diff;
float threshold = 210.0;
float thresholdAngle = 0.0;
float thresholdSpeed = 0.005;
PImage img;
int useImage = 0;

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
//  img = loadImage("spacething.jpg");
  img = loadImage("swordkid.jpg");
  img.loadPixels();
  int loc, imgLoc;
  for (int x = 0; x < width; x++) {
    for (int y = 0; y < height; y++) {
      loc = x + y*width;
      imgLoc = x + y*img.width;
      if(x == 0 || x == width-1 || y == 0 || y == height-1){
        diff[loc] = 255.0;
      }else{
        diff[loc] = brightness(img.pixels[imgLoc]);
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
    float currentThreshold;
    if(useImage == 2){
      oscillateThreshold();
      currentThreshold = threshold*sin(thresholdAngle)+45;
      if(currentThreshold < 0){
        currentThreshold*=-1;
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
          c = color(0);                 
        }else{
          c = pixels[loc];
        }
        pixels[loc] = c;
      }
    }
    updatePixels();
  }
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
    recalibrateGrid();
  }else if(key == 'c'){
    cols+=2;
    recalibrateGrid();
  }else if(key == 'C'){
    cols-=2;
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
  }else if(key == 'u'){
    thresholdSpeed-=0.005;
  }else if(key == 'U'){
    thresholdSpeed+=0.005;
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
