// EEM16 - Logic Design
// 2018_04_04
// Design Assignment #1
// dassign1.v

module inv(y,a);
   output y;
   input a;

   assign y=~(a);
endmodule

module nand2(y,a,b);
   output y;
   input a,b;
   wire d;
   assign d=a&b ;
   assign y=~(d);
endmodule

module nor2(y,a,b);
   output y;
   input a,b;
   wire d;
   assign d=a|b ;
   assign y=~(d);
endmodule

module dassign1_1 (pdec0,pdec3,pdec12,pdec15,nando,addr);
   output pdec0,pdec3,pdec12,pdec15;
   output [3:0] nando; //the output of the 4 nand gates that you should be using
   
   input [5:0] addr;

   //
   // vvv - Declare your wires here - vvv
   //
  wire a5_1, a4_1, a3_1, a2_1;
  wire a54_nandinvert, a54_nand, a23_nandinvert, a23_nand;
  
  inv inv1(a5_1,addr[5]);
  inv inv2(a4_1,addr[4]);
  nand2 nand_1(a54_nandinvert, a5_1, a4_1);
  assign nando[0] = a54_nandinvert;
  
  
  nand2 nand_2(a54_nand, addr[5], addr[4]);
  assign nando[1] = a54_nand;
  
  inv inv3(a3_1, addr[3]);
  inv inv4(a2_1, addr[2]);
  nand2 nand_3(a23_nandinvert, a2_1, a3_1);
  assign nando[2] = a23_nandinvert;
  
  nand2 nand4(a23_nand, addr[3],addr[2]);
  assign nando[3] = a23_nand;
  
  nor2 nor_1(pdec0, a54_nandinvert, a23_nandinvert);
  nor2 nor_2(pdec3, a54_nandinvert, a23_nand);
  nor2 nor_3(pdec12, a54_nand, a23_nandinvert);
  nor2 nor_4(pdec15, a54_nand, a23_nand);
 
endmodule

module dassign1_2 (y1, y2, a,b,c,d);
   output y1, y2;
   input a,b,c,d;

   //
   // vvv - Declare your wires here - vvv
   //
  wire nand_ab,nand_ab_invert, nand_abc;
  wire c_invert, nand_cd;
  wire nor_bd, nor_bd_invert;
  wire nand1,nand1_invert;
  


   //
   // vvv - Your structural verilog code here - vvv
   //
  nand2 nand_3input1(nand_ab, a, b);
  inv inv_ab(nand_ab_invert, nand_ab);
  nand2 nand_3input2(nand_abc, nand_ab_invert, c);
  
  inv inv_c(c_invert, c);
  nand2 nand_cd1(nand_cd, c_invert, d);
  
  nor2 nor_bd1(nor_bd, b, d);
  inv nor_bd1_invert(nor_bd_invert, nor_bd);
  
  nand2 nand_3inputfinal(nand1, nand_abc, nand_cd);
  inv nand_3inputfinalinvert(nand1_invert, nand1);
  nand2 nand_123(y1, nand1_invert, nor_bd_invert);
  
   //
   // vvv - Your declarative verilog code here - vvv
   //
  
  assign y2 = ~(~((a & b) & c) & ~(~c&d)  &((b|d)));
  

   
endmodule // dassign1_2


module mux21(y, i0, i1, sel);
   output y;
   input  i0, i1,sel;

   //sel = 1 choose a, otherwise b)
   assign y = (sel) ? i1 : i0;
endmodule // mux21

module dassign1_3 (pos, pos3, ascii);
   input [6:0] ascii;
   
   output [4:0] pos;
   output 	pos3;


   //
   // vvv - Declare your reg and wires here - vvv
   //
   reg [4:0] 	pos;
   wire 	pos3;
   
   //
   // vvv - Your procedural verilog (case) code here - vvv
   //
   always @(ascii) begin
     case(ascii)
       97 : pos = 5'b00001;
       98 : pos = 5'b00010;
       99 : pos = 5'b00011;
       100 : pos = 5'b00100;
       101 : pos = 5'b00101;
       102 : pos = 5'b00110;
       103 : pos = 5'b00111;
       104 : pos = 5'b01000;
       105 : pos = 5'b01001;
       106 : pos = 5'b01010;
       107 : pos = 5'b01011;
       108 : pos = 5'b01100;
       109 : pos = 5'b01101;
       110 : pos = 5'b01110;
       111 : pos = 5'b01111;
       112 : pos = 5'b10000;
       113 : pos = 5'b10001;
       114 : pos = 5'b10010;
       115 : pos = 5'b10011;
       116 : pos = 5'b10100;
       117 : pos = 5'b10101;
       118 : pos = 5'b10110;
       119 : pos = 5'b10111;
       120 : pos = 5'b11000;
       121 : pos = 5'b11001;
       122 : pos = 5'b11010;
       46 : pos = 5'b11110;
       44 : pos = 5'b11101;
       63 : pos = 5'b11111;
       default: pos = 5'b00000;
     endcase
       

   end
   
   //
   // vvv - Your structural verilog code here for pos3 - vvv
   //
  
  mux21 mutex1(pos3,ascii[3],ascii[3],1);
  
   
endmodule // dassign1_3

