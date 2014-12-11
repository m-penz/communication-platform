import processing.serial.*;
Serial myPort;  // Create object from Serial class
String val; // Data received from the serial port

void setup() {
  size(299, 299); 
  setupPort();
  
}
void draw(){
  
}

private void setupPort(){
  String portName = Serial.list()[0]; //change the 0 to a 1 or 2 etc. to match your port
  myPort = new Serial(this, portName, 9600);
  for (int i=0; i< Serial.list().length;i++) {
    println(Serial.list()[i]);
  }
}
private String readStringUntil(int inByte) {
  byte temp[] = myPort.readBytesUntil(inByte);
  if (temp == null) {
    return null;
  } 
  else {
    return new String(temp);
  }
}
void serialEvent(Serial myPort) {
  //put the incoming data into a String - 
  //the '\n' is our end delimiter indicating the end of a complete packet
  val = readStringUntil('\n');

  if (val != null) {
    //trim whitespace and formatting characters (like carriage return)
    val = trim(val);
    println(val);
  }
}

