class VecProps {
  float x;
  float y;
  color c;
  float o;
  float w;

  VecProps() {
    set(0, 0, 0, 0, 0);
  }
  
  VecProps(float ix, float iy, color ic, float io, float iw) {
    set(ix, iy, ic, io, iw);
  }

  void set(float ix, float iy, color ic, float io, float iw) {
    x = ix;
    y = iy;
    c = ic;
    o = io;
    w = iw;
  }
}