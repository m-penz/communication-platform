class HtmlHandler {
  PrintWriter output;
  FtpConnectionHandler ftpHandler;
  ArrayList<Clip>clipList;
  MailSender mailSender;

  String backgroundImagePath="";
  String prefix ="<html><body><div>";
  String postfix="</div></body></html>";
  String soundvariable="SOUNDVARIABLE";
  String style  ="<style>body{background-image:url('BGIMAGE'); background-repeat: no-repeat; } .btn {  width: 40px;  height: 40px;}</style>";
  String soundplaceholder="<audio id='SOUNDVARIABLE' src='SOUNDFILE'></audio><img class= 'btn' style='position:absolute;top:TOPOFFSETpx;left:LEFTOFFSETpx;' src='button.svg'  onclick='document.getElementById(\""+soundvariable+"\").play()' />'";

  public HtmlHandler(FtpConnectionHandler ftpHandler) {
    this.ftpHandler=ftpHandler;
    mailSender=new MailSender();
  }
  // should the audio files be uploaded only here???
  // currently they are uploaded in PAudioRecorder

    void generateAndUpload(int variableFileName, ArrayList<Clip> clipList) {     
    this.clipList=clipList;
    // Create a new file in the sketch directory  
    saveAndUploadBackground(variableFileName);
    String htmlFileName= saveAndUploadHtml(variableFileName);

    println(ftpHandler.getCurDir()+htmlFileName);
    mailSender.sendMail(ftpHandler.getCurDir()+"/"+htmlFileName);
  }
  //@return returns html file name
  private String saveAndUploadHtml(int v) {  
    output = createWriter("file/html_"+v+".html"); 
    writeHtml();
    ftpHandler.uploadFile("html_"+v+".html");
    return "html_"+v+".html";
  }
  private void saveAndUploadBackground(int v) {
    save("file/backgroundimage_" + (v)+".jpg");
    ftpHandler.uploadFile("backgroundimage_" + (v)+".jpg");
    backgroundImagePath="backgroundimage_" + (v)+".jpg";
  }

  private void writeHtml() {
    output.println(prefix);
    for (Clip c: clipList) {
      String clipToHtml = soundplaceholder;
      clipToHtml= clipToHtml.replaceAll("SOUNDVARIABLE", c.getId().substring(5));
      clipToHtml= clipToHtml.replaceAll("SOUNDFILE", c.getFileName().substring(5));
      clipToHtml= clipToHtml.replaceAll("TOPOFFSET", ""+(c.getY()-20));
      clipToHtml= clipToHtml.replaceAll("LEFTOFFSET", ""+(c.getX()-20));
      println(clipToHtml);
      output.println(clipToHtml);
    }

    output.println(postfix);

    output.println(style.replaceAll("BGIMAGE", backgroundImagePath));
    output.flush(); // Writes the remaining data to the file
    output.close(); // Finishes the file
  }

  private String loadDefaultContent() {
    String lines[] = loadStrings("defaultHtmlText.txt");
    String ret="";
    for (int i=0;i<lines.length;i++) {
      ret+="\n"+lines[i];
    }
    return ret;
  }
}

