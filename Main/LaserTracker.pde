class LaserTracker {
  color trackColor;
  int laserThreshold;
  ColorEventHandler event;
  int xOffsetFromTable;
  int yOffsetFromTable;
  Capture video;
  Point finalPoint;
  float closestColor;
  FinishTracker finTracker;
  int videoWidth,videoHeight;
  boolean videoDimSet=false;

  public LaserTracker(color trackColor, int laserThreshold, int xOffsetFromTable, int yOffsetFromTable, FinishTracker finTracker) {
    this.trackColor=trackColor;
    this.laserThreshold=laserThreshold;
    this.xOffsetFromTable=xOffsetFromTable;
    this.yOffsetFromTable=yOffsetFromTable;
    finalPoint=new Point(-10, -10);
    this.finTracker= finTracker;
  }
  void setEvent( ColorEventHandler event) {
    this.event=event;
  }
  void setVideoDim(int videoWidth, int videoHeight){
    videoDimSet=true;
    this.videoWidth=videoWidth;
    this.videoHeight=videoHeight;
    println("inLaserTracker: videoHeight: "+videoHeight+" videoWidth:"+videoWidth);
  }
  boolean checkVideoDimSet(){
    return videoDimSet;
  }

  void trackLaser(int[] pixelArr) {
    this.video=video;
    closestColor=2000;
    finalPoint=new Point(-10, -10);
    for (int x = xOffsetFromTable; x < videoWidth-xOffsetFromTable; x+=6 ) {
      for (int y = yOffsetFromTable; y < videoHeight-yOffsetFromTable; y+=6 ) {
        int loc = x + y*videoWidth;
        color currentColor = pixelArr[loc];
        
        evaluatePixel(x, y, currentColor);
      }
    }
    if (closestColor > laserThreshold) { 
      finalPoint.setPoint(-10, -10);
    }
    //println("*********************");
    //println("DONE TRACKING: finalPoint x: "+finalPoint.x+" y: "+finalPoint.y);
    
  }
  public void stampTriggered() {
    //println("TRIGGER DETECT POINT: "+closestColor+" finX: "+finalPoint.x+" finY: "+finalPoint.y);
    //println("-----------------------");
    if (finalPoint.x>0&&finalPoint.y>0) {
      // Draw a circle at the tracked pixel
      //drawPoint(finalPoint, color(0, 0, 255));
      if(checkFinishedTrigger()){
        finTracker.sessionFinished();
        rect(400,400,400,400);
      }else{
        event.colorDetected(finalPoint.x, finalPoint.y); 
      }
    }
  }
  private boolean checkFinishedTrigger(){
    println("x: "+finalPoint.x);
    println("y: "+finalPoint.y);
    println("xtrack: "+finTracker.getTrackRangeX());
    println("ytrack: "+finTracker.getTrackRangeY());
    
    if(finalPoint.x < finTracker.getTrackRangeX() && finalPoint.y < finTracker.getTrackRangeY()){
      println(" STAMP TRACKED WITHIN CIRCLE");
      return true;
    }
      println(" STAMP TRACKED OUTSIDE OF CIRCLE");
    return false;
  }

  public void evaluatePixel(int x, int y, color currentColor) {

    float r1 = red(currentColor);
    float g1 = green(currentColor);
    float b1 = blue(currentColor);
    float r2 = red(trackColor);
    float g2 = green(trackColor);
    float b2 = blue(trackColor);

    // XY coordinate of closest color

      // Using euclidean distance to compare colors
    float d = dist(r1, g1, b1, r2, g2, b2); // We are using the dist( ) function to compare the current color with the color we are tracking.

    // If current color is more similar to tracked color than
    // closest color, save current location and current difference
    if (d < closestColor) {
      closestColor = d;
      finalPoint.setPoint(x, y);
    } // We only consider the color found if its color distance is less than 10. 
    // This threshold of 10 is arbitrary and you can adjust this number depending on how accurate you require the tracking to be.
  }
  void drawPoint(Point p, color c) {
    fill(c);
    noStroke();
    ellipse(p.x, p.y, 16, 16);
  }
}

