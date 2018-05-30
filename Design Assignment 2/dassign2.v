// EEM16 - Logic Design
// 2018_04_13
// Design Assignment #2
// dassign2.v

//
// modules provided for your use
//
module inv(y,a);
   output y;
   input  a;

   assign y=~(a);
endmodule

module and2(y,a,b);
   output y;
   input  a,b;

   assign y=a&b ;
endmodule

module or2(y,a,b);
   output y;
   input  a,b;

   assign y=a|b ;
endmodule

module xor2(y,a,b);
   output y;
   input  a,b;

   assign y=a^b ;
endmodule

module mux21(y, i0, i1, sel);
   output y;
   input  i0, i1,sel;

   //sel = 1 choose i1, otherwise i0)
   assign y = (sel) ? i1 : i0;
endmodule // mux21

//
// Blocks for you to design begins here
//
module sbs(d, bout, x, y, bin);
   output d, bout;
   input  x, y, bin;

   //
   // Implement the single bit subtract here
   //
  wire xorone, oryandbin, andyandbin;
  
  //xor of the x and y and bin is d
  xor2 firstxor(xorone, x, y);
  xor2 secondxor(d, xorone, bin);
  
  //or y and bin
  or2 yandbin1(oryandbin, y, bin);
  
  //and y and bin
  and2 yandbin2(andyandbin, y, bin);
  
  //mux of two above with x as select bit is bout
  mux21 bitmx(bout, oryandbin, andyandbin, x);
  
  
endmodule 

module subtract8(d, bout, x, y);
   output [7:0] d;
   output 	bout;
   input [7:0] 	x, y;

   wire 	bin;
   wire [7:0] 	b;

   assign bin = 1'b0;
   assign bout = b[7];
   // 
   // Implement the 8-bit subtract function here
   // 
  
  sbs sbs0(d[0], b[0], x[0], y[0], bin);
  sbs sbs1(d[1], b[1], x[1], y[1], b[0]);
  sbs sbs2(d[2], b[2], x[2], y[2], b[1]);
  sbs sbs3(d[3], b[3], x[3], y[3], b[2]);
  sbs sbs4(d[4], b[4], x[4], y[4], b[3]);
  sbs sbs5(d[5], b[5], x[5], y[5], b[4]);
  sbs sbs6(d[6], b[6], x[6], y[6], b[5]);
  sbs sbs7(d[7], b[7], x[7], y[7], b[6]);

endmodule

module dassign2_1 (q, rout, rin, din);
   output q;
   output [7:0] rout;
   input [7:0] 	rin, din;
   //
   // Instantiate the subtract module
   // 
   wire 	bout;
   wire [7:0] 	dout;

   subtract8 sub8(dout, bout, rin, din);         

   //
   // Implement the rest of the SCS function here
   //
  
  
  //invert bout to get q
  
  inv invbout(q, bout);
  
  //mutex with bout as select
  //invert bout?
  mux21 bit0(rout[0], dout[0], rin[0], bout);
  mux21 bit1(rout[1], dout[1], rin[1], bout);
  mux21 bit2(rout[2], dout[2], rin[2], bout);
  mux21 bit3(rout[3], dout[3], rin[3], bout);
  mux21 bit4(rout[4], dout[4], rin[4], bout);
  mux21 bit5(rout[5], dout[5], rin[5], bout);
  mux21 bit6(rout[6], dout[6], rin[6], bout);
  mux21 bit7(rout[7], dout[7], rin[7], bout);

endmodule

module dassign2_2 (motor_drv, done, forw, rev, reset, drv_clk);
   output [3:0] motor_drv;
   output 	done;
   input 	forw, rev, reset, drv_clk;

   //
   // Parameters declaration for State Bits (An example)
   //
   parameter STATE_BITS = 2;
   parameter S0_ST = 2'b00;
   parameter S1_ST = 2'b01;
   parameter S2_ST = 2'b10;
   parameter S3_ST = 2'b11;

   reg [STATE_BITS-1:0] state, nx_state;
   reg 			done;
   reg [3:0] 		motor_drv;

   //
   // Storage elements for the state bits (You should not change)
   //
   always @(posedge drv_clk) begin
     
      state <= nx_state;  
   end

   always @(state or forw or rev or reset) begin
     if(forw)
       case(state)
         S0_ST: {nx_state, motor_drv, done}= {S1_ST, 4'b0001, 1'b1};
         S1_ST: {nx_state, motor_drv} = {S2_ST, 4'b0010};
         S2_ST: {nx_state, motor_drv} = {S3_ST,4'b0100 };
         S3_ST: {nx_state, motor_drv} = {S0_ST, 4'b1000};  
       endcase
     else
     if(rev) 
       case(state)
         S0_ST: {nx_state, motor_drv, done}= {S3_ST, 4'b0001, 1'b1};
         S3_ST: {nx_state, motor_drv} = {S2_ST, 4'b1000};
         S2_ST: {nx_state, motor_drv} = {S1_ST,4'b0100 };
         S1_ST: {nx_state, motor_drv} = {S0_ST, 4'b0010};
       endcase
     else
       nx_state = state;
     
     if(motor_drv == 4'b0001)
       done = 1'b1;
     else
       done = 1'b0;
     
     if(reset)begin
       motor_drv = 4'b0000;
       state = S0_ST;
     end
   end // always @ (state or forw or rev or reset)
endmodule // dassign2_2


