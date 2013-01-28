class MultiTouchController{//Used to process the android API touch events for easy use by applications
  PtsContainer currentTouches,fingers,lastTouches;//Internal storage objects for processing movement
   ArrayList <Boolean>select;
   ArrayList <Integer>pointerIndex;
  // ArrayList <int>pointerIndex;
   MultiTouchController(int numPts){
      currentTouches=new PtsContainer();  //populated with points caused by fingers currently on the screen
      fingers=new PtsContainer(); //circles to be drawn on the screen
      lastTouches=new PtsContainer(); //Used for movement
      select=new ArrayList<Boolean>(numPts);
      for(int i=0;i<numPts;i++){
        select.add(false); 
      }
      fingers.init();//Used for testing
   }
   public void touch(MotionEvent ev, int pointerId){//Method used when a touch event happens 
    pt currentTouch = new pt(ev.getX(pointerId),ev.getY(pointerId));//find the x and y coordinate of the touch event
    //fingers.setSelected(fingers.closestPt(currentTouch),pointerId);//find the closest disk to the touch event
    lastTouches=lastTouches.parseTouchEvent(ev);//Keep track of the touch location for movement
    select.set(fingers.closestPt(currentTouch),true);//Line in development
  }
  public void lift(int pointerId){//Used when a finger is lifted
    fingers.lift(pointerId);
    fingers.afterLift(pointerId);
    currentTouches.clearAt(pointerId);
    lastTouches.clearAt(pointerId);
    
  }
  public void motion(MotionEvent me){//Used when a finger moves on the screen
      //log the current position of the users fingers
     PtsContainer temp = new PtsContainer();
     currentTouches=currentTouches.parseTouchEvent(me);
     //calculate the distance moved from the previous frame and update movement
     temp=temp.findDifference(currentTouches, lastTouches);
     fingers.updateMovement(temp);
     fingers.movement();
     lastTouches.set(currentTouches);
  }  
  void draw(){//Draws the fingers PtsContainer  
    for(int i=0;i<fingers.size();i++){
      if(select.get(i)){
        fill(255,0,0);   
      }
      fingers.get(i).draw(); 
      fill(0);
    } 
  }
  //This method will set the boolean value to false after a lift
  void afterLift(int pointerId){
    
  }
  
  
  
}
