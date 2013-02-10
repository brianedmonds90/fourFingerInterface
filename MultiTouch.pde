import android.view.MotionEvent;
class MultiTouch{
  pt currentTouch, lastTouch, disk;
  boolean selected;
  int meIndex;
  pt movement; 
  MultiTouch(){
   currentTouch=new pt();
   lastTouch= new pt();
   disk=new pt();
   selected=false;
   meIndex=-1;
  }
//  MultiTouch(float x,float y){
//   currentTouch=new pt();
//   lastTouch= new pt();
//   disk=new pt(x,y);
//   selected=false;
//   meIndex=-1;
//  }
  MultiTouch(float x,float y,float z){
   currentTouch=new pt();
   lastTouch= new pt();
   disk=new pt(x,y,z);
   selected=false;
   meIndex=-1;
  }
  void lift(){
   //this.meIndex=-1;
   this.selected=false;
  }
  void movement(int pointerId, MotionEvent ev){
    currentTouch=new pt(ev.getX(pointerId),ev.getY(pointerId),0);
    disk.move(currentTouch.subtract(lastTouch));
    lastTouch.set(currentTouch);
  }
  void touch(int pointerId,MotionEvent ev){
    this.meIndex=pointerId;
    this.selected=true;
    this.lastTouch=new pt(ev.getX(pointerId),ev.getY(pointerId),0);
  }
  void draw(){
     if(this.selected){
       fill(0,255,0);
       this.disk.draw(); 
     }
     else{
       fill(255,0,0);
       this.disk.draw(); 
     }
  }
  String toString(){
    String ret="";
    ret+= "disk: "+disk;
    ret+= " currentTouch: "+currentTouch+" lastTouch: "+lastTouch+" meIndex: "+meIndex+ "Selected: "+selected;
   return ret; 
  }
  ArrayList getHistory(){
    //Need to implement
   return null; 
  }
  
}
