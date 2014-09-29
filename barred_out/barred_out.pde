/*******
/* Copyright (c) 2014 Michael Madden
/* barred_out
/******/

import ddf.minim.*;

Minim minim;
AudioInput in;

PImage img;

Cell[][] grid;

int cols = 6;
int rows = 100;
float sensitivity = 3.6;
float sensitivityDepth = cols/2;

void setup(){
  size(displayWidth/2,displayHeight/2);
  grid = new Cell[cols][rows];
  minim = new Minim(this);
  in = minim.getLineIn();
  img = loadImage("thing.jpg");
  for(int i = 0; i < cols; i++){
    for(int j = 0; j < rows; j++){
      grid[i][j] = new Cell(i,j);
    }
  }
}

void draw(){
  background(0);
  for(int i = 0; i < cols; i++){
    for(int j = 0 ; j < rows; j++){
      grid[i][j].oscillate();
      grid[i][j].display();
    }
  }
  loadPixels();
  img.loadPixels();
  for (int y = 0; y < height; y++) {
    for (int x = 0; x < width; x++) {
      int loc = x + y*width;
      float r = red(pixels[loc]);
      float g = green(pixels[loc]);
      float b = blue(pixels[loc]);
      img.pixels[loc] =  color(r,g,b);          
    }
  }
  updatePixels();
  image(img, 0, 0);
}

void stop(){
  in.close();
  minim.stop(); 
  super.stop();
}

void keyReleased(){
  float divisor = float(cols)/20;
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
  }
  else if(key == 's'){
    sensitivity+=divisor;    
  }
  else if(key == 'S'){
    sensitivity-=divisor;
    if(sensitivity <= 0){
      sensitivity = 0;
    }
  }
  else if(key == 'd'){
    sensitivityDepth-=divisor;
  }
  else if(key == 'D'){
    sensitivityDepth+=divisor;
    if(sensitivityDepth <= 0){
      sensitivityDepth = 0;
    }
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

class Cell {
 float x,y;
 float w,h;
 float angle;
 float rand1,rand2,rand3;
 int position;

 Cell(int tempX, int tempY){   
   w = width/cols;
   h = height/rows;
   x = tempX*w;
   y = tempY*h;
   position = tempX;
   if(!isOuterColumn()){
     angle = position%2==0?2*y:-2*y;
   }else{
     angle = position==0?1*random(255):-position*random(255);
   }
   rand1 = random(255);
   rand2 = random(255);
   rand3 = random(255);
 }
 
 void oscillate(){
   angle += 0.02;   
 }
 
 void display(){
  float sinangle = sin(angle)*127;
  float gain = in.left.level()*100;
  if(gain < sensitivity/sensitivityDepth){
     if(isOuterColumn()){
       rand1 = random(255);
       rand2 = random(255);
       rand3 = random(255);
     }
     if(gain >= (sensitivity/sensitivityDepth)/getOffset()){
       stroke(rand1+sinangle, rand2+sinangle, rand3+sinangle);
       fill(rand1+sinangle, rand2+sinangle, rand3+sinangle);
     }else{
       stroke(127+sinangle);
       fill(127+sinangle);
     }
   }else{
     if(!isOuterColumn() && gain > sensitivity/getOffset()){
       rand1 = random(255);
       rand2 = random(255);
       rand3 = random(255);
     }else if(gain >= sensitivity){
       rand1 = random(255);
       rand2 = random(255);
       rand3 = random(255);
     } 
     stroke(rand1+sinangle, rand2+sinangle, rand3+sinangle);
     fill(rand1+sinangle, rand2+sinangle, rand3+sinangle);
   }
   rect(x,y,w,h);
 }
 
 boolean isOuterColumn(){
   if(position <= 0 || position == cols-1){
     return true;
   }else{
     return false;
   }
 }
 
 float getOffset(){
   if(position < cols/2){
     return cols/2-position;
   }else{
     return position%(cols/2)+1; 
   }
 }
}
