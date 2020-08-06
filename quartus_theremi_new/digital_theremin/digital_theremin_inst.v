	digital_theremin u0 (
		.aud_xck_clk                                      (<connected-to-aud_xck_clk>),                                      //                                     aud_xck.clk
		.audio_and_video_config_0_external_interface_SDAT (<connected-to-audio_and_video_config_0_external_interface_SDAT>), // audio_and_video_config_0_external_interface.SDAT
		.audio_and_video_config_0_external_interface_SCLK (<connected-to-audio_and_video_config_0_external_interface_SCLK>), //                                            .SCLK
		.clk_clk                                          (<connected-to-clk_clk>),                                          //                                         clk.clk
		.dram_cntrl_wire_addr                             (<connected-to-dram_cntrl_wire_addr>),                             //                             dram_cntrl_wire.addr
		.dram_cntrl_wire_ba                               (<connected-to-dram_cntrl_wire_ba>),                               //                                            .ba
		.dram_cntrl_wire_cas_n                            (<connected-to-dram_cntrl_wire_cas_n>),                            //                                            .cas_n
		.dram_cntrl_wire_cke                              (<connected-to-dram_cntrl_wire_cke>),                              //                                            .cke
		.dram_cntrl_wire_cs_n                             (<connected-to-dram_cntrl_wire_cs_n>),                             //                                            .cs_n
		.dram_cntrl_wire_dq                               (<connected-to-dram_cntrl_wire_dq>),                               //                                            .dq
		.dram_cntrl_wire_dqm                              (<connected-to-dram_cntrl_wire_dqm>),                              //                                            .dqm
		.dram_cntrl_wire_ras_n                            (<connected-to-dram_cntrl_wire_ras_n>),                            //                                            .ras_n
		.dram_cntrl_wire_we_n                             (<connected-to-dram_cntrl_wire_we_n>),                             //                                            .we_n
		.i2s_coe_aud1_bclk                                (<connected-to-i2s_coe_aud1_bclk>),                                //                                         i2s.coe_aud1_bclk
		.i2s_coe_aud2_dacdat                              (<connected-to-i2s_coe_aud2_dacdat>),                              //                                            .coe_aud2_dacdat
		.i2s_coe_aud3_daclrck                             (<connected-to-i2s_coe_aud3_daclrck>),                             //                                            .coe_aud3_daclrck
		.lcd_controller_conduit_end_lt24_cs               (<connected-to-lcd_controller_conduit_end_lt24_cs>),               //                  lcd_controller_conduit_end.lt24_cs
		.lcd_controller_conduit_end_lt24_data             (<connected-to-lcd_controller_conduit_end_lt24_data>),             //                                            .lt24_data
		.lcd_controller_conduit_end_lt24_rd               (<connected-to-lcd_controller_conduit_end_lt24_rd>),               //                                            .lt24_rd
		.lcd_controller_conduit_end_lt24_wr               (<connected-to-lcd_controller_conduit_end_lt24_wr>),               //                                            .lt24_wr
		.lcd_controller_conduit_end_lt24_rs               (<connected-to-lcd_controller_conduit_end_lt24_rs>),               //                                            .lt24_rs
		.lcd_reset_n_external_connection_export           (<connected-to-lcd_reset_n_external_connection_export>),           //             lcd_reset_n_external_connection.export
		.pitch_in_coe_square_freq                         (<connected-to-pitch_in_coe_square_freq>),                         //                                    pitch_in.coe_square_freq
		.pitch_in_coe_freq_up_down                        (<connected-to-pitch_in_coe_freq_up_down>),                        //                                            .coe_freq_up_down
		.pitch_in_coe_cal_glis                            (<connected-to-pitch_in_coe_cal_glis>),                            //                                            .coe_cal_glis
		.reset_reset_n                                    (<connected-to-reset_reset_n>),                                    //                                       reset.reset_n
		.sdram_clk_clk                                    (<connected-to-sdram_clk_clk>),                                    //                                   sdram_clk.clk
		.touch_panel_busy_external_connection_export      (<connected-to-touch_panel_busy_external_connection_export>),      //        touch_panel_busy_external_connection.export
		.touch_panel_pen_irq_n_external_connection_export (<connected-to-touch_panel_pen_irq_n_external_connection_export>), //   touch_panel_pen_irq_n_external_connection.export
		.touch_panel_spi_external_MISO                    (<connected-to-touch_panel_spi_external_MISO>),                    //                    touch_panel_spi_external.MISO
		.touch_panel_spi_external_MOSI                    (<connected-to-touch_panel_spi_external_MOSI>),                    //                                            .MOSI
		.touch_panel_spi_external_SCLK                    (<connected-to-touch_panel_spi_external_SCLK>),                    //                                            .SCLK
		.touch_panel_spi_external_SS_n                    (<connected-to-touch_panel_spi_external_SS_n>),                    //                                            .SS_n
		.volume_in_coe_square_freq                        (<connected-to-volume_in_coe_square_freq>),                        //                                   volume_in.coe_square_freq
		.volume_in_coe_freq_up_down                       (<connected-to-volume_in_coe_freq_up_down>)                        //                                            .coe_freq_up_down
	);

