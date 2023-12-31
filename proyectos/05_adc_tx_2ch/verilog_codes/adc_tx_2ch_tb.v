// Author: Julisa Verdejo Palacios
// Name: adc_tx_tb.v
//
// Description: Testbench del modulo top.

`timescale 1 ns / 100 ps
`include "adc_tx_2ch.v"
`include "single_tick.v"
`include "timer.v"
`include "fsm_tick.v"
`include "fsm_adc_tx.v"
`include "spi_two_ch.v"
`include "fsm_adc_2ch.v"
`include "mux_ch.v"
`include "spi_wr.v"
`include "spi_write.v"
`include "piso_reg.v"
`include "counter_w.v"
`include "clk_div.v"
`include "fsm_spiw.v"
`include "spi_read.v"
`include "counter_r.v"
`include "sipo_reg.v"
`include "pipo_reg.v"
`include "fsm_spir.v"
`include "mux_data.v"
`include "rs232_tx.v"
`include "mux_tx.v"
`include "parity.v"
`include "fsm_tx.v"
`include "freq_div.v"


module adc_tx_2ch_tb();
  reg   rst;
  reg   clk;
  reg   button;
  reg   miso;
  wire  mosi;
  wire  dclk;
  wire  cs;
  wire  tx;
  wire  eoa;

  adc_tx_2ch dut (
  .rst_i(rst),
  .clk_i(clk),
  .button_i(button),
  .miso_i(miso),
  .mosi_o(mosi),
  .dclk_o(dclk),
  .cs_o(cs),
  .tx_o(tx),
  .eoa_o(eoa)
  );

  // Generador de reloj de 100 MHz con duty-cycle de 50 %
  always #5 clk = ~clk;

  // Secuencia de reset y condiciones iniciales
  initial begin
    clk = 0; rst = 1; button = 0;  miso = 1; #10;
             rst = 0;                        #10;
  end

  initial begin 
    // Configuracion de archivos de salida
    $dumpfile("adc_tx_2ch_tb.vcd");
    $dumpvars(0,adc_tx_2ch_tb);
    
    // Sincronizacion
    #30;

    //Estimulos de prueba
    button = 1; #10;
    button = 0; #10;
    
    // Esperar que acabe el spi
    #(10*40*60);

    // Esperar que acabe la transmision
    #(10*10415*12);

    // Esperar que acabe la transmision
    #(10*10415*12);
    
    $display("Test completed");
    $finish;
  end

endmodule