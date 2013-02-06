// **********************************
// ***      smoothing
// **********************************
 // 0: average of x and y cubics
void XYcubicFilter() {
   for(int k=0; k<20; k++) {
    for (int i=2; i<n-2; i++) for (int j=2; j<n-2; j++) L[i][j]=average(cubicFitX(i,j),cubicFitY(i,j));
    if(move) for (int i=2; i<n-2; i++) for (int j=2; j<n-2; j++) if(!pinned[i][j]) G[i][j].addScaledVec(0.5,L[i][j]); 
   };
  }

vec cubicFitX(int i, int j) {return(cubic(G[i-2][j], G[i-1][j],G[i][j],G[i+1][j],G[i+2][j] ));}
vec cubicFitY(int i, int j) {return(cubic(G[i][j-2], G[i][j-1],G[i][j],G[i][j+1],G[i][j+2] ));}
vec cubic (pt A, pt B, pt C, pt D, pt E) 
    {return(new vec( (-A.x+4*B.x-6*C.x+4*D.x-E.x)/6, (-A.y+4*B.y-6*C.y+4*D.y-E.y)/6, (-A.z+4*B.z-6*C.z+4*D.z-E.z)/6  ));}

void sfairInit() {
   for (int i=2; i<n-2; i++) for (int j=2; j<n-2; j++) {
     B[i][j]=average(cubicFitX(i,j),cubicFitY(i,j)); B[i][j].mul(3); // measure initial misfit
     Q[i][j].setTo(0,0,0); 
     V[i][j].setTo(0,0,0); };  
   }
  
boolean sfair() {
   float sx=0, sy=0; 
   for (int i=2; i<n-2; i++) for (int j=2; j<n-2; j++) if (!pinned[i][j]) {sx+=sq(B[i][j].x); sy+=sq(B[i][j].y); }; // Test magnitude of remaining misfit
   if ((sx<0.0000001) || (sy<0.0000001) ) return(false);    // stop if no speed (to avoid division by zero)
   for (int i=2; i<n-2; i++) for (int j=2; j<n-2; j++) if (!pinned[i][j]) {V[i][j].x+=B[i][j].x/sx; V[i][j].y+=B[i][j].y/sy; }; // increment veocity to follow misfit
   for (int i=2; i<n-2; i++) for (int j=2; j<n-2; j++) {      // compute acceleration to a smooth misfit from 4 unpinned neighbors in X and 4 in Y
     Q[i][j].setTo(0,0,0);
     if (!pinned[i][j]) {                          
                                                                       Q[i][j].addScaled(0.25,CP(i,j-2)); 
                                                                       Q[i][j].addScaled(-1,CP(i,j-1)); 
   Q[i][j].addScaled(0.25,CP(i-2,j)); Q[i][j].addScaled(-1,CP(i-1,j)); Q[i][j].addScaled(3,CP(i,j));  Q[i][j].addScaled(-1,CP(i+1,j)); Q[i][j].addScaled(0.25,CP(i+2,j)); 
                                                                       Q[i][j].addScaled(-1,CP(i,j+1));
                                                                       Q[i][j].addScaled(0.25,CP(i,j+2)); };
      };
    float tx=0, ty=0; 
    for (int i=2; i<n-2; i++) for (int j=2; j<n-2; j++) if (!pinned[i][j]) {tx+=Q[i][j].x*V[i][j].x;  ty+=Q[i][j].y*V[i][j].y;};  // magnitude of acceleration
    if ((sx*tx <= 6.0/1000.0) || (sy*ty <= 6.0/1000.0)) return(false);        // stop if speed* acceeration is small
    for (int i=2; i<n-2; i++) for (int j=2; j<n-2; j++) if (!pinned[i][j]) {
      G[i][j].x+=V[i][j].x/tx; G[i][j].y+=V[i][j].y/ty;
      B[i][j].x-=Q[i][j].x/tx; B[i][j].y-=Q[i][j].y/ty; 
      }; 
    return(true);
    }
vec CP(int i, int j) {vec v = V[i][j].make(); if (pinned[i][j]) v.setTo(0,0,0); return(v);}  // pinned points do not contribute

// we are using f(X), which returns the difference between X and the average of the cubic fits in x and y
//  INIT: B= 3*f(G); V=0; Q=0;
//  LOOP (for not pinnect):
//         s=B*B
//         V=V+B/s
//         Q= -3*f(V) (using 0 as V for pinned neighbors)
//         t=Q*V; stop if s*t is small
//         G=G+V/t
//         B=B-Q/t
//
