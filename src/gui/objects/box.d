module gui.objects.box;

import std.array;
import std.stdio;
import std.conv;

import gl.gl_1_0;

import gui.objects.camera;
import gui.objects.object3d;

class Box : Object3D{
  
  this(double x, double y, double z){
    super(x,y,z);
  }
  
  void render(Camera camera){
    glLoadIdentity();
    glTranslatef(camera.x+x(),camera.y-y(),camera.z-z());

    glRotatef(camera.rx+rx(), 1.0, 0.0, 0.0);
    glRotatef(camera.ry+ry(), 0.0, 1.0, 0.0);
    glRotatef(camera.rz+rz(), 0.0, 0.0, 1.0);
    glColor4f(r(), g(),  b(), alpha());
    glBegin(GL_QUADS);
      glVertex3f(sx() ,sy(),-sz());        // Top Right Of The Quad (Top)
      glVertex3f(-sx(),sy(),-sz());        // Top Left Of The Quad (Top)
      glVertex3f(-sx(),sy(),sz());         // Bottom Left Of The Quad (Top)
      glVertex3f(sx() ,sy(),sz());         // Bottom Right Of The Quad (Top)

      glVertex3f(sx() ,-sy(),sz());        // Top Right Of The Quad (Bottom)
      glVertex3f(-sx(),-sy(),sz());        // Top Left Of The Quad (Bottom)
      glVertex3f(-sx(),-sy(),-sz());       // Bottom Left Of The Quad (Bottom)
      glVertex3f(sx() ,-sy(),-sz());       // Bottom Right Of The Quad (Bottom)

      glVertex3f(sx() ,sy() ,sz());        // Top Right Of The Quad (Front)
      glVertex3f(-sx(),sy() ,sz());        // Top Left Of The Quad (Front)
      glVertex3f(-sx(),-sy(),sz());        // Bottom Left Of The Quad (Front)
      glVertex3f(sx() ,-sy(),sz());        // Bottom Right Of The Quad (Front)

      glVertex3f(sx() ,-sy(),-sz());       // Top Right Of The Quad (Back)
      glVertex3f(-sx(),-sy(),-sz());       // Top Left Of The Quad (Back)
      glVertex3f(-sx(),sy() ,-sz());       // Bottom Left Of The Quad (Back)
      glVertex3f(sx() ,sy() ,-sz());       // Bottom Right Of The Quad (Back)

      glVertex3f(-sx(),sy() ,sz());        // Top Right Of The Quad (Left)
      glVertex3f(-sx(),sy() ,-sz());       // Top Left Of The Quad (Left)
      glVertex3f(-sx(),-sy(),-sz());       // Bottom Left Of The Quad (Left)
      glVertex3f(-sx(),-sy(),sz());        // Bottom Right Of The Quad (Left)

      glVertex3f(sx() ,sy() ,-sz());       // Top Right Of The Quad (Right)
      glVertex3f(sx() ,sy() ,sz());        // Top Left Of The Quad (Right)
      glVertex3f(sx() ,-sy(),sz());        // Bottom Left Of The Quad (Right)
      glVertex3f(sx() ,-sy(),-sz());       // Bottom Right Of The Quad (Right)
    glEnd();
  }
};