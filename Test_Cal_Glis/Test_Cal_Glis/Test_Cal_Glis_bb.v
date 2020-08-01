
module Test_Cal_Glis (
	bclk_export,
	clk_clk,
	dacdat_export,
	daclrc_export,
	i2c_SDAT,
	i2c_SCLK,
	reset_reset_n,
	xck_clk);	

	input		bclk_export;
	input		clk_clk;
	output		dacdat_export;
	input		daclrc_export;
	inout		i2c_SDAT;
	output		i2c_SCLK;
	input		reset_reset_n;
	output		xck_clk;
endmodule
