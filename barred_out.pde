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
      grid[i][j] = new Cell(i*(width/cols),j*(height/rows), i);
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
 float rand1;
 float rand2;
 float rand3;
 int position;

 Cell(float tempX, float tempY, int tempP){
   x = tempX;
   y = tempY;
   w = width/cols;
   h = height/rows;
   position = tempP;
   if(!isOuterColumn()){
     angle = (position%2==0 || position == 0)?position:-position;
   }else{
     angle = position == 0?1*random(255):-position*random(255);
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
     if(isOuterColumn() && sinangle == 0){
       rand1 = random(255);
       rand2 = random(255);
       rand3 = random(255);
     }
//     if(!isOuterColumn()){
//       stroke(rand1+sinangle, rand2+sinangle, rand3+sinangle);
//       fill(rand1+sinangle, rand2+sinangle, rand3+sinangle);
//     }else{
       stroke(127+sinangle);
       fill(127+sinangle);
//     }
   }else{
     if(!isOuterColumn()){
       rand1 = random(255);
       rand2 = random(255);
       rand3 = random(255);
     } 
     stroke(rand1+sinangle, rand2+sinangle, rand3+sinangle);
     fill(rand1+sinangle, rand2+sinangle, rand3+sinangle);
   }
   pushMatrix();
   rect(x,y,w,h);
   popMatrix();
 }
 
 boolean isOuterColumn(){
   if(position == 0 || position == cols-1){
     return true;
   }else{
     return false;
   }
 }
}
