import processing.video.*;

import javax.mail.*;
import javax.mail.internet.*;
import java.util.Properties;

ArtefactHandler artefats;
StampHandler stampHandler;
VideoHandler videoHandler;
VideoEnum curVid;
FinishTracker finTracker;
FtpConnectionHandler ftpHandler;
HtmlHandler htmlHandler;
DemoHandler demoHandler;
Mode mode;
CameraTracker tracker;
MyCursor cursor;

// *************   CHANGE PRESENTATION / WORK mode *************
boolean presentationMode=true;

void setup() {
  if (presentationMode) {    
    size(displayWidth, displayHeight);
  }
  else {
    size(1280,720);
  }
  noCursor();
  cursor = new MyCursor(); 
  initHandlers();
}
void initHandlers() {
  ftpHandler= new FtpConnectionHandler();
  htmlHandler= new HtmlHandler(ftpHandler);
  videoHandler=new VideoHandler(this);
  artefats= new ArtefactHandler(this);
  stampHandler= new StampHandler(this, cursor, ftpHandler);
  finTracker=new FinishTracker(stampHandler, htmlHandler,ftpHandler);
  demoHandler = new DemoHandler();
  
  tracker=new CameraTracker(this, 5, cursor,finTracker);//147
  tracker.setShadowEvent(artefats);
  tracker.setLaserEvent(stampHandler);
  new Thread(ftpHandler).start();
  mode=Mode.SHADOW_CALLIBRATION;
  curVid=VideoEnum.VIDEO_PIL1;
}


void draw() { 
  clear();  
  finTracker.doDraw();
  artefats.doDraw();
  tracker.doDraw();
  stampHandler.doDraw();
  videoHandler.doDraw();
  cursor.doDraw();
  demoHandler.doDraw();
}

void mouseReleased() { 
  switch(mode) {
  case SHADOW_CALLIBRATION:
    tracker.doMouseReleased();      
    break;
  case ARTEFACT:
    //artefats.addArtefact(cursor.getMouseX(), cursor.getMouseY());
    break;
  case STAMP:
    stampHandler.colorDetected(cursor.getMouseX(), cursor.getMouseY());
    break;
  case VIDEO:
    //float angle = atan2(cursor.getMouseY() - height/2, cursor.getMouseX() - width/2);
    videoHandler.addVideo(curVid);
    break;
  default:
    break;
  }
}
void keyPressed() {
  // **** DETECT STAMP
  if (keyCode == KeyEvent.VK_PAGE_UP) {
    tracker.doKeyPressed();
  }
}
void mouseWheel(MouseEvent event) {
  float e = event.getCount();
  if (e>0)
    demoHandler.nextStep();
  else    
    demoHandler.prevStep();
}

void keyReleased() {
  // **** WIZ OF OZ: **** ARTEFACT MODE

  if (key=='a') {
    mode=Mode.ARTEFACT;
  } 
  else if (key=='h') {
    //produce and upload a html file htmlHandler?
    //safe last picture
    int currentCountName = stampHandler.getCountName();
    htmlHandler.generateAndUpload(currentCountName, stampHandler.getClipList());
  }else if (key=='r') {
    //produce and upload a html file htmlHandler?
    //safe last picture
    int currentCountName = stampHandler.getCountName();
    htmlHandler.generateAndUpload(currentCountName, stampHandler.getClipList());
    initHandlers();
    
  }
  else if (key=='m') {
    tracker.incrementBrightnessThreshold();
  }
  else if (key=='n') {
    tracker.decrementBrightnessThreshold();
  }
  else  if (keyCode == KeyEvent.VK_PAGE_UP) {
    tracker.doKeyReleased();
  }
  else if (key=='b') {
    mode=Mode.SHADOW_CALLIBRATION;
  }

  // **** WIZ OF OZ: **** STAMP MODE
  else if (key=='s') {
    //mode=Mode.STAMP;    
    tracker.toggleShowVideo();
  }
  else if (key=='c') {
    //mode=Mode.STAMP;    
    tracker.toggleToggleCallibrate();
  }
  // **** WIZ OF OZ: **** VIDEO MODE
  else if (key=='v') {
    mode=Mode.VIDEO;
  }
  // **** WIZ OF OZ: **** PLAY VIDEO 1
  else if (key=='5') {
    curVid=VideoEnum.VIDEO_PIL1;
  }
  else if (key=='z') {
    initHandlers();
  }
  // **** WIZ OF OZ: **** PLAY VIDEO 2
  else if (key=='6') {
    curVid=VideoEnum.VIDEO_PIL2;
  }
  // **** WIZ OF OZ: **** PLAY VIDEO 3
  else if (key=='7') {
    curVid=VideoEnum.VIDEO_PIL3;
  }
  // **** WIZ OF OZ: **** MIRROR Mouse
  else if (key=='8') {
    cursor.toggleMirror();
  } 
  // **** WIZ OF OZ: **** SHOW/ HIDE MOUSE
  else if (key=='9') {
    cursor.toggleShowMouse();
  } 

  // **** WIZ OF OZ: **** TOGGLE DEMO MODE
  else if (key=='1') {
    demoHandler.toggleShow();
  } 
  else if (key=='3') {
    demoHandler.nextStep();
  } 
  else if (key=='2') {
    demoHandler.prevStep();
  }
}
// Called every time a new frame is available to read
void movieEvent(Movie m) {
  m.read();
}
boolean sketchFullScreen() {
  return presentationMode;
}

