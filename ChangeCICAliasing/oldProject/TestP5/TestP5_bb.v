
module TestP5 (
	audio_and_video_config_0_external_interface_SDAT,
	audio_and_video_config_0_external_interface_SCLK,
	audio_serializer_0_conduit_bclk_export,
	audio_serializer_0_conduit_dacdat_export,
	audio_serializer_0_conduit_daclrck_export,
	clk_clk,
	reset_reset_n,
	freq_up_down_export,
	square_freq_export,
	xck_clk);	

	inout		audio_and_video_config_0_external_interface_SDAT;
	output		audio_and_video_config_0_external_interface_SCLK;
	input		audio_serializer_0_conduit_bclk_export;
	output		audio_serializer_0_conduit_dacdat_export;
	input		audio_serializer_0_conduit_daclrck_export;
	input		clk_clk;
	input		reset_reset_n;
	input	[1:0]	freq_up_down_export;
	input		square_freq_export;
	output		xck_clk;
endmodule
