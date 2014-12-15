import processing.video.*;
import java.util.Vector;
import java.util.Iterator;
import java.awt.event.KeyEvent;

class CameraTracker {
  Capture video;
  int yOffsetFromTable= 200;
  int xOffsetFromTable=140;

  //**************** SHADOW *************
  int distance=60;
  float brightnessThreshold=82;
  ShadowTracker shadowTracker;

  // TIMING
  float lastTime;
  // time to wait before the video array is checked again
  float waitingTime=200;

  // CALLIBRATION 
  boolean callibrationRect=false;
  MyCursor cursor;

  //************** LASER *******************
  // Start off tracking for red
  LaserTracker laserTracker;
  color trackColor = color(233, 29, 61);
  int laserThreshold = 90;
  boolean clicked=false;

  int cameraIndex;
  PApplet applet;
  ColorEventHandler laserEvent;
  boolean showVideo=false;

  public CameraTracker(PApplet applet, int cameraIndex, MyCursor cursor, FinishTracker finTracker) {
    this.laserThreshold=laserThreshold;
    this.cameraIndex=cameraIndex;
    this.applet=applet;
    this.cursor=cursor;

    shadowTracker = new ShadowTracker(distance, xOffsetFromTable, yOffsetFromTable);
    shadowTracker.setBrightnessThreshold(brightnessThreshold);
    laserTracker= new LaserTracker(trackColor, laserThreshold, xOffsetFromTable, yOffsetFromTable, finTracker);
    
    lastTime=0;
    String[] cameras = Capture.list();
    if (cameras.length == 0) {
      println("There are no cameras available for capture.");
      exit();
    } 
    else {
      println("Available cameras:");
      for (int i = 0; i < cameras.length; i++) {
        println("i: "+i+" "+cameras[i]);
      }
      // The camera can be initialized directly using an 
      // element from the array returned by list():
      if (cameraIndex>cameras.length)
        cameraIndex=1;

      println("CAMERA INDEX USED: "+cameraIndex);
      video = new Capture(applet, cameras[cameraIndex]);
      video.start();
    }
  }

  void setLaserEvent(ColorEventHandler laserEvent) {
    laserTracker.setEvent(laserEvent);
  }
  void setShadowEvent( ColorEventHandler shadowEvent) {
    shadowTracker.setEvent(shadowEvent);
  }
  void doDraw() {
    if (showVideo) {  
      image(video, 0, 0, width, height);    
      noFill();
      stroke(204, 102, 0);
      rect(xOffsetFromTable, yOffsetFromTable, width-xOffsetFromTable*2, height-yOffsetFromTable*2);
    }
    else if (callibrationRect) {
      noFill();
      stroke(204, 102, 0);
      rect(xOffsetFromTable, yOffsetFromTable, width-xOffsetFromTable*2, height-yOffsetFromTable*2);
    }
    if (timingRight()) {
      // Capture and display the video
      if (video.available()) {
        video.read();
      }
      // Before we begin searching, the "world record" for closest color is set to a high number that is easy for the first pixel to beat.

      video.loadPixels();
      shadowTracker.trackShadows(video);
    }
  }
  boolean timingRight() {
    float currentTime=millis();
    if (currentTime<lastTime+waitingTime) {
      return false;
    }
    lastTime=currentTime;
    return true;
  }
  void toggleShowVideo() {
    showVideo=!showVideo;
  }
  void toggleToggleCallibrate() {
    callibrationRect=!callibrationRect;
  }
  void doKeyPressed() {
    if(!laserTracker.checkVideoDimSet()){
      laserTracker.setVideoDim(video.width,video.height);
    }
    video.loadPixels();
    int[] pixelArr= video.pixels;
    laserTracker.trackLaser( pixelArr);
    println("PGUP");
  }
  void doKeyReleased() {
    laserTracker.stampTriggered();
  }
  void incrementBrightnessThreshold(){
    shadowTracker.incrementBrightnessThreshold();
  }
  void decrementBrightnessThreshold(){
    shadowTracker.decrementBrightnessThreshold();
  } 
  void doMouseReleased() {
    shadowTracker.doMouseReleased(cursor.getMouseX(), cursor.getMouseY());
  }
}

