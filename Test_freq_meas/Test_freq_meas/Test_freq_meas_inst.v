	Test_freq_meas u0 (
		.audio_i2c_SDAT                  (<connected-to-audio_i2c_SDAT>),                  //                audio_i2c.SDAT
		.audio_i2c_SCLK                  (<connected-to-audio_i2c_SCLK>),                  //                         .SCLK
		.audio_serializer_bclk_export    (<connected-to-audio_serializer_bclk_export>),    //    audio_serializer_bclk.export
		.audio_serializer_dacdat_export  (<connected-to-audio_serializer_dacdat_export>),  //  audio_serializer_dacdat.export
		.audio_serializer_daclrck_export (<connected-to-audio_serializer_daclrck_export>), // audio_serializer_daclrck.export
		.clk_clk                         (<connected-to-clk_clk>),                         //                      clk.clk
		.reset_reset_n                   (<connected-to-reset_reset_n>),                   //                    reset.reset_n
		.square_freq_export              (<connected-to-square_freq_export>),              //              square_freq.export
		.square_up_down_export           (<connected-to-square_up_down_export>),           //           square_up_down.export
		.xck_clk                         (<connected-to-xck_clk>)                          //                      xck.clk
	);

