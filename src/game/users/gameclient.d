/**
 * \file gameclient.d
 *
 * last modified Juli, 2011
 * first written Juli, 2011
 *
 * Copyright (c) 2010 Danny Arends
 *
 * Contains: GameClient
 * Written in the D Programming Language (http://www.digitalmars.com/d)
 **/

module game.users.gameclient;

import core.thread;
import std.array;
import std.conv;
import std.file;
import std.path;
import std.socket;
import std.stdio;
import std.string;
import std.uri;

import core.typedefs.webtypes;
import core.web.socketclient;

class GameClient : Thread{
  private:
  SocketClient network;
  bool         verbose;
  bool         online;
   
  public:
  this(string host = "localhost", ushort port = 3000, bool verbose = false){
    this.network = new SocketClient(host,port);
    this.verbose = verbose;
    this.online  = true;
    super(&run);
  }
  
  ~this(){ network.disconnect(); }
  
  void send(string rawtext){ network.write(rawtext); }
  void shutdown(){this.online = false;}
  
  void run(){
    try{
      network.connect();
      network.write("Test");
      while(online){
        //network.write("Test");
        Thread.sleep( dur!("msecs")( 10 ) );
      }
      writeln("Network Bye...");
    }catch (Throwable exception){
      if(verbose) writeln("Client threw an error");
      return;
    }finally{
      network.disconnect();
    }
  }
  
  void sendHeartbeat(int checks){
    this.send("T");
  }
}
