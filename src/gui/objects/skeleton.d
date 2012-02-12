module gui.objects.skeleton;

import std.array;
import std.stdio;
import std.math;
import std.conv;

import gl.gl_1_0;
import gl.gl_1_1;

import core.typedefs.types;

import gui.objects.camera;
import gui.objects.object3d;
import gui.formats.an8;
import gui.formats.an8types;

class Skeleton : Object3D{
  public:
    this(double x, double y, double z, string name = "data/objects/humanoid.an8"){ 
      super(x,y,z); 
      objects = loadAn8(name);
    }
    
    void buffer(){ }
    
    void render(int faceType = GL_LINES){
      glToLocation();
      glColor4f(r(), g(),  b(), alpha());
      renderBone(objects.figures[0].root,0,faceType);
      glPopMatrix();
    }
    
    void renderBone(Bone bone, int lvl, int faceType = GL_LINES){
      float angle;
      float s;
      if(bone.rotates){
        angle = (360.0/PI)*(acos(bone.ori[3]));
        s = sqrt(1-bone.ori[3]*bone.ori[3]);
        glRotatef(angle,getR(s, bone.ori[0]), getR(s, bone.ori[1]), getR(s, bone.ori[2]));
      }
      glColor4f(r(), g()-(lvl/3),  b()-(lvl/3), alpha());
      glBegin(faceType);
      glVertex3f( 0.0f,  0.0f,  0.0f );
      glVertex3f( 0.0f,  bone.length/shrink,  0.0f );
      glEnd();
      glTranslatef(0.0f,  bone.length/shrink,  0.0f);
      foreach(Bone b; bone.bones){
        renderBone(b,lvl+1,faceType);
      }
      glTranslatef(0.0f,  -(bone.length/shrink),  0.0f);
      if(bone.rotates){
        glRotatef(-angle,getR(s, bone.ori[0]), getR(s, bone.ori[1]), getR(s, bone.ori[2]));
      }
    }
    
    float getR(float scale, float r){ 
      if(scale < 0.0001) return r;
      return r/scale; 
    }

    int getFaceType(){ return GL_LINES; }
  
  private:
    An8 objects;
    float shrink = 10.0;
}
