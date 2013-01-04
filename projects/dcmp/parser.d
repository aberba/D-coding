module dcmp.parser;

import std.stdio, std.conv, std.string;
import dcmp.token, dcmp.recognizers, dcmp.functions, dcmp.expressions;
import dcmp.procedures, dcmp.errors, dcmp.controlstructs, dcmp.codegen_asm;

struct Parser{
  Token lookAhead;

  this(Token[] tokens){ this.tokens = tokens; lookAhead = tokens[0]; }
  Token nextToken(){
    ctok++;
    if(ctok >= tokens.length) abort("Unexpected end of input");
    return tokens[ctok];
  }
  Token currentToken(){ return tokens[ctok]; }

  void nextLabel(){ curLabel++; }
  string getL1(){ return(format("_Cl%s_1", curLabel)); }
  string getL2(){ return(format("_Cl%s_2", curLabel)); }

  private:
    int     curLabel = 0;
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

void doBlock(ref Parser p, bool isFunction = true){
  p.matchValue("{");
  while(p.lookAhead.value != "}"){
    p.matchStatement(isFunction);
  }
  if(isFunction) functionEpilog();
  p.matchValue("}");
}

void matchStatement(ref Parser p, bool isFunction = false){
  if(p.lookAhead.type == "type"){
    Token  type = p.matchType("type");              // Type is always followed by identifier
    Token  id   = p.matchType("identifier");
    if(p.lookAhead.value == "("){                   // Function declaration
      functions ~= p.doArgsDefinitionList(id.value, type.value);
      string funlabel = addLabel(id.value, true);
      functionProlog();
      p.doBlock();
      addLabel(funlabel ~ "_end");
    }else if(p.lookAhead.value == "="){             // Variable allocation & assigment
      Variable v = p.allocateVariable(id.value, type.value, isFunction);
      p.assignment(v);
      p.matchValue(";");
    }else if(p.lookAhead.value == ","){             // Multiple variable allocation
      p.allocateVariable(id.value, type.value, isFunction);
      while(p.lookAhead.value == ","){
        p.matchValue(",");
        id = p.matchType("identifier");
        p.allocateVariable(id.value, type.value, isFunction);
      }
    }else if(p.lookAhead.value == ";"){             // Single variable allocation
      p.allocateVariable(id.value, type.value, isFunction);
      p.matchValue(";");
    }else if(p.lookAhead.value == "["){             // Array allocation
      Variable v = p.allocateVariable(id.value, type.value, isFunction);
      if(p.lookAhead.value == "="){                 // Array initialization
        p.assignment(v);
      }
      p.matchValue(";");
    }
  }else if(p.lookAhead.type == "keyword"){          // Control statements
    Token keyword = p.matchType("keyword");
    p.controlStatement(keyword);
  }else if(p.lookAhead.type == "identifier"){       // Variable manipulation or Function call
    Token    id = p.matchType("identifier");
    if(p.lookAhead.value == "(") p.doArgsCallList(id);
    if(p.lookAhead.value == "="){
      Variable v  = getVariable(id.value);
      int n  = p.matchArrayIndex();
      p.assignment(v, n);
    }
    p.matchValue(";");
  }else{
    expected("keyword / identifier / type", p.lookAhead.type);
  }
}

int matchArrayIndex(ref Parser p){
  int n = 0;
  if(p.lookAhead.value == "["){             // Array variable allocation
    p.matchValue("[");
    n = to!int(p.matchType("numeric").value);
    p.matchValue("]");
  }
  return n;
}

/* Allocate a variable (so that it is added to the data section) */
Variable allocateVariable(ref Parser p, string name, string type, bool inFunction){
  if(inTable(name, getVariables())) duplicate(name);
  int n = p.matchArrayIndex();
  if(n == 0) n = 1;
  variables ~= Variable(name, type, 0, n);
  return variables[($-1)];
}
