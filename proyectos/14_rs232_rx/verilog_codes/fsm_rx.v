// Author: Julisa Verdejo Palacios
// Name: fsm_rx.v
//
// Description:

module fsm_rx (
  input      rst_i,
  input      clk_i,
  input      rx_i,
  input      baud_flag_i,
  input      cnt_flag_i,
  output reg en_baud_o,
  output reg en_sipo_o,
  output reg en_cnt_o,
  output reg en_pipo_o,  
  output reg eor_o
  //output [3:0] estado_o
);

  localparam [8:0] s0  = 9'b000000001,
                   s1  = 9'b000000010,
                   s2  = 9'b000000100,
                   s3  = 9'b000001000,
                   s4  = 9'b000010000,
                   s5  = 9'b000100000,
                   s6  = 9'b001000000,
                   s7  = 9'b010000000,
                   s8  = 9'b100000000;
                   //s9  = 4'b1001;

  reg [8:0] present_state, next_state;
  //assign estado_o = present_state;
  // Logica de proximo estado y decodificacion de salida
  always @(rx_i, baud_flag_i, cnt_flag_i, present_state) begin
    {en_baud_o, en_sipo_o, en_cnt_o, en_pipo_o, eor_o} = 5'b10000;
    next_state = present_state;
    case (present_state)
      s0 : begin
             {en_baud_o, en_sipo_o, en_cnt_o, en_pipo_o, eor_o} = 5'b00001;
             if (~rx_i)
               next_state = s1;
           end
      s1 : begin 
             if (baud_flag_i)
               next_state = s2;
           end
      s2 : begin 
             if (baud_flag_i)
               next_state = s3;
           end
      s3 : begin 
             {en_baud_o, en_sipo_o, en_cnt_o, en_pipo_o, eor_o} = 5'b11000;
             next_state = s4;
           end
      s4 : begin 
             if (baud_flag_i)
               next_state = s5;
           end
      s5 : begin
             if (baud_flag_i) begin
               if (cnt_flag_i) begin
                 next_state = s7;
               end else begin
                 next_state = s6;
               end
             end
           end
      s6 : begin
             {en_baud_o, en_sipo_o, en_cnt_o, en_pipo_o, eor_o} = 5'b10100;
             next_state = s1;
           end
      s7 : begin
             {en_baud_o, en_sipo_o, en_cnt_o, en_pipo_o, eor_o} = 5'b00110;
             next_state = s8;
           end
      s8 : begin
             {en_baud_o, en_sipo_o, en_cnt_o, en_pipo_o, eor_o} = 5'b00000;
             if (rx_i)
               next_state = s0;
           end
    endcase 
  end

  // Registro de estado
  always @(posedge clk_i, posedge rst_i) begin
    if (rst_i)
      present_state <= s0;
    else
      present_state <= next_state;
  end

endmodule