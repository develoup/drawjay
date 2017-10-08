import ddf.minim.*;
import ddf.minim.spi.*;
import ddf.minim.signals.*;
import ddf.minim.analysis.*;
import ddf.minim.ugens.*;
import ddf.minim.effects.*;
import processing.video.*;
import themidibus.*;
//import processing.serial.*;



// AUDIO VARS
Minim minim;
AudioInput  in;
AudioPlayer song;
float valaudio = 1;
Boolean drawWithAudio = true;
float audioIncrem = 40;

// STROKE VARS
PGraphics strokePG, canvasPG;
float opacity = 170;
int pppmouseX, pppmouseY, ppmouseX, ppmouseY;
float countrotation = 0.2;
boolean flagrotation = false;

// COLOR OPACITY WEIGHT VARS
int r = 142;
int g = 60;
int b = 60;
int alphaBrush = 100;
color pencil = color(244, 29, 69);
float weightBrush = 1;
color color_brush;

// PIXELS 3D VARS
PImage bg;
int cellsize_A = 10;
int cols_A, rows_A;
int cellsize_B = 20;
int cols_B, rows_B;
float count = 0.025;
float countstrokeweight = 1;
float anime_z = -8; 
float angle = 0;

// ANIMATION PRESETS VARS
boolean flagmirror = false;
boolean flagparticles_A = false;
boolean flagparticles_B = false;
boolean flagparticles_C = false;
boolean flagparticles_D = false;
boolean flagparticles_E = false;
boolean flagparticles_F = false;

// BRUSH TYPE VARS
int brush_type = 1;
int clickX, clickY;

// GRADIENT BACKGROUND
int Y_AXIS = 1;
int X_AXIS = 2;
color b1 = color(0, 0, 0, 90);
color b2 = color(50, 50, 50, 90);

// ANIMATED PETALOS VARS
VecProps petalous[];
int capacity = 100;
int count_capacity = 0;

// ANIMATED TRAZO VARS
VecTrazo trazous[];
int capacitytr = 800;
int count_capacitytr = 0;
float diff = 1;

// PROCESSING
//Serial myPort; 
int valor;
String val;
float fin;
int opacityCntrl = 255;
int weightCntrl = 60;
int audioCntrl = 120;
float conv = (float) audioCntrl / 1023;
int result = 0;

// CONTROL TRAZO, COLOR, ETC CON EL LOGO
SignDraw signdraw;

// CAMERA VARS
float count_rot = 0;
float countrotX = 0.0001;

// STATS VARS
Boolean stat_video = true;
Boolean stat_cam = false;

// VIDEO VARS
Movie video;

// MIDI BUS
MidiBus myBus;
int value;






void settings(){  
     size(600,600,P3D);
     //fullScreen(P3D);
     PJOGL.profile = 2;
}


void setup(){
  
     frameRate(120);
     smooth(4);
     background(0);
     
     // midi controller
     MidiBus.list();
     myBus = new MidiBus(this, 1, 2);
     
     // arduino serial port
     /*
     String portName = Serial.list()[6];
     myPort = new Serial(this, portName, 9600);
     myPort.clear();
     */
     
     // init petalos array
     petalous = new VecProps[capacity];
     for (int i=0;i<capacity;i++) {
          petalous[i] = new VecProps();
     }
     
     // init trazous array
     trazous = new VecTrazo[capacitytr];
     for (int i=0;i<capacitytr;i++) {
          trazous[i] = new VecTrazo();
     }
     
     // Sign Draw
     signdraw = new SignDraw();
     signdraw.set(width,height);
     signdraw.signloop(pencil, alphaBrush, weightBrush, valaudio, 1); 

     // calculate cols and rows for cellsize_A
     cols_A = width/cellsize_A;
     rows_A = height/cellsize_A;

     // calculate cols and rows for cellsize_B
     cols_B = width/cellsize_B;
     rows_B = height/cellsize_B;  
         
     // initialize stroke and canvas
     canvasPG = createGraphics(width,height);
     strokePG = createGraphics(width,height);

     // canvas
     canvasPG.beginDraw();
     canvasPG.background(0);
     canvasPG.endDraw();
         
     // stroke
     strokePG.beginDraw();
     strokePG.strokeWeight(2);
     strokePG.stroke(pencil);
     strokePG.endDraw();
      
     // initlialize audio input
     minim = new Minim(this);
     in = minim.getLineIn();
     
     // video
     //video = new Movie(this, "intro_earth.mov");
     //video.noLoop();
     //video.play();
     
}


