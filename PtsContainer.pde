import android.view.MotionEvent;
//This class extends ArrayList wrapper to hold points and perform operations on them
class PtsContainer extends ArrayList<pt>{
  //ArrayList <pt>pts;//Stores the pts
  PtsContainer(int numPts) {
    super(numPts);
  }
  PtsContainer(){
    super();
  }
  void draw(){
    for(int i=0;i<this.size();i++){
      if(this.get(i).selected){
        fill(255,0,0);   
      }
      this.get(i).draw(); 
      fill(0);
    } 
  }
  void drawWithNum(){
    for(int i=0;i<this.size();i++){
      this.get(i).drawWithNum(this.get(i).meIndex); 
    } 
  }
  void init(){
    for(int i=0;i<4;i++){
      this.add(new pt(i*100+50,i*100+50));
    }
  }
  int closestPt(pt aa){
    int closest=0;
    for(int i=0;i<this.size();i++){
      if(this.get(closest).distance(aa)>this.get(i).distance(aa)){
       //Make sure the pointer is not already selected by another touch event
        closest=i;
      }
    }
    return closest; 
  }
  void setSelected(int a){
    this.get(a).selected=true;
  }
  void setSelected(int a,int pointerIndex){
    this.get(a).selected=true;
    this.get(a).meIndex=pointerIndex;
  }
  void lift(int pointerId){
    for(int i=0;i<this.size();i++){
      //Find the circle that was selected by the finger that has been lifted
      if(this.get(i).meIndex==pointerId){
        this.get(i).meIndex=-1;
        this.get(i).selected=false;
        return;
      }
    }
  }
  void clearAt(int a){
    if(a<this.size()){
      this.remove(a);
    }
  }
  void set(PtsContainer ptsContainer){
      this.clear();
         for(int i=0;i<ptsContainer.size();i++){
           this.add(ptsContainer.get(i));
        } 
  }
  void movement(){
    for(int i=0;i<this.size();i++){
      if(this.get(i).selected){
        this.get(i).move();
      }
    }
  }
  PtsContainer parseTouchEvent(MotionEvent me){
    PtsContainer temp=new PtsContainer(me.getPointerCount());
    float x,y;
    for(int i=0;i<me.getPointerCount();i++){
      //Loop through the touches on the screen and store the data in the currentTouches array
        x = me.getX(i);
        y = me.getY(i);
        temp.add(new pt(x,y));
    }
    return temp;
  }
/*  void parseTouchEvent(MotionEvent me, int pointerId){
    float x,y;
    x = me.getX(pointerId);
    y = me.getY(pointerId);
    if(this.size()==0){
      this.add(new pt(x,y));
      return;
    }
    if(pointerId<this.size())
      this.set(pointerId, new pt(x,y));
    else
      this.add(new pt(x,y));    
  }*/
  PtsContainer findDifference(PtsContainer a, PtsContainer b){
    PtsContainer temp=new PtsContainer();
    for(int i=0;i<a.size();i++){
      temp.add(a.get(i).subtract(b.get(i)));
    }
    return temp;
  }
  public String toString(){
    String ret="";
    for(int i=0;i<this.size();i++){
      ret+=this.get(i).toString();  
    }
    return ret;
  }
  void updateMovement(PtsContainer delta){
    for(int i=0;i<delta.size();i++){
      for(int j=0;j<this.size();j++){
        if(this.get(j).meIndex==i){
          this.get(j).movement=delta.get(i);
        }
      }
    }
  }
  //@params: pointerId> the Android pointerId that was lifted
  //Method provides bookKeeping for updating pointerIndexes after a lift
  void afterLift(int pointerId){
    for(int i=0;i<this.size();i++){
      if(this.get(i).meIndex>pointerId){
       this.get(i).meIndex--; 
      }  
    }
  }
}


