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

//String[] images = {"gl3.jpg", "gl2.jpg", "nsfw4.png", "nsfw1.png", "fuckin elvis1.png", "pentagram.png", "matches.jpg", "etmj.jpg", "kraken.jpg", "jump.jpg", "baphomet.png", "logo1.jpg", "gl1.jpg", "swordkid.jpg", "nsfw2.png"};
String[] images = {"gl3.jpg", "gl2.jpg", "pentagram.png", "logo1.jpg"};
int image = 0;
//float[] diff;
PVector[] diff;
float threshold = 215.0;
float thresholdAngle = 1.0;
float thresholdSpeed = 0.005;
boolean reverseShading = false;
boolean colorCrazy = true;
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
  //diff = new float[width*height];
  diff = new PVector[width*height];
  img = loadImage(images[image]);
  img.resize(width, height);
  img.loadPixels();
  int loc, imgLoc;
  for (int x = 0; x < width; x++) {
    for (int y = 0; y < height; y++) {
      loc = x + y*width;
      imgLoc = x + y*img.width;
      if(x < border || x > width-border || y < border || y > height-border){
        //diff[loc] = 255.0;
        diff[loc].x = 255.0;
        diff[loc].y = 255.0;
        diff[loc].z = 255.0;
      }else{
        if(imgLoc < img.pixels.length){
          //diff[loc] = brightness(img.pixels[imgLoc]);
          float r = red(img.pixels[imgLoc]);
          float g = green(img.pixels[imgLoc]);;
          float b = blue(img.pixels[imgLoc]);;
          diff[loc] = new PVector(r, g, b);
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
      
      //if(diff[loc] > currentThreshold){
      //  c = reverseShading ? pixels[loc] : color(0);
      //}else{
      //  c = reverseShading ? color(0) : pixels[loc];
      //}
      
      color imgPx = color(diff[loc].x, diff[loc].y, diff[loc].z);
      if(brightness(imgPx) > currentThreshold){
        c = reverseShading ? pixels[loc] : imgPx;
      }else{
        c = reverseShading ? imgPx : pixels[loc];
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
    if(rows < 1){
      rows = 1;
    }
    recalibrateGrid();
  }else if(key == 'c'){
    cols+=2;
    recalibrateGrid();
  }else if(key == 'C'){
    cols-=2;
    if(cols < 2){
      cols = 2;
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
  }else if(key == 'p'){
    image++;
    if(image > images.length-1){
      image = 0;
    }
    img = null;
    setupImage();
  }else if(key == 'P'){
    image--;
    if(image < 0){
      image = images.length-1;
    }
    img = null;
    setupImage();
  }else if(key == '?'){
    cols = 6;
    rows = 100;
    sensitivity = 3.6;
    sensitivityDepth = cols/2.0;
    oscillateSpeed = 0.02;
    threshold = 215.0;
    thresholdAngle = 1.0;
    thresholdSpeed = 0.005;
    recalibrateGrid();
  }else if(key == '1'){
    cols = 2;
    rows = 1;
    recalibrateGrid();
  }else if(key == 'z'){
    colorCrazy = !colorCrazy;
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
