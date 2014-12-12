class FinishTracker {
  //tracks a specific region on the board. Clicking on it with the stamp will end the session and upload all the files
  
  
  int finWidth=500;
  int finHeight=500;
  StampHandler stampHandler;
  HtmlHandler htmlHandler;
  public FinishTracker(StampHandler stampHandler, HtmlHandler htmlHandler) {
    this.stampHandler=stampHandler;
    this.htmlHandler=htmlHandler;
  }
  public void doDraw() {
    strokeWeight(8);
    ellipse(0, 0, finWidth, finHeight);
    strokeWeight(1);
  }
  // returns the width that is being tracked from 0 to return value
  public int getTrackRangeX() {
    return (int)finWidth/2;
  }
  public int getTrackRangeY() {
    return (int) finHeight/2;
  }

  public void sessionFinished() {    
    //safe last picture
    int currentCountName = stampHandler.getCountName();
    htmlHandler.generateAndUpload(currentCountName, stampHandler.getClipList());
  }
}

