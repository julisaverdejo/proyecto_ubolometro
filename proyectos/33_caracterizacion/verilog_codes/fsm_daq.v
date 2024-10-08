// Author: Julisa Verdejo Palacios
// Name: .v
//
// Description:

module fsm_daq (
  input             rst_i,
  input             clk_i,
  input             start_i,
  input             eodac_i,
  input             eoadc_i,
  input             eotx_i,
  input             set_i,
  input             flag_i,
  output reg        stdac_o,
  output reg        stadc_o,
  output reg        stx_o,
  output reg        enset_o,
  output reg  [1:0] opc1_o,
  output reg  [1:0] opc2_o,
  output reg        we_o,
  output reg        sel_o,
  output reg        eos_o
);

  localparam [4:0]  s0 = 5'b00000,
                    s1 = 5'b00001,
                    s2 = 5'b00010,
				    s3 = 5'b00011,
				    s4 = 5'b00100,
				    s5 = 5'b00101,
				    s6 = 5'b00110,
				    s7 = 5'b00111,
				    //s8 = 5'b01000,
				    //s9 = 5'b01001,
				   s10 = 5'b01010,
				   s11 = 5'b01011,
				   s12 = 5'b01100,
				   s13 = 5'b01101,
				   s14 = 5'b01110,
				   s15 = 5'b01111,
				   s16 = 5'b10000,
				   s17 = 5'b10001,
				   s18 = 5'b10010,
				   s19 = 5'b10011,
				   s20 = 5'b10100,
				   s21 = 5'b10101;

  reg [4:0] next_state, present_state;

  always @(*) begin
    stdac_o = 1'b0; stadc_o = 1'b0; stx_o = 1'b0; enset_o = 1'b0; opc1_o = 2'b00; opc2_o = 2'b00; we_o = 1'b0; sel_o = 1'b0; eos_o = 1'b1;
    next_state = present_state;
    case(present_state)
       s0: begin
             stdac_o = 1'b0; stadc_o = 1'b0; stx_o = 1'b0; enset_o = 1'b0; opc1_o = 2'b00; opc2_o = 2'b00; we_o = 1'b0; sel_o = 1'b0; eos_o = 1'b1;
             if (start_i)
               next_state = s1;
           end

       s1: begin
             stdac_o = 1'b1; stadc_o = 1'b0; stx_o = 1'b0; enset_o = 1'b0; opc1_o = 2'b01; opc2_o = 2'b01; we_o = 1'b0; sel_o = 1'b0; eos_o = 1'b0;
             next_state = s2;
           end

       s2: begin
             stdac_o = 1'b0; stadc_o = 1'b0; stx_o = 1'b0; enset_o = 1'b0; opc1_o = 2'b01; opc2_o = 2'b01; we_o = 1'b0; sel_o = 1'b0; eos_o = 1'b0;
             if (eodac_i)
               next_state = s3;
           end 

       s3: begin
             stdac_o = 1'b0; stadc_o = 1'b0; stx_o = 1'b0; enset_o = 1'b1; opc1_o = 2'b01; opc2_o = 2'b01; we_o = 1'b0; sel_o = 1'b0; eos_o = 1'b0;
             if (zset_i)
               next_state = s4;
           end

       s4: begin
             stdac_o = 1'b0; stadc_o = 1'b1; stx_o = 1'b0; enset_o = 1'b0; opc1_o = 2'b01; opc2_o = 2'b01; we_o = 1'b0; sel_o = 1'b0; eos_o = 1'b0;
             next_state = s5;
           end

       s5: begin
             stdac_o = 1'b0; stadc_o = 1'b0; stx_o = 1'b0; enset_o = 1'b0; opc1_o = 2'b01; opc2_o = 2'b01; we_o = 1'b0; sel_o = 1'b0; eos_o = 1'b0;
             if (eoadc_i)
			   next_state = s6;
           end

