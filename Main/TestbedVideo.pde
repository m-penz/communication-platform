class TestbedVideo {

  PApplet applet;
  Movie myMovie;
  int x, y;
  float angle;
  boolean play=false;

  public TestbedVideo(PApplet applet, String path) {
    this.applet=applet;
    myMovie = new Movie(applet, path);
    myMovie.noLoop();
  }

  void doDraw() {
    if (play) {
      translate(width, height);
      rotate(PI);
      //image(myMovie, -myMovie.width/2, 0);
      int myMovieHeightProportional=(int)(width*myMovie.height/myMovie.width);
      int yOffset = (height-myMovieHeightProportional)/2;
      image(myMovie,0,yOffset,width,myMovieHeightProportional);
      if (myMovie.time()>= myMovie.duration()-5) {
        play=false;
        myMovie.stop();
      }
      rotate(-PI);
      translate(-width,-height);
    }
  }
  public void playVideo(float angle) {
    this.angle=angle;
    myMovie.play();
    play=true;
  }
  public void playVideo(){
    myMovie.play();
    play=true;
  }
}

