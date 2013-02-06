String  Format(int v, int n) {String s=str(v); String spaces = "                               ";
   int L = max(0,n-s.length());
   String front = spaces.substring(0, L);
   return(front+s);
  };

String  Format(String s, int n) {String spaces = "                                 ";
    int L = max(0,n-s.length());
    String back = spaces.substring(0, L);
    return(s+back);
  };


String  Format(float f, int n, int z) {
   String spaces = "                                ";
   String s=nf(f,n,z); 
   while (s.indexOf("0")==0) {s=s.substring(1,s.length());};
   int b=s.indexOf("."); int a=max(0,n-b); int c=s.length()-b-1;  int d=0;
   if (c>z) {s=s.substring(0,b+1+z); c=z;} else { d=z-c;};
   String front = spaces.substring(0, a);
   String back = spaces.substring(0, d);
   return(front+s+back);
  };
