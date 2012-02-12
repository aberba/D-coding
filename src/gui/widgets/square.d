module gui.widgets.square;

import std.array;
import std.stdio;
import std.conv;

import gl.gl_1_0;
import gl.gl_1_1;

import gui.widgets.object2d;

class Square : Object2D{
public:
  this(double x, double y, double sx, double sy, Object2D parent){
    super(x,y,sx,sy,parent);
  }
  
  void render(){
    glLoadIdentity();
    glTranslatef(x, y, 0.0f);
    glColor4f(r, g,  b, alpha);
    if(getTexture() != -1){
      glEnable(GL_TEXTURE_2D);
      glBindTexture(GL_TEXTURE_2D, getTexture());
    }
    glBegin(GL_QUADS);
      
      glTexCoord2f(1.0, 1.0);
      glVertex3f(sx, sy, 0.0f );
      
      glTexCoord2f(0.0, 1.0);
      glVertex3f(0,  sy, 0.0f );
      
      glTexCoord2f(0.0, 0.0);
      glVertex3f(0,  0,  0.0f );
      
      glTexCoord2f(1.0, 0.0);
      glVertex3f(sx, 0,  0.0f );
    glEnd();
    if(getTexture() != -1) glDisable(GL_TEXTURE_2D);
  }
  
  Object2DType getType(){ return Object2DType.SQUARE; }
}
