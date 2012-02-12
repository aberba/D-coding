/**********************************************************************
 * \file src/plugins/regression/augmentation.d
 *
 * copyright (c) 1991-2010 Ritsert C Jansen, Danny Arends, Pjotr Prins, Karl Broman
 * last modified Feb, 2012
 * first written 2010
 * Written in the D Programming Language (http://www.digitalmars.com/d)
 **********************************************************************/
module plugins.regression.augmentation;
 
import std.stdio;
import std.math;

import core.arrays.types;
import plugins.regression.support;

double rf(double cmdistance){
  return (0.5*(1.0-exp(-0.02*cmdistance)));
}

const int RFUNKNOWN = 999;

enum : char{
  MLEFT = 'L',
  MMIDDLE='M',
  MRIGHT='R',
  MUNLINKED='U',
}

dvector calcrf(cvector position, dvector mapdistance){
  uint nmarkers = cast(uint)position.length;
  dvector r = newvector!double(nmarkers);
  for(uint m=0; m<nmarkers; m++) {
    r[m]= RFUNKNOWN;
    if ((position[m]==MLEFT)||(position[m]==MMIDDLE)) {
      r[m]= rf(mapdistance[m+1]-mapdistance[m]);
      if (r[m]<0) {
        writefln("ERROR: Position=",position[m]," r[m]=",r[m]);
        return r;
      }
    }
  }
  return r;
}

cvector markerpos(ivector chr){
  uint nmarkers = cast(uint)chr.length;
  cvector position = newvector!char(nmarkers);
  for(uint m=0; m<nmarkers; m++){
    if(m==0){
      if(chr[m]==chr[m+1]) 
        position[m]=MLEFT;
      else 
        position[m]=MUNLINKED;
    } else if (m==nmarkers-1) {
      if (chr[m]==chr[m-1]) 
        position[m]=MRIGHT;
      else 
        position[m]=MUNLINKED;
    } else if (chr[m]==chr[m-1]) {
      if (chr[m]==chr[m+1]) 
        position[m]=MMIDDLE;
      else 
        position[m]=MRIGHT;
    } else {
      if (chr[m]==chr[m+1]) 
        position[m]=MLEFT;
      else 
        position[m]=MUNLINKED;
    }
  }
  return position;
}

double augmentation(dmatrix markers, cvector positions, dvector rf, int verbose){
  for(uint i=1; i < markers.length; i++){
  
  }
  return 0.0;
}
