import java.sql.Timestamp;
import java.util.Date;

class FtpConnectionHandler implements Runnable {
  // Declare a new FTPClient
  FTPClient ftp;
  FTPMessageCollector listener;

  // Declare an array to hold directory listings
  String[] files;
  String delimiter="\\";
  String host = "stand-alone-complex.at";  
  String workingDir="www.penzmarcel.at/CommunicationPlatform";
  String sessionDir="";
  String userName="standab9";
  String password="LJnFkp9F";
  String pathToLocaleFileDir="C:\\Users\\M\\Dropbox\\DataSync\\prototype_boras_DB\\file\\";

  public void run() {
    connectFTP();
    java.util.Date date= new java.util.Date();
    String sessionDirName=new Timestamp(date.getTime()).toString();
    sessionDirName = sessionDirName.replace(" ", "_");
    makeDir(sessionDirName);
    sessionDir="/"+sessionDirName;   
    quitFTP();
    uploadFile("button.svg");
  }

  public String makeDir(String name) {
    try
    {     // try to make a directory
      println("Make a new directory: "+name);
      ftp.mkdir(name);
      return name;
    }
    catch (Exception e)
    {
      //Print out the type of error
      println("mError "+e);
    }
    return "";
  }
  public void makeDirAndMoveInto(String name) {
    String newDir=makeDir(name);
    println("Moving into a directory");
    try {
      ftp.chdir(newDir);
    }
    catch(Exception e) {
      println("Error: "+e);
    }
  }
  public void uploadFile(String fileName) {
    try {
      connectFTP();
      ftp.put(pathToLocaleFileDir+fileName, fileName, false);
      quitFTP();
    }
    catch (Exception e)
    {
      //Print out the type of error
      println("Error "+e);
    }
  }
  public String getCurDir() {
    try {
      return workingDir+sessionDir;
    }
    catch(Exception e) {
      println("Error "+e);
      return "";
    }
  }
  public void connectFTP()
  {
    try
    {
      // set up a new ftp client
      ftp = new FTPClient();
      ftp.setRemoteHost(host); // ie. ftp.site.com

      // set up listener
      listener = new FTPMessageCollector();
      ftp.setMessageListener(listener);

      // connect to the ftp client
      println ("Connecting");
      ftp.connect();

      // login to the ftp client
      println ("Logging in");
      ftp.login(userName, password);

      // set up in passive mode
      println ("Setting up passive, ASCII transfers");
      ftp.setConnectMode(FTPConnectMode.PASV);

      // set up for BINARY transfers
      //http://www.serv-u.com/newsletter/NewsL2008-03-18.asp
      ftp.setType(FTPTransferType.BINARY);

      ftp.chdir(workingDir+sessionDir);
    }
    catch (Exception e)
    {
      //Print out the type of error
      println("Error "+e);
    }
  }

  public void quitFTP() {
    try {
      // Shut down client
      println ("Quitting client");
      ftp.quit();

      // Print out the listener messages
      String messages = listener.getLog();
      println ("Listener log:");

      // End message - if you get to here it must have worked
      println(messages);
      println ("Disconnect complete");
    }
    catch (Exception e)
    {
      //Print out the type of error
      println("Error "+e);
    }
  }
}

