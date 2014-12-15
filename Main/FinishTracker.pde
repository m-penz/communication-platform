class FinishTracker {
  //tracks a specific region on the board. Clicking on it with the stamp will end the session and upload all the files
  //rename this lass
  PShape doneButton,doneNotifier;
  int finWidth=150;
  int finHeight=150;
  int xOffset=25;
  int yOffset=165;
  StampHandler stampHandler;
  HtmlHandler htmlHandler;
  FtpConnectionHandler ftpHandler;
 boolean isSessionFinished=false;
  public FinishTracker(StampHandler stampHandler, HtmlHandler htmlHandler, FtpConnectionHandler ftpHandler) {
    this.stampHandler=stampHandler;
    this.htmlHandler=htmlHandler;
    this.ftpHandler=ftpHandler;

    doneButton = loadShape("doneButton.svg");
    doneNotifier= loadShape("doneNotification.svg");
  }
  public void doDraw() {
    //strokeWeight(8);
   // ellipse(0, 0, finWidth, finHeight);
   doneButton.disableStyle();
    strokeWeight(1.5);
    shape(doneButton,xOffset,yOffset, finWidth, finWidth);
    if(isSessionFinished){
     isSessionFinished=false;
    sessionFinished(); 
    }
  }
  public void setSessionFinished(){
    doneNotifier.disableStyle();
    shape(doneNotifier,400,400,600,300);
    isSessionFinished=true;
  }
  // returns the width that is being tracked from 0 to return value
  public int getTrackRangeX() {
    return (int)finWidth+xOffset;
  }
  public int getTrackRangeY() {
    return (int) finHeight+yOffset;
  }

  private void sessionFinished() {    
    //safe last picture
    int currentCountName = stampHandler.getCountName();
    htmlHandler.generateAndUpload(currentCountName, stampHandler.getClipList());
    stampHandler.clearStage();
    ftpHandler.makeNewDirOnServer();
  }
}

