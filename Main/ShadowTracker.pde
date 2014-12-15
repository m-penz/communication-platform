class ShadowTracker {
  ColorEventHandler event;
  float brightnessThreshold;
  int distance;

  int xOffsetFromTable;
  int yOffsetFromTable;

  public ShadowTracker(int distance, int xOffsetFromTable, int yOffsetFromTable) {
    this.distance= distance;
    this.xOffsetFromTable=xOffsetFromTable;
    this.yOffsetFromTable=yOffsetFromTable;
  }

  Capture video;
  void setEvent( ColorEventHandler event) {
    this.event=event;
  }

  public void trackShadows(Capture video) {
    //Looks at every 50x50 pixel square
    this.video=video;
    Vector result = new Vector();
    //println("TrackShadows xoff: "+xOffsetFromTable+" video.width:"+video.width+" dist: "+distance);
    for (int x = xOffsetFromTable; x < video.width-xOffsetFromTable; x+=distance ) {
      for (int y = yOffsetFromTable; y < video.height-yOffsetFromTable; y+=distance ) {
        int loc = x + y*video.width;
        color currentColor = video.pixels[loc];  
        evaluatePixel(x, y, result, currentColor);
      }
    }
    /* if (result.size()<1) {
     //brightnessThreshold= min(brightnessThreshold+.31, 100);
     }*/
  }
  public void evaluatePixel(int x, int y, Vector result, color currentColor) {
    float xDistRandom= random(-distance*.3, distance*.3);
    float yDistRandom= random(-distance*.3, distance*.3);
    x = (int) round(map(x+xDistRandom, 0, video.width, 0, width));    
    y = (int) round(map(y+yDistRandom, 0, video.height, 0, height));
    //********************** MAP CAMERA TO SKETCH SIZE ***************************

    float r1 = red(currentColor);
    float g1 = green(currentColor);
    float b1 = blue(currentColor);

    //********************** SHADOWS ***************************

    //The standard formula to measure brightness
    float luma = 0.2126 * r1 + 0.7152 * g1 + 0.0722 * b1; 
    //println("TrackShadows: Luma: "+luma+" thresh: "+brightnessThreshold);
    //You could tune this threshold to your 
    if (luma < brightnessThreshold) {
      result.add(new Point(x, y));
      event.colorDetectedAtTime(x, y, millis());
      Iterator it = result.iterator();
      while (it.hasNext ()) {
        Point p = (Point) it.next();
        // Draw a circle at the tracked pixel
        // **************************** COMMENT IN TO DEVELOPE ****************************
        //drawPoint(p, color(255, 0, 0));
      }    
      //TODO   
      if (result.size()>15) {
        // setBrightnessThreshold(max(brightnessThreshold-.01, 20));
      }/*
    else if (result.size()<1) {
       brightnessThreshold= min(brightnessThreshold+1, 255);
       }*/
    }
  }
  void setBrightnessThreshold(float brightnessThreshold) {
    this.brightnessThreshold=brightnessThreshold;
    println("TrackShadows: New brightness: "+brightnessThreshold);
  }
  void doMouseReleased(int x, int y) {
    if (video!=null) {
      if ( video.available()) {
        video.read();
      }
      video.loadPixels();
      int loc = x + y*video.width;
      if (video.pixels.length>loc) {
        color currentColor = video.pixels[loc];
        float r1 = red(currentColor);
        float g1 = green(currentColor);
        float b1 = blue(currentColor);

        //The standard formula to measure brightness
        float luma = 0.2126 * r1 + 0.7152 * g1 + 0.0722 * b1;     
        setBrightnessThreshold(luma);
      }
    }
  }
  void incrementBrightnessThreshold() {
    setBrightnessThreshold(++brightnessThreshold);
  }
  void decrementBrightnessThreshold() {
    setBrightnessThreshold(--brightnessThreshold);
  }
  void drawPoint(Point p, color c) {
    fill(c);
    strokeWeight(4.0);
    stroke(0);
    ellipse(p.x, p.y, 16, 16);
  }
}

