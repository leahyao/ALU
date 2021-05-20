// define signal and parameter of ALU

package alu_pkg;

	parameter srcwidth  = 8;
	parameter dstwidth  = 16;

	typedef struct packed {
		logic [srcwidth-1:0] 		a;
		logic [srcwidth-1:0] 		b;
		logic [dstwidth-1:0] 		out;
		logic [srcwidth-1:0] 		remainder;
	} uint_t;
	
	typedef struct packed {
		logic [srcwidth-1:0] 		operand_a;
		logic [srcwidth-1:0] 		operand_b;
		logic [dstwidth-1:0] 		result;
	} uint_vld_t;


	typedef struct packed {
		logic				vld;
		logic [2:0]			op;  	  //100: add, 101: sub
							  //010: mul, 011: div
							  //001: mean
	} alu_cmd_t;


endpackage: alu_pkg

