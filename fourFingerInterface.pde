import android.view.MotionEvent;
// Build a container to hold the current rotation of the box
MultiTouchController mc;
pt test;
PImage img;//Image background stuff
void setup() {
 // size(displayWidth, displayHeight,  P3D);
  mc =new MultiTouchController(4);
  mc.init();
  size(displayWidth,displayHeight,P3D);
  img = loadImage("pixar.jpg"); 
}//End of setup
void draw() {
  background(255, 255, 255);
  beginShape();
  texture(img);  
  vertex(0, 0, 0, 0);
  vertex(displayWidth, 0, img.width, 0);
  vertex(displayWidth, displayHeight, img.width, img.height);
  vertex(0,displayHeight, 0, img.height);
  endShape();
  fill(0);
  stroke(100);
  mc.draw();
}//end of draw
public boolean surfaceTouchEvent(MotionEvent me) {//Overwrite this android touch method to process touch data
  int action= whichAction(me);
  if(action==1){
    mc.touch(me,whichFinger(me)); 
  }
 else if(action==2){
    mc.motion(me);
  }
  else if(action==0){
    mc.lift(whichFinger(me)); 
  }
  
//      final int action = me.getAction();
//      switch (action & MotionEvent.ACTION_MASK) {
//      case MotionEvent.ACTION_DOWN: {
//      mc.touch(me,0);
//      break;
//    }
//   case MotionEvent.ACTION_POINTER_DOWN: {
//       final int pointerIndex = (action & MotionEvent.ACTION_POINTER_INDEX_MASK)>> MotionEvent.ACTION_POINTER_INDEX_SHIFT;
//       final int pointerId = me.getPointerId(pointerIndex);
//       mc.touch(me,pointerIndex);
//       break;
//  }
//  case MotionEvent.ACTION_MOVE: {
//      //Clear the current Touches arrayList 
//      for(int i=0;i<me.getPointerCount();i++){
//        if(i>3)
//          break;
//       mc.motion(me,i);
//      }
//      break;
//    }
//    case MotionEvent.ACTION_UP: {
//       mc.lift(0);
//       break;
//     }    
//     case MotionEvent.ACTION_POINTER_UP: {
//         // Extract the index of the pointer that left the touch sensor
//         final int pointerIndex = (action & MotionEvent.ACTION_POINTER_INDEX_MASK)>> MotionEvent.ACTION_POINTER_INDEX_SHIFT;
//         final int pointerId = me.getPointerId(pointerIndex);
//         mc.lift(pointerId);   
//         break;
//     }
//  }
  return super.surfaceTouchEvent(me);
}  
int whichAction(MotionEvent me) { // 1=press, 0=release, 2=drag
   int action = me.getAction(); 
   int aaction = action & MotionEvent.ACTION_MASK;
   int what=0;
   if (aaction==MotionEvent.ACTION_POINTER_UP || aaction==MotionEvent.ACTION_UP) what=0;
   if (aaction==MotionEvent.ACTION_DOWN || aaction==MotionEvent.ACTION_POINTER_DOWN) what=1;
   if (aaction==MotionEvent.ACTION_MOVE) what=2;
           if(what!=2) println("   action = "+what); // id in the order pressed (filling), except for last finger
   return what; }
   
int whichFinger(MotionEvent me) {
          int pointerIndex = (me.getAction() & MotionEvent.ACTION_POINTER_INDEX_MASK)>> MotionEvent.ACTION_POINTER_INDEX_SHIFT;
          int pointerId = me.getPointerId(pointerIndex);
           println("   finger = "+pointerId); // id in the order pressed (filling), except for last finger
          return pointerId;
          }
