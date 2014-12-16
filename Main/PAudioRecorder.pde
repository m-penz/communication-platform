import ddf.minim.*;

// this class should be refactorized
// currently it deals with audio, but also with ftp transfer and images!!!!
class PAudioRecorder {

  Minim minim;
  AudioInput in;
  AudioRecorder recorder;
  FtpConnectionHandler ftpHanlder;
  PrintWriter output;
  /*##########################*/
  int countname=0; //change the name
  int recTime;
  int recDur=15000; //record 10 sec.
  boolean stopAutomatic=true;

  public PAudioRecorder(PApplet a, FtpConnectionHandler ftpHandler)
  {
    this.ftpHanlder=ftpHandler;
    minim = new Minim(a);
    in = minim.getLineIn(Minim.MONO, 512);
    newFile();
  }

  // change the file name
  String newFile()
  {      

    countname=loadCountName();
    countname++;
    String fileName="file/soundclip_" + countname + ".wav";
    recorder = minim.createRecorder(in, fileName, true);
    writeCountNameToFile();
    return fileName;
  }
  public int getCountName() {
    return countname;
  }
  /*###############################*/
  private int loadCountName() {
    String lines[] = loadStrings("nameCount.txt");
    int ret=0;
    if (lines.length>0)
      ret = Integer.parseInt(lines[0]);
    return ret;
  }
  private void writeCountNameToFile() {
    output = createWriter("data/nameCount.txt");   
    output.println(countname);
    output.flush();  // Flush all the data to the file
    output.close();  // Close the file
  }
  
  public void setStopAutomatic() {
    stopAutomatic=true;
  }
  public void setStopAfterKey() {
    stopAutomatic=false;
  }
//The file is uploaded after saving.
  void doDraw()
  {
    if (recorder.isRecording()) {
      if (stopAutomatic) {
        if (millis()-recTime>recDur) {
          stopRecordingAndSave();
        }
      }
    }
  }

  String record()
  {
    String fileName="";
    if (!recorder.isRecording()) {
      fileName = newFile();
      /*#######################################*/
      recorder.beginRecord();
    }
    this.recTime=millis();
    return fileName;
  }
  private void stopRecordingAndSave() {
    if ( recorder.isRecording() ) 
    {
      recorder.endRecord();
      recorder.save();
      println("doneButton saving.");      
      ftpHanlder.uploadFile("soundclip_" + countname + ".wav");
    }
  }

  void doStop()
  {
    in.close();
    minim.stop();
  }
  public int getRecordingDuration() {
    return recDur;
  }
}

