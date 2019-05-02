module boothr4_tb (
  output reg clk_i,
  output reg rst_i,
  output reg [7:0]inbus_i,
  output reg begin_i,
  output end_o,
  output [7:0]outbus_o
);
boothr4 f1 (.clk_i(clk_i), .rst_i(rst_i), .inbus_i(inbus_i), .begin_i(begin_i), .end_o(end_o), .outbus_o(outbus_o));
initial begin
  clk_i = 1'd0;
  forever 
  #50 clk_i = ~clk_i;
end
initial begin
  rst_i=1'd0;
  begin_i=1'd1;
  //inbus_i=8'b10100100;
    inbus_i=8'b11000100;   
  #10 rst_i=1'd1;
  //#90 inbus_i=8'b10010101;
    #90 inbus_i=8'b01101001;
end
endmodule