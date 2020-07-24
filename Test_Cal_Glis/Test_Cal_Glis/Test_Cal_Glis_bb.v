
module Test_Cal_Glis (
	bclk_export,
	clk_clk,
	dacdat_export,
	daclrc_export,
	freq_up_down_export,
	i2c_SDAT,
	i2c_SCLK,
	reset_reset_n,
	square_freq_export,
	xck_clk,
	cal_glis_export);	

	input		bclk_export;
	input		clk_clk;
	output		dacdat_export;
	input		daclrc_export;
	input	[1:0]	freq_up_down_export;
	inout		i2c_SDAT;
	output		i2c_SCLK;
	input		reset_reset_n;
	input		square_freq_export;
	output		xck_clk;
	inout	[1:0]	cal_glis_export;
endmodule
