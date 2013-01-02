module dcmp.parser;

import std.stdio, std.conv;
import dcmp.token, dcmp.recognizers, dcmp.functions, dcmp.expressions, dcmp.errors, dcmp.codegen_asm;

struct Parser{
  Token lookAhead;

  this(Token[] tokens){ this.tokens = tokens; lookAhead = tokens[0]; }
  Token nextToken(){
    ctok++;
    if(ctok >= tokens.length) abort("Unexpected end of input");
    return tokens[ctok];
  }
  Token currentToken(){ return tokens[ctok]; }
  private:
    Token[] tokens;
    int     ctok = 0;
}

void parseProgram(ref Parser p){
  prolog();
  while(p.lookAhead.value[0] != EOI){
    p.matchStatement();
  }
  epilog();
}

void doArgsDefinitionList(ref Parser p){
  if(p.lookAhead.value == ")") return;
  Token  type = p.matchType("type");
  Token  id   = p.matchType("identifier");
//  variables ~= id.value;
  while(p.lookAhead.value == ","){
    p.matchValue(",");
    type = p.matchType("type");
    id   = p.matchType("identifier");
//    variables ~= id.value;
  }
}

void doArgsCallList(ref Parser p, Token func){
  p.matchValue("(");
  p.bexpression();
  while(p.lookAhead.value == ","){
    p.matchValue(",");
    p.bexpression();
  }
  p.matchValue(")");
  callFunction(func.value);
}

void matchStatement(ref Parser p){
  if(p.lookAhead.type == "type"){
    Token  type = p.matchType("type");
    Token  id   = p.matchType("identifier");
    if(p.lookAhead.value == "("){        // Function declaration
      p.matchValue("(");
      p.doArgsDefinitionList();
      p.matchValue(")");
      string funlabel = addLabel(id.value, true);
      functionProlog();
      p.doBlock();
      addLabel(funlabel ~ "_end");
    }else if(p.lookAhead.value == "="){  // Variable allocation & assigment
      allocateVariable(id.value);
      p.assignment(id);
      p.matchValue(";");
    }else if(p.lookAhead.value == ","){  // Multiple variable allocation
      allocateVariable(id.value);
      while(p.lookAhead.value == ","){
        p.matchValue(",");
        id   = p.matchType("identifier");
        allocateVariable(id.value);
      }
    }else if(p.lookAhead.value == ";"){  // Single variable allocation
      allocateVariable(id.value);
      p.matchValue(";");
    }
  }else if(p.lookAhead.type == "keyword"){      // Control statements
    Token  keyw = p.matchType("keyword");
    if(keyw.value != "else"){
      p.matchValue("(");
      p.bexpression();
      p.matchValue(")");
    }
    p.doBlock(false);
  }else if(p.lookAhead.type == "identifier"){   // Variable manipulation or Function call
    Token  id   = p.matchType("identifier");
    if(p.lookAhead.value == "(") p.doArgsCallList(id);
    if(p.lookAhead.value == "=") p.assignment(id);
    p.matchValue(";");
  }else{
    expected("keyword/type", p.lookAhead.type);
  }
}

void doBlock(ref Parser p, bool isFunction = true){
  p.matchValue("{");
  while(p.lookAhead.value != "}"){
    p.matchStatement();
  }
  if(isFunction) functionEpilog();
  p.matchValue("}");
}

