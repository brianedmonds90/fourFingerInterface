import android.view.MotionEvent;
// Build a container to hold the current rotation of the box
MultiTouchController mController;
pt test;
PImage img;//Image background stuff 
int screenWidth, screenHeight;

//TurboWarpStuff********************************************************************************************
int n=33;                                   // size of grid. Must be >2!
pt[][] G = new pt [n][n];                  // array of vertices
int pi,pj;                                   // indices of vertex being dragged when mouse is pressed

boolean showVertices=true, showEdges=false, showTexture=true;  // flags for rendering vertices and edges
color red = color(200, 10, 10), blue = color(10, 10, 200), green = color(10, 200, 20), 
magenta = color(200, 50, 200), black = color(10, 10, 10); 
float w,h,ww,hh;                                  // width, height of cell in absolute and normalized units
vec offset = new vec (0,0,0);                  // offset vector from mouse to clicked vertex

// constraints
int mc = 60;                                   // max number of constraints
int[] cn = new int [10];                           // number of constraints in each set
int[][] I = new  int [10][mc];                        // i coordiantes of saved constraints
int[][] J = new int [10][mc];                        // j coordiantes of saved constraints
pt[][] C = new pt [10][mc];                           // constrainted location
int m=0;                                        // current set of constraints

void restoreConstraints () {
  pinBorder();
  for (int k=0; k<cn[m]; k++) { 
    int i = I[m][k];  int j = J[m][k]; 
    G[i][j].setTo(C[m][k]); 
    pinned[i][j]=true;
    }; 
  }

void saveConstraints () {
  cn[m]=0;
  for (int i=2; i<n-2; i++) for (int j=2; j<n-2; j++) if (pinned[i][j]) {I[m][cn[m]]=i; J[m][cn[m]]=j; C[m][cn[m]].setTo(G[i][j]); cn[m]++; };
  }

void initConstraints () {for (int i=0; i<10; i++) for (int j=0; j<mc; j++) C[i][j]=new pt(0,0,0); }

// SMOOTHING  
vec[][] L = new vec [n][n];                // laplace vectors for vertices
vec[][] B = new vec [n][n];                // CG vectors for vertices
vec[][] Q = new vec [n][n];                // CG vectors for vertices
vec[][] V = new vec [n][n];                // CG vectors for vertices
boolean showL=false, showQ=false,showV=false, showB=false;              // flags for rendering laplace vectors
boolean[][] pinned= new boolean [n][n];     // mask for pinned vertices
boolean move = true;
int fstp=0, nstp=0;              // Iteration counters for fast and normal smoothing
boolean smoothing = false;

void resetVertices() {   // resets points and laplace vectors 
   for (int i=0; i<n; i++) for (int j=0; j<n; j++) {
     G[i][j]=new pt(i*w,j*h,0); 
     L[i][j]=new vec(0,0,0); 
     B[i][j]=new vec(0,0,0);  
     Q[i][j]=new vec(0,0,0);  
     V[i][j]=new vec(0,0,0);
     };  
   } 

void pinBorder() { // pins two rings of border vertices
  for (int i=0; i<n; i++) for (int j=0; j<n; j++) pinned[i][j]=false;  
  for (int i=0; i<n; i++) {pinned[i][0]=true; pinned[i][1]=true;    pinned[i][n-2]=true; pinned[i][n-1]=true; };
  for (int j=0; j<n; j++) {pinned[0][j]=true; pinned[1][j]=true;    pinned[n-2][j]=true; pinned[n-1][j]=true; };
  // pin another ring for testing
  //  for (int j=0; j<n; j++) { pinned[2][j]=true; pinned[n-3][j]=true; pinned[j][2]=true; pinned[j][n-3]=true;};
  }        

//End of turboWarp stuff*********************************************************************



void setup() {
 // size(displayWidth, displayHeight,  P3D);
  mController =new MultiTouchController();
  //mController.init();
  size(displayWidth,displayHeight,P3D);
  
  img = loadImage("pixar.jpg"); 
}//End of setup
void draw() {
  background(0, 0, 0);
  beginShape();
  texture(img);  
    vertex((displayWidth-img.width)/2, (displayHeight-img.height)/2, 0, 0);
    vertex((img.width+displayWidth)/2, (displayHeight-img.height)/2, img.width, 0);
    vertex((img.width+displayWidth)/2, (displayHeight+img.height)/2, img.width, img.height);
    vertex((displayWidth-img.width)/2,(displayHeight+img.height)/2, 0, img.height);
  endShape();
  fill(0);
  stroke(100);
  mController.draw();
}//end of draw
public boolean surfaceTouchEvent(MotionEvent me) {//Overwrite this android touch method to process touch data
  int action= whichAction(me);
  if(action==1){
    mController.touch(me,whichFinger(me)); 
    mousePressed(mController.mTContainer.get(0).currentTouch);
  }
  else if(action==0){
    mController.lift(whichFinger(me));
     mousePressed(mController.mTContainer.get(0).currentTouch);
  }
  else if(action==2){
    mController.motion(me);
  }
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
   return what; 
   }  
int whichFinger(MotionEvent me) {
          int pointerIndex = (me.getAction() & MotionEvent.ACTION_POINTER_INDEX_MASK)>> MotionEvent.ACTION_POINTER_INDEX_SHIFT;
          int pointerId = me.getPointerId(pointerIndex);
           println(" finger = "+pointerId); // id in the order pressed (filling), except for last finger
          return pointerId;
          }
       
void mousePressed(pt cTouch) { 
   //Mouse.setToMouse(); 
   pickVertex(cTouch);  // sets pi, pj to indices of vertex closest to mouse
   pinned[pi][pj]=true;
  
   offset.setTo(dif(cTouch,G[pi][pj]));
   nstp=0;
   smoothing=false;
   };  
   
void pickVertex(pt a) {
  float minDist=2*w;
  for (int i=0; i<n; i++) for (int j=0; j<n; j++) {
    println("G[pi] Anything?: "+G[i][j]);
    float dist = a.disTo(G[i][j]);
    println("mark 2");
    if (dist<minDist) {minDist=dist; pi=i; pj=j;};
    };
  }    
void mouseReleased() {    // unpin vertex if ctrl is pressed when mouse released
   //if (keyPressed) if (key==CODED) if (keyCode==CONTROL)  
   //pinned[pi][pj]=false;
   smoothing=true; sfairInit(); fstp=0;
   };  
void fs() { smoothing=true; sfairInit(); fstp=0; for(int k=0; k<100; k++) if (sfair()) fstp++;}
