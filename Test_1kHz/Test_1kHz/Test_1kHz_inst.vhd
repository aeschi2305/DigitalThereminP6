	component Test_1kHz is
		port (
			aud_bclk_export                                  : inout std_logic := 'X'; -- export
			aud_dacdat_export                                : out   std_logic;        -- export
			aud_daclrck_export                               : inout std_logic := 'X'; -- export
			audio_and_video_config_0_external_interface_SDAT : inout std_logic := 'X'; -- SDAT
			audio_and_video_config_0_external_interface_SCLK : out   std_logic;        -- SCLK
			clk_clk                                          : in    std_logic := 'X'; -- clk
			reset_reset_n                                    : in    std_logic := 'X'  -- reset_n
		);
	end component Test_1kHz;

	u0 : component Test_1kHz
		port map (
			aud_bclk_export                                  => CONNECTED_TO_aud_bclk_export,                                  --                                    aud_bclk.export
			aud_dacdat_export                                => CONNECTED_TO_aud_dacdat_export,                                --                                  aud_dacdat.export
			aud_daclrck_export                               => CONNECTED_TO_aud_daclrck_export,                               --                                 aud_daclrck.export
			audio_and_video_config_0_external_interface_SDAT => CONNECTED_TO_audio_and_video_config_0_external_interface_SDAT, -- audio_and_video_config_0_external_interface.SDAT
			audio_and_video_config_0_external_interface_SCLK => CONNECTED_TO_audio_and_video_config_0_external_interface_SCLK, --                                            .SCLK
			clk_clk                                          => CONNECTED_TO_clk_clk,                                          --                                         clk.clk
			reset_reset_n                                    => CONNECTED_TO_reset_reset_n                                     --                                       reset.reset_n
		);

