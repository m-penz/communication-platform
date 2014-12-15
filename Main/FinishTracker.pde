class FinishTracker {
  //tracks a specific region on the board. Clicking on it with the stamp will end the session and upload all the files
  //rename this lass
  PShape done;
  int finWidth=150;
  int finHeight=150;
  int xOffset=25;
  int yOffset=165;
  StampHandler stampHandler;
  HtmlHandler htmlHandler;
  FtpConnectionHandler ftpHandler;
  public FinishTracker(StampHandler stampHandler, HtmlHandler htmlHandler, FtpConnectionHandler ftpHandler) {
    this.stampHandler=stampHandler;
    this.htmlHandler=htmlHandler;
    this.ftpHandler=ftpHandler;

    done = loadShape("done.svg");
  }
  public void doDraw() {
    //strokeWeight(8);
   // ellipse(0, 0, finWidth, finHeight);
   done.disableStyle();
    strokeWeight(1.5);
    shape(done,xOffset,yOffset, finWidth, finWidth);
  }
  // returns the width that is being tracked from 0 to return value
  public int getTrackRangeX() {
    return (int)finWidth+xOffset;
  }
  public int getTrackRangeY() {
    return (int) finHeight+yOffset;
  }

  public void sessionFinished() {    
    //safe last picture
    int currentCountName = stampHandler.getCountName();
    htmlHandler.generateAndUpload(currentCountName, stampHandler.getClipList());
    stampHandler.clearStage();
    ftpHandler.makeNewDirOnServer();
  }
}

