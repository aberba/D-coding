/******************************************************************//**
 * \file src/plugins/generator/generator.d
 * \brief Generator definition
 *
 * <i>Copyright (c) 2012</i> Danny Arends<br>
 * Last modified Feb, 2012<br>
 * First written Dec, 2011<br>
 * Written in the D Programming Language (http://www.digitalmars.com/d)
 **********************************************************************/
module plugins.generator.generator;

import std.stdio;
import std.math;
import plugins.generator.algorithm;
import plugins.generator.grammar;

/*! \brief Interface to define a generator
 *
 *  Interface to define a generator
 */
interface AbstractGenerator{
public:
  bool generate(Algorithm a, Grammar g){ 
  
  }
  
}

class Generator : AbstractGenerator{
public:
  override bool generate(Algorithm a, Grammar g){
  
  }
  
  bool loadTemplates(string path = "./data/templates"){
  
  }
  
private:
  Template[] templates;
}
