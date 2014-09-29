import ddf.minim.*;

Minim minim;
AudioInput in;

Cell[][] grid;

int cols = 6;
int rows = 100;

void setup(){
  size(displayWidth,displayHeight);
  grid = new Cell[cols][rows];
  minim = new Minim(this);
  // get a line in from Minim, default bit depth is 16
  in = minim.getLineIn();
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
}

void stop()
{
  // always close Minim audio classes when you are done with them
  in.close();
  minim.stop(); 
  super.stop();
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
  if(gain < 1.2){
     if(isOuterColumn()){
       rand1 = random(255);
       rand2 = random(255);
       rand3 = random(255);
     }
     if(!isOuterColumn() && gain > 1.0){
       stroke(rand1+sinangle, rand2+sinangle, rand3+sinangle);
       fill(rand1+sinangle, rand2+sinangle, rand3+sinangle);
     }else{
       stroke(127+sinangle);
       fill(127+sinangle);
     }
   }else{
     if(!isOuterColumn()){
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
   if(position == 0 || position == cols-1){
     return true;
   }else{
     return false;
   }
 }
}
