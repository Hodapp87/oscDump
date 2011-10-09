/**
 * Based on: oscP5parsing by andreas schlegel
 * Uses oscP5 & netP5 (http://www.sojamo.de/oscP5)
 */

import oscP5.*;
import netP5.*;

OscP5 oscP5;
NetAddress myRemoteLocation;

void setup() {
  size(100,100);
  frameRate(25);
  /* start oscP5, listening for incoming messages at port 12000 */
  oscP5 = new OscP5(this,12000);
  
  /* myRemoteLocation is a NetAddress. a NetAddress takes 2 parameters,
   * an ip address and a port number. myRemoteLocation is used as parameter in
   * oscP5.send() when sending osc packets to another computer, device, 
   * application. usage see below. for testing purposes the listening port
   * and the port of the remote location address are the same, hence you will
   * send messages back to this sketch.
   */
  myRemoteLocation = new NetAddress("127.0.0.1",12000);
}

void draw() {
  background(0);  
}

void mousePressed() {
  /* create a new osc message object */
  OscMessage myMessage = new OscMessage("/test");
  
  myMessage.add(123); /* add an int to the osc message */
  myMessage.add(12.34); /* add a float to the osc message */
  myMessage.add("some text"); /* add a string to the osc message */
  myMessage.add(true);
  myMessage.add('c');
  double a = 12.34567890123456789;
  myMessage.add(a);
  myMessage.add(new byte[] { 0x00, 0x00, 0x00, 0x00, 0x11, 0x22, 0x33, 0x44, 0x55, 0x66, 0x77, (byte) 0x88, (byte) 0x99, (byte) 0xAA, (byte) 0xBB, (byte) 0xCC, (byte) 0xDD, (byte) 0xEE, (byte) 0xFF });

  /* send the message */
  oscP5.send(myMessage, myRemoteLocation); 
}

void oscEvent(OscMessage msg) {
  
  String addr = msg.addrPattern();
  String typetag = msg.typetag();
  byte[] typebytes = msg.getTypetagAsBytes();
  println("Received OSC message, timetag=" + msg.timetag() + ", address pattern="+addr + ", typetag=" + typetag);
  
  msg.printData();
  
  for(int i = 0; i < typebytes.length; ++i) {

    OscArgument arg = msg.get(i);
    print("Argument " + i + ": ");

    try {
      switch(typebytes[i]) {
      case 'N':
        println("null value");
        break;
      case 'i':
        println("int, " + arg.intValue());
        break;
      case 's':
        String s = arg.stringValue();
        println("string, " + s.length() + " characters: " + s);
        break;
      case 'f':
        println("float, " + arg.floatValue());
        break;
      case 'd':
        println("double, " + arg.doubleValue());
        break;
      case 'T':
        println("boolean, true");
        break;
      case 'F':
        println("boolean, false");
        break;
      case 'c':
        println("character, " + Character.toString(arg.charValue()));
        break;
      case 'b':
        byte b[] = arg.blobValue();
        String bytes = "";
        int j = 0;
        for(j = 0; j < 16 && j < b.length; ++j) {
          bytes += String.format("%02X ", b[j]);
        }
        if (j < b.length) {
          bytes += "...";
        }
        println("byte array, " + b.length + " bytes: " + bytes);
        break;
      case 'S':
        println("symbol, " + arg.stringValue());
        break;
      default:
        println("unknown typetag " + String.format("%c", typebytes[i]));
        break;
      }
    } catch(Exception e) {
      println("Threw exception: " + e.toString());
    }
  }

}
