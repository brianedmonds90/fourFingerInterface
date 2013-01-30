import android.view.MotionEvent;
// Build a container to hold the current rotation of the box
MultiTouchController mc;
pt test;
void setup() {
 // size(displayWidth, displayHeight,  P3D);
  mc =new MultiTouchController(4);
  mc.init(); 
  fill(0);
  stroke(100);
}//End of setup
void draw() {
  background(255, 255, 255);
  mc.draw();
}//end of draw
public boolean surfaceTouchEvent(MotionEvent me) {//Overwrite this android touch method to process touch data
      final int action = me.getAction();
      switch (action & MotionEvent.ACTION_MASK) {
      case MotionEvent.ACTION_DOWN: {
      mc.touch(me,0);
      mc.draw();
      break;
    }
   case MotionEvent.ACTION_POINTER_DOWN: {
       final int pointerIndex = (action & MotionEvent.ACTION_POINTER_INDEX_MASK)>> MotionEvent.ACTION_POINTER_INDEX_SHIFT;
       final int pointerId = me.getPointerId(pointerIndex);
       mc.touch(me,pointerIndex);
       mc.draw();
       break;
  }
  case MotionEvent.ACTION_MOVE: {
      //Clear the current Touches arrayList 
      for(int i=0;i<me.getPointerCount();i++){
        if(i>3)
          break;
       mc.motion(me,i);
      }
      mc.draw();
      break;
    }
    case MotionEvent.ACTION_UP: {
       mc.lift(0);
       mc.draw();
       break;
     }    
     case MotionEvent.ACTION_POINTER_UP: {
         // Extract the index of the pointer that left the touch sensor
         final int pointerIndex = (action & MotionEvent.ACTION_POINTER_INDEX_MASK)>> MotionEvent.ACTION_POINTER_INDEX_SHIFT;
         final int pointerId = me.getPointerId(pointerIndex);
         mc.lift(pointerId);   
         mc.draw();
         break;
     }
  }
  return super.surfaceTouchEvent(me);
}  


