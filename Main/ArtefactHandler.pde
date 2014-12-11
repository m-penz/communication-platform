import megamu.mesh.*;
//http://www.leebyron.com/else/mesh/
import java.util.Iterator;
import java.util.Map;
import java.util.Map.Entry;
class ArtefactHandler implements ColorEventHandler {

  PApplet applet;
  int colorMax=60;
  int colorMin=10;
  float lifespan=3000;

  Voronoi voronoi;
  // *********************************** ADDIN ARTEFACT MARKS IS COMMENTED OUT !!!!!!!!!!!! COMMENT IN IF YOU WANT A MARK THERE ********************
  float[][] points;
  ArrayList<Integer> colorTargetMap;
  ArrayList<Integer> colorIsMap;  
  ArrayList<Float> timeStampMap;
  // closest object we allow is X px away
  int artefactProximityThreshold=90;

  ArtefactHandler(PApplet applet) {
    this.applet=applet;
    colorTargetMap = new ArrayList<Integer>();
    colorIsMap= new ArrayList<Integer>();
    timeStampMap = new ArrayList<Float>();
    points = new float[1][2];
    initMaps();
    voronoi = new Voronoi(points);
  }
  void initMaps() {
    points[0][0]=800/4;
    points[0][1]=600/2;    
    colorIsMap.add(120);
    colorTargetMap.add( 0);
    timeStampMap.add( millis()+.0);
  }

  void doDraw() {
    drawRegion();
    drawEdges();
    //drawArtefactMarks();
  }
  /*
  private void drawArtefactMarks() {
   for (ArtefactMark a: artefactMarkMap.values()) {
   a.doDraw();
   }
   }*/

  private void drawRegion() {
    MPolygon[] myRegions = voronoi.getRegions();
    for (int i=0; i<myRegions.length; i++)
    {
      //println("DRAW REGION Art. i: "+i+" timestampmapsize: "+timeStampMap.size());
      if (i<timeStampMap.size()) {
        float time= timeStampMap.get(i);

       // println("i: "+i+"  millis: "+millis()+" - time: "+time+" = "+(millis()-time)+" < lifespan: "+lifespan);
       /* if (millis()-time<lifespan) {
          // an array of points
          float[][] regionCoordinates = myRegions[i].getCoords();
          fill(getColor(i)); 
          myRegions[i].draw(applet); // draw this shape
        }*/
        if (millis()-time>lifespan) {
          removeArtefact(i);
        }
      }
    }
  }
  private void removeArtefact(int index) {
    int maxIndex=points.length-1;

    removeVoronoiPoint(index);

    if (index<colorTargetMap.size())
      colorTargetMap.remove(index);

    if (index<colorIsMap.size())
      colorIsMap.remove(index);

    if (index<timeStampMap.size()) {
     // println("timestamp");
      timeStampMap.remove(index);
    }
  }

  private color getColor(int index) {
    if (index<colorIsMap.size()&& index< colorTargetMap.size()) {
      if (colorIsMap.get(index)>colorTargetMap.get(index)) {
        int cur = colorIsMap.get(index);
        float r = red(cur);
        float g = green(cur);
        float b = blue(cur);
        colorIsMap.add(index, color(r--, g--, b--));
      }
      return colorIsMap.get(index);
    }
    return color(0, 0, 0);
  }

  private void drawEdges() {
    float[][] myEdges = voronoi.getEdges();
    for (int i=0; i<myEdges.length; i++)
    {
      float startX = myEdges[i][0];
      float startY = myEdges[i][1];
      float endX = myEdges[i][2];
      float endY = myEdges[i][3];
      strokeWeight(.75);
      stroke(246, 238, 208);
      //stroke(235,244,198);
      line( startX, startY, endX, endY );
    }
  }
  //returns index of artefact
  int checkPointAlreadyExisting(float x, float y) {
    for (int i=0; i< points.length;i++) {
      if (abs(points[i][1]-y)<=artefactProximityThreshold) {
        if (abs(points[i][0]-x)<=artefactProximityThreshold) {
          // println("already existing: point : x:"+x+" y:"+y+" ");
          return i;
        }
      }
    }
    return -1;
  }
  public void addArtefact(float x, float y, float timeStamp) {    
    //println("artefact detected: x: "+x+" y: "+y+" time: "+timeStamp);
    int artefactIndex=checkPointAlreadyExisting(x, y);
    if (artefactIndex<0) {//doesn't exist yet
      int index= addVoronoiPoint(x, y);
      addColors(index);
      addTimeStamp(index, timeStamp);
      //addArtefactMark(index, x, y);
      //println("artefact detected: artefact doesn't exist");
    }
    else {//does exist
      // println("artefact detected: artefact exists time updated");
      updateTimeStamp(artefactIndex, timeStamp);
    }
  }
  private void updateTimeStamp(int index, float timeStamp) {
    if (index<timeStampMap.size())
      timeStampMap.add(index, timeStamp);
  }
  private void addColors(int index) {
    //put new random color as target
    //key is index 
    colorTargetMap.add((int)random(colorMin, colorMax));
    colorIsMap.add(color(235, 244, 198));
  }
  private void addTimeStamp(int index, float timeStamp) {
    timeStampMap.add(timeStamp);
  }
  private void removeVoronoiPoint(int index) {
    if (index < points.length-1) {
      float[][] result = new float[points.length-1][2];
      //println("_------------------");
      //println("DELETING INDEX: "+index);
     /* for (int i=0; i<points.length;i++) {
        println(" BEFORE DELETING: i: "+i+" x:"+points[i][0]+ " y: "+points[i][1]);
      }*/
      if (index>0) {
        System.arraycopy(points, 0, result, 0, index);    
        System.arraycopy(points, index+1, result, index, points.length- (index+1));
      }
      else if (index==0) {
        System.arraycopy(points, 1, result, 0, points.length-1);
      }
      else if (index==points.length-1) {
        System.arraycopy(points, 0, result, 0, points.length-1);
      }

      if (result != null && result.length>0) {
       /* for (int i=0; i<result.length;i++) {
          println(" AFTER DELETING: i: "+i+" x:"+result[i][0]+ " y: "+result[i][1]);
        }*/
        points = result;
        if (points!=null) {
          voronoi = new Voronoi(points);
        }
      }
    }
  }
  private int addVoronoiPoint(float x, float y) {   
    float[][] newPoint = new float[1][2];
    newPoint[0][0]=x;
    newPoint[0][1]=y;

    float[][] result = new float[points.length + newPoint.length][2];

    System.arraycopy(points, 0, result, 0, points.length);
    System.arraycopy(newPoint, 0, result, points.length, newPoint.length);

    if (result != null && result.length>0) {
      points = result;
      voronoi = new Voronoi(result);
    }
    return points.length-1;
  }

  public void colorDetected(float xPos, float yPos) {
    //addArtefact(xPos, yPos);
  }
  public void colorDetectedAtTime(float xPos, float yPos, float timeStamp) {
    addArtefact(xPos, yPos, timeStamp);
  }
}