void draw(){
  
  colorMode(HSB);
  
  if( stat_video == false ){
  
         // video stat
         image(video, 0, 0, width, height);
         
  } else {
  
         // draw stat
         pushMatrix(); 
         background(0);
  
         // arduino
         /*
         if (myPort.available() > 0) { 
               val = myPort.readStringUntil(10);
               if (val != null){
                   fin = float(val);
                   result = int(fin*conv);
                   //alphaBrush = result;
                   audioIncrem = result;
               }
         }
         */
  
         // get audio input
         if( drawWithAudio ){
             valaudio = (in.left.level() + in.right.level()) * audioIncrem;          
         }else{
             valaudio = 1;
         }
                 
         
         /* ************************************************ ANIMATION PARTICLES / STROKES / 3D / ETC ************************************************ */
         // draw particles B
         if(flagparticles_B){
           
                pushMatrix(); 
                loadPixels();
                
                // Begin loop for columns
                for (int i = 0; i < cols_B; i ++ ) {
                    for (int j = 0; j < rows_B; j ++ ) {
                      
                        int x = i*cellsize_B + cellsize_B/2; // x position
                        int y = j*cellsize_B + cellsize_B/2; // y position
                        int loc = x + y*width; // Pixel array location
                        color c = canvasPG.pixels[loc]; // Grab the color
                        float value = brightness(c);
                        
                        if( value > 20 ){
                          float z = (valaudio/3) * brightness(canvasPG.pixels[loc])-8;
                          //float z = map(brightness(canvasPG.pixels[loc])-8, 0, 255, 0, valaudio);
                          pushMatrix();    
                          translate(x,y,z);
                          strokeWeight(1);
                          stroke(0, z+50);
                          fill(c);
                          rectMode(CENTER);
                          ellipse(0,0,cellsize_B-1,cellsize_B-1);
                          popMatrix();
                        }
                        
                    }
                }
                popMatrix();
           
         }
         
         // draw particles A
         if(flagparticles_A){
           
                loadPixels();
 
                for (int i = 0; i < cols_A; i ++ ) {
                    for (int j = 0; j < rows_A; j ++ ) {
                        
                          int x = i*cellsize_A + cellsize_A/2; // x position
                          int y = j*cellsize_A + cellsize_A/2; // y position
                          int loc = x + y*width; // Pixel array location
                          color c = canvasPG.pixels[loc+int(valaudio*4)]; // Grab the color
                          float value = brightness(c);                      
                          if( value > 20 ){
                              float z = (valaudio/3) * brightness(canvasPG.pixels[loc])-8;   
                              pushMatrix();
                              translate(x,y,z);
                              noStroke();
                              fill(c);
                              rectMode(CENTER);
                              rect(0,0,cellsize_A-2,cellsize_A-2);
                              popMatrix();
                          }
                    }
                }
                
           
         }
         
         // draw particles C
         if(flagparticles_C){
           
                loadPixels();
                
                // Begin loop for columns
                for (int i = 0; i < cols_A; i ++ ) {
                    for (int j = 0; j < rows_A; j ++ ) {                      
                        int x = i*cellsize_A + cellsize_A/2; // x position
                        int y = j*cellsize_A + cellsize_A/2; // y position
                        int loc = x + y*width; // Pixel array location
                        color c = strokePG.pixels[loc]; // Grab the color
                        float value = brightness(c);
                        //float rndmline = valaudio-8;
                        
                        if( value > 10 ){
                          float audiovalue = valaudio/4;
                          pushMatrix();
                          noFill();
                          line(width/2, 0, (x-width/2)*audiovalue+x, (y+height/2)*audiovalue);
                          //line(width/2, height, (x-width/2)*audiovalue+x+rndmline, (y-height/2)*audiovalue);
                          strokeWeight(1);
                          stroke(c, 90+valaudio);
                          line(x, y, (x-width/2)*audiovalue+x, (y-height/2)*audiovalue+y);
                          popMatrix();
                        }
                        
                    }
                }
           
         }
         
         // draw particles D
         if(flagparticles_D){
              
                //translate(0, height/3, -100);
                translate(0, 0, 0);
                
                // Begin loop for columns
                for(int x = 0; x<cols_B;  x++){
                  for(int y =0; y<rows_B;  y++){
                        
                          int xc = x*cellsize_B + cellsize_B/2; // x position
                          int yc = y*cellsize_B + cellsize_B/2; // y position
                          int loc = xc + yc*width; // Pixel array location
                          color c = canvasPG.pixels[loc]; // Grab the color
                          float value = brightness(c);
                          //float z = (valaudio/3) * brightness(canvasPG.pixels[loc]);
                          if( value > 20 ){ 
                              fill(c, 160);
                              noStroke();
                              beginShape();
                              vertex(x*cellsize_B, y*cellsize_B, valaudio*2);
                              vertex(x*cellsize_B+cellsize_B, y*cellsize_B, y*valaudio);
                              vertex(x*cellsize_B+cellsize_B, y*cellsize_B+cellsize_B, y*valaudio*2);
                              vertex(x*cellsize_B, y*cellsize_B+cellsize_B, valaudio*valaudio);
                              endShape(CLOSE);                              
                          }
                    }
                }
           
         }
         
         // draw particles E
         if(flagparticles_E){
           
                // light
                directionalLight(255, 0, 255, 20, 200, -20000);
                
                // camera
                beginCamera();
                camera();
                translate(0,0,0);
                rotateX(valaudio/44);
                rotateY(valaudio/36);
                endCamera();
           
                loadPixels();
                
                // Begin loop for columns
                for (int i = 0; i < cols_B; i ++ ) {
                    for (int j = 0; j < rows_B; j ++ ) {
                      
                        int x = i*cellsize_B + cellsize_B/2; // x position
                        int y = j*cellsize_B + cellsize_B/2; // y position
                        int loc = x + y*width; // Pixel array location
                        color c = canvasPG.pixels[loc]; // Grab the color
                        float value = brightness(c);
                        
                        if( value > 20 ){
                          float z = (valaudio/4) * brightness(canvasPG.pixels[loc])-8;
                          pushMatrix();    
                          translate(x,y,z);
                          strokeWeight(1);
                          stroke(0, z+10);
                          fill(c);
                          rectMode(CENTER);
                          box(cellsize_B, cellsize_B, z);
                          //ellipse(0,0,cellsize_B-2,cellsize_B-2);
                          popMatrix();
                        }
                        
                    }
                }
                count_rot = count_rot + 0.01;
           
         } else {
                beginCamera();
                camera();
                translate(0,0,0);
                rotateZ(0);
                rotateY(0);
                endCamera();
         }
         
         // draw particles F
         if(flagparticles_F){
           
                // light
                directionalLight(255, 255, 255, width/2, height/2-350, -8050);
                
                // camera
                /*
                beginCamera();
                pushMatrix();
                camera();
                rotateY(countrotX);
                translate(width/2,0,-300);
                endCamera();
                */
                
                
                // countrotX
                countrotX = countrotX + (valaudio/50);
           
                // loadPixels
                loadPixels();
                
                //float randompos = random(-3,3);
                
                // Begin loop for columns
                for (int i = 0; i < cols_B; i ++ ) {
                    for (int j = 0; j < rows_B; j ++ ) {
                      
                        int x = i*cellsize_B + cellsize_B/2; // x position
                        int y = j*cellsize_B + cellsize_B/2; // y position
                        int loc = x + y*width; // Pixel array location
                        color c = canvasPG.pixels[loc]; // Grab the color
                        float value = brightness(c);
                        float posaudio = valaudio/20;
                        
                        if( value > 20 ){
                          float z = posaudio*brightness(canvasPG.pixels[loc])-8;
                          //float ya = (y-height/2)*posaudio+y+randompos;
                          pushMatrix();    
                          translate(x,y,z);
                          rotateY(countrotX);
                          rotateX(countrotX);
                          //rotateZ(countrotX);
                          strokeWeight(1);
                          stroke(0,50);
                          fill(c);
                          rectMode(CENTER);
                          box(cellsize_B, cellsize_B, z+80);
                          popMatrix();
                        }
                        
                    }
                }
                count_rot = count_rot + 0.01;
           
         }
         /* ************************************************ ANIMATION PARTICLES / STROKES / 3D / ETC ************************************************ */
         
        
        
        
         /* ************************************************ ESPECIAL / COLOR / OPACITY BRUSHES ************************************************ */
         
         // brushes by keypressed
         if (keyPressed) {
           
                 // ramitas
                 if (key == '/') {
                     strokePG.beginDraw();
                     strokePG.stroke(pencil);
                     strokePG.strokeWeight(2);
                     strokePG.line(pmouseX, pmouseY, mouseX+random(-40,6), mouseY+random(-20,valaudio));
                     strokePG.endDraw();
                 }
                 
                 // petalos
                 if (key == '9') {             
                     // add petalous
                     float mathrand = random(30);
                     if( count_capacity < capacity ){
                         color clr = color(244,29,69);
                         petalous[count_capacity].set(mouseX+random(-60,60), mouseY+random(-60,60), clr, random(240), valaudio+mathrand);
                         count_capacity ++;
                     }
                 }
                     
                 // audio value
                 if (key == '*') audioIncrem = min(200, audioIncrem+1);
                 if (key == '-') audioIncrem = max(0, audioIncrem-1);
        
                 // opacity
                 if (key == '3') alphaBrush = min(255, alphaBrush+2);
                 if (key == '0') alphaBrush = max(0, alphaBrush-2);
        
                 // weight brush value
                 if (key == '2') weightBrush = min(30, weightBrush+0.25);
                 if (key == '1') weightBrush = max(1, weightBrush-0.25);
    
                 // color - alpha
                 if (key == '4') pencil = color(0, 0, 0);
                 if (key == '+') pencil = color(255, 255, 255);
                 if (key == '6') pencil = color(244,29,69);
                 // 142, 60, 60
                 if (key == '8') pencil = color(115, 79, 20);
                 if (key == '5') pencil = color(190, 138, 74);
                 if (key == '=') pencil = color(208, 176, 131);
                 if (key == 'z') pencil = color(48,51,118);
                 if (key == 'x') pencil = color(58,62,167);
                 if (key == 'c') pencil = color(165,162,190);                 
                 if (key == 'v') pencil = color(216,123,39);                
                 if (key == 'b') pencil = color(41,217,175);
  
         }
         
         /* ************************************************ ESPECIAL / COLOR / OPACITY BRUSHES ************************************************ */
         
         
         
         // draw canvasPG
         noTint();
         noStroke();
         image(canvasPG,0,0);   
         
         
        
         /* ************************************************ BASIC / MIRROR BRUSHES ************************************************ */
         
         // set brush weight by audio
         strokePG.strokeWeight(weightBrush+(valaudio*3));
         
         // draw on mousepressed
         if (mousePressed) {
         
             // capture image
             PGraphics strPG = strokePG;
             strPG.updatePixels();
                       
             // brush type base
             if (brush_type == 1) {
               strokePG.beginDraw();
               strokePG.beginShape();
               strokePG.noFill();
               strokePG.stroke(pencil);
               strokePG.vertex(mouseX,mouseY);
               strokePG.vertex(pmouseX,pmouseY);
               strokePG.vertex(mouseX,mouseY);
               strokePG.vertex(pmouseX,pmouseY);
               strokePG.endShape();
               strokePG.endDraw();
             }
             
             // brush type 
             if (brush_type == 2) {
                   /*
                   float weight = dist(mouseX, mouseY, pmouseX+2, pmouseY+2);
                   if (countstrokeweight <= weight){
                     countstrokeweight = countstrokeweight + 0.5;
                   }else if(countstrokeweight >= 0.5){
                     countstrokeweight = countstrokeweight - 0.5;
                   }
                   */
                   float wb = (weightBrush*3) + 60;
                   strokePG.beginDraw();
                   strokePG.beginShape(QUAD);
                   strokePG.fill(pencil, alphaBrush);
                   //strokePG.strokeWeight(60);
                   strokePG.noStroke();
                   strokePG.vertex(mouseX,mouseY);
                   strokePG.vertex(pmouseX+wb,pmouseY);
                   strokePG.vertex(mouseX+wb,mouseY+wb);
                   strokePG.vertex(pmouseX,pmouseY+wb);
                   strokePG.endShape(CLOSE);
                   strokePG.endDraw();
                   
                   /*
                   strokePG.beginDraw();
                   strokePG.fill(pencil, alphaBrush);
                   strokePG.noStroke();
                   strokePG.rect(mouseX,mouseY,60,60);
                   strokePG.endDraw();
                   */
             }
                       
             // brush type pincel
             if (brush_type == 3) {
                   strokePG.beginDraw();       
                   strokePG.stroke(pencil, 40);
                   strokePG.strokeWeight(4+valaudio*0.25);
                   strokePG.noFill();
                   strokePG.beginShape();
                   strokePG.vertex(mouseX,mouseY);
                   strokePG.vertex(pmouseX,pmouseY);
                   strokePG.vertex(mouseX,mouseY);
                   strokePG.vertex(pmouseX,pmouseY);
                   strokePG.endShape();
                   for (int num = 14; num > 0; num --) {
                         float offset = random(-20, 30);
                         color newColor = color(red(pencil)+offset, green(pencil)+offset, blue(pencil)+offset, random(10, 205));       
                         strokePG.stroke(newColor);
                         strokePG.strokeWeight(random(1,6)+valaudio*0.25);
                         float rdmpen = random(-6, 8);
                         strokePG.line(pmouseX+rdmpen, pmouseY+rdmpen, mouseX+rdmpen, mouseY+rdmpen);
                   }
                   strokePG.endDraw();
             }
             
             // brush type 
             if (brush_type == 4) {
                   if( count_capacitytr < capacitytr ){
                       trazous[count_capacitytr].set(pmouseX, pmouseY, mouseX, mouseY, pencil, alphaBrush, valaudio);
                       count_capacitytr ++;
                   }
             }
            
             // draw mirror
             if(flagmirror){   
                       
                 // brush type base
                 if (brush_type == 1) {
                     strokePG.beginDraw();
                     strokePG.beginShape();
                     strokePG.noFill();
                     strokePG.stroke(pencil);
                     strokePG.vertex(width-mouseX,mouseY);
                     strokePG.vertex(width-pmouseX,pmouseY);
                     strokePG.vertex(width-mouseX,mouseY);
                     strokePG.vertex(width-pmouseX,pmouseY);
                     strokePG.endShape();
                     strokePG.endDraw();
                 }          
                 
                 /*
                 // brush type 
                 if (brush_type == 2) {
                       float weight = dist(mouseX, mouseY, pmouseX+2, pmouseY+2);
                       if (countstrokeweight <= weight){
                         countstrokeweight = countstrokeweight + 0.5;
                       }else if(countstrokeweight >= 0.5){
                         countstrokeweight = countstrokeweight - 0.5;
                       }
                       strokePG.beginDraw();
                       strokePG.stroke(pencil, alphaBrush);
                       strokePG.strokeWeight(countstrokeweight);
                       strokePG.noFill();
                       strokePG.beginShape(QUAD);
                       strokePG.vertex(width-mouseX,mouseY);
                       strokePG.vertex(width-pmouseX,pmouseY);
                       strokePG.vertex(width-mouseX,mouseY);
                       strokePG.vertex(width-pmouseX,pmouseY);
                       strokePG.endShape();
                       strokePG.endDraw();
                 }
                 */
                           
                 // brush type pincel
                 if (brush_type == 3) {
                       strokePG.beginDraw();       
                       strokePG.stroke(pencil, 40);
                       strokePG.strokeWeight(4+valaudio*0.25);
                       strokePG.noFill();
                       strokePG.beginShape();
                       strokePG.vertex(width-mouseX,mouseY);
                       strokePG.vertex(width-pmouseX,pmouseY);
                       strokePG.vertex(width-mouseX,mouseY);
                       strokePG.vertex(width-pmouseX,pmouseY);
                       strokePG.endShape();
                       for (int num = 14; num > 0; num --) {
                             float offset = random(-20, 30);
                             color newColor = color(red(pencil)+offset, green(pencil)+offset, blue(pencil)+offset, random(10, 205));       
                             strokePG.stroke(newColor);
                             strokePG.strokeWeight(random(1,6)+valaudio*0.25);
                             float rdmpen = random(-6, 8);
                             strokePG.line(width-pmouseX+rdmpen, pmouseY+rdmpen, width-mouseX+rdmpen, mouseY+rdmpen);
                       }
                       strokePG.endDraw();
                 }

             }
            
             // draw finished image
             tint(255, alphaBrush);
             image(strPG, 0, 0);
            
        }
        
        /* ************************************************ BASIC / MIRROR BRUSHES ************************************************ */
        
        
        
        
        /* ************************************************ ANIMATED BRUSHES ************************************************ */
       
        // petalous animation
        for (int i=0;i<count_capacity;i++) {
                  float wvalue = petalous[i].w*valaudio;
                  strokeWeight(2);
                  stroke(petalous[i].c, petalous[i].o/3);
                  line(petalous[i].x, petalous[i].y, petalous[i].x+wvalue, petalous[i].y+wvalue);
                  fill(petalous[i].c, petalous[i].o/3);
                  noStroke();
                  ellipse(petalous[i].x, petalous[i].y, wvalue+40, wvalue+50);
        }
       
        // trazous animation
        for (int i=0;i<count_capacitytr;i++) {
                   float wvaluetr = trazous[i].w*valaudio*2;
                   float posrandom = random(-diff,diff);
                   /*
                   stroke(trazous[i].c, trazous[i].o);
                   strokeWeight(wvaluetr);
                   strokeJoin(ROUND);
                   noFill();
                   line(trazous[i].bx+posrandom, trazous[i].by+posrandom, trazous[i].ax+posrandom, trazous[i].ay+posrandom);
                   */

                   beginShape(QUAD);
                   stroke(trazous[i].c, trazous[i].o);
                   strokeWeight(wvaluetr);
                   strokeJoin(ROUND);
                   vertex(trazous[i].bx,trazous[i].by+posrandom);
                   vertex(trazous[i].ax,trazous[i].ay+posrandom);
                   vertex(trazous[i].bx,trazous[i].by+posrandom);
                   vertex(trazous[i].ax,trazous[i].ay+posrandom);
                   endShape();
                   
         }
         
         /* ************************************************ ANIMATED BRUSHES ************************************************ */
                 
         // bg gradient
         // setGradient(0, 0, width/2, height, b1, b2, X_AXIS);
         // setGradient(width/2, 0, width/2, height, b2, b1, X_AXIS);
         
         popMatrix();
                
         // draw sign logo
         signdraw.signloop(pencil, alphaBrush, weightBrush, valaudio, 1);
         
  }
                 
}

