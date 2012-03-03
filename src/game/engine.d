/******************************************************************//**
 * \file src/game/engine.d
 * \brief GameEngine and Game description
 *
 * <i>Copyright (c) 2012</i> Danny Arends<br>
 * Last modified Feb, 2012<br>
 * First written Dec, 2011<br>
 * Written in the D Programming Language (http://www.digitalmars.com/d)
 **********************************************************************/
module game.engine;

import std.stdio;

import core.typedefs.types;

import io.events.engine;
import io.events.clockevents;
import gui.engine;
import gui.screen;
import gui.motion;
import gui.hudhandler;
import sfx.engine;

import game.tilemap;
import game.player;

import game.games.triggerpull;
import game.users.gameclient;

enum Stage{STARTUP, MENU, PLAYING};

abstract class Game : EventHandler{
  abstract void setup2D(Screen screen);
  abstract void setup3D(Screen screen);
  abstract void setupSound(SFXEngine sound);
  abstract void load(GameEngine engine);
  abstract void save();
  abstract void quit(GameEngine engine);
  abstract void render(GFXEngine engine);
  
  @property CameraMotion cameraMotion(CameraMotion m = null){ 
    if(m !is null){ motion=m; }
    return motion; 
  }
  
  @property HudHandler hudHandler(HudHandler h = null){ 
    if(h !is null){ hud=h; }
    return hud; 
  }

private:
  CameraMotion motion;
  HudHandler   hud;
}

class GameEngine : ClockEventHandler{
  public:
    void startRendering(GFXEngine engine){
      this.engine = engine;
      this.stage = Stage.STARTUP;
      engine.screen.showLoading();
    }
    
    void rotateLogo(int after, int ntime){
      if(stage == Stage.STARTUP){
        engine.screen.rotateLogo(3);
      }
    }

    void changeLogo(int after, int ntime){
      if(stage == Stage.STARTUP){
        if(ntime==2)engine.screen.changeLogo("openGL");
        if(ntime==1)engine.screen.changeLogo("openAL");
      }
    }
    
    void setMainMenuStage(int after, int ntime){
      writeln("[ G ] Changing stage to menu");
      cleanUpGame();
      stage = Stage.MENU;
      engine.screen.clear();
      engine.screen.showMainMenu();
      //add(new ClockEvent(&this.setGameStage,1000));
    }
    
    void cleanUpGame(){
      if(game !is null){
        game.save();
        game.quit(this);
        updateFrequency = 0.0;
      }
    }

    void setGameStage(Game g){
      writeln("[ G ] Changing stage to playing");
      cleanUpGame();
      game = g;
      stage = Stage.PLAYING;
      engine.screen.clear();
      game.setupSound(engine.sound);
      game.setup2D(engine.screen);
      game.setup3D(engine.screen);
      game.load(this);
      setT0();
    }
    
    void render(){
      if(stage==Stage.PLAYING){
        game.render(engine);
      }
    }
    
  void handle(Event e){
    if(e is null) return;
    if(e.getEventType() == EventType.QUIT){
      game.save();
      game.quit(this);
      setMainMenuStage(0,0);
      return;
    }
    if(stage==Stage.PLAYING){
      if(!e.handled && game.hudHandler()) game.hudHandler().handle(e); 
      if(!e.handled && game.cameraMotion()) game.cameraMotion().handle(e);
      if(!e.handled)game.handle(e);
    }
    e.handled=true;
  }
  
  @property Stage gamestage(){ return stage; }
  
  void update(){
    super.update();
    if(stage==Stage.PLAYING){
      if(game.cameraMotion()) game.cameraMotion().update();
      if(updateFrequency > 0.0){
        if((getTN()-getT0()).total!"msecs" > cast(long)(1000*updateFrequency)){
          setT0();
          return game.update();
        }
      }else{  //Update game every cycle
        return game.update();
      }
    }
  }
  
  void requestUpdate(double seconds){
    updateFrequency = seconds;
  }
  
  @property GameClient network(){ return engine.network; }
  
  private:
    GFXEngine   engine;
    Stage       stage;
    Game        game;
    double      updateFrequency = 0.0;
}
