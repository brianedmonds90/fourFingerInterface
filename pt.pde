import android.view.MotionEvent;

class pt {
  float x=0, y=0;
  boolean selected;
  pt movement;
  int meIndex;//Motion Event index of selected
  pt(){
    this.x=0;
    this.y=0;
    selected=false;
    meIndex=-1;
  } 
  pt(float x,float y){
    this.x=x;
    this.y=y;
    selected=false;
    meIndex=-1;
    movement=new pt();
  }
  float distance(pt a){
    return (float) Math.sqrt((this.x-a.x)*(this.x-a.x)+(this.y-a.y)*(this.y-a.y));  
  }
  void draw(){
    ellipse(this.x,this.y,100,100);
  }
  void drawWithNum(int num){
    fill(255,0,0);
    ellipse(this.x,this.y,100,100);
     fill(50);
     textSize(50);
    text(num,this.x-4,this.y-4);
  }
  public void move(float dx, float dy) {
    this.x+=dx;
    this.y+=dy;
    
  }
 public void move(pt delta){
    this.x+=delta.x;
    this.y+=delta.y;
  }
  public void move(){
    this.x+=movement.x;
    this.y+=movement.y;
  }
  public pt subtract(pt a){
    return new pt(this.x-a.x,this.y-a.y);
  }
  public String toString(){
    return "("+x+","+y+")";
    
  }
  public boolean equals(pt a){
    if(a.x==this.x&&a.y==this.y)
    return true;
    return false;  
  }
  public void touch(MotionEvent me,int pointerId){
    //find the location of the event
    this.meIndex=pointerId;
    this.selected=true;
  }
  public void lift(MotionEvent me,int pointerId){
    this.meIndex=-1;
    this.selected=false;
  }
  void set(pt p){
   this.x=p.x;
   this.y=p.y; 
  }
}
