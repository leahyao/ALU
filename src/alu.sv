module alu
  (

   input  clk,
   input  reset_n,

   input  alu_pkg::alu_cmd_t  alu_cmd,
   input  alu_pkg::uint_vld_t operand_a,
   input  alu_pkg::uint_vld_t operand_b,

   output alu_pkg::uint_vld_t result

   );
	logic 				ex1_vld;
	logic [2:0]			ex1_op;
	logic [alu_pkg::srcwidth-1:0]	ex1_operand_a;
	logic [alu_pkg::srcwidth-1:0]	ex1_operand_b;

   	logic [alu_pkg::dstwidth-1:0] 	rst_add;
   	logic [alu_pkg::dstwidth-1:0] 	rst_sub;
   	logic [alu_pkg::dstwidth-1:0] 	rst_mul;
   	logic [alu_pkg::dstwidth-1:0] 	rst_div;
   	logic [alu_pkg::srcwidth-1:0] 	remainder;
   	logic [alu_pkg::dstwidth-1:0] 	rst_mean;
   	
	//ctrl path
	always @(posedge clk or posedge reset_n) begin
		if(reset_n) begin
			ex1_vld <= 1'b0;
			ex1_op  <= 3'b0;
		end else begin 	
			ex1_vld <= alu_cmd.vld;
			ex1_op  <= alu_cmd.op;
		end
	end

	//data path
	always @(posedge clk) begin
		ex1_operand_a <= operand_a;
		ex1_operand_b <= operand_b;
	end


	add m_add(
		.a 	(ex1_operand_a),
		.b 	(ex1_operand_b),
		.out	(rst_add)
   	);

	sub m_sub(
		.a	(ex1_operand_a),
		.b	(ex1_operand_b),
		.out	(rst_sub)
   	);

	mul m_mul(
		.a	(ex1_operand_a),
		.b	(ex1_operand_b),
		.out	(rst_mul)
   	);

	div m_div(
		.a	(ex1_operand_a),
		.b	(ex1_operand_b),
		.out	(rst_div),
		.remainder(remainder),
   	);
	
	assign rst_mean = {1'b0,rst_add[dstwidth-1:1]};
	
	assign result = {alu_pkg::dstwidth{ex1_op==3'b001}} & rst_mean | 
			{alu_pkg::dstwidth{ex1_op==3'b010}} & rst_mul  |
			{alu_pkg::dstwidth{ex1_op==3'b011}} & {remainder,rst_div[srcwidth-1:0]}  |
			{alu_pkg::dstwidth{ex1_op==3'b100}} & rst_add  |
			{alu_pkg::dstwidth{ex1_op==3'b101}} & rst_sub ;
   	

endmodule
