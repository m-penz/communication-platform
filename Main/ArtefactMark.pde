class ArtefactMark {
  float centerX, centerY;
  int markWidth, markHeight;
  public ArtefactMark(float centerX, float centerY) {
    this.centerX=centerX;
    this.centerY=centerY;
    markWidth =20;
    markHeight = 20;
  }

  public void doDraw() {
    fill(0);
    noStroke();
    rect(centerX-markWidth/2,centerY-markHeight/2,markWidth,markHeight);
  }
}

