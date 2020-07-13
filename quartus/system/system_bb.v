
module system (
	clk_clk,
	dram_ctrl_wire_addr,
	dram_ctrl_wire_ba,
	dram_ctrl_wire_cas_n,
	dram_ctrl_wire_cke,
	dram_ctrl_wire_cs_n,
	dram_ctrl_wire_dq,
	dram_ctrl_wire_dqm,
	dram_ctrl_wire_ras_n,
	dram_ctrl_wire_we_n,
	lcd_controller_conduit_end_lt24_cs,
	lcd_controller_conduit_end_lt24_data,
	lcd_controller_conduit_end_lt24_rd,
	lcd_controller_conduit_end_lt24_wr,
	lcd_controller_conduit_end_lt24_rs,
	lcd_reset_n_external_connection_export,
	reset_reset_n,
	sdram_clk_clk,
	touch_panel_busy_external_connection_export,
	touch_panel_pen_irq_n_external_connection_export,
	touch_panel_spi_external_MISO,
	touch_panel_spi_external_MOSI,
	touch_panel_spi_external_SCLK,
	touch_panel_spi_external_SS_n);	

	input		clk_clk;
	output	[12:0]	dram_ctrl_wire_addr;
	output	[1:0]	dram_ctrl_wire_ba;
	output		dram_ctrl_wire_cas_n;
	output		dram_ctrl_wire_cke;
	output		dram_ctrl_wire_cs_n;
	inout	[15:0]	dram_ctrl_wire_dq;
	output	[1:0]	dram_ctrl_wire_dqm;
	output		dram_ctrl_wire_ras_n;
	output		dram_ctrl_wire_we_n;
	output		lcd_controller_conduit_end_lt24_cs;
	output	[15:0]	lcd_controller_conduit_end_lt24_data;
	output		lcd_controller_conduit_end_lt24_rd;
	output		lcd_controller_conduit_end_lt24_wr;
	output		lcd_controller_conduit_end_lt24_rs;
	output		lcd_reset_n_external_connection_export;
	input		reset_reset_n;
	output		sdram_clk_clk;
	input		touch_panel_busy_external_connection_export;
	input		touch_panel_pen_irq_n_external_connection_export;
	input		touch_panel_spi_external_MISO;
	output		touch_panel_spi_external_MOSI;
	output		touch_panel_spi_external_SCLK;
	output		touch_panel_spi_external_SS_n;
endmodule
