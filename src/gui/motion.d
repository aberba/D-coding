/**********************************************************************
 * \file src/gui/motion.d
 *
 * copyright (c) 2012 Danny Arends
 * last modified Feb, 2012
 * first written Dec, 2011
 * Written in the D Programming Language (http://www.digitalmars.com/d)
 **********************************************************************/
module gui.motion;

import std.array;
import std.stdio;
import std.math;
import std.conv;

import sdl.sdlstructs;

import io.events.engine;
import io.events.keyevent;
import io.events.mouseevent;
import gui.screen;
import gui.objects.object3d;
import gui.objects.camera;

class CameraMotion : EventHandler{ 
  this(Screen screen){ scr = screen; }
  
  @property Screen screen(){ return scr; }
  private:
  Screen scr;
}

class NoMotion : CameraMotion {
  this(){ super(null); }  
  void handle(Event e){ }
}

class FPMotion : CameraMotion {
  this(Screen screen){ super(screen); }
  
  void handle(Event e){
    if(e.getEventType() == EventType.KEYBOARD){
      KeyEvent evt = cast(KeyEvent)e;
      switch(evt.getSDLkey()){
        case SDLK_UP:
          screen().getCamera().move(0,0,2);
          e.handled=true;
          break;
        case SDLK_DOWN:
          screen.getCamera().move(0,0,-2);
          e.handled=true;
          break;
        case SDLK_PAGEUP:
          screen.getCamera().move(0,2,0);
          e.handled=true;
          break;
        case SDLK_PAGEDOWN:
          screen.getCamera().move(0,-2,0);
          e.handled=true;
          break;
        case SDLK_LEFT:
          screen.getCamera().move(-2,0,0);
          e.handled=true;
          break;
        case SDLK_RIGHT:
          screen.getCamera().move(2,0,0);
          e.handled=true;
          break;
        default: break;
        }
        writefln("[MOV] KeyBOARD %s",evt.getSDLkey());
      }
    }
  }

class ObjectMotion : CameraMotion {
  this(Screen screen, Object3D object, double distance = 20){ 
    super(screen);
    this.object=object;
    this.distancetotarget=distance;
  }
  
  void handle(Event e){
    if(e.getEventType() == EventType.KEYBOARD){
      KeyEvent k_evt = cast(KeyEvent)e;
      switch(k_evt.getSDLkey()){
        case SDLK_UP:
          object.move(0,0,2);
          e.handled=true;
          break;
        case SDLK_DOWN:
          object.move(0,0,-2);
          e.handled=true;
          break;
        case SDLK_PAGEUP:
          screen.getCamera().rotate(-2,0,0);
          e.handled=true;
          break;
        case SDLK_PAGEDOWN:
          screen.getCamera().rotate(2,0,0);
          e.handled=true;
          break;
        case SDLK_LEFT:
          object.move(-2,0,0);
          e.handled=true;
          break;
        case SDLK_RIGHT:
          object.move(2,0,0);
          e.handled=true;
          break;
        case SDLK_EQUALS:
          distancetotarget++;
          e.handled=true;
          break;      
        case SDLK_MINUS:
          distancetotarget--;
          e.handled=true;
          break;
        default: break;
      }
      writefln("[MOV] KeyBOARD %s",k_evt.getSDLkey());
    }
    if(e.getEventType() == EventType.MOUSE){
      MouseEvent m_evt = cast(MouseEvent) e;
      switch(m_evt.getBtn()){
        case MouseBtn.RIGHT:
          dragging=!dragging;
          e.handled=true;
        break;
        default: 
        if(dragging){
          screen.getCamera().rotate(2*m_evt.syr,2*m_evt.sxr,0);
          update();
          e.handled=true;
        }
        break;
      }
    }
  }
  
  void update(){
    double loc[3] = object.getLocation();
    Camera c = screen.getCamera();
    int h_rot = cast(int)c.getRotation()[0];
    int v_rot = cast(int)c.getRotation()[1]+90;
    float cameramod = distancetotarget*cos((h_rot*PI)/180);
    loc[0] += cameramod*(cos((v_rot*PI)/180));
    loc[1] += distancetotarget*sin((h_rot*PI)/180);
    loc[2] += cameramod*(sin((v_rot*PI)/180));
    c.setLocation(-loc[0],-loc[1],-loc[2]);
  }
  
  private:
    double     distancetotarget = 20;
    Object3D   object;
    bool       dragging=false;
}