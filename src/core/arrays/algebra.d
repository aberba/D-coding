/**********************************************************************
 * \file src/core/arrays/algebra.d
 *
 * copyright (c) 2012 Danny Arends
 * last modified Feb, 2012
 * first written May, 2011
 * Written in the D Programming Language (http://www.digitalmars.com/d)
 **********************************************************************/ 
module core.arrays.algebra;

import std.stdio;
import std.conv;
import std.string;
import std.math;
import std.random;

/**
* D-routine to get the sum of values of d1<br>
* bugs: none found<br>
* @param d1 any type any length vector<br>
*/
T sum(T)(T[] d){
  T s = 0;
  foreach(T e; d[0..$]){ s += e; }
  return s;
}

/**
* D-routine to get the max value of d1<br>
* bugs: none found<br>
* @param d1 any type any length vector<br>
*/
T max(T)(T[] d){
  T m = 0;
  foreach(T e; d[0..$]){ if(m < e){ m = e; } }
  return m;
}


/**
* D-routine to get the max value of a range within d1<br>
* bugs: none found<br>
* @param d1 any type any length vector<br>
* @param r range to consider<br>
*/
T maxOf(T)(T[] d, T r){
  T m = 0;
  for(int x=0;x<d.length-r;x++){ 
    T e = sum!T(d[x..x+r]);
    if(m < e){ m = e; } 
  }
  return m;
}

T[] applyRandomness(T)(T[] d1, int[] rnd){
  T[] r;
  r.length = d1.length;
  for(int x=0;x<d1.length;x++){
    if(rnd[x] != 0){
      r[x] = d1[x] + to!T(uniform(-rnd[x],rnd[x])/100.0);
    }else{
      r[x] = d1[x];
    }
  }
  return r;
}

/**
* D-routine that substracts d1 from d2<br>
* bugs: none found<br>
* @param d1 any type any length vector<br>
* @param d2 any type any length vector<br>
*/
T[] subtract(T)(T[] d1,T[] d2){
  if(d1.length!=d2.length) throw new Exception("Error: Should have same length");
  T[] diff;
  diff.length = d1.length;
  for(int x=0;x<d1.length;x++){
    diff[x] = d1[x] - d2[x];
  }
  return diff;
}

/**
* D-routine that adds d1 to d2<br>
* bugs: none found<br>
* @param d1 any type any length vector<br>
* @param d2 any type any length vector<br>
*/
T[] add(T)(T[] d1,T[] d2){
  if(d1.length!=d2.length) throw new Exception("Error: Should have same length");
  T[] sum;
  sum.reserve(d1.length);
  for(int x=0;x<d1.length;x++){
    sum ~= d1[x] + d2[x];
  }
  return sum;
}

/**
* D-routine that multiplies a vector with a constant<br>
* bugs: none found<br>
* @param d1 any type any length vector<br>
* @param alpha float parameter holding the maginification factor<br>
*/
T[] multiply(T)(T[] d1, float alpha = 1.0){
  T[] factor;
  factor.reserve(d1.length);
  for(int x=0;x<d1.length;x++){
    factor ~= d1[x] * alpha;
  }
  return factor;
}

/**
* D-routine that adds a multiple of another vector with a constant<br>
* bugs: none found<br>
* @param d1 any type any length vector<br>
* @param d2 any type any length vector<br>
* @param alpha float parameter holding the maginification factor<br>
*/
T[] addnmultiply(T)(T[] d1,T[] d2, float alpha = 1.0){
  if(d1.length!=d2.length) throw new Exception("Error: Should have same length");
  T[] factor;
  factor.reserve(d1.length);
  for(int x=0;x<d1.length;x++){
    factor ~= d1[x] + d2[x] * alpha;
  }
  return factor;
}

/**
* D-routine that calculates the magintude of a vector<br>
* bugs: none found<br>
* @param d1 any type any length vector<br>
*/
float magnitude(T)(T[] d1){
  float f = 0.0;
  for(int x=0;x<d1.length;x++){
    f += (d1[x] * d1[x]);
  }
  return sqrt(f);
}

/**
* D-routine normalizes a vector<br>
* bugs: none found<br>
* @param d1 any type any length vector<br>
*/
T[] normalize(T)(T[] d1){
  T[] normal;
  normal.reserve(d1.length);
  
  float len = magnitude!T(d1);
  if (len == 0.0f) len = 1.0f;

  // reduce to unit size
  for(int x=0;x<d1.length;x++){
    normal ~= d1[x] / len;
  }
  return normal;
}


/**
* D-routine that finds a normalized normal vector for a triangle<br>
* bugs: none found<br>
* @param v any type 3x3 holding the three points of the triangle<br>
*/
T[] trianglefindnormal(T)(T[3][3] v){
  T[3] a;
  T[3] b;
  T[] normal;
  normal.reserve(3);
  
  a[0] = v[0][0] - v[1][0];
  a[1] = v[0][1] - v[1][1];
  a[2] = v[0][2] - v[1][2];

  b[0] = v[1][0] - v[2][0];
  b[1] = v[1][1] - v[2][1];
  b[2] = v[1][2] - v[2][2];

  // calculate the cross product and place the resulting vector
  normal[0] = (a[1] * b[2]) - (a[2] * b[1]);
  normal[1] = (a[2] * b[0]) - (a[0] * b[2]);
  normal[2] = (a[0] * b[1]) - (a[1] * b[0]);

  // normalize the normal
  return normalize(normal);
}

unittest{
  writeln("Unit test: ",__FILE__);
  try{
    double[] a = [1,2,3];
    double[] b = [2,2,1];
    assert(multiply!double(a,2) == [2,4,6]);
    assert(add!double(a,b) == [3,4,4]);
    assert(addnmultiply!double(a,b,3) == [7,8,6]);
    writeln("OK: ",__FILE__);  
  }catch(Throwable e){
    string err = to!string(e).split("\n")[0];
    writefln(" - %s\nFAILED: %s",err,__FILE__);  
  }
}
