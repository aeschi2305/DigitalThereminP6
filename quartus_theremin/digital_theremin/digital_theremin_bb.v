
module digital_theremin (
	aud_xck_clk,
	audio_and_video_config_0_external_interface_SDAT,
	audio_and_video_config_0_external_interface_SCLK,
	clk_clk,
	dram_cntrl_wire_addr,
	dram_cntrl_wire_ba,
	dram_cntrl_wire_cas_n,
	dram_cntrl_wire_cke,
	dram_cntrl_wire_cs_n,
	dram_cntrl_wire_dq,
	dram_cntrl_wire_dqm,
	dram_cntrl_wire_ras_n,
	dram_cntrl_wire_we_n,
	i2s_coe_aud1_bclk,
	i2s_coe_aud2_dacdat,
	i2s_coe_aud3_daclrck,
	lcd_controller_conduit_end_lt24_cs,
	lcd_controller_conduit_end_lt24_data,
	lcd_controller_conduit_end_lt24_rd,
	lcd_controller_conduit_end_lt24_wr,
	lcd_controller_conduit_end_lt24_rs,
	lcd_reset_n_external_connection_export,
	pitch_in_coe_square_freq,
	pitch_in_coe_freq_up_down,
	pitch_in_coe_cal_glis,
	reset_reset_n,
	sdram_clk_clk,
	touch_panel_busy_external_connection_export,
	touch_panel_pen_irq_n_external_connection_export,
	touch_panel_spi_external_MISO,
	touch_panel_spi_external_MOSI,
	touch_panel_spi_external_SCLK,
	touch_panel_spi_external_SS_n,
	volume_in_coe_square_freq,
	volume_in_coe_freq_up_down);	

	output		aud_xck_clk;
	inout		audio_and_video_config_0_external_interface_SDAT;
	output		audio_and_video_config_0_external_interface_SCLK;
	input		clk_clk;
	output	[12:0]	dram_cntrl_wire_addr;
	output	[1:0]	dram_cntrl_wire_ba;
	output		dram_cntrl_wire_cas_n;
	output		dram_cntrl_wire_cke;
	output		dram_cntrl_wire_cs_n;
	inout	[15:0]	dram_cntrl_wire_dq;
	output	[1:0]	dram_cntrl_wire_dqm;
	output		dram_cntrl_wire_ras_n;
	output		dram_cntrl_wire_we_n;
	input		i2s_coe_aud1_bclk;
	output		i2s_coe_aud2_dacdat;
	input		i2s_coe_aud3_daclrck;
	output		lcd_controller_conduit_end_lt24_cs;
	output	[15:0]	lcd_controller_conduit_end_lt24_data;
	output		lcd_controller_conduit_end_lt24_rd;
	output		lcd_controller_conduit_end_lt24_wr;
	output		lcd_controller_conduit_end_lt24_rs;
	output		lcd_reset_n_external_connection_export;
	input		pitch_in_coe_square_freq;
	input	[1:0]	pitch_in_coe_freq_up_down;
	input	[1:0]	pitch_in_coe_cal_glis;
	input		reset_reset_n;
	output		sdram_clk_clk;
	input		touch_panel_busy_external_connection_export;
	input		touch_panel_pen_irq_n_external_connection_export;
	input		touch_panel_spi_external_MISO;
	output		touch_panel_spi_external_MOSI;
	output		touch_panel_spi_external_SCLK;
	output		touch_panel_spi_external_SS_n;
	input		volume_in_coe_square_freq;
	input	[1:0]	volume_in_coe_freq_up_down;
endmodule
