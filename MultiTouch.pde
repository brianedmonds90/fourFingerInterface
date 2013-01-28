import android.view.MotionEvent;
class MultiTouch{
  pt currentTouch, lastTouch, disks;
  boolean selected;
  int meIndex;
  pt movement; 
  MultiTouch(){
    currentTouch=new pt();
    lastTouch= new pt();
    disks=new pt();
   // movement=new pt();
    selected=false;
    meIndex=-1;
  }
  void lift(){
   this.meIndex=-1;
   this.selected=false;
   currentTouch=null;
   lastTouch=null; 
  }
  void movement(int pointerId, MotionEvent ev){
    currentTouch=new pt(ev.getX(pointerId),ev.getY(pointerId));
    disks.move(lastTouch.subtract(currentTouch));
    lastTouch=currentTouch;
  }
  void touch(int pointerId,MotionEvent ev){
    this.meIndex=pointerId;
    this.selected=true;
    this.lastTouch=new pt(ev.getX(pointerId),ev.getY(pointerId));
  }
  
  
}
