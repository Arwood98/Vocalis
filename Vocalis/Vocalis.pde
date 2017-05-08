import ddf.minim.*;

Minim minim;
AudioInput in;
//slider til justering af sværhedsgrad + variabel
float sliderX;
float diff;
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
//Dead Screen
PImage deadScreen;
//position af spikes
float deadX = 0;



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
  deadScreen = loadImage("deadScreen.png");
  sliderX = width/2;
}



void draw(){
  background(255);
  //en switch case, der indeholder spillens forskellige dele bestående af menu, spillet og en deadscreen
  switch(gameState) {
    //spilmenuen:
    case 0:
      image(menu,0,0,width,height);
      
      rectMode(CENTER);
      fill(125);
      rect(sliderX,height*0.932,width/80,width/40,width/200);

      //aktiverer, når en knap på musen bliver trykket
      if (mousePressed == true){
        //determinerer, om musen er inden for knappernes y-værdier
        if (mouseY >=  height*0.57 && mouseY <= height*0.73){
          //determinerer, om musen er inden for x-området af én af knapperne
          if (mouseX >= width*0.13 && mouseX <= width*0.36){
            gameState = 1;
          }
          if (mouseX >= width*0.64 && mouseX <= width*0.87){
            exit();
          }
        }
        if(mouseX >= sliderX-(width/50) && mouseX <= sliderX+(width/50) && mouseY >= height*0.91 && mouseY <= height*0.95) {
          sliderX = mouseX;
          if(sliderX < width*0.13) sliderX = width*0.13;
          if(sliderX > width*0.87) sliderX = width*0.87;
        }
      }
      break;
    //selve spillet:
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
      //spillerens position på venstre side af bjælken:
      translate(x,0);
      image(playerModel,width/14,height-(height/8),width/20,height/8);
      popMatrix();
      
      //spikes på venstre side af skærmen
      fill(0);
      rectMode(CORNER);
      rect(0,height*0.8,deadX,height*0.2);
      pushMatrix();
      translate(deadX,height*0.8);
      fill(230,0,70);
      triangle(0,0,width/50,height/50,0,height/25);
      translate(0,height/25);
      triangle(0,0,width/50,height/50,0,height/25);
      translate(0,height/25);
      triangle(0,0,width/50,height/50,0,height/25);
      translate(0,height/25);
      triangle(0,0,width/50,height/50,0,height/25);
      translate(0,height/25);
      triangle(0,0,width/50,height/50,0,height/25);
      translate(0,height/25);
      popMatrix();
      
      //funktion for bevægelse af spikes mod højre
      //for(int i = 0; i < 5; i++){
        deadX += width*1/*i*//pow(map(diff,width*0.13,width*0.87,9,11),5);
     // }
      
      //funktion for død af spilleren ved kontakt med spikes
      /*if(deadX >= x-width/10){
        gameState = 2;
      }*/
      
      //viser værdier til debugging
      pushMatrix();
      translate(width-200,100);
      scale(5);
      fill(255,0,0);
      text(avg,0,0);
      text(avgVol,0,35);
      text(deadX,0,70);
      popMatrix();
      break;
      
      //viser en deadscreen, når spilleren dør:
      case 2:
      //et for-loop, der bliver brugt til at time tiden, denne deadscreen skal vises:
      float deadTime;
      int deadEnd = 6000;
      deadTime = millis();
      if(deadTime >= deadEnd){
        gameState = 0;
      }
      image(deadScreen,0,0,width,height);
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