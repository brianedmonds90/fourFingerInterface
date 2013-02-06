import android.view.MotionEvent;

class pt { 
  float x=0, y=0, z=0;
  int meIndex;//Motion Event index of selected
  pt(){
    this.x=0;
    this.y=0;
  } 
  pt(float x,float y){
    this.x=x;
    this.y=y;
  }
  pt(float x,float y, float z){
    this.x=x;
    this.y=y;
    this.z=z;
  }
  float distance(pt a){
    return (float) Math.sqrt((this.x-a.x)*(this.x-a.x)+(this.y-a.y)*(this.y-a.y));  
  }
  void draw(){
    ellipse(this.x,this.y,50,50);
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

  void set(pt p){
   this.x=p.x;
   this.y=p.y; 
  }
  pt make() {return(new pt(x,y,z));};
  void show(float r) { pushMatrix(); translate(x,y,z); sphere(r); popMatrix();}; 
  void showLineTo (pt P) {line(x,y,z,P.x,P.y,P.z); }; 
  void setToPoint(pt P) { x = P.x; y = P.y; z = P.z;}; 
  void setTo(pt P) { x = P.x; y = P.y; z = P.z;}; 
  void setTo (float px, float py, float pz) {x = px; y = py; z = pz;}; 
  void setToMouse() { x = mouseX; y = mouseY; }; 
  void write() {println("("+x+","+y+","+z+")");};
  void addVec(vec V) {x += V.x; y += V.y; z += V.z;};
  void addScaledVec(float s, vec V) {x += s*V.x; y += s*V.y; z += s*V.z;};
  void subVec(vec V) {x -= V.x; y -= V.y; z -= V.z;};
  void vert() {vertex(x,y,z);};
  void vertext(float u, float v) {vertex(x,y,z,u,v);};
  boolean isInWindow() {return(((x<0)||(x>width)||(y<0)||(y>height)));};
  void label(String s, vec D) {text(s, x+D.x, y+D.y, z+D.z);  };
  vec vecTo(pt P) {return(new vec(P.x-x,P.y-y,P.z-z)); };
  float disTo(pt P) {return(sqrt( sq(P.x-x)+sq(P.y-y)+sq(P.z-z) )); };
  vec vecToMid(pt P, pt Q) {return(new vec((P.x+Q.x)/2.0-x,(P.y+Q.y)/2.0-y,(P.z+Q.z)/2.0-z )); };
  vec vecToProp (pt B, pt D) {
      vec CB = this.vecTo(B); float LCB = CB.norm();
      vec CD = this.vecTo(D); float LCD = CD.norm();
      vec U = CB.make();
      vec V = CD.make(); V.sub(U); V.mul(LCB/(LCB+LCD));
      U.add(V);
      return(U);  
      };  
  void addPt(pt P) {x+=P.x; y+=P.y; z+=P.z;};
  void subPt(pt P) {x-=P.x; y-=P.y; z-=P.z; };
  void mul(float f) {x*=f; y*=f; y*=f;};
  void pers(float d) { y=d*y/(d+z); x=d*x/(d+z); z=d*z/(d+z); };
  void inverserPers(float d) { y=d*y/(d-z); x=d*x/(d-z); z=d*z/(d-z); };
  boolean coplanar (pt A, pt B, pt C) {return(abs(tetVol(this,A,B,C))<0.0001);};
  boolean cw (pt A, pt B, pt C) {return(tetVol(this,A,B,C)>0.0001);};
  } ;
 
class vec { float x,y,z; 
  vec (float px, float py, float pz) {x = px; y = py; z = pz;};
  void setTo (float px, float py, float pz) {x = px; y = py; z = pz;}; 
  vec make() {return(new vec(x,y,z));};
  void setTo(vec V) { x = V.x; y = V.y; z = V.z;}; 
  void show (pt P) {line(P.x,P.y, P.z,P.x+x,P.y+y,P.z+z); }; 
  void add(vec V) {x += V.x; y += V.y; z += V.z;};
  void addScaled(float m, vec V) {x += m*V.x; y += m*V.y; z += m*V.z;};
  void sub(vec V) {x -= V.x; y -= V.y; z -= V.z;};
  void mul(float m) {x *= m; y *= m; z *= m;};
  void div(float m) {x /= m; y /= m; z /= m;};
  void write() {println("("+x+","+y+","+z+")");};
  float norm() {return(sqrt(sq(x)+sq(y)+sq(z)));}; 
  void makeUnit() {float n=this.norm(); if (n>0.0001) {this.div(n);};};
  void back() {x= -x; y= -y; z= -z;};
  boolean coplanar (vec V, vec W) {return(abs(mixed(this,V,W))<0.0001);};
  boolean cw (vec U, vec V, vec W) {return(mixed(this,V,W)>0.0001);};
  } ;
  
vec triNormalFromPts(pt A, pt B, pt C) {vec N = cross(A.vecTo(B),A.vecTo(C));  return(N); };
float tetVol (pt A, pt B, pt C, pt D) { return(dot(triNormalFromPts(A,B,C),A.vecTo(D))); };
float dot(vec U, vec V) {return(U.x*V.x+U.y*V.y+U.z*V.z); };
vec cross(vec U, vec V) {return(new vec( U.y*V.z-U.z*V.y, U.z*V.x-U.x*V.z, U.x*V.y-U.y*V.x )); };
float mixed(vec U, vec V, vec W) {return(dot(cross(U,V),W)); };
pt average (pt A, pt B) {return(new pt((A.x+B.x)/2 , (A.y+B.y)/2, (A.z+B.z)/2 )); };
pt average (pt A, pt B, pt C) {return(new pt((A.x+B.x+C.x)/3 , (A.y+B.y+C.y)/3, (A.z+B.z+C.z)/3 )); };
pt average (pt A, pt B, pt C, pt D) {return(new pt( (A.x+B.x+C.x+D.x)/4 , (A.y+B.y+C.y+D.y)/4, (A.z+B.z+C.z+D.z)/4 ) ); };
pt between (pt A, float s, pt B) {return(new pt((s-1)*A.x+s*B.x , (s-1)*A.y+s*B.y,(s-1)*A.z+s*B.z )); };
vec between (vec A, float s, vec B) {return(new vec((s-1)*A.x+s*B.x , (s-1)*A.y+s*B.y,(s-1)*A.z+s*B.z )); };
vec dif(pt A, pt B) {return(new vec( B.x-A.x , B.y-A.y , B.z-A.z)); };
vec dif(vec U, vec V) {return(new vec(V.x-U.x,V.y-U.y,V.z-U.z)); };
vec sum(vec U, vec V) {return(new vec(V.x+U.x,V.y+U.y,V.z+U.z)); };
vec average(vec U, vec V) {return(new vec((U.x+V.x)/2,(U.y+V.y)/2,(U.z+V.z)/2)); };
vec average (vec A, vec B, vec C, vec D) {return(new vec( (A.x+B.x+C.x+D.x)/4 , (A.y+B.y+C.y+D.y)/4, (A.z+B.z+C.z+D.z)/4 ) ); };
