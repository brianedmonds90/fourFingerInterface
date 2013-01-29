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
      draw();
      break;
    }
   case MotionEvent.ACTION_POINTER_DOWN: {
       for(int i=1;i<me.getPointerCount();i++){
         if(i>3)
           break;
         mc.touch(me,i);
       }
      /* System.out.println("ACTION POINTER DOWN");
       System.out.println(mc);
       System.out.println("End of Action Pointer Down");*/
       draw();
       break;
  }
  /*case MotionEvent.ACTION_MOVE: {
      //Clear the current Touches arrayList 
         for(int i=0;i<me.getPointerCount();i++){
         if(i>3)
           break;
         mc.motion(me,i);
         }
      draw();
      break;
    }*/
    case MotionEvent.ACTION_UP: {
       final int pointerIndex = (action & MotionEvent.ACTION_POINTER_INDEX_MASK)>> MotionEvent.ACTION_POINTER_INDEX_SHIFT;
         final int pointerId = me.getPointerId(pointerIndex);
       //mc.lift(pointerId);
       mc.lift(0);
     /*  System.out.println("Lifted Pointer Up: "+pointerId);
       System.out.println("ACTION POINTER Up");
       System.out.println(mc);
       System.out.println("End of Action Pointer Up");*/
       draw();
       break;
     }    
     case MotionEvent.ACTION_POINTER_UP: {
         // Extract the index of the pointer that left the touch sensor
         final int pointerIndex = (action & MotionEvent.ACTION_POINTER_INDEX_MASK)>> MotionEvent.ACTION_POINTER_INDEX_SHIFT;
         final int pointerId = me.getPointerId(pointerIndex);
         System.out.println("Lifted Action Pointer Up: "+pointerId);
         mc.lift(pointerId);   
         System.out.println("ACTION POINTER Up");
         System.out.println(mc);
         System.out.println("End of Action Pointer Up");
         draw();
         break;
     }
  }
  return super.surfaceTouchEvent(me);
}  


