class Clip {
  PShape stampMark;
  color col;

  int x, y;
  String fileName;
  String id;

  Minim m;
  AudioPlayer audioClip;
  //CURVE
  int ingoingX, ingoingY, outgoingX, outgoingY;  
  int bezierHandleOffset=200;

  String path;
  int recordingDuration;
  float startTime;
  MyCursor cursor;

  int recordingCircleSize=120;
  int stampMarkDim=60;

  ArrayList<PShape> countdownList;
  // how many different steps until the recording ends
  int maxPhases;
  int phaseDuration;

  public Clip(int xPar, int yPar, String fileName, Minim m, String path, color col, int recordingDuration, MyCursor cursor, ArrayList<PShape> countdownList) {
    x=xPar;
    y=yPar;
    calcCurvePoints(x, y);
    this.fileName=fileName;
    this.col=col;
    this.m=m;
    this.path=path;
    this.cursor=cursor;
    println("filenamefornewclip: "+fileName);
    if (fileName.length()>0)
      this.id = fileName.substring(0, fileName.length()-4);
    else
      this.id="defaultId";

    this.countdownList=countdownList;
    this.recordingDuration=recordingDuration;
    maxPhases = countdownList.size();
    phaseDuration = round(recordingDuration/maxPhases);

    stampMark = loadShape(path);
    startTime=millis();
  }

  public String getFileName() {
    return fileName;
  }
  public String getId() {
    return id;
  }

  private void calcCurvePoints(int x, int y) {
    ingoingX = (int)random(x-bezierHandleOffset, x+bezierHandleOffset);
    ingoingY = (int)random(y-bezierHandleOffset, y+bezierHandleOffset);
    outgoingX = x -(ingoingX-x);
    outgoingY = y -(ingoingY-y);
    println("line: x/y: "+x+"/"+y+" ingoingX/Y: "+ingoingX+"/"+ingoingY+" outgoingX/Y: "+outgoingX+"/"+outgoingY);
  }
  public int getIngoingX() {
    return ingoingX;
  }
  public int getIngoingY() {
    return ingoingY;
  }
  public int getOutgoingX() {
    return outgoingX;
  }
  public int getOutgoingY() {
    return outgoingY;
  }

  public void doDraw() {
    if (millis()-startTime<recordingDuration) { 
      int phase = floor((millis()-startTime)/phaseDuration);
      if (phase<countdownList.size()) {
        shape(countdownList.get(phase), x-stampMarkDim, y-stampMarkDim, stampMarkDim*2, stampMarkDim*2);
      }
    }
    else {
      fill(col, 150);   
      noStroke();  
      stampMark.disableStyle();  // Ignore the colors in the Use color variable 'c' as fill color
      shape(stampMark, x-stampMarkDim/2, y-stampMarkDim/2, stampMarkDim, stampMarkDim);
    }
  }

  public void setColor(color col) {
    this.col=col;
  }

  public boolean isMouseOver(float xPos, float yPos) {
    if (xPos>(x-stampMarkDim) && xPos<(x+stampMarkDim)) {
      if (yPos>(y-stampMarkDim) && yPos<(y+stampMarkDim)) {
        return true;
      }
    } 
    return false;
  }
  public void removeImage() {
    stampMark= loadShape("emtpy.svg");
  }
  public void changePos(int newX, int newY) {
    x=newX;
    y=newY;
  }
  public int getXDim() {
    return stampMarkDim;
  }
  public int getYDim() {
    return stampMarkDim;
  }
  public int getX() {
    return x;
  }
  public int getY() {
    return y;
  }
  public void play() {
    println(fileName);
    try {
      audioClip = m.loadFile(fileName);
      if (audioClip!=null)
        audioClip.play();
    }
    catch(Exception e) {
    }
  }
}

