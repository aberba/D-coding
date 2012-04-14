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

import core.stdinc;

import core.typedefs.types;
import core.events.engine;
import core.events.clockevents;

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

abstract class GameObject{
  public:
    this(string data){
      fromString(data);
    }

    this(string dir, string name){
      _filename = name;
      _filepath = dir ~ name;
      if(exists(filepath) && isFile(filepath)){
        writefln("[OBJ] Loading GameObject-file: %s",filepath);
        fromString(readText(filepath));
        writefln("[OBJ] Done loading GameObject-file: %s",filepath);    
      }
    }
    
    void load(){
      if(exists(filepath) && isFile(filepath)){
        writefln("[OBJ] Loading GameObject-file: %s",filepath);
        fromString(readText(filepath));
        writefln("[OBJ] Done loading GameObject-file: %s",filepath);    
      }
    }

    void save(){
      writefln("[OBJ] Saving GameObject-file: %s",filepath);
      auto fp = new File(filepath,"wb");
      fp.write(asString());
      fp.close();
      writefln("[OBJ] Done saving GameObject-file: %s",filepath);  
    }
    
    @property{
      string     filepath(){ return _filepath; }
      string     filename(){ return _filename; }
    }

    abstract void fromString(string data);
    abstract string asString();

  private:
    string _filepath;
    string _filename;
}

/*! \brief Abstract game class
 *
 *  Defines a game that is runnable inside out GFXEngine 
 */
abstract class Game : EventHandler{
  abstract void setup2D(Screen screen);
  abstract void setup3D(Screen screen);
  abstract void setupSound(SFXEngine sound);
  abstract void load();
  abstract void save();
  abstract void quit();
  abstract void render(GFXEngine engine);
  
  @property CameraMotion cameraMotion(CameraMotion m = null){ 
    if(m !is null){ motion=m; }
    return motion; 
  }
  
  @property HudHandler hudHandler(HudHandler h = null){ 
    if(h !is null){ hud=h; }
    return hud; 
  }
  
  @property GameEngine engine(GameEngine e = null){ 
    if(e !is null){ gameengine=e; }
    return gameengine; 
  }

private:
  GameEngine   gameengine;
  CameraMotion motion;
  HudHandler   hud;
}

/*! \brief GameEngine handles the current Game
 *
 *  GameEngine handles the current Game, and 
 *  provides resources and events to the current Game
 */
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
        game.quit();
        updateFrequency = 0.0;
      }
    }

    void setGameStage(Game g){
      writeln("[ G ] Changing stage to playing");
      cleanUpGame();
      game = g;
      stage = Stage.PLAYING;
      engine.screen.clear();
      game.engine(this);
      game.setupSound(engine.sound);
      game.setup2D(engine.screen);
      game.setup3D(engine.screen);
      game.load();
      setT0();
    }
    
    void render(){
      if(stage==Stage.PLAYING){
        game.render(engine);
      }
    }
    
    override void handle(Event e){
      if(e is null) return;
      if(e.getEventType() == EventType.QUIT){
        game.save();
        game.quit();
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
  
    override void update(){
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
    
    @property{
      Stage      gamestage(){ return stage; }
      GameClient network(){ return engine.network; }
      Screen     screen(){ return engine.screen; }
      GFXEngine  gfxengine(){ return engine; }
    }
  
  private:
    GFXEngine   engine;
    Stage       stage;
    Game        game;
    double      updateFrequency = 0.0;
}
