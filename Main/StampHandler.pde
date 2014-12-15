class StampHandler implements ColorEventHandler {
  PApplet applet;

  ArrayList<Clip> clipList;
  ArrayList<PShape> countdownList;
  color col;
  int strokeWeightInc=1;
  String nextToSave;

  // AUDIO
  PAudioRecorder audioRec;
  AudioPlayer audioPlayer;
  Minim m;
  MyCursor cursor;
  FtpConnectionHandler ftpHandler;

  public StampHandler(PApplet applet, MyCursor cursor, FtpConnectionHandler ftpHandler) {    
    this.applet=applet;
    this.cursor=cursor;
    this.ftpHandler=ftpHandler;
    clipList = new ArrayList<Clip>();
    m= new Minim(applet);    
    audioRec= new PAudioRecorder(applet, ftpHandler);
    col=color(235, 244, 198);
    countdownList=new ArrayList<PShape>();
    loadCountDownImages(countdownList);
  }

  public ArrayList<Clip> getClipList() {
    return clipList;
  }
  //this is where audio clip and image are produced
  public void colorDetected(float xPos, float yPos) {
    //println("STAMP HANDLER");
    boolean foundClip=false;
    for (Clip c:clipList) {
      // println("REPLAY FOR ALL c: "+c.getX()+"/"+c.getY());
      if (c.isMouseOver(xPos, yPos)) {
        //  println("REPLAY PLAY");
        c.play();
        foundClip=true;
      }
    }  
    if (!foundClip) {
      String fileName = audioRec.record();
      PImage newTrace= applet.createImage(width, height, 0);
      Clip newClip = new Clip((int)xPos, (int) yPos, fileName, m, "stamp.svg", col, audioRec.getRecordingDuration(), cursor, countdownList);
      clipList.add(newClip);
    }
  }
  public void doDraw() { 
    audioRec.doDraw();

    for (int i=0;i<clipList.size();i++) {
      clipList.get(i).doDraw();
    }
    stroke(col);
    noFill(); 
    strokeWeightInc=1;
    for (int i=0;i<clipList.size()-1;i++) {

      strokeWeight(strokeWeightInc++);
      Clip thisNode=clipList.get(i);
      Clip nextNode= clipList.get(i+1);
      //Bezier Handles
      //line(thisNode.getX(),thisNode.getY(),thisNode.getOutgoingX(),thisNode.getOutgoingY());
      //line(nextNode.getX(),nextNode.getY(),nextNode.getIngoingX(),nextNode.getIngoingY());

      bezier(thisNode.getX(), thisNode.getY(), thisNode.getOutgoingX(), thisNode.getOutgoingY(), nextNode.getIngoingX(), nextNode.getIngoingY(), nextNode.getX(), nextNode.getY());
    }
  }
  public void clearStage(){
   clipList=new ArrayList<Clip>();i
  }
  public int getCountName() {
    return audioRec.getCountName();
  }
  public void setStopAutomatic() {
    audioRec.setStopAutomatic();
  }
  private void loadCountDownImages(ArrayList<PShape> countdownList) {
    PShape s0 = loadShape("time_0.svg");
    PShape s1 = loadShape("time_1.svg");
    PShape s2 = loadShape("time_2.svg");
    PShape s3 = loadShape("time_3.svg");
    PShape s4 = loadShape("time_4.svg");
    PShape s5 = loadShape("time_5.svg");
    PShape s6 = loadShape("time_6.svg");
    PShape s7 = loadShape("time_7.svg");
    PShape s8 = loadShape("time_8.svg");
    PShape s9 = loadShape("time_9.svg");
    PShape s10 = loadShape("time_10.svg");
    PShape s11 = loadShape("time_11.svg");    
    PShape s12 = loadShape("time_12.svg");
    countdownList.add(s0);
    countdownList.add(s1);
    countdownList.add(s2);
    countdownList.add(s3);
    countdownList.add(s4);
    countdownList.add(s5);
    countdownList.add(s6);
    countdownList.add(s7);
    countdownList.add(s8);
    countdownList.add(s9);
    countdownList.add(s10);
    countdownList.add(s11);    
    countdownList.add(s12);
  }

  public void colorDetectedAtTime(float xPos, float yPos, float timeStamp) {
  };
}

