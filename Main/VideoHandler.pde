class VideoHandler {

  PApplet applet;
  TestbedVideo vid1, vid2, vid3;
  VideoEnum videoPlayed;

  public VideoHandler(PApplet applet) {
    this.applet=applet;
    videoPlayed = VideoEnum.VIDEO_NONE;
    // COMMENT IN TO LOAD VIDEOS !!!!
    vid1 = new TestbedVideo(applet, "Pilot 2-SD_short.mp4");    
    vid2 = new TestbedVideo(applet, "Pilot 3-SD_short.mp4");    
    vid3 = new TestbedVideo(applet, "Pilot 4-SD_short.mp4");
  }

  void doDraw() {
    switch(videoPlayed) {
    case VIDEO_PIL1:
      vid1.doDraw();   
      break;
    case VIDEO_PIL2:
      vid2.doDraw();       
      break;
    case VIDEO_PIL3:
      vid3.doDraw();     
      break;
    case VIDEO_NONE:
      break;
    default:
      break;
    }
  }
  /*
  public void addVideoAngled(float angle, VideoEnum video) {
   switch(video) {
   case VIDEO_PIL1:
   vid1.playVideo(angle);   
   videoPlayed=VideoEnum.VIDEO_PIL1;   
   break;
   case VIDEO_PIL2:
   vid2.playVideo(angle);   
   videoPlayed=VideoEnum.VIDEO_PIL2;      
   break;
   case VIDEO_PIL3:
   vid3.playVideo(angle);  
   videoPlayed=VideoEnum.VIDEO_PIL3;       
   break;
   default:
   break;
   }
   } */  public void addVideo(VideoEnum video) {
    switch(video) {
    case VIDEO_PIL1:
      vid1.playVideo();   
      videoPlayed=VideoEnum.VIDEO_PIL1;   
      break;
    case VIDEO_PIL2:
      vid2.playVideo();   
      videoPlayed=VideoEnum.VIDEO_PIL2;      
      break;
    case VIDEO_PIL3:
      vid3.playVideo();  
      videoPlayed=VideoEnum.VIDEO_PIL3;       
      break;
    default:
      break;
    }
  }
}

