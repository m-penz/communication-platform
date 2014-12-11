/**
 *
 * Voronoi diagram animation
 * by Ben Chun (ben@benchun.net)
 *
 * 19 October 2009
 *
 **/

class MyVoronoi {
  int colorMax=60;
  int colorMin=10;
  ArrayList<Site> sites;
  int SITE_MAX_VEL = 2;
  int SITE_MARKER_SIZE = 6;
  PApplet applet;

  public MyVoronoi(PApplet applet, float[][] points)
  {
    this.applet=applet;
    sites = new ArrayList<Site>();
    for (int i=0; i<points.length;i++) {
      float x= points[i][0];
      float y= points[i][1];
      sites.add(new Site(x, y));
    }
  }

  public void doDraw()
  {
    drawRegions();
    // drawSites();
  }

  void drawRegions()
  {
    loadPixels(); // must call before using pixels[]

    for (int x=0; x<width; x++)
    {
      for (int y=0; y<height; y++)
      {
        float minDist = width+height;
        int closest = 0;
        for (int i=0; i<sites.size(); i++)
        {
          Site s = sites.get(i);
          float d = dist(x, y, s.x, s.y);
          if (d<minDist)
          {
            closest = i;
            minDist = d;
          }
        }

        /* the naive, slow way */
        //stroke(255,255,255);
        //point(x,y);

        /* set() is about 3x faster in P2D mode (just as slow as stroke/point in JAVA2D) */
        set(x, y, sites.get(closest).getColor());

        /* pixels[] is about 10x faster in P2D and 4x faster in JAVA2D */
        pixels[y*width+x] = sites.get(closest).getColor();
      }
    }
    updatePixels(); // must call after using pixels[]
  }

  void drawSites() {
    for (int i=0; i<sites.size(); i++)
    {
      Site s = sites.get(i);
      fill(255, 128);
      stroke(0);
      //ellipse(s.x, s.y, SITE_MARKER_SIZE, SITE_MARKER_SIZE);
    }
  }

  void moveSites() {
    for (int i=0; i<sites.size(); i++)
    {
      Site s = sites.get(i);
      s.move();
    }
  }
  public void addPoint(int x, int y) {
    Site s = new Site(x, y);
    sites.add(s);
  }

  class Site {
    int colorMin=20;
    int colorMax=60;
    float x, y;
    color c_target;
    color c_is;
    PVector vel;

    Site(float x, float y)
    {
      this.x=x;
      this.y=y;
      c_target = color((int)random(colorMin, colorMax));
      c_is=255;
      vel = new PVector(random(-SITE_MAX_VEL, SITE_MAX_VEL), random(-SITE_MAX_VEL, SITE_MAX_VEL));
    }

    void move()
    {
      x += vel.x;
      y += vel.y;
      if ((x<0) || (x>width)) vel.x *= -1;
      if ((y<0) || (y>height)) vel.y *= -1;
    }

    int getColor() {
      if (c_is>c_target)       
        c_is--;
      return c_is;
    }
  }
}

