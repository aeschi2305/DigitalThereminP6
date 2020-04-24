	system u0 (
		.clk_clk                                          (<connected-to-clk_clk>),                                          //                                       clk.clk
		.dram_ctrl_wire_addr                              (<connected-to-dram_ctrl_wire_addr>),                              //                            dram_ctrl_wire.addr
		.dram_ctrl_wire_ba                                (<connected-to-dram_ctrl_wire_ba>),                                //                                          .ba
		.dram_ctrl_wire_cas_n                             (<connected-to-dram_ctrl_wire_cas_n>),                             //                                          .cas_n
		.dram_ctrl_wire_cke                               (<connected-to-dram_ctrl_wire_cke>),                               //                                          .cke
		.dram_ctrl_wire_cs_n                              (<connected-to-dram_ctrl_wire_cs_n>),                              //                                          .cs_n
		.dram_ctrl_wire_dq                                (<connected-to-dram_ctrl_wire_dq>),                                //                                          .dq
		.dram_ctrl_wire_dqm                               (<connected-to-dram_ctrl_wire_dqm>),                               //                                          .dqm
		.dram_ctrl_wire_ras_n                             (<connected-to-dram_ctrl_wire_ras_n>),                             //                                          .ras_n
		.dram_ctrl_wire_we_n                              (<connected-to-dram_ctrl_wire_we_n>),                              //                                          .we_n
		.lcd_controller_conduit_end_lt24_cs               (<connected-to-lcd_controller_conduit_end_lt24_cs>),               //                lcd_controller_conduit_end.lt24_cs
		.lcd_controller_conduit_end_lt24_data             (<connected-to-lcd_controller_conduit_end_lt24_data>),             //                                          .lt24_data
		.lcd_controller_conduit_end_lt24_rd               (<connected-to-lcd_controller_conduit_end_lt24_rd>),               //                                          .lt24_rd
		.lcd_controller_conduit_end_lt24_wr               (<connected-to-lcd_controller_conduit_end_lt24_wr>),               //                                          .lt24_wr
		.lcd_controller_conduit_end_lt24_rs               (<connected-to-lcd_controller_conduit_end_lt24_rs>),               //                                          .lt24_rs
		.lcd_reset_n_external_connection_export           (<connected-to-lcd_reset_n_external_connection_export>),           //           lcd_reset_n_external_connection.export
		.reset_reset_n                                    (<connected-to-reset_reset_n>),                                    //                                     reset.reset_n
		.touch_panel_busy_external_connection_export      (<connected-to-touch_panel_busy_external_connection_export>),      //      touch_panel_busy_external_connection.export
		.touch_panel_pen_irq_n_external_connection_export (<connected-to-touch_panel_pen_irq_n_external_connection_export>), // touch_panel_pen_irq_n_external_connection.export
		.touch_panel_spi_external_MISO                    (<connected-to-touch_panel_spi_external_MISO>),                    //                  touch_panel_spi_external.MISO
		.touch_panel_spi_external_MOSI                    (<connected-to-touch_panel_spi_external_MOSI>),                    //                                          .MOSI
		.touch_panel_spi_external_SCLK                    (<connected-to-touch_panel_spi_external_SCLK>),                    //                                          .SCLK
		.touch_panel_spi_external_SS_n                    (<connected-to-touch_panel_spi_external_SS_n>)                     //                                          .SS_n
	);
