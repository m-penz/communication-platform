class FinishTracker {
  //tracks a specific region on the board. Clicking on it with the stamp will end the session and upload all the files
  //rename this lass
  PShape doneButton, doneNotifier, noRecordingsShape;
  int finButtonWidth=150;
  int finButtonHeight=150;
  int xButtonOffset=75;
  int yButtonOffset=175;

  int finNotWidth=500;
  int finNotHeight=finNotWidth/2;
  int finNotXOffset = (width-finNotWidth)/2;
  int finNotYOffset = 400;

  // no recordings notification
  boolean noRecordings=false;
  int noRecDur;
  int initialNoRecDur=200;

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
    noRecordingsShape=loadShape("noRecordings.svg");
  }
  public void doDraw() {
    //strokeWeight(8);
    // ellipse(0, 0, finButtonWidth, finButtonHeight);
    doneButton.disableStyle();
    strokeWeight(1.5);
    shape(doneButton, xButtonOffset, yButtonOffset, finButtonWidth, finButtonWidth);
    if (isSessionFinished) {
      isSessionFinished=false;
      sessionFinished();
    }
    if (noRecordings) {
      noRecDur--;
      strokeWeight(0);
      shape(noRecordingsShape, finNotXOffset, 220, 400, 400);
      if (noRecDur<0)
        noRecordings=false;
    }
  }
  private void enableNoRecordingsNotification() {
    noRecordings=true;
    noRecDur=initialNoRecDur;
  }

  //shows "no data" repsective "conversation saved"
  public void setSessionFinished() {
    if (stampHandler.getClipList().size()>0) {
      strokeWeight(0);
      shape(doneNotifier, finNotXOffset, finNotYOffset, finNotWidth, finNotHeight);
      isSessionFinished=true;
    } else {
      enableNoRecordingsNotification();
    }
  }
  // returns the width that is being tracked from 0 to return value
  public int getTrackRangeX() {
    return (int)finButtonWidth+xButtonOffset;
  }
  public int getTrackRangeY() {
    return (int) finButtonHeight+yButtonOffset;
  }
  //uploads only if there are audio recordings
  private void sessionFinished() {    
    //safe last picture

    int currentCountName = stampHandler.getCountName();
    htmlHandler.generateAndUpload(currentCountName, stampHandler.getClipList());
    stampHandler.clearStage();
    ftpHandler.makeNewDirOnServer();
  }
}

