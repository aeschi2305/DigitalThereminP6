	component Test_Cal_Glis is
		port (
			bclk_export         : in    std_logic                    := 'X';             -- export
			clk_clk             : in    std_logic                    := 'X';             -- clk
			dacdat_export       : out   std_logic;                                       -- export
			daclrc_export       : in    std_logic                    := 'X';             -- export
			i2c_SDAT            : inout std_logic                    := 'X';             -- SDAT
			i2c_SCLK            : out   std_logic;                                       -- SCLK
			reset_reset_n       : in    std_logic                    := 'X';             -- reset_n
			xck_clk             : out   std_logic;                                       -- clk
			freq_up_down_export : in    std_logic_vector(1 downto 0) := (others => 'X'); -- export
			square_freq_export  : in    std_logic                    := 'X'              -- export
		);
	end component Test_Cal_Glis;

	u0 : component Test_Cal_Glis
		port map (
			bclk_export         => CONNECTED_TO_bclk_export,         --         bclk.export
			clk_clk             => CONNECTED_TO_clk_clk,             --          clk.clk
			dacdat_export       => CONNECTED_TO_dacdat_export,       --       dacdat.export
			daclrc_export       => CONNECTED_TO_daclrc_export,       --       daclrc.export
			i2c_SDAT            => CONNECTED_TO_i2c_SDAT,            --          i2c.SDAT
			i2c_SCLK            => CONNECTED_TO_i2c_SCLK,            --             .SCLK
			reset_reset_n       => CONNECTED_TO_reset_reset_n,       --        reset.reset_n
			xck_clk             => CONNECTED_TO_xck_clk,             --          xck.clk
			freq_up_down_export => CONNECTED_TO_freq_up_down_export, -- freq_up_down.export
			square_freq_export  => CONNECTED_TO_square_freq_export   --  square_freq.export
		);

