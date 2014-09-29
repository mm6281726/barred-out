import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import ddf.minim.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class barred_out extends PApplet {



Minim minim;
AudioInput in;

Cell[] left;
Cell[] right;
Cell[] leftleft;
Cell[] rightright;
Cell[] leftleftleft;
Cell[] rightrightright;

int cols = 100;
int rows = 6;

public void setup(){
  size(1500,1000, P3D);
  left = new Cell[cols];
  right = new Cell[cols];
  leftleft = new Cell[cols];
  rightright = new Cell[cols];
  leftleftleft = new Cell[cols];
  rightrightright = new Cell[cols];
  minim = new Minim(this);
  // get a line in from Minim, default bit depth is 16
  in = minim.getLineIn();
  
  for(int i = 0; i < cols; i++){
//    left[i] = new Cell(width/4,i*(height/100),i*random(255));
//    right[i] = new Cell(width/2, i*(height/100),-i*random(255));
//    leftleft[i] = new Cell(0,i*(height/100),-i);
//    rightright[i] = new Cell(3*(width/4), i*(height/100),i);
    leftleftleft[i] = new Cell(0,i*(height/100),i, 3);
    leftleft[i] = new Cell(1*(width/rows),i*(height/100),-i, 2);
    left[i] = new Cell(2*(width/rows),i*(height/100),i, 1);
    right[i] = new Cell(3*(width/rows), i*(height/100),-i, 1);
    rightright[i] = new Cell(4*(width/rows), i*(height/100),i, 2);    
    rightrightright[i] = new Cell(5*(width/rows), i*(height/100),-i, 3);
  }
}

public void draw(){
  background(0);
  for(int i = 0; i < cols; i++){
    left[i].oscillate();
    left[i].display();
    right[i].oscillate();
    right[i].display();
    leftleft[i].oscillate();
    leftleft[i].display();
    rightright[i].oscillate();
    rightright[i].display();
    leftleftleft[i].oscillate();
    leftleftleft[i].display();
    rightrightright[i].oscillate();
    rightrightright[i].display();
  }
}

public void stop()
{
  // always close Minim audio classes when you are done with them
  in.close();
  minim.stop(); 
  super.stop();
}

class Cell {
 float x,y,z;
 float w,h;
 float angle;
 float rand1;
 float rand2;
 float rand3;
 int position;

 Cell(float tempX, float tempY, float tempAngle, int tempP){
   x = tempX;
   y = tempY;
   z = 0;
   w = width/rows;
   h = height/100;
   position = tempP;
   if(position < 3){
     angle = tempAngle;
   }else{
     angle = tempAngle*random(255);
   }
   rand1 = random(255);
   rand2 = random(255);
   rand3 = random(255);
 }
 
 public void oscillate(){
   angle += 0.02f;   
 }
 
 public void display(){
  println(in.left.level()*100);
  float sinangle = sin(angle);
  if(in.left.level() * 100 < 1.2f){
     if(position < 3 && sinangle * 100 == 0){
       rand1 = random(255);
       rand2 = random(255);
       rand3 = random(255);
     }
     if((in.left.level() * 100 > 0.35f && position == 3) || (in.left.level() * 100 > 0.7f && position == 2) || (in.left.level() * 100 > 0.9f && position == 3)){
       stroke(rand1+127*sinangle, rand2+127*sinangle, rand3+127*sinangle);
       fill(rand1+127*sinangle, rand2+127*sinangle, rand3+127*sinangle);
     }else{
       stroke(127+127*sinangle);
       fill(127+127*sinangle);
     }
   }else{
     if(position == 2 && in.left.level() * 100 > 3.2f){
       rand1 = random(255);
       rand2 = random(255);
       rand3 = random(255);
     }else if(position == 1 && in.left.level() * 100 > 10.2f){
       rand1 = random(255);
       rand2 = random(255);
       rand3 = random(255);
     } 
     stroke(rand1+127*sinangle, rand2+127*sinangle, rand3+127*sinangle);
     fill(rand1+127*sinangle, rand2+127*sinangle, rand3+127*sinangle);
   }
   pushMatrix();
   translate(0, 0, z);
   rect(x,y,w,h);
   popMatrix();
 }
}
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "--full-screen", "--bgcolor=#666666", "--stop-color=#cccccc", "barred_out" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
