/******************************************************************//**
 * \file deps/gl/gl.d
 * \brief Wrapper for openGL
 *
 * <i>Copyright (c) 2012</i> Danny Arends<br>
 * Last modified Apr, 2012<br>
 * First written 2010<br>
 * Written in the D Programming Language (http://www.digitalmars.com/d)
 **********************************************************************/
module ext.opengl.gl;

import std.stdio, std.conv, std.c.stdarg;
import ext.load.loader, ext.load.libload;
public import ext.opengl.gl_1_0, ext.opengl.gl_1_1, ext.opengl.gl_1_2;
import ext.opengl.gl_1_3, ext.opengl.gl_1_4, ext.opengl.gl_1_5;

/* Loads a single gl extension (Needs a live reference to the library) */
template load_extension(T){
    ext_binding!(T) load_extension(ref T a) {
    ext_binding!(T) res;
    res.eptr = cast(void**)&a;
    return res;
  }
}

version(Windows){
  void* function(char*) wglGetProcAddress;
}else{
  void* function(char*) glXGetProcAddress;
}

/* Binding of a single openGL extension */
package struct ext_binding(T) {
  bool opCall(string name,bool verbose = false, string msg = "Bound extension"){
    void* func;
    version(Windows){
      func = wglGetProcAddress(&name.dup[0]);
    }else{
      func = glXGetProcAddress(&name.dup[0]);
    }
    if(!func){
      writeln("Cannot bind extension: " ~ name);
      return false;
    }else{
      if(verbose) writeln(msg ~ ": " ~ name);
      *eptr = func;
      return true;
    }
  }
  
  private:
    void** eptr;
}

