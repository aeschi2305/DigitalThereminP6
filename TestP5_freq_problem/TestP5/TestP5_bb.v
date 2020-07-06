
module TestP5 (
	audio_0_external_interface_BCLK,
	audio_0_external_interface_DACDAT,
	audio_0_external_interface_DACLRCK,
	audio_and_video_config_0_external_interface_SDAT,
	audio_and_video_config_0_external_interface_SCLK,
	clk_clk,
	daclrc_export,
	reset_reset_n,
	square_freq_export,
	freq_up_down_export);	

	input		audio_0_external_interface_BCLK;
	output		audio_0_external_interface_DACDAT;
	input		audio_0_external_interface_DACLRCK;
	inout		audio_and_video_config_0_external_interface_SDAT;
	output		audio_and_video_config_0_external_interface_SCLK;
	input		clk_clk;
	input		daclrc_export;
	input		reset_reset_n;
	input		square_freq_export;
	inout	[1:0]	freq_up_down_export;
endmodule
