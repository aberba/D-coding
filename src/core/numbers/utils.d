/**********************************************************************
 * \file src/core/numbers/utils.d
 *
 * copyright (c) 2012 Danny Arends
 * last modified Feb, 2012
 * first written Feb, 2012
 * Written in the D Programming Language (http://www.digitalmars.com/d)
 **********************************************************************/
module core.numbers.utils;

import std.stdio;
import std.conv;
import std.math;
import std.string;
import std.random;

T gcd(T)(T a, T b){ 
  while(a % b != 0){
    T tmp = a%b;
    a   = b;
    b   = tmp;
  }
  return b;
}

T modpow(T)(T base, T exponent, T modulus){
  T result = 1;
  while(exponent > 0){
    if((exponent & 1) == 1){
      result = (result * base) % modulus;
    }    
    exponent = exponent >> 1;
    base = (base * base) % modulus;
  }
  return result;
}

unittest{
  writeln("Unit test: ",__FILE__);
  try{
    writeln(" gdc(8,12) = ",gcd(8,12));
    writeln(" modpow(6,3000,23) = ",modpow(6,3000,23));
    writeln(" modpow(5,300,253) = ",modpow(5,300,253));
    writeln("OK: ",__FILE__);
  }catch(Throwable e){
    string err = to!string(e).split("\n")[0];
    writefln(" - %s\nFAILED: %s",err,__FILE__);  
  }
}
