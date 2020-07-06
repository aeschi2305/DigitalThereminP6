	Test_1kHz u0 (
		.aud_bclk_export                                  (<connected-to-aud_bclk_export>),                                  //                                    aud_bclk.export
		.aud_dacdat_export                                (<connected-to-aud_dacdat_export>),                                //                                  aud_dacdat.export
		.aud_daclrck_export                               (<connected-to-aud_daclrck_export>),                               //                                 aud_daclrck.export
		.audio_and_video_config_0_external_interface_SDAT (<connected-to-audio_and_video_config_0_external_interface_SDAT>), // audio_and_video_config_0_external_interface.SDAT
		.audio_and_video_config_0_external_interface_SCLK (<connected-to-audio_and_video_config_0_external_interface_SCLK>), //                                            .SCLK
		.clk_clk                                          (<connected-to-clk_clk>),                                          //                                         clk.clk
		.reset_reset_n                                    (<connected-to-reset_reset_n>)                                     //                                       reset.reset_n
	);

