module gui.eventhandler;

import core.thread;
import std.array;
import std.stdio;
import std.conv;

import sdl.sdlstructs;
import sdl.sdlfunctions;

import gui.engine;

class EventHandler : Thread{
public:
  this(Engine engine){
    parent=engine;
    super(&run);
  }
  
  void run(){
    while(!parent.isDone()){
      while(SDL_PollEvent(&event)){
        switch(event.type){
        case SDL_ACTIVEEVENT:
          if(event.active.gain == 0){
            parent.isActive(false);
          }else{
            parent.isActive(true);
          }
          break;          
        case SDL_VIDEORESIZE:
          parent.setSurface(event.resize.w,event.resize.h,SDL_SetVideoMode(event.resize.w, event.resize.h, parent.screen_bpp, parent.getVideoFlags()));
          if(parent.getSurface() is null){
            writefln("Video surface resize failed: %s", SDL_GetError());
            return;
          }
          resizeWindow(event.resize.w, event.resize.h);
          break;
        case SDL_KEYDOWN:
          handleKeyPress(&event.key.keysym);
          break;
        case SDL_QUIT:
          parent.isDone(true);
          break;
        default:
          break;
        }
      }
      SDL_Delay(10);
    }
  }
  
  void handleKeyPress(SDL_keysym *keysym){
    switch(keysym.sym){
    case SDLK_ESCAPE:
      break;
      case SDLK_F1:
      SDL_WM_ToggleFullScreen(parent.getSurface());
      break;
      default:
      break;
    }
  }
private:
  SDL_Event event;                      /* Used to collect events */
  Engine    parent;
}