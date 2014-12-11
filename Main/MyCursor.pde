class MyCursor {
  private  PImage cursor;
  private int cursorDiam;
  private int offsetX=0;

  private  int myMouseX=0;
  private  int myMouseY=0;
  private boolean toggleShowMouse=false;

  public MyCursor() {
    cursor = loadImage("pointer.png");
    cursorDiam=5;
  }

  public void doDraw() {
    myMouseX = abs(offsetX-mouseX);
    myMouseY = mouseY;    

    if (toggleShowMouse){
      tint(255, 127);
      image(cursor, myMouseX-cursorDiam/2, myMouseY-cursorDiam/2, cursorDiam, cursorDiam);
      tint(255, 255);
    }
  }
  public void toggleMirror() {
    if (offsetX>0) {
      offsetX=0;
    }
    else {
      offsetX=width;
    }
  }

  public  void toggleShowMouse() {
    toggleShowMouse=!toggleShowMouse;
  }
  public int getMouseX() {
    return myMouseX;
  }
  public int getMouseY() {
    return myMouseY;
  }
}

