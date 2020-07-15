	component system is
		port (
			clk_clk                                          : in    std_logic                     := 'X';             -- clk
			dram_ctrl_wire_addr                              : out   std_logic_vector(12 downto 0);                    -- addr
			dram_ctrl_wire_ba                                : out   std_logic_vector(1 downto 0);                     -- ba
			dram_ctrl_wire_cas_n                             : out   std_logic;                                        -- cas_n
			dram_ctrl_wire_cke                               : out   std_logic;                                        -- cke
			dram_ctrl_wire_cs_n                              : out   std_logic;                                        -- cs_n
			dram_ctrl_wire_dq                                : inout std_logic_vector(15 downto 0) := (others => 'X'); -- dq
			dram_ctrl_wire_dqm                               : out   std_logic_vector(1 downto 0);                     -- dqm
			dram_ctrl_wire_ras_n                             : out   std_logic;                                        -- ras_n
			dram_ctrl_wire_we_n                              : out   std_logic;                                        -- we_n
			lcd_controller_conduit_end_lt24_cs               : out   std_logic;                                        -- lt24_cs
			lcd_controller_conduit_end_lt24_data             : out   std_logic_vector(15 downto 0);                    -- lt24_data
			lcd_controller_conduit_end_lt24_rd               : out   std_logic;                                        -- lt24_rd
			lcd_controller_conduit_end_lt24_wr               : out   std_logic;                                        -- lt24_wr
			lcd_controller_conduit_end_lt24_rs               : out   std_logic;                                        -- lt24_rs
			lcd_reset_n_external_connection_export           : out   std_logic;                                        -- export
			reset_reset_n                                    : in    std_logic                     := 'X';             -- reset_n
			sdram_clk_clk                                    : out   std_logic;                                        -- clk
			touch_panel_busy_external_connection_export      : in    std_logic                     := 'X';             -- export
			touch_panel_pen_irq_n_external_connection_export : in    std_logic                     := 'X';             -- export
			touch_panel_spi_external_MISO                    : in    std_logic                     := 'X';             -- MISO
			touch_panel_spi_external_MOSI                    : out   std_logic;                                        -- MOSI
			touch_panel_spi_external_SCLK                    : out   std_logic;                                        -- SCLK
			touch_panel_spi_external_SS_n                    : out   std_logic;                                        -- SS_n
			audio_and_video_config_0_external_interface_SDAT : inout std_logic                     := 'X';             -- SDAT
			audio_and_video_config_0_external_interface_SCLK : out   std_logic                                         -- SCLK
		);
	end component system;

	u0 : component system
		port map (
			clk_clk                                          => CONNECTED_TO_clk_clk,                                          --                                         clk.clk
			dram_ctrl_wire_addr                              => CONNECTED_TO_dram_ctrl_wire_addr,                              --                              dram_ctrl_wire.addr
			dram_ctrl_wire_ba                                => CONNECTED_TO_dram_ctrl_wire_ba,                                --                                            .ba
			dram_ctrl_wire_cas_n                             => CONNECTED_TO_dram_ctrl_wire_cas_n,                             --                                            .cas_n
			dram_ctrl_wire_cke                               => CONNECTED_TO_dram_ctrl_wire_cke,                               --                                            .cke
			dram_ctrl_wire_cs_n                              => CONNECTED_TO_dram_ctrl_wire_cs_n,                              --                                            .cs_n
			dram_ctrl_wire_dq                                => CONNECTED_TO_dram_ctrl_wire_dq,                                --                                            .dq
			dram_ctrl_wire_dqm                               => CONNECTED_TO_dram_ctrl_wire_dqm,                               --                                            .dqm
			dram_ctrl_wire_ras_n                             => CONNECTED_TO_dram_ctrl_wire_ras_n,                             --                                            .ras_n
			dram_ctrl_wire_we_n                              => CONNECTED_TO_dram_ctrl_wire_we_n,                              --                                            .we_n
			lcd_controller_conduit_end_lt24_cs               => CONNECTED_TO_lcd_controller_conduit_end_lt24_cs,               --                  lcd_controller_conduit_end.lt24_cs
			lcd_controller_conduit_end_lt24_data             => CONNECTED_TO_lcd_controller_conduit_end_lt24_data,             --                                            .lt24_data
			lcd_controller_conduit_end_lt24_rd               => CONNECTED_TO_lcd_controller_conduit_end_lt24_rd,               --                                            .lt24_rd
			lcd_controller_conduit_end_lt24_wr               => CONNECTED_TO_lcd_controller_conduit_end_lt24_wr,               --                                            .lt24_wr
			lcd_controller_conduit_end_lt24_rs               => CONNECTED_TO_lcd_controller_conduit_end_lt24_rs,               --                                            .lt24_rs
			lcd_reset_n_external_connection_export           => CONNECTED_TO_lcd_reset_n_external_connection_export,           --             lcd_reset_n_external_connection.export
			reset_reset_n                                    => CONNECTED_TO_reset_reset_n,                                    --                                       reset.reset_n
			sdram_clk_clk                                    => CONNECTED_TO_sdram_clk_clk,                                    --                                   sdram_clk.clk
			touch_panel_busy_external_connection_export      => CONNECTED_TO_touch_panel_busy_external_connection_export,      --        touch_panel_busy_external_connection.export
			touch_panel_pen_irq_n_external_connection_export => CONNECTED_TO_touch_panel_pen_irq_n_external_connection_export, --   touch_panel_pen_irq_n_external_connection.export
			touch_panel_spi_external_MISO                    => CONNECTED_TO_touch_panel_spi_external_MISO,                    --                    touch_panel_spi_external.MISO
			touch_panel_spi_external_MOSI                    => CONNECTED_TO_touch_panel_spi_external_MOSI,                    --                                            .MOSI
			touch_panel_spi_external_SCLK                    => CONNECTED_TO_touch_panel_spi_external_SCLK,                    --                                            .SCLK
			touch_panel_spi_external_SS_n                    => CONNECTED_TO_touch_panel_spi_external_SS_n,                    --                                            .SS_n
			audio_and_video_config_0_external_interface_SDAT => CONNECTED_TO_audio_and_video_config_0_external_interface_SDAT, -- audio_and_video_config_0_external_interface.SDAT
			audio_and_video_config_0_external_interface_SCLK => CONNECTED_TO_audio_and_video_config_0_external_interface_SCLK  --                                            .SCLK
		);

