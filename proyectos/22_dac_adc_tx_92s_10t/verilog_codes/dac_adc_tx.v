// Author: Julisa Verdejo Palacios
// Name: spi_write.v
//
// Description: Instanciacion de todos los modulos utilizados para la escritura.

module dac_adc_tx (
  input   rst_i,
  input   clk_i,
  input   button_i,
  input   miso_adc_i,
  output  mosi_dac_o,
  output  dclk_o,
  output  cs_dac_o,
  output  mosi_adc_o,
  output  sck_o,
  output  cs_adc_o,
  output  tx_o,
  output  eos_o
);

  wire start;
  wire eodac, eoadc, eotx;
  wire stdac, stadc, stx;
  wire we, sel, flag;
  wire [7:0] addr, count;
  wire [1:0] opc1, opc2;
  wire [11:0] romout, dataram, doutram;
  wire [7:0] dmsb, dlsb, data;
  
  localparam [28:0] k_i   = 29'd499999999;  // 5 seg
  //Configuraciones DAC
  localparam  [3:0] ctrl = 4'b0011; // DAC-A
  //localparam  [7:0] kmax_dac = 8'd7; //160ns
  localparam  [7:0] kmax_dac = 8'd8; //180ns
  
  //Configuraciones ADC
  localparam cmd = 8'b10010111; //Ch0
  //localparam  [7:0] kmax_adc = 8'd39; // Periodo dclk = 800ns
  localparam  [7:0] kmax_adc = 8'd59; // Periodo dclk = 1200ns
  
  //Configuraciones RS232_TX
  localparam [14:0] baud = 15'd867;
  localparam psel = 1'b0;
  assign dmsb = {4'b0000, doutram[11:8]};
  assign dlsb = doutram[7:0];
 
  single_tick #(.Width(29)) mod_tick (
    .rst_i(rst_i),
    .clk_i(clk_i),
    .k_i(k_i),
    .button_i(button_i),
    .start_o(start)
  );
  
  fsm_dac_adc_tx  mod_fsm_dac_adc_tx (
    .rst_i(rst_i),
    .clk_i(clk_i),
	.start_i(start),
	.eodac_i(eodac),
	.eoadc_i(eoadc),
	.eotx_i(eotx),
	.flag_i(flag),
	.stdac_o(stdac),
	.stadc_o(stadc),
	.stx_o(stx),
	.opc1_o(opc1),
	.opc2_o(opc2),
	.we_o(we),
	.sel_o(sel),
	.eos_o(eos_o)
  );
  
  spi_write_dac  mod_spi_write_dac (
    .rst_i(rst_i),
    .clk_i(clk_i),
	.strw_i(stdac),
	.kmax_i(kmax_dac),
	.din_i({ctrl,romout}),
	.mosi_o(mosi_dac_o),
	.sck_o(sck_o),
	.cs_o(cs_dac_o),
	.eow_o(eodac)
  ); 
	
  spi_wr_adc  mod_spi_wr_adc (
    .rst_i(rst_i),
    .clk_i(clk_i),
	.strc_i(stadc),
	.cmd_i(cmd),
	.kmax_i(kmax_adc),
	.miso_i(miso_adc_i),
	.mosi_o(mosi_adc_o),
	.dout_o(dataram),
	.dclk_o(dclk_o),
	.cs_o(cs_adc_o),
	.eoc_o(eoadc)
  ); 
  
  rs232_tx #(.Width(15)) mod_rs232_tx (
    .rst_i(rst_i),
    .clk_i(clk_i),
    .st_i(stx),
	.d_i(data),
	.baud_i(baud),
	.psel_i(psel),
	.tx_o(tx_o),
	.eot_o(eotx)
  );
 
  ram_volts       #(.Width(12)) mod_ram_volts (.clk_i(clk_i), .we_i(we), .addr_i(addr), .dinram_i(dataram), .doutram_o(doutram));
  
  mux_ch         #(.Width(8))   mod_mux_ch    (.sel_i(sel), .dmsb_i(dmsb), .dlsb_i(dlsb), .data_o(data));
  
  counter_volts   #(.Width(12)) mod_cnt_volts (.rst_i(rst_i), .clk_i(clk_i), .opc1_i(opc1), .count_o(count));
  
  counter_address #(.Width(8))  mod_cnt_addr  (.rst_i(rst_i), .clk_i(clk_i), .opc2_i(opc2), .count_o(addr), .flag_o(flag));
  
  rom_volts mod_rom (.addr_i(count), .rom_o(romout));


endmodule