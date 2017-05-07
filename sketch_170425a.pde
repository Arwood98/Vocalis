import ddf.minim.*;

Minim minim;
AudioInput in;
//værdier for 
float val;
float valMax;
//max value adjustment
float max = 0.3;
//variabler for gennemsnitsværdi af amplitude
int increment;
float[] array;


void setup()
{
  size(2000, 700, P2D);
  minim = new Minim(this);
  minim.debugOn();
  
  increment = 0;
  array = new float[30];  
    
  // get a line in from Minim, default bit depth is 16
  //kilde: http://code.compartmental.net/tools/minim/quickstart/
  in = minim.getLineIn(Minim.STEREO, 512);
  background(0);
}

//knapper på startskærmen
void doStateWelcomeScreenDisplay(){
  //aktiverer, når en knap på musen bliver trykket
  if (mousePressed == true){
    //determinerer, om musen er inden for knappernes y-værdier
    if (mouseY >= height*0.85 && mouseY <= height*0.7){
      //determinerer, om musen er inden for x-området af én af knapperne
      if (mouseX >= width/5 && mouseX <= width/4){
        
      }
      if (mouseX >= width*0.75 && mouseX <= width*0.85){
      }
    }
  }
}


void draw(){
  background(255);
  // draw the waveforms
  for(int i = 0; i < in.bufferSize() - 1; i++){
    
    
    val = in.mix.get(i);
    
  }  
  if (increment >= 30){ increment = 0; }
    array[increment] = val;
    increment++;

  float avg = 0;
  for (int i = 0; i<30; i++){
    avg += array[i];
  }
  avg = avg/30;
  if(avg > val){
    val += (avg-val/5);
  } if (avg < val){
    val -= (val-avg/5);
  }
  fill(125);
  rect(0,0,map(val,0,max,0,width),height);
  pushMatrix();
  translate(width-150,50);
  scale(3);
  fill(0);
  text(mouseX,0,0);
  translate(0, -50);
  text(mouseY,0,0);
  popMatrix();
}


void stop()
{
  // always close Minim audio classes when you are done with them
  in.close();
  minim.stop();
  super.stop();
}