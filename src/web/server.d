/**********************************************************************
 * \file src/web/server.d
 * Loosly Based on: http://github.com/burjui/quarkHTTPd/
 * copyright (c) 2012 Danny Arends
 * last modified Feb, 2012
 * first written Jun, 2011
 * Written in the D Programming Language (http://www.digitalmars.com/d)
 **********************************************************************/
module web.server;

import core.stdinc;
import core.typedefs.types;

class Server(Client) : core.thread.Thread{
  private:
    Socket       socket;
    SocketSet    set;
    string       _hostname    = "0.0.0.0";
    ushort       _port        = 3000;
    Client[]     clients;
    uint         _max_clients = 2000;
    ubyte[1024]  buffer;
  
  public:
    this(string hostname = "0.0.0.0", ushort port = 3000, uint max_clients=2000){
      super(&run);
      socket = new Socket(AddressFamily.INET, SocketType.STREAM, ProtocolType.TCP);
      _port = port;
      _hostname = hostname;
      _max_clients = max_clients;
      with(socket){
        bind(new InternetAddress(hostname,port));
        listen(20);
      }
      clients = new Client[max_clients];
      writeln("[Server] Constructed");
    }
    
    @property int    max_clients(){ return _max_clients; }
    @property int    port(){return _port; }
    @property string hostname(){return _hostname; }

    void run(){
      writeln("[Server] Start listening for clients");
      set = new SocketSet();
      while(true){
        assert(set !is null);
        set.reset();
        set.add(socket);
        foreach(Client c; clients){
          if(c !is null){
            set.add(c.socket);
          }
        }
        int result = Socket.select(set, null, null, 50000);
        if(result > 0) {
          if(set.isSet(socket)) {
            Socket sock = socket.accept();
            if(sock !is null){
              uint index;
              for(index = 0; index < clients.length; index++) {
                if(clients[index] is null) {
                  clients[index] = new Client(this, sock, cast(uint)index);
                  clients[index].start();
                  writefln("[Server] Accepted connection on %d",index);
                  break;
                }
              }
              if(index == clients.length) {
                sock.close();
              }
              if(result == 1) continue;
            }
          }
          foreach(uint index, ref Client fib; clients) {
            if(fib is null) continue;
            if(set.isSet(fib.socket)){
              auto received = fib.socket.receive(buffer);
              if(received <= 0) {
                clients[index].close();
                clients[index].offline();
                clients[index] = null;
                writefln("[Server] Dropped connection %d",index);
                continue;
              }else{
                clients[index].processCommand(buffer[0..received]);
                writefln("[Server] Received from %d: %s",index, to!string(toType!char(buffer[0..received])));
              }
            }
          }
        }
      }
      writeln("[Server] Shutdown");
    }
}