// Fin de secuencia dummie

       s6: begin
             stdac_o = 1'b1; stadc_o = 1'b0; stx_o = 1'b0; enset_o = 1'b0; opc1_o = 2'b01; opc2_o = 2'b01; we_o = 1'b0; sel_o = 1'b0; eos_o = 1'b0;
             next_state = s7;
           end

       s7: begin
             stdac_o = 1'b0; stadc_o = 1'b0; stx_o = 1'b0; enset_o = 1'b0; opc1_o = 2'b01; opc2_o = 2'b01; we_o = 1'b0; sel_o = 1'b0; eos_o = 1'b0;
             if (eodac_i)
               next_state = s10;
           end		  

       //s8: begin
             //stdac_o = 1'b0; stadc_o = 1'b0; stx_o = 1'b0; enset_o = 1'b0; opc1_o = 2'b01; opc2_o = 2'b01; we_o = 1'b0; sel_o = 1'b0; eos_o = 1'b0;
             //next_state = s9;
           //end	

       //s9: begin
             //stdac_o = 1'b0; stadc_o = 1'b0; stx_o = 1'b0; enset_o = 1'b0; opc1_o = 2'b01; opc2_o = 2'b01; we_o = 1'b0; sel_o = 1'b0; eos_o = 1'b0;
             //next_state = s10;
           //end	

       s10: begin
             stdac_o = 1'b0; stadc_o = 1'b1; stx_o = 1'b0; enset_o = 1'b0; opc1_o = 2'b01; opc2_o = 2'b01; we_o = 1'b0; sel_o = 1'b0; eos_o = 1'b0;
             next_state = s11;
           end

       s11: begin
             stdac_o = 1'b0; stadc_o = 1'b0; stx_o = 1'b0; enset_o = 1'b0; opc1_o = 2'b01; opc2_o = 2'b01; we_o = 1'b0; sel_o = 1'b0; eos_o = 1'b0;
             if (eoadc_i)
               next_state = s12;
           end

       s12: begin
             stdac_o = 1'b0; stadc_o = 1'b0; stx_o = 1'b0; enset_o = 1'b0; opc1_o = 2'b01; opc2_o = 2'b01; we_o = 1'b1; sel_o = 1'b0; eos_o = 1'b0;
             next_state = s13;
           end

       s13: begin
             stdac_o = 1'b0; stadc_o = 1'b0; stx_o = 1'b0; enset_o = 1'b0; opc1_o = 2'b10; opc2_o = 2'b10; we_o = 1'b0; sel_o = 1'b0; eos_o = 1'b0;
             next_state = s14;
           end

       s14: begin
             stdac_o = 1'b0; stadc_o = 1'b0; stx_o = 1'b0; enset_o = 1'b0; opc1_o = 2'b01; opc2_o = 2'b01; we_o = 1'b0; sel_o = 1'b0; eos_o = 1'b0;
			 if (flag_i) begin
               next_state = s15;
			 end else begin
			   next_state = s6;
           end

       s15: begin
             stdac_o = 1'b0; stadc_o = 1'b0; stx_o = 1'b0; enset_o = 1'b0; opc1_o = 2'b00; opc2_o = 2'b00; we_o = 1'b0; sel_o = 1'b0; eos_o = 1'b0;
             next_state = s16;
           end

      s16: begin
            stdac_o = 1'b0; stadc_o = 1'b0; stx_o = 1'b1; enset_o = 1'b0; opc1_o = 2'b01; opc2_o = 2'b01; we_o = 1'b0; sel_o = 1'b0; eos_o = 1'b0;
			next_state = s17;
          end

      s17: begin
            stdac_o = 1'b0; stadc_o = 1'b0; stx_o = 1'b0; enset_o = 1'b0; opc1_o = 2'b01; opc2_o = 2'b01; we_o = 1'b0; sel_o = 1'b0; eos_o = 1'b0;
			if (eotx_i)
			  next_state = s18;
          end

      s18: begin
            stdac_o = 1'b0; stadc_o = 1'b0; stx_o = 1'b1; enset_o = 1'b0; opc1_o = 2'b01; opc2_o = 2'b01; we_o = 1'b0; sel_o = 1'b1; eos_o = 1'b0;
			next_state = s19;
          end

      s19: begin
            stdac_o = 1'b0; stadc_o = 1'b0; stx_o = 1'b0; enset_o = 1'b0; opc1_o = 2'b01; opc2_o = 2'b01; we_o = 1'b0; sel_o = 1'b1; eos_o = 1'b0;
			if (eotx_i)
			  next_state = s20;
          end

      s20: begin
            stdac_o = 1'b0; stadc_o = 1'b0; stx_o = 1'b0; enset_o = 1'b0; opc1_o = 2'b01; opc2_o = 2'b10; we_o = 1'b0; sel_o = 1'b0; eos_o = 1'b0;
			next_state = s21;
          end

      s21: begin
            stdac_o = 1'b0; stadc_o = 1'b0; stx_o = 1'b0; enset_o = 1'b0; opc1_o = 2'b01; opc2_o = 2'b01; we_o = 1'b0; sel_o = 1'b0; eos_o = 1'b0;
			if (flag_i) begin
			  next_state = s0;
			end else begin
			  next_state = s16;
			end
          end

      default:  begin
                  next_state = s0;
                end
    endcase
  end   

  always @(posedge clk_i, posedge rst_i) begin
    if (rst_i)
      present_state <= s0;
    else
      present_state <= next_state;
  end
  
endmodule