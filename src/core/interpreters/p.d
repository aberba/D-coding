/*
 * P.d - Interpreter for P'' programming language in D
 * 
 * See: http://en.wikipedia.org/wiki/P'' or http://www.cs.unibo.it/~martini/PP/bohm-jac.pdf
 * Copyright (c) 2010 Danny Arends
 * 
 */
 
module core.interpreters.p;

import core.thread;
import std.array;
import std.stdio;
import std.conv;
import std.datetime;
import core.time;

enum OP : char {R = 'R', LAMBDA = 'l', START_BLOCK = '(', CLOSE_BLOCK = ')'};

/* Check if op-code is valid P code */
bool is_valid_op(char op){
	if (op == 'R') return true;
	if (op == 'l') return true;
	if (op == '(') return true;
	if (op == ')') return true;
  debug writeln("Warning: Ignoring the invalid operator: " ~ op);
	return false;
}

class PInterpreter{
  int       p_max_memory = 1024;
  bool      p_debug = 0;

  char[]    p_memory;

  int       p_ip = 0;
  int       p_mp = 0; //Starts pointing to the first character of the input

  OP[]    p_program;
  int[]     p_targets;
  long      step=0;
  bool      p_running = true;
  int       p_timeout = 3;
  
  string run(){
    auto t0 = Clock.currTime();
    
    while(p_running){
      p_runstep();
      auto t1 = Clock.currTime();
      if(p_timeout > 0 && (t1-t0) >= dur!"seconds"(p_timeout)){
        p_running = false;
        writeln("Error: Runtime killed by timeout (Infinite loop?)");
      }
    }
    if(p_debug) writeln("Buffer:" ~ p_memory[1..$]);
    return to!string(p_memory[1..$]);  
  }
  
  this(string prog, string input, int max_memory = 1024, int timeout = 3, bool debugmode = true){
    p_timeout = timeout;
    p_debug = debugmode;
    p_max_memory = (max_memory+1);  // Add 1 for the blank spot in the front
    p_memory.length = p_max_memory;
    init_memory(input);
    p_running = init_prog(prog);    
  }
    
  /* Execute an opcode */
  void execute_opcode(OP op){
    if(p_debug) writefln("Step: %d, Executing: %s, Memory pointer: %d (%s), Instruction pointer: %d", step, op, p_mp, p_memory[p_mp], p_ip);
  	switch(op){
  		case OP.R:
        if(p_mp < (p_max_memory-1)){
          p_mp++;
        }else{
          p_mp=0;
        }
  			break;
  		case OP.LAMBDA:
        if(p_mp < (p_max_memory-1)){
          p_memory[p_mp] = p_memory[(p_mp+1)];
        }else{
          p_memory[p_mp] = p_memory[0];
        }
        if(p_mp>0){
          p_mp--;
        }else{
          p_mp=(p_max_memory-1);
        }
  			break;
  		case OP.START_BLOCK:
        if(p_debug) writefln("Step: %d, compare %s == %s",step, p_memory[p_mp], p_memory[0]);
  			if(p_memory[p_mp] == p_memory[0]){
          p_ip = p_targets[p_ip];
        }
  			break;
  		case OP.CLOSE_BLOCK:
  			p_ip = p_targets[p_ip] - 1;
  			break;
  	}
  }

  /* Parses the code, removing any unknown operators */
  bool init_prog(string code){
  	for(int i=0; i < code.length; i++){
  		char op = code[i];
  		if (is_valid_op(op)) p_program ~= cast(OP)op;
  	}	
  	p_ip = 0;
  	return init_targets();
  }

  /* Initializes the memory */
  void init_memory(string input = ""){
    p_memory[0] = 0;
  	for(int i=1; i< p_max_memory; i++){
      if(i <= input.length){
        p_memory[i] = cast(int) input[i-1];
      }else{
        p_memory[i] = 0;
      }
  	}
  	p_mp = 0;
  }

  /* Initializes the 'target' stack, recording the while jumps in the program */
  bool init_targets(){
  	p_targets.length = p_program.length;
  	int[] temp_stack;
  	foreach(int i, char op ; p_program){
  		if (op == '('){
  			temp_stack ~= i;
  		}
  		if (op == ')'){
  			if (temp_stack.length == 0){
          writeln("Parse error: ) with no matching (");
          return false;
        }
  			int target = temp_stack[(temp_stack.length-1)];
        temp_stack.popBack();
  			p_targets[i] = target;
  			p_targets[target] = i;
  		}
  	}
  	if(temp_stack.length > 0){
      writeln("Parse error: ( with no matching )");
      return false;
    }
    return true;
  }

  /* Execute a single p command */
  void p_runstep(){
  	// execute instruction under ip
  	OP op = p_program[p_ip];
  	execute_opcode(op);
  	p_ip++;
    step++;
  	if(p_ip >= p_program.length){
  		p_running = false;
  	}
  }
}

unittest{
  auto p = new PInterpreter("RRl(ll)","001",10);
  string s = p.run();
  assert(s=="1111111111");
  p = new PInterpreter("RR(Rl(l(R)))","0001",10);
  string s = p.run();
  assert(s=="111");
  p = new PInterpreter("RRl","011",10);
  string s = p.run();
  assert(s=="111");
}
