class MultiTouchController{//Used to process the android API touch events for easy use by applications
   ArrayList <MultiTouch> mTContainer;//Container for MultiTouch objects
   //http://wiki.processing.org/w/Android
   MultiTouch temp;
   MultiTouchController(int num){
      mTContainer=new ArrayList<MultiTouch>(num);
      for(int i=0;i<num;i++){
        mTContainer.add(new MultiTouch()); 
      }
   }
   public void init(){//Puts disk objects on the screen to be moved around
     for(int i=0;i<4;i++){
      mTContainer.set(i,new MultiTouch(i*100+100,i*100+200));
    }
   }
  public void touch(MotionEvent ev, int pointerId){//Method used when a touch event happens
    if(pointerId>3)
     return; 
    pt cTouch = new pt(ev.getX(pointerId),ev.getY(pointerId));//find the x and y coordinate of the touch event    
    temp=findClosest(cTouch);
    if(temp!=null){
      temp.selected=true;
      temp.meIndex=pointerId;
      temp.lastTouch=cTouch; //Keep track of the touch location for movement
    }
  }
  public void lift(int pointerId){//Used when a finger is lifted
    for(int i=0;i<mTContainer.size();i++){
      temp=mTContainer.get(i);
      if(temp.meIndex==pointerId){
          temp.lift();
      }
    }
    afterLift(pointerId);   
  }
  public MultiTouch findClosest(pt aa){//Returns the index of the closest disk of the container to the 
    float minDistance= Float.MAX_VALUE;
    MultiTouch closest=null;
    for(MultiTouch mt: mTContainer){
      float d= mt.disk.distance(aa);
      if(d<minDistance&&!mt.selected){
        minDistance=d;
        closest=mt; 
      }
    }
    return closest; 
  }
  public void motion(MotionEvent me,int pointerId){//Used when a finger moves on the screen
       int index=indexOf(pointerId);
       if(index!=-1){
         temp=mTContainer.get(index);
         //log the current position of the users fingers
         temp.currentTouch= new pt(me.getX(pointerId),me.getY(pointerId));
        //calculate the distance moved from the previous frame and move the point
         temp.movement(pointerId,me);
       }
  }  
  void draw(){//Draws the disks  
    int num=0;
    for(int i=0;i<mTContainer.size();i++){
      mTContainer.get(i).draw(); 
    }
  }
  //@params: pointerId> the Android pointerId that was lifted
  //Method provides bookKeeping for updating pointerIndexes after a lift
  void afterLift(int pointerId){
    for(int i=0;i<mTContainer.size();i++){
      temp=mTContainer.get(i);
      if(temp.meIndex>pointerId){
        temp.meIndex--; 
      }  
    }
  }
  String toString(){
    String ret="";
    for(int i=0;i<mTContainer.size();i++){ 
      ret+="Multitouch: "+mTContainer.get(i);
      ret+="\n";
    }
    return ret;
  }
  int indexOf(int pointerId){
    for(int i=0;i<mTContainer.size();i++){
      if(mTContainer.get(i).meIndex==pointerId&&mTContainer.get(i).selected){
        return i; 
      }  
    }
    System.out.println("Why was this called?");
    return -1;
  } 
}
