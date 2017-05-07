import ddf.minim.*;

Minim minim;
AudioInput in;
//værdier for amplitude
float vol;
float avgVol;
//maksimal lydstyrke justering
float max = 0.3;
//variabler for gennemsnitsværdi af amplitude
int increment;
float[] array;
//varigheden, over hvilken lydstyrken bliver optegnet for at generere gennemsnitsværdien
int dur = 60;
//x-værdi af bjælken
float x;
//Spilstatus (startmenu eller spil)
//kilde: https://forum.processing.org/one/topic/game-menu.html
int gameState;
//baggrundsbillede til startsmenu
PImage menu;
//PlayerCharacter
PImage playerModel;


void setup()
{
  //size(2000, 700, P2D);
  fullScreen();
  minim = new Minim(this);
  minim.debugOn();
  
  increment = 0;
  array = new float[dur];  
    
  // get a line in from Minim, default bit depth is 16
  //kilde: http://code.compartmental.net/tools/minim/quickstart/
  in = minim.getLineIn(Minim.MONO, 512);
  background(0);
  gameState = 0;
  //Initialisere billeder til baggrund og spiller
  menu = loadImage("startScreen.png");
  playerModel = loadImage("playerModel.png");
}



void draw(){
  background(255);
  switch(gameState) {
    case 0:
      image(menu,0,0,width,width*9/16);
      //aktiverer, når en knap på musen bliver trykket
      if (mousePressed == true){
        //determinerer, om musen er inden for knappernes y-værdier
        if (mouseY >= (width*9/16)*4/5 && mouseY <= (width*9/16)){
          //determinerer, om musen er inden for x-området af én af knapperne
          if (mouseX >= 0 && mouseX <= width*2/7){
            gameState = 1;
          }
          if (mouseX >= width*5/7 && mouseX <= width){
            exit();
          }
        }
      }
      break;
    case 1:
      //Opfanger lydniveauet og gemmer det i "vol" variablen
      for(int i = 0; i < in.bufferSize() - 1; i++){
        vol = in.mix.get(i);
      }
      //gemmer de sidste lydniveauer for at få en gennemsnitsværdi
      if (increment >= dur){ increment = 0; }
        array[increment] = vol;
        increment++;
      //laver variablen "avg" og gemmer gennemsnitsværdien i denne
      float avg = 0;
      for (int i = 0; i<dur; i++){
        avg += array[i];
      }
      //jeg dividerer avg med antallet af værdier i arrayen for at få gennemsnittet
      avg = avg/dur;
      //jeg fjerner unøjagtigheder i beregningen ved ikke at lade avg-værdien være under 0
      if (avg <= 0) avg=0;
      //to if-statements, der bestemmer bjælkens retning, og samtidig udjævner dens bevægelse
      if(avg > avgVol){
        avgVol += (avg-avgVol)/10;
      } if (avg < avgVol){ 
        avgVol -= (avgVol-avg)/100;
      }
      x = map(avgVol,0,max,0,width);
      //Bjælken, der genspejler lydniveauet
      fill(125);
      rect(0,0,x+width/8,height);
      
      //jeg laver en Matrix der sørger for, at alle affine transformations
      //ikke bliver anvendt på andre objekter end dem inden i denne.
      pushMatrix();
      translate(x,0);
      image(playerModel,width/14,height-(height/8),width/20,height/8);
      popMatrix();
      //viser værdier til debugging
      pushMatrix();
      translate(width-200,100);
      scale(5);
      fill(255,0,0);
      text(avg,0,0);
      text(avgVol,0,75);
      popMatrix();
      break;
  }
}
//Stopper Minim audio
void stop()
{
  in.close();
  minim.stop();
  super.stop();
}