//Load the functions when the module is loaded
static this(){
  HXModule lib = load_library("opengl32","GL","");
  version(Windows){
    load_function(wglGetProcAddress)(lib, "wglGetProcAddress");
  }else{
    load_function(glXGetProcAddress)(lib,"glXGetProcAddress");
  }
  load_function(glClearIndex)(lib, "glClearIndex");
  load_function(glClearColor)(lib, "glClearColor");
  load_function(glClear)(lib, "glClear");
  load_function(glIndexMask)(lib, "glIndexMask");
  load_function(glColorMask)(lib, "glColorMask");
  load_function(glAlphaFunc)(lib, "glAlphaFunc");
  load_function(glBlendFunc)(lib, "glBlendFunc");
  load_function(glLogicOp)(lib, "glLogicOp");
  load_function(glCullFace)(lib, "glCullFace");
  load_function(glFrontFace)(lib, "glFrontFace");
  load_function(glPointSize)(lib, "glPointSize");
  load_function(glLineWidth)(lib, "glLineWidth");
  load_function(glLineStipple)(lib, "glLineStipple");
  load_function(glPolygonMode)(lib, "glPolygonMode");
  load_function(glPolygonOffset)(lib, "glPolygonOffset");
  load_function(glPolygonStipple)(lib, "glPolygonStipple");
  load_function(glGetPolygonStipple)(lib, "glGetPolygonStipple");
  load_function(glEdgeFlag)(lib, "glEdgeFlag");
  load_function(glEdgeFlagv)(lib, "glEdgeFlagv");
  load_function(glScissor)(lib, "glScissor");
  load_function(glClipPlane)(lib, "glClipPlane");
  load_function(glGetClipPlane)(lib, "glGetClipPlane");
  load_function(glDrawBuffer)(lib, "glDrawBuffer");
  load_function(glReadBuffer)(lib, "glReadBuffer");
  load_function(glEnable)(lib, "glEnable");
  load_function(glDisable)(lib, "glDisable");
  load_function(glIsEnabled)(lib, "glIsEnabled");
  load_function(glEnableClientState)(lib, "glEnableClientState");
  load_function(glDisableClientState)(lib, "glDisableClientState");
  load_function(glGetBooleanv)(lib, "glGetBooleanv");
  load_function(glGetDoublev)(lib, "glGetDoublev");
  load_function(glGetFloatv)(lib, "glGetFloatv");
  load_function(glGetIntegerv)(lib, "glGetIntegerv");
  load_function(glPushAttrib)(lib, "glPushAttrib");
  load_function(glPopAttrib)(lib, "glPopAttrib");
  load_function(glPushClientAttrib)(lib, "glPushClientAttrib");
  load_function(glPopClientAttrib)(lib, "glPopClientAttrib");
  load_function(glRenderMode)(lib, "glRenderMode");
  load_function(glGetError)(lib, "glGetError");
  load_function(glGetString)(lib, "glGetString");
  load_function(glFinish)(lib, "glFinish");
  load_function(glFlush)(lib, "glFlush");
  load_function(glHint)(lib, "glHint");
  load_function(glClearDepth)(lib, "glClearDepth");
  load_function(glDepthFunc)(lib, "glDepthFunc");
  load_function(glDepthMask)(lib, "glDepthMask");
  load_function(glDepthRange)(lib, "glDepthRange");
  load_function(glClearAccum)(lib, "glClearAccum");
  load_function(glAccum)(lib, "glAccum");
  load_function(glMatrixMode)(lib, "glMatrixMode");
  load_function(glOrtho)(lib, "glOrtho");
  load_function(glFrustum)(lib, "glFrustum");
  load_function(glViewport)(lib, "glViewport");
  load_function(glPushMatrix)(lib, "glPushMatrix");
  load_function(glPopMatrix)(lib, "glPopMatrix");
  load_function(glLoadIdentity)(lib, "glLoadIdentity");
  load_function(glLoadMatrixd)(lib, "glLoadMatrixd");
  load_function(glLoadMatrixf)(lib, "glLoadMatrixf");
  load_function(glMultMatrixd)(lib, "glMultMatrixd");
  load_function(glMultMatrixf)(lib, "glMultMatrixf");
  load_function(glRotated)(lib, "glRotated");
  load_function(glRotatef)(lib, "glRotatef");
  load_function(glScaled)(lib, "glScaled");
  load_function(glScalef)(lib, "glScalef");
  load_function(glTranslated)(lib, "glTranslated");
  load_function(glTranslatef)(lib, "glTranslatef");
  load_function(glIsList)(lib, "glIsList");
  load_function(glDeleteLists)(lib, "glDeleteLists");
  load_function(glGenLists)(lib, "glGenLists");
  load_function(glNewList)(lib, "glNewList");
  load_function(glEndList)(lib, "glEndList");
  load_function(glCallList)(lib, "glCallList");
  load_function(glCallLists)(lib, "glCallLists");
  load_function(glListBase)(lib, "glListBase");
  load_function(glBegin)(lib, "glBegin");
  load_function(glEnd)(lib, "glEnd");
  load_function(glVertex2d)(lib, "glVertex2d");
  load_function(glVertex2f)(lib, "glVertex2f");
  load_function(glVertex2i)(lib, "glVertex2i");
  load_function(glVertex2s)(lib, "glVertex2s");
  load_function(glVertex3d)(lib, "glVertex3d");
  load_function(glVertex3f)(lib, "glVertex3f");
  load_function(glVertex3i)(lib, "glVertex3i");
  load_function(glVertex3s)(lib, "glVertex3s");
  load_function(glVertex4d)(lib, "glVertex4d");
  load_function(glVertex4f)(lib, "glVertex4f");
  load_function(glVertex4i)(lib, "glVertex4i");
  load_function(glVertex4s)(lib, "glVertex4s");
  load_function(glVertex2dv)(lib, "glVertex2dv");
  load_function(glVertex2fv)(lib, "glVertex2fv");
  load_function(glVertex2iv)(lib, "glVertex2iv");
  load_function(glVertex2sv)(lib, "glVertex2sv");
  load_function(glVertex3dv)(lib, "glVertex3dv");
  load_function(glVertex3fv)(lib, "glVertex3fv");
  load_function(glVertex3iv)(lib, "glVertex3iv");
  load_function(glVertex3sv)(lib, "glVertex3sv");
  load_function(glVertex4dv)(lib, "glVertex4dv");
  load_function(glVertex4fv)(lib, "glVertex4fv");
  load_function(glVertex4iv)(lib, "glVertex4iv");
  load_function(glVertex4sv)(lib, "glVertex4sv");
  load_function(glNormal3b)(lib, "glNormal3b");
  load_function(glNormal3d)(lib, "glNormal3d");
  load_function(glNormal3f)(lib, "glNormal3f");
  load_function(glNormal3i)(lib, "glNormal3i");
  load_function(glNormal3s)(lib, "glNormal3s");
  load_function(glNormal3bv)(lib, "glNormal3bv");
  load_function(glNormal3dv)(lib, "glNormal3dv");
  load_function(glNormal3fv)(lib, "glNormal3fv");
  load_function(glNormal3iv)(lib, "glNormal3iv");
  load_function(glNormal3sv)(lib, "glNormal3sv");
  load_function(glIndexd)(lib, "glIndexd");
  load_function(glIndexf)(lib, "glIndexf");
  load_function(glIndexi)(lib, "glIndexi");
  load_function(glIndexs)(lib, "glIndexs");
  load_function(glIndexub)(lib, "glIndexub");
  load_function(glIndexdv)(lib, "glIndexdv");
  load_function(glIndexfv)(lib, "glIndexfv");
  load_function(glIndexiv)(lib, "glIndexiv");
  load_function(glIndexsv)(lib, "glIndexsv");
  load_function(glIndexubv)(lib, "glIndexubv");
  load_function(glColor3b)(lib, "glColor3b");
  load_function(glColor3d)(lib, "glColor3d");
  load_function(glColor3f)(lib, "glColor3f");
  load_function(glColor3i)(lib, "glColor3i");
  load_function(glColor3s)(lib, "glColor3s");
  load_function(glColor3ub)(lib, "glColor3ub");
  load_function(glColor3ui)(lib, "glColor3ui");
  load_function(glColor3us)(lib, "glColor3us");
  load_function(glColor4b)(lib, "glColor4b");
  load_function(glColor4d)(lib, "glColor4d");
  load_function(glColor4f)(lib, "glColor4f");
  load_function(glColor4i)(lib, "glColor4i");
  load_function(glColor4s)(lib, "glColor4s");
  load_function(glColor4ub)(lib, "glColor4ub");
  load_function(glColor4ui)(lib, "glColor4ui");
  load_function(glColor4us)(lib, "glColor4us");
  load_function(glColor3bv)(lib, "glColor3bv");
  load_function(glColor3dv)(lib, "glColor3dv");
  load_function(glColor3fv)(lib, "glColor3fv");
  load_function(glColor3iv)(lib, "glColor3iv");
  load_function(glColor3sv)(lib, "glColor3sv");
  load_function(glColor3ubv)(lib, "glColor3ubv");
  load_function(glColor3uiv)(lib, "glColor3uiv");
  load_function(glColor3usv)(lib, "glColor3usv");
  load_function(glColor4bv)(lib, "glColor4bv");
  load_function(glColor4dv)(lib, "glColor4dv");
  load_function(glColor4fv)(lib, "glColor4fv");
  load_function(glColor4iv)(lib, "glColor4iv");
  load_function(glColor4sv)(lib, "glColor4sv");
  load_function(glColor4ubv)(lib, "glColor4ubv");
  load_function(glColor4uiv)(lib, "glColor4uiv");
  load_function(glColor4usv)(lib, "glColor4usv");
  load_function(glTexCoord1d)(lib, "glTexCoord1d");
  load_function(glTexCoord1f)(lib, "glTexCoord1f");
  load_function(glTexCoord1i)(lib, "glTexCoord1i");
  load_function(glTexCoord1s)(lib, "glTexCoord1s");
  load_function(glTexCoord2d)(lib, "glTexCoord2d");
  load_function(glTexCoord2f)(lib, "glTexCoord2f");
  load_function(glTexCoord2i)(lib, "glTexCoord2i");
  load_function(glTexCoord2s)(lib, "glTexCoord2s");
  load_function(glTexCoord3d)(lib, "glTexCoord3d");
  load_function(glTexCoord3f)(lib, "glTexCoord3f");
  load_function(glTexCoord3i)(lib, "glTexCoord3i");
  load_function(glTexCoord3s)(lib, "glTexCoord3s");
  load_function(glTexCoord4d)(lib, "glTexCoord4d");
  load_function(glTexCoord4f)(lib, "glTexCoord4f");
  load_function(glTexCoord4i)(lib, "glTexCoord4i");
  load_function(glTexCoord4s)(lib, "glTexCoord4s");
  load_function(glTexCoord1dv)(lib, "glTexCoord1dv");
  load_function(glTexCoord1fv)(lib, "glTexCoord1fv");
  load_function(glTexCoord1iv)(lib, "glTexCoord1iv");
  load_function(glTexCoord1sv)(lib, "glTexCoord1sv");
  load_function(glTexCoord2dv)(lib, "glTexCoord2dv");
  load_function(glTexCoord2fv)(lib, "glTexCoord2fv");
  load_function(glTexCoord2iv)(lib, "glTexCoord2iv");
  load_function(glTexCoord2sv)(lib, "glTexCoord2sv");
  load_function(glTexCoord3dv)(lib, "glTexCoord3dv");
  load_function(glTexCoord3fv)(lib, "glTexCoord3fv");
  load_function(glTexCoord3iv)(lib, "glTexCoord3iv");
  load_function(glTexCoord3sv)(lib, "glTexCoord3sv");
  load_function(glTexCoord4dv)(lib, "glTexCoord4dv");
  load_function(glTexCoord4fv)(lib, "glTexCoord4fv");
  load_function(glTexCoord4iv)(lib, "glTexCoord4iv");
  load_function(glTexCoord4sv)(lib, "glTexCoord4sv");
  load_function(glRasterPos2d)(lib, "glRasterPos2d");
  load_function(glRasterPos2f)(lib, "glRasterPos2f");
  load_function(glRasterPos2i)(lib, "glRasterPos2i");
  load_function(glRasterPos2s)(lib, "glRasterPos2s");
  load_function(glRasterPos3d)(lib, "glRasterPos3d");
  load_function(glRasterPos3f)(lib, "glRasterPos3f");
  load_function(glRasterPos3i)(lib, "glRasterPos3i");
  load_function(glRasterPos3s)(lib, "glRasterPos3s");
  load_function(glRasterPos4d)(lib, "glRasterPos4d");
  load_function(glRasterPos4f)(lib, "glRasterPos4f");
  load_function(glRasterPos4i)(lib, "glRasterPos4i");
  load_function(glRasterPos4s)(lib, "glRasterPos4s");
  load_function(glRasterPos2dv)(lib, "glRasterPos2dv");
  load_function(glRasterPos2fv)(lib, "glRasterPos2fv");
  load_function(glRasterPos2iv)(lib, "glRasterPos2iv");
  load_function(glRasterPos2sv)(lib, "glRasterPos2sv");
  load_function(glRasterPos3dv)(lib, "glRasterPos3dv");
  load_function(glRasterPos3fv)(lib, "glRasterPos3fv");
  load_function(glRasterPos3iv)(lib, "glRasterPos3iv");
  load_function(glRasterPos3sv)(lib, "glRasterPos3sv");
  load_function(glRasterPos4dv)(lib, "glRasterPos4dv");
  load_function(glRasterPos4fv)(lib, "glRasterPos4fv");
  load_function(glRasterPos4iv)(lib, "glRasterPos4iv");
  load_function(glRasterPos4sv)(lib, "glRasterPos4sv");
  load_function(glRectd)(lib, "glRectd");
  load_function(glRectf)(lib, "glRectf");
  load_function(glRecti)(lib, "glRecti");
  load_function(glRects)(lib, "glRects");
  load_function(glRectdv)(lib, "glRectdv");
  load_function(glRectfv)(lib, "glRectfv");
  load_function(glRectiv)(lib, "glRectiv");
  load_function(glRectsv)(lib, "glRectsv");
  load_function(glShadeModel)(lib, "glShadeModel");
  load_function(glLightf)(lib, "glLightf");
  load_function(glLighti)(lib, "glLighti");
  load_function(glLightfv)(lib, "glLightfv");
  load_function(glLightiv)(lib, "glLightiv");
  load_function(glGetLightfv)(lib, "glGetLightfv");
  load_function(glGetLightiv)(lib, "glGetLightiv");
  load_function(glLightModelf)(lib, "glLightModelf");
  load_function(glLightModeli)(lib, "glLightModeli");
  load_function(glLightModelfv)(lib, "glLightModelfv");
  load_function(glLightModeliv)(lib, "glLightModeliv");
  load_function(glMaterialf)(lib, "glMaterialf");
  load_function(glMateriali)(lib, "glMateriali");
  load_function(glMaterialfv)(lib, "glMaterialfv");
  load_function(glMaterialiv)(lib, "glMaterialiv");
  load_function(glGetMaterialfv)(lib, "glGetMaterialfv");
  load_function(glGetMaterialiv)(lib, "glGetMaterialiv");
  load_function(glColorMaterial)(lib, "glColorMaterial");
  load_function(glPixelZoom)(lib, "glPixelZoom");
  load_function(glPixelStoref)(lib, "glPixelStoref");
  load_function(glPixelStorei)(lib, "glPixelStorei");
  load_function(glPixelTransferf)(lib, "glPixelTransferf");
  load_function(glPixelTransferi)(lib, "glPixelTransferi");
  load_function(glPixelMapfv)(lib, "glPixelMapfv");
  load_function(glPixelMapuiv)(lib, "glPixelMapuiv");
  load_function(glPixelMapusv)(lib, "glPixelMapusv");
  load_function(glGetPixelMapfv)(lib, "glGetPixelMapfv");
  load_function(glGetPixelMapuiv)(lib, "glGetPixelMapuiv");
  load_function(glGetPixelMapusv)(lib, "glGetPixelMapusv");
  load_function(glBitmap)(lib, "glBitmap");
  load_function(glReadPixels)(lib, "glReadPixels");
  load_function(glDrawPixels)(lib, "glDrawPixels");
  load_function(glCopyPixels)(lib, "glCopyPixels");
  load_function(glStencilFunc)(lib, "glStencilFunc");
  load_function(glStencilMask)(lib, "glStencilMask");
  load_function(glStencilOp)(lib, "glStencilOp");
  load_function(glClearStencil)(lib, "glClearStencil");
  load_function(glTexGend)(lib, "glTexGend");
  load_function(glTexGenf)(lib, "glTexGenf");
  load_function(glTexGeni)(lib, "glTexGeni");
  load_function(glTexGendv)(lib, "glTexGendv");
  load_function(glTexGenfv)(lib, "glTexGenfv");
  load_function(glTexGeniv)(lib, "glTexGeniv");
  load_function(glTexEnvf)(lib, "glTexEnvf");
  load_function(glTexEnvi)(lib, "glTexEnvi");
  load_function(glTexEnvfv)(lib, "glTexEnvfv");
  load_function(glTexEnviv)(lib, "glTexEnviv");
  load_function(glGetTexEnvfv)(lib, "glGetTexEnvfv");
  load_function(glGetTexEnviv)(lib, "glGetTexEnviv");
  load_function(glTexParameterf)(lib, "glTexParameterf");
  load_function(glTexParameteri)(lib, "glTexParameteri");
  load_function(glTexParameterfv)(lib, "glTexParameterfv");
  load_function(glTexParameteriv)(lib, "glTexParameteriv");
  load_function(glGetTexParameterfv)(lib, "glGetTexParameterfv");
  load_function(glGetTexParameteriv)(lib, "glGetTexParameteriv");
  load_function(glGetTexLevelParameterfv)(lib, "glGetTexLevelParameterfv");
  load_function(glGetTexLevelParameteriv)(lib, "glGetTexLevelParameteriv");
  load_function(glTexImage1D)(lib, "glTexImage1D");
  load_function(glTexImage2D)(lib, "glTexImage2D");
  load_function(glGetTexImage)(lib, "glGetTexImage");
  load_function(glMap1d)(lib, "glMap1d");
  load_function(glMap1f)(lib, "glMap1f");
  load_function(glMap2d)(lib, "glMap2d");
  load_function(glMap2f)(lib, "glMap2f");
  load_function(glGetMapdv)(lib, "glGetMapdv");
  load_function(glGetMapfv)(lib, "glGetMapfv");
  load_function(glEvalCoord1d)(lib, "glEvalCoord1d");
  load_function(glEvalCoord1f)(lib, "glEvalCoord1f");
  load_function(glEvalCoord1dv)(lib, "glEvalCoord1dv");
  load_function(glEvalCoord1fv)(lib, "glEvalCoord1fv");
  load_function(glEvalCoord2d)(lib, "glEvalCoord2d");
  load_function(glEvalCoord2f)(lib, "glEvalCoord2f");
  load_function(glEvalCoord2dv)(lib, "glEvalCoord2dv");
  load_function(glEvalCoord2fv)(lib, "glEvalCoord2fv");
  load_function(glMapGrid1d)(lib, "glMapGrid1d");
  load_function(glMapGrid1f)(lib, "glMapGrid1f");
  load_function(glMapGrid2d)(lib, "glMapGrid2d");
  load_function(glMapGrid2f)(lib, "glMapGrid2f");
  load_function(glEvalPoint1)(lib, "glEvalPoint1");
  load_function(glEvalPoint2)(lib, "glEvalPoint2");
  load_function(glEvalMesh1)(lib, "glEvalMesh1");
  load_function(glEvalMesh2)(lib, "glEvalMesh2");
  load_function(glFogf)(lib, "glFogf");
  load_function(glFogi)(lib, "glFogi");
  load_function(glFogfv)(lib, "glFogfv");
  load_function(glFogiv)(lib, "glFogiv");
  load_function(glFeedbackBuffer)(lib, "glFeedbackBuffer");
  load_function(glPassThrough)(lib, "glPassThrough");
  load_function(glSelectBuffer)(lib, "glSelectBuffer");
  load_function(glInitNames)(lib, "glInitNames");
  load_function(glLoadName)(lib, "glLoadName");
  load_function(glPushName)(lib, "glPushName");
  load_function(glPopName)(lib, "glPopName");
  // gl 1.1
  load_function(glGenTextures)(lib, "glGenTextures");
  load_function(glDeleteTextures)(lib, "glDeleteTextures");
  load_function(glBindTexture)(lib, "glBindTexture");
  load_function(glPrioritizeTextures)(lib, "glPrioritizeTextures");
  load_function(glAreTexturesResident)(lib, "glAreTexturesResident");
  load_function(glIsTexture)(lib, "glIsTexture");
  load_function(glTexSubImage1D)(lib, "glTexSubImage1D");
  load_function(glTexSubImage2D)(lib, "glTexSubImage2D");
  load_function(glCopyTexImage1D)(lib, "glCopyTexImage1D");
  load_function(glCopyTexImage2D)(lib, "glCopyTexImage2D");
  load_function(glCopyTexSubImage1D)(lib, "glCopyTexSubImage1D");
  load_function(glCopyTexSubImage2D)(lib, "glCopyTexSubImage2D");
  load_function(glVertexPointer)(lib, "glVertexPointer");
  load_function(glNormalPointer)(lib, "glNormalPointer");
  load_function(glColorPointer)(lib, "glColorPointer");
  load_function(glIndexPointer)(lib, "glIndexPointer");
  load_function(glTexCoordPointer)(lib, "glTexCoordPointer");
  load_function(glEdgeFlagPointer)(lib, "glEdgeFlagPointer");
  load_function(glGetPointerv)(lib, "glGetPointerv");
  load_function(glArrayElement)(lib, "glArrayElement");
  load_function(glDrawArrays)(lib, "glDrawArrays");
  load_function(glDrawElements)(lib, "glDrawElements");
  load_function(glInterleavedArrays)(lib, "glInterleavedArrays");
  debug writeln("[ D ] Mapped OPENGL functionality");
}


