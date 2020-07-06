	component TestP5 is
		port (
			audio_and_video_config_0_external_interface_SDAT : inout std_logic                    := 'X';             -- SDAT
			audio_and_video_config_0_external_interface_SCLK : out   std_logic;                                       -- SCLK
			audio_serializer_0_conduit_bclk_export           : in    std_logic                    := 'X';             -- export
			audio_serializer_0_conduit_dacdat_export         : out   std_logic;                                       -- export
			audio_serializer_0_conduit_daclrck_export        : in    std_logic                    := 'X';             -- export
			clk_clk                                          : in    std_logic                    := 'X';             -- clk
			reset_reset_n                                    : in    std_logic                    := 'X';             -- reset_n
			freq_up_down_export                              : in    std_logic_vector(1 downto 0) := (others => 'X'); -- export
			square_freq_export                               : in    std_logic                    := 'X';             -- export
			xck_clk                                          : out   std_logic                                        -- clk
		);
	end component TestP5;

	u0 : component TestP5
		port map (
			audio_and_video_config_0_external_interface_SDAT => CONNECTED_TO_audio_and_video_config_0_external_interface_SDAT, -- audio_and_video_config_0_external_interface.SDAT
			audio_and_video_config_0_external_interface_SCLK => CONNECTED_TO_audio_and_video_config_0_external_interface_SCLK, --                                            .SCLK
			audio_serializer_0_conduit_bclk_export           => CONNECTED_TO_audio_serializer_0_conduit_bclk_export,           --             audio_serializer_0_conduit_bclk.export
			audio_serializer_0_conduit_dacdat_export         => CONNECTED_TO_audio_serializer_0_conduit_dacdat_export,         --           audio_serializer_0_conduit_dacdat.export
			audio_serializer_0_conduit_daclrck_export        => CONNECTED_TO_audio_serializer_0_conduit_daclrck_export,        --          audio_serializer_0_conduit_daclrck.export
			clk_clk                                          => CONNECTED_TO_clk_clk,                                          --                                         clk.clk
			reset_reset_n                                    => CONNECTED_TO_reset_reset_n,                                    --                                       reset.reset_n
			freq_up_down_export                              => CONNECTED_TO_freq_up_down_export,                              --                                freq_up_down.export
			square_freq_export                               => CONNECTED_TO_square_freq_export,                               --                                 square_freq.export
			xck_clk                                          => CONNECTED_TO_xck_clk                                           --                                         xck.clk
		);

