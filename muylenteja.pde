import ddf.minim.analysis.*;
import ddf.minim.*;

Minim minim;
AudioPlayer lentejas;
String[] sentences;
String[] serverResponse;
PImage plasma;

public enum States {
  WAITING_FOR_DELAY, 
    PLAYING_WAV,
}

//Folder parameters
final int filesPerFolder = 47;

//Finite-state machine parameters
int delayBetweenNames = 10000; //in ms

States currState = States.WAITING_FOR_DELAY;
int startTime = millis();
int sentenceIndex;

void setup() {

  minim = new Minim(this);
  sentences = loadStrings("frases_rajoy.txt");
  plasma = loadImage("plasma.jpg");

  size(1350, 900); 
  background(plasma);
  fill(255);
  textSize(24);
  textAlign(LEFT);
  noStroke();
  
}

void draw() {

  //Finite-state machine
  switch(currState) {
  case WAITING_FOR_DELAY:
    if (startTime + delayBetweenNames < millis()) {
      sentenceIndex = (int)(random(filesPerFolder)+1);
      //sentenceIndex = 28;
      String randomName = "audio/rajoy_"+nf(sentenceIndex, 2)+".mp3";
      lentejas = minim.loadFile(randomName, 1024);
      currState = States.PLAYING_WAV;
      lentejas.play();
      background(plasma);
      fill(0,130);
      rect(200,580,1019,133);
      fill(255,255);
      text(sentences[sentenceIndex-1], 210, 592, 1000, 200);
    }
    break;
  case PLAYING_WAV:
    if (!lentejas.isPlaying()) {
      currState = States.WAITING_FOR_DELAY;
      startTime = millis();
      background(plasma);
      serverResponse = loadStrings("http://172.27.0.101/gpio/0");
    }
    break;
  }
}


void stop() {

  minim.stop();
  super.stop();
}