void load_extensions(){
  writeln("[EXT] Discovering: OPENGL EXTENSIONS");
  // gl 1.2
  load_extension(glDrawRangeElements)("glDrawRangeElements");
  load_extension(glTexImage3D)("glTexImage3D");
  load_extension(glTexSubImage3D)("glTexSubImage3D");
  load_extension(glCopyTexSubImage3D)("glCopyTexSubImage3D");
  // gl 1.3
  load_extension(glActiveTexture)("glActiveTexture");
  load_extension(glClientActiveTexture)("glClientActiveTexture");
  load_extension(glMultiTexCoord1d)("glMultiTexCoord1d");
  load_extension(glMultiTexCoord1dv)("glMultiTexCoord1dv");
  load_extension(glMultiTexCoord1f)("glMultiTexCoord1f");
  load_extension(glMultiTexCoord1fv)("glMultiTexCoord1fv");
  load_extension(glMultiTexCoord1i)("glMultiTexCoord1i");
  load_extension(glMultiTexCoord1iv)("glMultiTexCoord1iv");
  load_extension(glMultiTexCoord1s)("glMultiTexCoord1s");
  load_extension(glMultiTexCoord1sv)("glMultiTexCoord1sv");
  load_extension(glMultiTexCoord2d)("glMultiTexCoord2d");
  load_extension(glMultiTexCoord2dv)("glMultiTexCoord2dv");
  load_extension(glMultiTexCoord2f)("glMultiTexCoord2f");
  load_extension(glMultiTexCoord2fv)("glMultiTexCoord2fv");
  load_extension(glMultiTexCoord2i)("glMultiTexCoord2i");
  load_extension(glMultiTexCoord2iv)("glMultiTexCoord2iv");
  load_extension(glMultiTexCoord2s)("glMultiTexCoord2s");
  load_extension(glMultiTexCoord2sv)("glMultiTexCoord2s");
  load_extension(glMultiTexCoord3d)("glMultiTexCoord3d");
  load_extension(glMultiTexCoord3dv)("glMultiTexCoord3d");
  load_extension(glMultiTexCoord3f)("glMultiTexCoord3f");
  load_extension(glMultiTexCoord3fv)("glMultiTexCoord3fv");
  load_extension(glMultiTexCoord3i)("glMultiTexCoord3i");
  load_extension(glMultiTexCoord3iv)("glMultiTexCoord3iv");
  load_extension(glMultiTexCoord3s)("glMultiTexCoord3s");
  load_extension(glMultiTexCoord3sv)("glMultiTexCoord3sv");
  load_extension(glMultiTexCoord4d)("glMultiTexCoord4d");
  load_extension(glMultiTexCoord4dv)("glMultiTexCoord4dv");
  load_extension(glMultiTexCoord4f)("glMultiTexCoord4f");
  load_extension(glMultiTexCoord4fv)("glMultiTexCoord4fv");
  load_extension(glMultiTexCoord4i)("glMultiTexCoord4i");
  load_extension(glMultiTexCoord4iv)("glMultiTexCoord4iv");
  load_extension(glMultiTexCoord4s)("glMultiTexCoord4s");
  load_extension(glMultiTexCoord4sv)("glMultiTexCoord4sv");
  load_extension(glLoadTransposeMatrixd)("glLoadTransposeMatrixd");
  load_extension(glLoadTransposeMatrixf)("glLoadTransposeMatrixf");
  load_extension(glMultTransposeMatrixd)("glMultTransposeMatrixd");
  load_extension(glMultTransposeMatrixf)("glMultTransposeMatrixf");
  load_extension(glSampleCoverage)("glSampleCoverage");
  load_extension(glCompressedTexImage1D)("glCompressedTexImage1D");
  load_extension(glCompressedTexImage2D)("glCompressedTexImage2D");
  load_extension(glCompressedTexImage3D)("glCompressedTexImage3D");
  load_extension(glCompressedTexSubImage1D)("glCompressedTexSubImage1D");
  load_extension(glCompressedTexSubImage2D)("glCompressedTexSubImage2D");
  load_extension(glCompressedTexSubImage3D)("glCompressedTexSubImage3D");
  load_extension(glGetCompressedTexImage)("glGetCompressedTexImage");
  // gl 1.4
  load_extension(glBlendFuncSeparate)("glBlendFuncSeparate");
  load_extension(glFogCoordf)("glFogCoordf");
  load_extension(glFogCoordfv)("glFogCoordfv");
  load_extension(glFogCoordd)("glFogCoordd");
  load_extension(glFogCoorddv)("glFogCoorddv");
  load_extension(glFogCoordPointer)("glFogCoordPointer");
  load_extension(glMultiDrawArrays)("glMultiDrawArrays");
  load_extension(glMultiDrawElements)("glMultiDrawElements");
  load_extension(glPointParameterf)("glPointParameterf");
  load_extension(glPointParameterfv)("glPointParameterfv");
  load_extension(glPointParameteri)("glPointParameteri");
  load_extension(glPointParameteriv)("glPointParameteriv");
  load_extension(glSecondaryColor3b)("glSecondaryColor3b");
  load_extension(glSecondaryColor3bv)("glSecondaryColor3bv");
  load_extension(glSecondaryColor3d)("glSecondaryColor3d");
  load_extension(glSecondaryColor3dv)("glSecondaryColor3dv");
  load_extension(glSecondaryColor3f)("glSecondaryColor3f");
  load_extension(glSecondaryColor3fv)("glSecondaryColor3fv");
  load_extension(glSecondaryColor3i)("glSecondaryColor3i");
  load_extension(glSecondaryColor3iv)("glSecondaryColor3iv");
  load_extension(glSecondaryColor3s)("glSecondaryColor3s");
  load_extension(glSecondaryColor3sv)("glSecondaryColor3sv");
  load_extension(glSecondaryColor3ub)("glSecondaryColor3ub");
  load_extension(glSecondaryColor3ubv)("glSecondaryColor3ubv");
  load_extension(glSecondaryColor3ui)("glSecondaryColor3ui");
  load_extension(glSecondaryColor3uiv)("glSecondaryColor3uiv");
  load_extension(glSecondaryColor3us)("glSecondaryColor3us");
  load_extension(glSecondaryColor3usv)("glSecondaryColor3usv");
  load_extension(glSecondaryColorPointer)("glSecondaryColorPointer");
  load_extension(glWindowPos2d)("glWindowPos2d");
  load_extension(glWindowPos2dv)("glWindowPos2dv");
  load_extension(glWindowPos2f)("glWindowPos2f");
  load_extension(glWindowPos2fv)("glWindowPos2fv");
  load_extension(glWindowPos2i)("glWindowPos2i");
  load_extension(glWindowPos2iv)("glWindowPos2iv");
  load_extension(glWindowPos2s)("glWindowPos2s");
  load_extension(glWindowPos2sv)("glWindowPos2sv");
  load_extension(glWindowPos3d)("glWindowPos3d");
  load_extension(glWindowPos3dv)("glWindowPos3dv");
  load_extension(glWindowPos3f)("glWindowPos3f");
  load_extension(glWindowPos3fv)("glWindowPos3fv");
  load_extension(glWindowPos3i)("glWindowPos3i");
  load_extension(glWindowPos3iv)("glWindowPos3iv");
  load_extension(glWindowPos3s)("glWindowPos3s");
  load_extension(glWindowPos3sv)("glWindowPos3sv");
  load_extension(glBlendEquation)("glBlendEquation");
  load_extension(glBlendColor)("glBlendColor");
  // gl 1.5
  load_extension(glGenQueries)("glGenQueries");
  load_extension(glDeleteQueries)("glDeleteQueries");
  load_extension(glIsQuery)("glIsQuery");
  load_extension(glBeginQuery)("glBeginQuery");
  load_extension(glEndQuery)("glEndQuery");
  load_extension(glGetQueryiv)("glGetQueryiv");
  load_extension(glGetQueryObjectiv)("glGetQueryObjectiv");
  load_extension(glGetQueryObjectuiv)("glGetQueryObjectuiv");
  load_extension(glBindBuffer)("glBindBuffer");
  load_extension(glDeleteBuffers)("glDeleteBuffers");
  load_extension(glGenBuffers)("glGenBuffers");
  load_extension(glIsBuffer)("glIsBuffer");
  load_extension(glBufferData)("glBufferData");
  load_extension(glBufferSubData)("glBufferSubData");
  load_extension(glGetBufferSubData)("glGetBufferSubData");
  load_extension(glMapBuffer)("glMapBuffer");
  load_extension(glUnmapBuffer)("glUnmapBuffer");
  load_extension(glGetBufferParameteriv)("glGetBufferParameteriv");
  load_extension(glGetBufferPointerv)("glGetBufferPointerv");
  debug writeln("[EXT] Loaded OPENGL EXTENSIONS functionality");
}
