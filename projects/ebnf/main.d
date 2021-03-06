﻿/******************************************************************//**
 * \file src/main/ebnf.d
 * \brief Main function for BNF
 *
 * <i>Copyright (c) 2012</i> Danny Arends<br>
 * Last modified Mar, 2012<br>
 * First written Jul, 2011<br>
 * Written in the D Programming Language (http://www.digitalmars.com/d)
 **********************************************************************/
import std.file, std.stdio, std.string, std.conv;
import ebnf.functions, ebnf.grammar, ebnf.rule, ebnf.symbol;

void main(string[] args){
  if(args.length > 1){
    BNFGrammar grammar;
    grammar.load(args[1], false);
    writefln("- Loaded: %s Backus-Naur Form production rules", grammar.length);
    
    Symbol[][] exp;
    writefln("- Expansion of symbol\n");
    writefln("\'A\' = %s", grammar.expand(new Symbol("'A'")));
    writefln("D = %s"    , grammar.expand(new Symbol("D")));
    writefln("$ = %s"    , grammar.expand(new Symbol("$")));
    writefln("FN = %s"   , grammar.expand(new Symbol("FN")));

    writefln("- Expansion of Symbol-Array:\n");
    exp = grammar.expand([new Symbol("D"), new Symbol("'A'")]);
    writefln("D 'A'   = %s %s",exp.length, exp[0].length);
    exp = grammar.expand([new Symbol("D"), new Symbol("LCC")]);
    writefln("D LCC   = %s %s",exp.length, exp[0].length);
    exp = grammar.expand([new Symbol("D"), new Symbol("LCC"),new Symbol("D")]);
    writefln("D LCC D = %s %s",exp.length, exp[0].length);

    writefln("- Expansion of Rule-0:\n");
    exp = grammar.expand(grammar.rules[0],4);

    writefln("- Expansion of Rule-1:\n");
    exp = grammar.expand(grammar.rules[1],4);
    
    writefln("- Expansion of Rule-2:\n");
    exp = grammar.expand(grammar.rules[2],5);
  }
}
