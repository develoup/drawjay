class SignDraw {
  float w, h;


  SignDraw() {
    set(0, 0);
  }
  
  SignDraw(float iw, float ih) {
    set(iw, ih);
  }

  void set(float iw, float ih) {
    w = iw;
    h = ih;
  }

  void signloop(color clr, float opct, float wgth, float aud, int type) {
  
    translate(w-103, h-95, 0);
    noStroke();
    fill(clr, opct);
    ellipse(0, 60, wgth+2, wgth+2);
    //strokeWeight(wgth+1);
    //stroke(clr, opct);
    //line(0, 35, 0,85);
    noFill();
    strokeWeight(3);
    stroke(clr, 100);
    ellipse(0, 60, 40+aud*7, 40+aud*7);
    fill(clr, opct);
    textSize(18);
    text("DRAWJAY", -105, 65, 0);
    fill(255, opct);
    text("COM", 26, 65, 0);

  }
}