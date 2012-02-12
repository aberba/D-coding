module gui.objects.sphere;

import std.array;
import std.stdio;
import std.conv;
import std.math;

import gl.gl_1_0;
import gl.gl_1_1;

import gui.objects.camera;
import gui.objects.object3d;

class Sphere : Object3D{
public:
  this(double x, double y, double z){
    super(x,y,z);
  }
  
  void buffer(){ }
  
  void render(int faceType = GL_TRIANGLE_STRIP){
    glToLocation();
    glColor4f(r(), g(),  b(), alpha());
    if(textureid != -1){
      glEnable(GL_TEXTURE_2D);
      glBindTexture(GL_TEXTURE_2D, textureid);
    }
    for(uint i = 0; i <= subdivisions; i++ ){
      glBegin(faceType);
      double si = i/2.0;
      double dip = 2*(i+1);
      theta[0] = ((si * twopi) / subdivisions) - PI_2;
      theta[1] = (((si + 1) * twopi) / subdivisions) - PI_2;
      for(uint j = 0; j <= subdivisions; j++ ){
        theta[2] = (subdivisions-j) * twopi / subdivisions;
        e[0] = cos(theta[1]) * cos(theta[2]);
        e[1] = sin(theta[1]);
        e[2] = cos(theta[1]) * sin(theta[2]);
        
        glNormal3f(e[0], e[1], e[2]);
        glTexCoord2f(cast(float)((j)/subdivisions) , cast(float)(dip/subdivisions) );
        glVertex3f(e[0]*sx(), e[1]*sy(), e[2]*sz());
        
        e[0] = cos(theta[0]) * cos(theta[2]);
        e[1] = sin(theta[0]);
        e[2] = cos(theta[0]) * sin(theta[2]);
        
        glNormal3f(e[0], e[1], e[2]);
        glTexCoord2f(cast(float)((j)/subdivisions) , cast(float)(dip/subdivisions) );
        glVertex3f(e[0]*sx(), e[1]*sy(), e[2]*sz());
      }
      glEnd();
    }
    if(textureid != -1) glDisable(GL_TEXTURE_2D);
    glPopMatrix();
  }
  
  int getFaceType(){ return GL_TRIANGLE_STRIP; }

private:
  uint subdivisions = 70;
  double theta[3];
  double e[3];
  double twopi      = 2.0*PI;
}
