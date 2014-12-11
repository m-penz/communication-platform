// Learning Processing
// Daniel Shiffman
// http://www.learningprocessing.com

// Example 16-11: Simple color tracking



/*********************************** DEPRECATED

import processing.video.*;
import java.awt.event.KeyEvent;

public class ColorTracker {
  // Variable for capture device
  Capture video;
  // A variable for the color we are searching for.
  color trackColor; 
  int threshold, cameraIndex;
  PApplet applet;
  ColorEventHandler eventHandler;
  boolean clicked=false;
  boolean showVideo=true;

  public ColorTracker(PApplet applet, int threshold, int cameraIndex, ColorEventHandler eventHandler) {
    this.threshold=threshold;
    this.cameraIndex=cameraIndex;
    this.applet=applet;
    String[] cameras = Capture.list();
    this.eventHandler=eventHandler;
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
      video = new Capture(applet, cameras[cameraIndex]);
      video.start();
    }

    // Start off tracking for red
    trackColor = color(240, 161, 175);
    smooth();
  }

  void doDraw() {
    // Capture and display the video
    if (video.available()) {
      video.read();
    }
    if (showVideo)
      image(video, 0, 0);

    if (clicked) {
      clicked=false;

      video.loadPixels();
      // Before we begin searching, the "world record" for closest color is set to a high number that is easy for the first pixel to beat.
      float worldRecord = 500; 

      // XY coordinate of closest color
      int closestX = 0;
      int closestY = 0;

      // Begin loop to walk through every pixel
      for (int x = 0; x < video.width; x ++ ) {
        for (int y = 0; y < video.height; y ++ ) {
          int loc = x + y*video.width;
          // What is current color
          color currentColor = video.pixels[loc];
          float r1 = red(currentColor);
          float g1 = green(currentColor);
          float b1 = blue(currentColor);
          float r2 = red(trackColor);
          float g2 = green(trackColor);
          float b2 = blue(trackColor);

          // Using euclidean distance to compare colors
          float d = dist(r1, g1, b1, r2, g2, b2); // We are using the dist( ) function to compare the current color with the color we are tracking.

          // If current color is more similar to tracked color than
          // closest color, save current location and current difference
          if (d < worldRecord) {
            worldRecord = d;
            closestX = x;
            closestY = y;
          }
        }
      }

      // We only consider the color found if its color distance is less than 10. 
      // This threshold of 10 is arbitrary and you can adjust this number depending on how accurate you require the tracking to be.
      if (worldRecord < threshold) { 
        // Draw a circle at the tracked pixel
        fill(trackColor);
        strokeWeight(4.0);
        stroke(0);
        ellipse(closestX, closestY, 16, 16);

        eventHandler.colorDetected(closestX, closestY);
      }
    }
  }
  void toggleShowVideo() {
    showVideo=!showVideo;
  }

  void doKeyReleased()
  {
    if (keyCode == KeyEvent.VK_PAGE_UP) {
      clicked = true;
      println("PGUP");
    }
  }
}*/

