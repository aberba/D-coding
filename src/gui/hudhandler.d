module gui.hudhandler;

import std.array;
import std.stdio;
import std.conv;

import sdl.sdlstructs;
import core.typedefs.types;

import core.events.engine;
import core.events.keyevent;
import core.events.mouseevent;
import core.events.networkevent;

import game.engine;
import gui.engine;
import gui.enginefunctions;
import gui.widgets.object2d;
import gui.widgets.textinput;
import gui.widgets.button;

class HudHandler : EventHandler{
  public:    
    this(GFXEngine engine){
      this.engine = engine;
    }
    
    void handle(Event e){
      if(e is null) return;
      if(e.getEventType() == EventType.MOUSE){
        MouseEvent evt = cast(MouseEvent) e;
        if(evt.getBtn() == MouseBtn.LEFT){
          Object2D hit = engine.screen.getObjectAt(evt.sx, evt.sy);
          if(hit !is null && !hit.isScreen()){
            switch(hit.getType){
              case Object2DType.BUTTON:
                (cast(Button)(hit)).onClick(evt.sx, evt.sy);
                e.handled = true;
              break;
              case Object2DType.TEXTINPUT:
                keyhandler = cast(TextInput)(hit);
                e.handled = true;
              break;
              default:
              break;
            }
          }else{
            double[3] loc = evt.getXYZ();
            engine.handle(new NetworkEvent(NetEvent.MOVEMENT ~ arrayToString(loc,":") ~ "\0", false));
            //writeln("S:" ~ to!string(evt.sx) ~ ";" ~ to!string(evt.sy));
          }
        }
      }
      if(e.getEventType() == EventType.KEYBOARD){
        KeyEvent key = cast(KeyEvent) e;
        if(key.getSDLkey() == SDLK_RSHIFT || key.getSDLkey() == SDLK_LSHIFT){
          shiftStatus = false;
          if(key.getKeyEventType() == KeyEventType.DOWN){
            shiftStatus = true;
          }
        }else{
          if(key.getKeyEventType() == KeyEventType.DOWN){
            key.setShift(shiftStatus);
            if(keyhandler !is null){
              engine.handle(keyhandler.handleKeyPress(key));
            }
          }
        }
      }
    }
    
  private:
    GFXEngine   engine;
    TextInput   keyhandler;
    bool        shiftStatus;
}
