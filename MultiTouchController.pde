class MultiTouchController{//Used to process the android API touch events for easy use by applications
   ArrayList <MultiTouch> mTContainer;//Container for MultiTouch objects
   MultiTouch temp;
   MultiTouchController(int num){
      mTContainer=new ArrayList<MultiTouch>(num);
      for(int i=0;i<num;i++){
        mTContainer.add(new MultiTouch()); 
      }
   }
   public void init(){//Puts disk objects on the screen to be moved around
     for(int i=0;i<4;i++){
      mTContainer.set(i,new MultiTouch(i*100+50,i*100+50));
    }
   }
  public void touch(MotionEvent ev, int pointerId){//Method used when a touch event happens
    if(pointerId>3)
     return; 
    pt cTouch = new pt(ev.getX(pointerId),ev.getY(pointerId));//find the x and y coordinate of the touch event
    int index= findClosest(cTouch); //find the closest disk to the touch event
    
    mTContainer.get(index).selected=true;
    mTContainer.get(index).meIndex=pointerId;
    mTContainer.get(index).lastTouch=cTouch; //Keep track of the touch location for movement
  }
  public void lift(int pointerId){//Used when a finger is lifted
    for(int i=0;i<mTContainer.size();i++){
      if(mTContainer.get(i).meIndex==pointerId){
          mTContainer.get(i).lift();
      }
      /*else if(mTContainer.get(i).meIndex>pointerId){
         mTContainer.get(i).meIndex--; 
      }*/
    }
     afterLift(pointerId);   
  }
  public int findClosest(pt aa){//Returns the index of the closest disk of the container to the 
    int closest=0;
    for(int i=1;i<mTContainer.size();i++){
      if(mTContainer.get(closest).disk.distance(aa)>mTContainer.get(i).disk.distance(aa)){
       //Make sure the pointer is not already selected by another touch event
        if(!mTContainer.get(i).selected){
         closest=i;
         }
     }
    }
    return closest; 
  }
 
  public void motion(MotionEvent me,int pointerId){//Used when a finger moves on the screen
       int index=indexOf(pointerId);
       //log the current position of the users fingers
       mTContainer.get(index).currentTouch= new pt(me.getX(pointerId),me.getY(pointerId));
      //calculate the distance moved from the previous frame and move the point
       mTContainer.get(index).movement(pointerId,me);
  }  
  void draw(){//Draws the disks  
    for(int i=0;i<mTContainer.size();i++){
      mTContainer.get(i).draw();
    } 
  }
  //@params: pointerId> the Android pointerId that was lifted
  //Method provides bookKeeping for updating pointerIndexes after a lift
  void afterLift(int pointerId){
    for(int i=0;i<mTContainer.size();i++){
      if(mTContainer.get(i).meIndex>pointerId){
        mTContainer.get(i).meIndex--; 
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
      if(mTContainer.get(i).meIndex==pointerId){
        return i; 
      }  
    }
    return -1;
  } 
}
