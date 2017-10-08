class VecTrazo {
  float ax,ay, bx,by;
  color c;
  float o;
  float w;

  VecTrazo() {
    set(0, 0, 0, 0, 0, 0, 0);
  }
  
  VecTrazo(float ix, float iy, float jx, float jy, color ic, float io, float iw) {
    set(ix, iy, jx, jy, ic, io, iw);
  }

  void set(float ix, float iy, float jx, float jy, color ic, float io, float iw) {
    ax = ix;
    ay = iy;
    bx = jx;
    by = jy;
    c = ic;
    o = io;
    w = iw;
  }
}