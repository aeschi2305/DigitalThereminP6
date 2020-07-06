
module Test_1kHz (
	aud_bclk_export,
	aud_dacdat_export,
	aud_daclrck_export,
	audio_and_video_config_0_external_interface_SDAT,
	audio_and_video_config_0_external_interface_SCLK,
	clk_clk,
	reset_reset_n);	

	inout		aud_bclk_export;
	output		aud_dacdat_export;
	inout		aud_daclrck_export;
	inout		audio_and_video_config_0_external_interface_SDAT;
	output		audio_and_video_config_0_external_interface_SCLK;
	input		clk_clk;
	input		reset_reset_n;
endmodule
