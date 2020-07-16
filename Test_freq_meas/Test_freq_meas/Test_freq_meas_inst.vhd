	component Test_freq_meas is
		port (
			audio_i2c_SDAT                  : inout std_logic                    := 'X';             -- SDAT
			audio_i2c_SCLK                  : out   std_logic;                                       -- SCLK
			audio_serializer_bclk_export    : in    std_logic                    := 'X';             -- export
			audio_serializer_dacdat_export  : out   std_logic;                                       -- export
			audio_serializer_daclrck_export : in    std_logic                    := 'X';             -- export
			clk_clk                         : in    std_logic                    := 'X';             -- clk
			reset_reset_n                   : in    std_logic                    := 'X';             -- reset_n
			square_freq_export              : inout std_logic                    := 'X';             -- export
			square_up_down_export           : in    std_logic_vector(1 downto 0) := (others => 'X'); -- export
			xck_clk                         : out   std_logic                                        -- clk
		);
	end component Test_freq_meas;

	u0 : component Test_freq_meas
		port map (
			audio_i2c_SDAT                  => CONNECTED_TO_audio_i2c_SDAT,                  --                audio_i2c.SDAT
			audio_i2c_SCLK                  => CONNECTED_TO_audio_i2c_SCLK,                  --                         .SCLK
			audio_serializer_bclk_export    => CONNECTED_TO_audio_serializer_bclk_export,    --    audio_serializer_bclk.export
			audio_serializer_dacdat_export  => CONNECTED_TO_audio_serializer_dacdat_export,  --  audio_serializer_dacdat.export
			audio_serializer_daclrck_export => CONNECTED_TO_audio_serializer_daclrck_export, -- audio_serializer_daclrck.export
			clk_clk                         => CONNECTED_TO_clk_clk,                         --                      clk.clk
			reset_reset_n                   => CONNECTED_TO_reset_reset_n,                   --                    reset.reset_n
			square_freq_export              => CONNECTED_TO_square_freq_export,              --              square_freq.export
			square_up_down_export           => CONNECTED_TO_square_up_down_export,           --           square_up_down.export
			xck_clk                         => CONNECTED_TO_xck_clk                          --                      xck.clk
		);