void mousePressed(){
  
        countstrokeweight = 0.5;
        strokePG.strokeWeight(countstrokeweight);
        strokePG.stroke(pencil, alphaBrush);
        strokePG.beginDraw();
        strokePG.clear();
        strokePG.endDraw();
}


void mouseReleased(){
  
       canvasPG.beginDraw();
       canvasPG.tint(255,alphaBrush);
       canvasPG.image(strokePG,0,0);
       canvasPG.noTint();
       canvasPG.endDraw();
     
}

void controllerChange(int channel, int number, int value) {
  println();
  println("Controller Change:");
  println("--------");
  println("Channel:"+channel);
  println("Number:"+number);
  println("Value:"+value);
  
  // opacity
  if (number == 6){
    alphaBrush = value*2;
  }
  
  // weight
  if (number == 7){
    weightBrush = value*0.5;
  }
  
  // color
  if (number == 29){
    pencil = color(value*2, 255, 255);
  }
  
  // brush type
  if (number == 24){
    brush_type = value;
  }
  
}

void keyPressed() {

      // clear
      //if (key==CODED) {
          if (keyCode == 8){
                      canvasPG.beginDraw();
                      canvasPG.background(0);
                      canvasPG.endDraw();
           }
     //}
      
      // basic brushes
      if (key == 'q') brush_type = 1;
      if (key == 'w') brush_type = 2;
      if (key == 'e') brush_type = 4;
      if (key == 'r') brush_type = 3;
      
      // draw audio
      if (key == 'a') {
        if( drawWithAudio ){
          drawWithAudio = false;
        } else {
          drawWithAudio = true;
        }
      }
      
      // draw particles A
      if (key == 'p'){
        if( flagparticles_A ){
          flagparticles_A = false;
        } else {
          flagparticles_A = true;
        }
      }
      
      // draw particles B
      if (key == 'o'){
        if( flagparticles_B ){
          flagparticles_B = false;
        } else {
          flagparticles_B = true;
        }
      }
      
      // draw particles C
      if (key == 'i'){
        if( flagparticles_C ){
          flagparticles_C = false;
        } else {
          flagparticles_C = true;
        }
      }
      
      // draw particle_D
      if (key == 'u'){
        if( flagparticles_D ){
          flagparticles_D = false;
        } else {
          flagparticles_D = true;
        }
      }
      
      // draw particle_E
      if (key == 'y'){
        if( flagparticles_E ){
          flagparticles_E = false;
        } else {
          flagparticles_E = true;
        }
      }
      
      // draw particle_F
      if (key == 's'){
        if( flagparticles_F ){
          flagparticles_F = false;
        } else {
          flagparticles_F = true;
        }
      }
      
      // draw mirror
      if (key == 't'){
        if( flagmirror ){
          flagmirror = false;
        } else {
          flagmirror = true;
        }
      }
            
      // preset_1 blanco esqueleto
      if (key == 'ñ') {
            brush_type = 1;
            flagmirror = true;
            audioIncrem = 60;
            alphaBrush = 160;
            pencil = color(255, 255, 255);
            weightBrush = 4;
      }
            
      // preset_2 blanco espiral
      if (key == 'l') {
            brush_type = 2;
            audioIncrem = 40;
            alphaBrush = 120;
            pencil = color(48,51,118);
            weightBrush = 2;
      }
            
      // preset_3 rojo tendones
      if (key == 'k') {
            brush_type = 1;
            flagmirror = true;
            audioIncrem = 40;
            alphaBrush = 100;
            pencil = color(142, 60, 60);
            weightBrush = 5;
      }
            
      // preset_4 marron madera
      if (key == 'j') {
            brush_type = 1;
            flagmirror = true;
            audioIncrem = 40;
            alphaBrush = 50;
            pencil = color(115, 79, 20);
            weightBrush = 26;
      }
            
      // preset_5 lagrima
      if (key == 'h') {
            brush_type = 1;
            flagmirror = false;
            audioIncrem = 50;
            alphaBrush = 160;
            pencil = color(244, 29, 69);
            weightBrush = 4;
      }
            
      // preset_6 blanco final
      if (key == 'g') {
            brush_type = 1;
            flagmirror = false;
            audioIncrem = 40;
            alphaBrush = 20;
            pencil = color(255, 255, 255);
            weightBrush = 20;
      }
            
      // preset_7 firma final
      if (key == 'f') {
            flagparticles_A = false;
            flagparticles_B = false;
            flagparticles_C = false;
            brush_type = 1;
            flagmirror = false;
            audioIncrem = 5;
            alphaBrush = 160;
            pencil = color(255, 255, 255);
            weightBrush = 2;
      }
  
}


// Intro video events
void movieEvent(Movie m) {
    if(m.available()){
        if (m.time() == m.duration()){
              stat_video = true;
        }
        m.read();
    }
}