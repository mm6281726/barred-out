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
   angle += oscillateSpeed;   
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
