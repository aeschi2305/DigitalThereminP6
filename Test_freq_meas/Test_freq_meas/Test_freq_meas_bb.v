
module Test_freq_meas (
	audio_i2c_SDAT,
	audio_i2c_SCLK,
	audio_serializer_bclk_export,
	audio_serializer_dacdat_export,
	audio_serializer_daclrck_export,
	clk_clk,
	reset_reset_n,
	square_freq_export,
	square_up_down_export,
	xck_clk);	

	inout		audio_i2c_SDAT;
	output		audio_i2c_SCLK;
	input		audio_serializer_bclk_export;
	output		audio_serializer_dacdat_export;
	input		audio_serializer_daclrck_export;
	input		clk_clk;
	input		reset_reset_n;
	inout		square_freq_export;
	input	[1:0]	square_up_down_export;
	output		xck_clk;
endmodule
