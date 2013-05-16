import controlP5.*;
import oscP5.*;
import netP5.*;

ControlP5 cp5;
OscP5 oscP5;
NetAddress pdAddress;

int nx = 16;
int ny = 4;
boolean playing = false;
Textlabel kickLabel;
Textlabel snareLabel;
Textlabel hatLabel;
Textlabel crashLabel;

void setup() {
  size(530, 250);
  oscP5 = new OscP5(this,12000);
  pdAddress = new NetAddress("127.0.0.1",12000);

  cp5 = new ControlP5(this);

  cp5.addMatrix("pattern")
     .setPosition(50, 100)
     .setSize(400, 100)
     .setGrid(nx, ny)
     .setGap(2, 2)
     .setInterval(200)
     .setMode(ControlP5.MULTIPLES)
     .setColorBackground(color(120))
     .setBackground(color(40))
     ;

  cp5.addTextlabel("kickLabel")
	 .setText("KICK")
	 .setPosition(450, 108)
	 ;

  cp5.addTextlabel("snareLabel")
	 .setText("SNARE")
	 .setPosition(450, 132)
	 ;

  cp5.addTextlabel("hatLabel")
	 .setText("HAT")
	 .setPosition(450, 156)
	 ;

  cp5.addTextlabel("crashLabel")
	 .setText("CRASH")
	 .setPosition(450, 180)
	 ;

  cp5.addToggle("playing")
  	 .setCaptionLabel("PLAY")
     .setPosition(50,50)
     ;
  
  //cp5.getController("pattern").getCaptionLabel().alignX(CENTER);
  cp5.getController("pattern").setLabelVisible(false);
  noStroke();
  smooth();
}

// probably better to subclass Matrix instead
void drawBarRects(){
	fill(30,40,50);
	noStroke();
	rect(50, 90, 98, 120);

	fill(30,40,50,170);
	noStroke();
	rect(150, 90, 98, 120);

	fill(30,40,50);
	noStroke();
	rect(250, 90, 98, 120);

	fill(30,40,50,170);
	noStroke();
	rect(350, 90, 98, 120);
}

void draw() {
  background(0);
  fill(255, 100);
  if(playing == true){
  	cp5.get(Matrix.class, "pattern").play();
  	} else {
  	cp5.get(Matrix.class, "pattern").stop();
  	}
  drawBarRects();
  pushMatrix();
  translate(width/2 + 150, height/2);
  rotate(frameCount*0.001);
  popMatrix();
}


void pattern(int theX, int theY) {
  println("got it: "+theX+", "+theY);
  OscMessage myMessage = new OscMessage("/play");
  String drum[] = {"kick", "snare", "hat", "crash"};
  myMessage.add(drum[theY]);

  oscP5.send(myMessage, pdAddress); 
}
