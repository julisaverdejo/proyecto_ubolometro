// Author: Julisa Verdejo Palacios
// Name: adc_tx_tb.v
//
// Description: Testbench del modulo top.

`timescale 1 ns / 100 ps
`include "spi_write_dac.v"
`include "piso_reg.v"
`include "counter_w.v"
`include "clk_div.v"
`include "fsm_spiw.v"
`include "counter.v"
`include "fsm_sin.v"
`include "rom_sin.v"
`include "spi_dac_sin.v"


module spi_dac_sin_tb();
  reg   rst;
  reg   clk;
  reg   start;
  wire  mosi;
  wire  sck;
  wire  cs;
  wire  end_o;

  spi_dac_sin dut (
    .rst_i(rst),
    .clk_i(clk),
    .start_i(start),
    .mosi_o(mosi),
    .sck_o(sck),
    .cs_o(cs),
    .end_o(end_o)
  );

  // Generador de reloj de 100 MHz con duty-cycle de 50 %
  always #5 clk = ~clk;

  // Secuencia de reset y condiciones iniciales
  initial begin
    clk = 0; rst = 1; start = 0;  #10;
             rst = 0;              #10;
  end

  initial begin 
    // Configuracion de archivos de salida
    $dumpfile("spi_dac_sin_tb.vcd");
    $dumpvars(0,spi_dac_sin_tb);
    
    // Sincronizacion
    #30;

    //Estimulos de prueba
    start = 1; #10;
    start = 0; #10;
    
    // Esperar que acabe el spi
    #(2000*1024);

    
    $display("Test completed");
    $finish;
  end

endmodule