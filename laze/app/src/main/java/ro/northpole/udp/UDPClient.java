import java.io.*;
import java.net.*;

class UDPClient
{
  public static void main(String args[]) throws Exception
  {
    DatagramSocket clientSocket = new DatagramSocket();
    // InetAddress IPAddress = InetAddress.getByName("localhost");
    // InetAddress IPAddress = InetAddress.getByName("255.255.255.255");
    InetAddress IPAddress = InetAddress.getByName("255.255.255.0");
    byte[] sendData = new byte[1024];
    byte[] receiveData = new byte[1024];
    String sentence = "hello";
    sendData = sentence.getBytes();
    DatagramPacket sendPacket = new DatagramPacket(sendData, sendData.length, IPAddress, 9876);
    clientSocket.send(sendPacket);
    DatagramPacket receivePacket = new DatagramPacket(receiveData, receiveData.length);
    clientSocket.receive(receivePacket);
    String modifiedSentence = new String(receivePacket.getData());
    System.out.println("FROM SERVER:" + modifiedSentence);
    clientSocket.close();
  }
}
