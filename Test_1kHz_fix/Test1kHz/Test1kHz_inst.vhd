	component Test1kHz is
		port (
			clk_clk                       : in    std_logic := 'X'; -- clk
			codecdigitalinterface_BCLK    : in    std_logic := 'X'; -- BCLK
			codecdigitalinterface_DACDAT  : out   std_logic;        -- DACDAT
			codecdigitalinterface_DACLRCK : in    std_logic := 'X'; -- DACLRCK
			codeci2c_SDAT                 : inout std_logic := 'X'; -- SDAT
			codeci2c_SCLK                 : out   std_logic;        -- SCLK
			reset_reset_n                 : in    std_logic := 'X'  -- reset_n
		);
	end component Test1kHz;

	u0 : component Test1kHz
		port map (
			clk_clk                       => CONNECTED_TO_clk_clk,                       --                   clk.clk
			codecdigitalinterface_BCLK    => CONNECTED_TO_codecdigitalinterface_BCLK,    -- codecdigitalinterface.BCLK
			codecdigitalinterface_DACDAT  => CONNECTED_TO_codecdigitalinterface_DACDAT,  --                      .DACDAT
			codecdigitalinterface_DACLRCK => CONNECTED_TO_codecdigitalinterface_DACLRCK, --                      .DACLRCK
			codeci2c_SDAT                 => CONNECTED_TO_codeci2c_SDAT,                 --              codeci2c.SDAT
			codeci2c_SCLK                 => CONNECTED_TO_codeci2c_SCLK,                 --                      .SCLK
			reset_reset_n                 => CONNECTED_TO_reset_reset_n                  --                 reset.reset_n
		);

