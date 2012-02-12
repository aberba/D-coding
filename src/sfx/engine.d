module sfx.engine;

import std.stdio;
import std.string;
import std.conv;
import std.array;
import std.file;
import std.random;

import openal.al;
import openal.al_types;
import openal.alc;
import openal.alut;
import openal.alut_types;

import io.events.engine;

import sfx.formats.wav;

class SFXEngine : EventHandler{
  
  this(){
  	alutInit(null, cast(char**)0);
	  if(alGetError() == AL_NO_ERROR){
      writeln("[SFX] Sound initialized.");
    }
    listDevices();
    checkEAX();
	}
  
  void load(){
    sounds.length = 0;
    foreach(string e; dirEntries("data/sounds", SpanMode.breadth)){
      e = e[e.indexOf("data/")..$];
      if(isFile(e) && e.indexOf(".wav") > 0){
        sounds ~= e;
      }
    }
    writefln("[SFX] Buffered %d sounds",sounds.length);
  }
  
  void listDevices(){
    write("[SFX] Devices available: ");
    if(alcIsExtensionPresent(null, "ALC_ENUMERATION_EXT".dup.ptr) == AL_TRUE){
      writef("%s\n",to!string(cast(char*)alcGetString(null, ALC_DEVICE_SPECIFIER)));
    }else{
      write("ALC_ENUMERATION_EXT not supported\n");
    }
  }
 
  bool checkEAX(){
    if(alIsExtensionPresent("EAX2.0".dup.ptr) == AL_TRUE){
      hasEAX = true;
      writeln("[SFX] EAX 2.0 is supported");
    }
    return hasEAX;
  }
  
  wavInfo getSound(string name, bool verbose = false){
    foreach(string e; sounds){
      if(e.indexOf(name) > 0){
         return loadSound(this, e, verbose);
      }
    }
    assert(0);
  }
  
  ALfloat* getSourcePos(){ return SourcePos.ptr; }
  ALfloat* getSourceVel(){ return SourceVel.ptr; }
  
  void handle(Event e){ }
  
  private:
    string[]  sounds;
    bool      hasEAX = false;
    ALfloat   SourcePos[3] =   [0.0, 0.0, 0.0];
    ALfloat   SourceVel[3] =   [0.0, 0.0, 0.0];
    ALfloat   ListenerPos[3] = [0.0, 0.0, 0.0];
    ALfloat   ListenerVel[3] = [0.0, 0.0, 0.0];
    ALfloat   ListenerOri[6] = [0.0, 0.0, -1.0,  0.0, 1.0, 0.0];
}