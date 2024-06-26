// Author: Julisa Verdejo Palacios
// Name: spi_read.v
//
// Description: Instanciacion de todos los modulos utilizados en la lectura del ADC.

module spi_read_adc (     
  input         rst_i,
  input         clk_i,
  input         strr_i,
  input         miso_i,
  input         slow_clk_i,
  output [11:0] dout_o,
  output        eor_o
);

  wire [5:0] cnt;
  wire [1:0] opc1, opc2;
  wire [15:0] data;
  wire hab;
  
  counter_r_adc  #(.Width(6))  mod_cnt_r  (.rst_i(rst_i), .clk_i(clk_i), .opc_i(opc1), .cnt_o(cnt));
  sipo_reg_adc   #(.Width(16)) mod_sipo   (.rst_i(rst_i), .clk_i(clk_i), .din_i(miso_i), .op_i(opc2), .dout_o(data));
  pipo_reg_adc   #(.Width(12)) mod_pipo   (.rst_i(rst_i), .clk_i(clk_i), .hab_i(hab), .din_i(data[15:4]), .dout_o(dout_o)); 
  
  fsm_spir_adc mod_fsm (  
    .rst_i(rst_i), 
    .clk_i(clk_i), 
    .strr_i(strr_i), 
    .slow_clk_i(slow_clk_i), 
    .cnt_i(cnt), 
    .opc1_o(opc1), 
    .opc2_o(opc2), 
    .eor_o(eor_o), 
    .hab_o(hab)
  );
  
endmodule  