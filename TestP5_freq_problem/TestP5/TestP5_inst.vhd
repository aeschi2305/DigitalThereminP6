	component TestP5 is
		port (
			audio_0_external_interface_BCLK                  : in    std_logic                    := 'X';             -- BCLK
			audio_0_external_interface_DACDAT                : out   std_logic;                                       -- DACDAT
			audio_0_external_interface_DACLRCK               : in    std_logic                    := 'X';             -- DACLRCK
			audio_and_video_config_0_external_interface_SDAT : inout std_logic                    := 'X';             -- SDAT
			audio_and_video_config_0_external_interface_SCLK : out   std_logic;                                       -- SCLK
			clk_clk                                          : in    std_logic                    := 'X';             -- clk
			daclrc_export                                    : in    std_logic                    := 'X';             -- export
			reset_reset_n                                    : in    std_logic                    := 'X';             -- reset_n
			square_freq_export                               : in    std_logic                    := 'X';             -- export
			freq_up_down_export                              : inout std_logic_vector(1 downto 0) := (others => 'X')  -- export
		);
	end component TestP5;

	u0 : component TestP5
		port map (
			audio_0_external_interface_BCLK                  => CONNECTED_TO_audio_0_external_interface_BCLK,                  --                  audio_0_external_interface.BCLK
			audio_0_external_interface_DACDAT                => CONNECTED_TO_audio_0_external_interface_DACDAT,                --                                            .DACDAT
			audio_0_external_interface_DACLRCK               => CONNECTED_TO_audio_0_external_interface_DACLRCK,               --                                            .DACLRCK
			audio_and_video_config_0_external_interface_SDAT => CONNECTED_TO_audio_and_video_config_0_external_interface_SDAT, -- audio_and_video_config_0_external_interface.SDAT
			audio_and_video_config_0_external_interface_SCLK => CONNECTED_TO_audio_and_video_config_0_external_interface_SCLK, --                                            .SCLK
			clk_clk                                          => CONNECTED_TO_clk_clk,                                          --                                         clk.clk
			daclrc_export                                    => CONNECTED_TO_daclrc_export,                                    --                                      daclrc.export
			reset_reset_n                                    => CONNECTED_TO_reset_reset_n,                                    --                                       reset.reset_n
			square_freq_export                               => CONNECTED_TO_square_freq_export,                               --                                 square_freq.export
			freq_up_down_export                              => CONNECTED_TO_freq_up_down_export                               --                                freq_up_down.export
		);

