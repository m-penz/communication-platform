class DemoHandler {
  PImage imgStep0, imgStep1, imgStep2, imgStep3;
  int stepCounter=0;
  ArrayList<PImage> imgList;
  int maxSteps=4;

  boolean demoOver=false;
  boolean demoShow=true;

  public DemoHandler() {
    imgList = new ArrayList<PImage>();

    imgStep1 = loadImage("introduction_mirr-01.png");
    imgStep2 = loadImage("introduction_mirr-02.png");
    imgStep3 = loadImage("introduction_mirr-03.png");

    imgList.add(imgStep0);
    imgList.add(imgStep1);
    imgList.add(imgStep2);
    imgList.add(imgStep3);
  } 
  public void doDraw() {
    if (!demoOver && demoShow) {
      PImage img=imgList.get(stepCounter);
      if (img!=null) {
        tint(255);
        translate(width, height);
        rotate(PI);
        float factor=.5;
        int imgWidth= (int)(width*factor);
        int imgHeight= (int)(img.height*width/img.width*factor);
        int xOffset=(int)((width-width*factor)/2);
        int yOffset=(int)((height-height*factor)/2);
        image(img, xOffset, yOffset, imgWidth, imgHeight);
        //rotate(-PI);
        //translate(-width, -height);
      }
    }
  }

  public void nextStep() {
    stepCounter++;
    if (stepCounter==maxSteps) {
      demoOver=true;
    }
  }
  public void prevStep() {
    if (demoOver) {
      stepCounter=maxSteps-1;
      demoOver=false;
    }
    else if (stepCounter>0) {
      stepCounter--;
    }
  }
  public void toggleShow() {
    demoShow=!demoShow;
  }
}

