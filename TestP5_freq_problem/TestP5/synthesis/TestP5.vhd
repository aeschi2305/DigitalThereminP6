-- TestP5.vhd

-- Generated using ACDS version 17.1 590

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity TestP5 is
	port (
		audio_0_external_interface_BCLK                  : in    std_logic                    := '0';             --                  audio_0_external_interface.BCLK
		audio_0_external_interface_DACDAT                : out   std_logic;                                       --                                            .DACDAT
		audio_0_external_interface_DACLRCK               : in    std_logic                    := '0';             --                                            .DACLRCK
		audio_and_video_config_0_external_interface_SDAT : inout std_logic                    := '0';             -- audio_and_video_config_0_external_interface.SDAT
		audio_and_video_config_0_external_interface_SCLK : out   std_logic;                                       --                                            .SCLK
		clk_clk                                          : in    std_logic                    := '0';             --                                         clk.clk
		freq_up_down_export                              : inout std_logic_vector(1 downto 0) := (others => '0'); --                                freq_up_down.export
		reset_reset_n                                    : in    std_logic                    := '0';             --                                       reset.reset_n
		square_freq_export                               : in    std_logic                    := '0';              --                                 square_freq.export
		AUD_XCK                            : out std_logic
	);
end entity TestP5;

architecture rtl of TestP5 is
	component Tone_generation_top is
		generic (
			dat_len_avl : natural := 31
		);
		port (
			csi_clk          : in    std_logic                     := 'X';             -- clk
			rsi_reset_n      : in    std_logic                     := 'X';             -- reset_n
			coe_square_freq  : in    std_logic                     := 'X';             -- export
			aso_seR_ready    : in    std_logic                     := 'X';             -- ready
			aso_seR_valid    : out   std_logic;                                        -- valid
			aso_seR_data     : out   std_logic_vector(23 downto 0);                    -- data
			aso_seL_ready    : in    std_logic                     := 'X';             -- ready
			aso_seL_valid    : out   std_logic;                                        -- valid
			aso_seL_data     : out   std_logic_vector(23 downto 0);                    -- data
			coe_DACLRC       : in    std_logic                     := 'X';             -- export
			coe_freq_up_down : inout std_logic_vector(1 downto 0)  := (others => 'X')  -- export
		);
	end component Tone_generation_top;

	component TestP5_audio is
		port (
			clk                          : in  std_logic                     := 'X';             -- clk
			reset                        : in  std_logic                     := 'X';             -- reset
		--	from_adc_left_channel_ready  : in  std_logic                     := 'X';             -- ready
		--	from_adc_left_channel_data   : out std_logic_vector(23 downto 0);                    -- data
		--	from_adc_left_channel_valid  : out std_logic;                                        -- valid
		--	from_adc_right_channel_ready : in  std_logic                     := 'X';             -- ready
		--	from_adc_right_channel_data  : out std_logic_vector(23 downto 0);                    -- data
		--	from_adc_right_channel_valid : out std_logic;                                        -- valid
			to_dac_left_channel_data     : in  std_logic_vector(23 downto 0) := (others => 'X'); -- data
			to_dac_left_channel_valid    : in  std_logic                     := 'X';             -- valid
			to_dac_left_channel_ready    : out std_logic;                                        -- ready
			to_dac_right_channel_data    : in  std_logic_vector(23 downto 0) := (others => 'X'); -- data
			to_dac_right_channel_valid   : in  std_logic                     := 'X';             -- valid
			to_dac_right_channel_ready   : out std_logic;                                        -- ready
			AUD_BCLK                     : in  std_logic                     := 'X';             -- export
			AUD_DACDAT                   : out std_logic;                                        -- export
			AUD_DACLRCK                  : in  std_logic                     := 'X'              -- export
		);
	end component TestP5_audio;

	component TestP5_audio_and_video_config_0 is
		port (
			clk         : in    std_logic                     := 'X';             -- clk
			reset       : in    std_logic                     := 'X';             -- reset
			address     : in    std_logic_vector(1 downto 0)  := (others => 'X'); -- address
			byteenable  : in    std_logic_vector(3 downto 0)  := (others => 'X'); -- byteenable
			read        : in    std_logic                     := 'X';             -- read
			write       : in    std_logic                     := 'X';             -- write
			writedata   : in    std_logic_vector(31 downto 0) := (others => 'X'); -- writedata
			readdata    : out   std_logic_vector(31 downto 0);                    -- readdata
			waitrequest : out   std_logic;                                        -- waitrequest
			I2C_SDAT    : inout std_logic                     := 'X';             -- export
			I2C_SCLK    : out   std_logic                                         -- export
		);
	end component TestP5_audio_and_video_config_0;

	component TestP5_audio_pll_0 is
		port (
			ref_clk_clk        : in  std_logic := 'X'; -- clk
			ref_reset_reset    : in  std_logic := 'X'; -- reset
			audio_clk_clk      : out std_logic;        -- clk
			reset_source_reset : out std_logic         -- reset
		);
	end component TestP5_audio_pll_0;

	component altera_avalon_dc_fifo is
		generic (
			SYMBOLS_PER_BEAT   : integer := 1;
			BITS_PER_SYMBOL    : integer := 8;
			FIFO_DEPTH         : integer := 16;
			CHANNEL_WIDTH      : integer := 0;
			ERROR_WIDTH        : integer := 0;
			USE_PACKETS        : integer := 0;
			USE_IN_FILL_LEVEL  : integer := 0;
			USE_OUT_FILL_LEVEL : integer := 0;
			WR_SYNC_DEPTH      : integer := 3;
			RD_SYNC_DEPTH      : integer := 3
		);
		port (
			in_clk            : in  std_logic                     := 'X';             -- clk
			in_reset_n        : in  std_logic                     := 'X';             -- reset_n
			out_clk           : in  std_logic                     := 'X';             -- clk
			out_reset_n       : in  std_logic                     := 'X';             -- reset_n
			in_data           : in  std_logic_vector(23 downto 0) := (others => 'X'); -- data
			in_valid          : in  std_logic                     := 'X';             -- valid
			in_ready          : out std_logic;                                        -- ready
			out_data          : out std_logic_vector(23 downto 0);                    -- data
			out_valid         : out std_logic;                                        -- valid
			out_ready         : in  std_logic                     := 'X';             -- ready
			in_csr_address    : in  std_logic                     := 'X';             -- address
			in_csr_read       : in  std_logic                     := 'X';             -- read
			in_csr_write      : in  std_logic                     := 'X';             -- write
			in_csr_readdata   : out std_logic_vector(31 downto 0);                    -- readdata
			in_csr_writedata  : in  std_logic_vector(31 downto 0) := (others => 'X'); -- writedata
			out_csr_address   : in  std_logic                     := 'X';             -- address
			out_csr_read      : in  std_logic                     := 'X';             -- read
			out_csr_write     : in  std_logic                     := 'X';             -- write
			out_csr_readdata  : out std_logic_vector(31 downto 0);                    -- readdata
			out_csr_writedata : in  std_logic_vector(31 downto 0) := (others => 'X'); -- writedata
			in_startofpacket  : in  std_logic                     := 'X';             -- startofpacket
			in_endofpacket    : in  std_logic                     := 'X';             -- endofpacket
			out_startofpacket : out std_logic;                                        -- startofpacket
			out_endofpacket   : out std_logic;                                        -- endofpacket
			in_empty          : in  std_logic_vector(0 downto 0)  := (others => 'X'); -- empty
			out_empty         : out std_logic_vector(0 downto 0);                     -- empty
			in_error          : in  std_logic_vector(0 downto 0)  := (others => 'X'); -- error
			out_error         : out std_logic_vector(0 downto 0);                     -- error
			in_channel        : in  std_logic_vector(0 downto 0)  := (others => 'X'); -- channel
			out_channel       : out std_logic_vector(0 downto 0);                     -- channel
			space_avail_data  : out std_logic_vector(5 downto 0)                      -- data
		);
	end component altera_avalon_dc_fifo;

	component TestP5_pll_0 is
		port (
			refclk   : in  std_logic := 'X'; -- clk
			rst      : in  std_logic := 'X'; -- reset
			outclk_0 : out std_logic;        -- clk
			locked   : out std_logic         -- export
		);
	end component TestP5_pll_0;

	component altera_reset_controller is
		generic (
			NUM_RESET_INPUTS          : integer := 6;
			OUTPUT_RESET_SYNC_EDGES   : string  := "deassert";
			SYNC_DEPTH                : integer := 2;
			RESET_REQUEST_PRESENT     : integer := 0;
			RESET_REQ_WAIT_TIME       : integer := 1;
			MIN_RST_ASSERTION_TIME    : integer := 3;
			RESET_REQ_EARLY_DSRT_TIME : integer := 1;
			USE_RESET_REQUEST_IN0     : integer := 0;
			USE_RESET_REQUEST_IN1     : integer := 0;
			USE_RESET_REQUEST_IN2     : integer := 0;
			USE_RESET_REQUEST_IN3     : integer := 0;
			USE_RESET_REQUEST_IN4     : integer := 0;
			USE_RESET_REQUEST_IN5     : integer := 0;
			USE_RESET_REQUEST_IN6     : integer := 0;
			USE_RESET_REQUEST_IN7     : integer := 0;
			USE_RESET_REQUEST_IN8     : integer := 0;
			USE_RESET_REQUEST_IN9     : integer := 0;
			USE_RESET_REQUEST_IN10    : integer := 0;
			USE_RESET_REQUEST_IN11    : integer := 0;
			USE_RESET_REQUEST_IN12    : integer := 0;
			USE_RESET_REQUEST_IN13    : integer := 0;
			USE_RESET_REQUEST_IN14    : integer := 0;
			USE_RESET_REQUEST_IN15    : integer := 0;
			ADAPT_RESET_REQUEST       : integer := 0
		);
		port (
			reset_in0      : in  std_logic := 'X'; -- reset
			clk            : in  std_logic := 'X'; -- clk
			reset_out      : out std_logic;        -- reset
			reset_req      : out std_logic;        -- reset_req
			reset_req_in0  : in  std_logic := 'X'; -- reset_req
			reset_in1      : in  std_logic := 'X'; -- reset
			reset_req_in1  : in  std_logic := 'X'; -- reset_req
			reset_in2      : in  std_logic := 'X'; -- reset
			reset_req_in2  : in  std_logic := 'X'; -- reset_req
			reset_in3      : in  std_logic := 'X'; -- reset
			reset_req_in3  : in  std_logic := 'X'; -- reset_req
			reset_in4      : in  std_logic := 'X'; -- reset
			reset_req_in4  : in  std_logic := 'X'; -- reset_req
			reset_in5      : in  std_logic := 'X'; -- reset
			reset_req_in5  : in  std_logic := 'X'; -- reset_req
			reset_in6      : in  std_logic := 'X'; -- reset
			reset_req_in6  : in  std_logic := 'X'; -- reset_req
			reset_in7      : in  std_logic := 'X'; -- reset
			reset_req_in7  : in  std_logic := 'X'; -- reset_req
			reset_in8      : in  std_logic := 'X'; -- reset
			reset_req_in8  : in  std_logic := 'X'; -- reset_req
			reset_in9      : in  std_logic := 'X'; -- reset
			reset_req_in9  : in  std_logic := 'X'; -- reset_req
			reset_in10     : in  std_logic := 'X'; -- reset
			reset_req_in10 : in  std_logic := 'X'; -- reset_req
			reset_in11     : in  std_logic := 'X'; -- reset
			reset_req_in11 : in  std_logic := 'X'; -- reset_req
			reset_in12     : in  std_logic := 'X'; -- reset
			reset_req_in12 : in  std_logic := 'X'; -- reset_req
			reset_in13     : in  std_logic := 'X'; -- reset
			reset_req_in13 : in  std_logic := 'X'; -- reset_req
			reset_in14     : in  std_logic := 'X'; -- reset
			reset_req_in14 : in  std_logic := 'X'; -- reset_req
			reset_in15     : in  std_logic := 'X'; -- reset
			reset_req_in15 : in  std_logic := 'X'  -- reset_req
		);
	end component altera_reset_controller;

	signal dc_fifo_1_out_valid                          : std_logic;                     -- dc_fifo_1:out_valid -> audio:to_dac_left_channel_valid
	signal dc_fifo_1_out_data                           : std_logic_vector(23 downto 0); -- dc_fifo_1:out_data -> audio:to_dac_left_channel_data
	signal dc_fifo_1_out_ready                          : std_logic;                     -- audio:to_dac_left_channel_ready -> dc_fifo_1:out_ready
	signal dc_fifo_0_out_valid                          : std_logic;                     -- dc_fifo_0:out_valid -> audio:to_dac_right_channel_valid
	signal dc_fifo_0_out_data                           : std_logic_vector(23 downto 0); -- dc_fifo_0:out_data -> audio:to_dac_right_channel_data
	signal dc_fifo_0_out_ready                          : std_logic;                     -- audio:to_dac_right_channel_ready -> dc_fifo_0:out_ready
	signal tone_generation_0_sel_valid                  : std_logic;                     -- Tone_generation_0:aso_seL_valid -> dc_fifo_1:in_valid
	signal tone_generation_0_sel_data                   : std_logic_vector(23 downto 0); -- Tone_generation_0:aso_seL_data -> dc_fifo_1:in_data
	signal tone_generation_0_sel_ready                  : std_logic;                     -- dc_fifo_1:in_ready -> Tone_generation_0:aso_seL_ready
	signal tone_generation_0_ser_valid                  : std_logic;                     -- Tone_generation_0:aso_seR_valid -> dc_fifo_0:in_valid
	signal tone_generation_0_ser_data                   : std_logic_vector(23 downto 0); -- Tone_generation_0:aso_seR_data -> dc_fifo_0:in_data
	signal tone_generation_0_ser_ready                  : std_logic;                     -- dc_fifo_0:in_ready -> Tone_generation_0:aso_seR_ready
	signal audio_pll_0_audio_clk_clk                    : std_logic;                     -- audio_pll_0:audio_clk_clk -> [audio:clk, audio_and_video_config_0:clk, dc_fifo_0:out_clk, dc_fifo_1:out_clk, rst_controller_001:clk, rst_controller_002:clk]
	signal pll_0_outclk0_clk                            : std_logic;                     -- pll_0:outclk_0 -> [Tone_generation_0:csi_clk, dc_fifo_0:in_clk, dc_fifo_1:in_clk, rst_controller:clk]
	signal rst_controller_reset_out_reset               : std_logic;                     -- rst_controller:reset_out -> rst_controller_reset_out_reset:in
	signal rst_controller_001_reset_out_reset           : std_logic;                     -- rst_controller_001:reset_out -> [audio:reset, audio_and_video_config_0:reset]
	signal audio_pll_0_reset_source_reset               : std_logic;                     -- audio_pll_0:reset_source_reset -> rst_controller_001:reset_in0
	signal rst_controller_002_reset_out_reset           : std_logic;                     -- rst_controller_002:reset_out -> rst_controller_002_reset_out_reset:in
	signal reset_reset_n_ports_inv                      : std_logic;                     -- reset_reset_n:inv -> [audio_pll_0:ref_reset_reset, pll_0:rst, rst_controller:reset_in0, rst_controller_002:reset_in0]
	signal rst_controller_reset_out_reset_ports_inv     : std_logic;                     -- rst_controller_reset_out_reset:inv -> [Tone_generation_0:rsi_reset_n, dc_fifo_0:in_reset_n, dc_fifo_1:in_reset_n]
	signal rst_controller_002_reset_out_reset_ports_inv : std_logic;                     -- rst_controller_002_reset_out_reset:inv -> [dc_fifo_0:out_reset_n, dc_fifo_1:out_reset_n]
	signal DACLRC 										: std_logic;
begin
	AUD_XCK <= audio_pll_0_audio_clk_clk;
	DACLRC <= audio_0_external_interface_DACLRCK;

	tone_generation_0 : component Tone_generation_top
		generic map (
			dat_len_avl => 31
		)
		port map (
			csi_clk          => pll_0_outclk0_clk,                        --         clock.clk
			rsi_reset_n      => rst_controller_reset_out_reset_ports_inv, --         reset.reset_n
			coe_square_freq  => square_freq_export,                       -- conduit_end_0.export
			aso_seR_ready    => tone_generation_0_ser_ready,              --           ser.ready
			aso_seR_valid    => tone_generation_0_ser_valid,              --              .valid
			aso_seR_data     => tone_generation_0_ser_data,               --              .data
			aso_seL_ready    => tone_generation_0_sel_ready,              --           sel.ready
			aso_seL_valid    => tone_generation_0_sel_valid,              --              .valid
			aso_seL_data     => tone_generation_0_sel_data,               --              .data
			coe_DACLRC       => DACLRC,                            --   conduit_end.export
			coe_freq_up_down => freq_up_down_export                       -- conduit_end_1.export
		);

	audio : component TestP5_audio
		port map (
			clk                          => audio_pll_0_audio_clk_clk,          --                         clk.clk
			reset                        => rst_controller_001_reset_out_reset, --                       reset.reset
			--from_adc_left_channel_ready  => open,                               --  avalon_left_channel_source.ready
			--from_adc_left_channel_data   => open,                               --                            .data
			--from_adc_left_channel_valid  => open,                               --                            .valid
			--from_adc_right_channel_ready => open,                               -- avalon_right_channel_source.ready
			--from_adc_right_channel_data  => open,                               --                            .data
			--from_adc_right_channel_valid => open,                               --                            .valid
			to_dac_left_channel_data     => dc_fifo_1_out_data,                 --    avalon_left_channel_sink.data
			to_dac_left_channel_valid    => dc_fifo_1_out_valid,                --                            .valid
			to_dac_left_channel_ready    => dc_fifo_1_out_ready,                --                            .ready
			to_dac_right_channel_data    => dc_fifo_0_out_data,                 --   avalon_right_channel_sink.data
			to_dac_right_channel_valid   => dc_fifo_0_out_valid,                --                            .valid
			to_dac_right_channel_ready   => dc_fifo_0_out_ready,                --                            .ready
			AUD_BCLK                     => audio_0_external_interface_BCLK,    --          external_interface.export
			AUD_DACDAT                   => audio_0_external_interface_DACDAT,  --                            .export
			AUD_DACLRCK                  => DACLRC  --                            .export
		);

	audio_and_video_config_0 : component TestP5_audio_and_video_config_0
		port map (
			clk         => audio_pll_0_audio_clk_clk,                        --                    clk.clk
			reset       => rst_controller_001_reset_out_reset,               --                  reset.reset
			address     => open,                                             -- avalon_av_config_slave.address
			byteenable  => open,                                             --                       .byteenable
			read        => open,                                             --                       .read
			write       => open,                                             --                       .write
			writedata   => open,                                             --                       .writedata
			readdata    => open,                                             --                       .readdata
			waitrequest => open,                                             --                       .waitrequest
			I2C_SDAT    => audio_and_video_config_0_external_interface_SDAT, --     external_interface.export
			I2C_SCLK    => audio_and_video_config_0_external_interface_SCLK  --                       .export
		);

	audio_pll_0 : component TestP5_audio_pll_0
		port map (
			ref_clk_clk        => clk_clk,                        --      ref_clk.clk
			ref_reset_reset    => reset_reset_n_ports_inv,        --    ref_reset.reset
			audio_clk_clk      => audio_pll_0_audio_clk_clk,      --    audio_clk.clk
			reset_source_reset => audio_pll_0_reset_source_reset  -- reset_source.reset
		);

	dc_fifo_0 : component altera_avalon_dc_fifo
		generic map (
			SYMBOLS_PER_BEAT   => 1,
			BITS_PER_SYMBOL    => 24,
			FIFO_DEPTH         => 32,
			CHANNEL_WIDTH      => 0,
			ERROR_WIDTH        => 0,
			USE_PACKETS        => 0,
			USE_IN_FILL_LEVEL  => 0,
			USE_OUT_FILL_LEVEL => 0,
			WR_SYNC_DEPTH      => 3,
			RD_SYNC_DEPTH      => 3
		)
		port map (
			in_clk            => pll_0_outclk0_clk,                            --        in_clk.clk
			in_reset_n        => rst_controller_reset_out_reset_ports_inv,     --  in_clk_reset.reset_n
			out_clk           => audio_pll_0_audio_clk_clk,                    --       out_clk.clk
			out_reset_n       => rst_controller_002_reset_out_reset_ports_inv, -- out_clk_reset.reset_n
			in_data           => tone_generation_0_ser_data,                   --            in.data
			in_valid          => tone_generation_0_ser_valid,                  --              .valid
			in_ready          => tone_generation_0_ser_ready,                  --              .ready
			out_data          => dc_fifo_0_out_data,                           --           out.data
			out_valid         => dc_fifo_0_out_valid,                          --              .valid
			out_ready         => dc_fifo_0_out_ready,                          --              .ready
			in_csr_address    => '0',                                          --   (terminated)
			in_csr_read       => '0',                                          --   (terminated)
			in_csr_write      => '0',                                          --   (terminated)
			in_csr_readdata   => open,                                         --   (terminated)
			in_csr_writedata  => "00000000000000000000000000000000",           --   (terminated)
			out_csr_address   => '0',                                          --   (terminated)
			out_csr_read      => '0',                                          --   (terminated)
			out_csr_write     => '0',                                          --   (terminated)
			out_csr_readdata  => open,                                         --   (terminated)
			out_csr_writedata => "00000000000000000000000000000000",           --   (terminated)
			in_startofpacket  => '0',                                          --   (terminated)
			in_endofpacket    => '0',                                          --   (terminated)
			out_startofpacket => open,                                         --   (terminated)
			out_endofpacket   => open,                                         --   (terminated)
			in_empty          => "0",                                          --   (terminated)
			out_empty         => open,                                         --   (terminated)
			in_error          => "0",                                          --   (terminated)
			out_error         => open,                                         --   (terminated)
			in_channel        => "0",                                          --   (terminated)
			out_channel       => open,                                         --   (terminated)
			space_avail_data  => open                                          --   (terminated)
		);

	dc_fifo_1 : component altera_avalon_dc_fifo
		generic map (
			SYMBOLS_PER_BEAT   => 1,
			BITS_PER_SYMBOL    => 24,
			FIFO_DEPTH         => 32,
			CHANNEL_WIDTH      => 0,
			ERROR_WIDTH        => 0,
			USE_PACKETS        => 0,
			USE_IN_FILL_LEVEL  => 0,
			USE_OUT_FILL_LEVEL => 0,
			WR_SYNC_DEPTH      => 3,
			RD_SYNC_DEPTH      => 3
		)
		port map (
			in_clk            => pll_0_outclk0_clk,                            --        in_clk.clk
			in_reset_n        => rst_controller_reset_out_reset_ports_inv,     --  in_clk_reset.reset_n
			out_clk           => audio_pll_0_audio_clk_clk,                    --       out_clk.clk
			out_reset_n       => rst_controller_002_reset_out_reset_ports_inv, -- out_clk_reset.reset_n
			in_data           => tone_generation_0_sel_data,                   --            in.data
			in_valid          => tone_generation_0_sel_valid,                  --              .valid
			in_ready          => tone_generation_0_sel_ready,                  --              .ready
			out_data          => dc_fifo_1_out_data,                           --           out.data
			out_valid         => dc_fifo_1_out_valid,                          --              .valid
			out_ready         => dc_fifo_1_out_ready,                          --              .ready
			in_csr_address    => '0',                                          --   (terminated)
			in_csr_read       => '0',                                          --   (terminated)
			in_csr_write      => '0',                                          --   (terminated)
			in_csr_readdata   => open,                                         --   (terminated)
			in_csr_writedata  => "00000000000000000000000000000000",           --   (terminated)
			out_csr_address   => '0',                                          --   (terminated)
			out_csr_read      => '0',                                          --   (terminated)
			out_csr_write     => '0',                                          --   (terminated)
			out_csr_readdata  => open,                                         --   (terminated)
			out_csr_writedata => "00000000000000000000000000000000",           --   (terminated)
			in_startofpacket  => '0',                                          --   (terminated)
			in_endofpacket    => '0',                                          --   (terminated)
			out_startofpacket => open,                                         --   (terminated)
			out_endofpacket   => open,                                         --   (terminated)
			in_empty          => "0",                                          --   (terminated)
			out_empty         => open,                                         --   (terminated)
			in_error          => "0",                                          --   (terminated)
			out_error         => open,                                         --   (terminated)
			in_channel        => "0",                                          --   (terminated)
			out_channel       => open,                                         --   (terminated)
			space_avail_data  => open                                          --   (terminated)
		);

	pll_0 : component TestP5_pll_0
		port map (
			refclk   => clk_clk,                 --  refclk.clk
			rst      => reset_reset_n_ports_inv, --   reset.reset
			outclk_0 => pll_0_outclk0_clk,       -- outclk0.clk
			locked   => open                     -- (terminated)
		);

	rst_controller : component altera_reset_controller
		generic map (
			NUM_RESET_INPUTS          => 1,
			OUTPUT_RESET_SYNC_EDGES   => "deassert",
			SYNC_DEPTH                => 2,
			RESET_REQUEST_PRESENT     => 0,
			RESET_REQ_WAIT_TIME       => 1,
			MIN_RST_ASSERTION_TIME    => 3,
			RESET_REQ_EARLY_DSRT_TIME => 1,
			USE_RESET_REQUEST_IN0     => 0,
			USE_RESET_REQUEST_IN1     => 0,
			USE_RESET_REQUEST_IN2     => 0,
			USE_RESET_REQUEST_IN3     => 0,
			USE_RESET_REQUEST_IN4     => 0,
			USE_RESET_REQUEST_IN5     => 0,
			USE_RESET_REQUEST_IN6     => 0,
			USE_RESET_REQUEST_IN7     => 0,
			USE_RESET_REQUEST_IN8     => 0,
			USE_RESET_REQUEST_IN9     => 0,
			USE_RESET_REQUEST_IN10    => 0,
			USE_RESET_REQUEST_IN11    => 0,
			USE_RESET_REQUEST_IN12    => 0,
			USE_RESET_REQUEST_IN13    => 0,
			USE_RESET_REQUEST_IN14    => 0,
			USE_RESET_REQUEST_IN15    => 0,
			ADAPT_RESET_REQUEST       => 0
		)
		port map (
			reset_in0      => reset_reset_n_ports_inv,        -- reset_in0.reset
			clk            => pll_0_outclk0_clk,              --       clk.clk
			reset_out      => rst_controller_reset_out_reset, -- reset_out.reset
			reset_req      => open,                           -- (terminated)
			reset_req_in0  => '0',                            -- (terminated)
			reset_in1      => '0',                            -- (terminated)
			reset_req_in1  => '0',                            -- (terminated)
			reset_in2      => '0',                            -- (terminated)
			reset_req_in2  => '0',                            -- (terminated)
			reset_in3      => '0',                            -- (terminated)
			reset_req_in3  => '0',                            -- (terminated)
			reset_in4      => '0',                            -- (terminated)
			reset_req_in4  => '0',                            -- (terminated)
			reset_in5      => '0',                            -- (terminated)
			reset_req_in5  => '0',                            -- (terminated)
			reset_in6      => '0',                            -- (terminated)
			reset_req_in6  => '0',                            -- (terminated)
			reset_in7      => '0',                            -- (terminated)
			reset_req_in7  => '0',                            -- (terminated)
			reset_in8      => '0',                            -- (terminated)
			reset_req_in8  => '0',                            -- (terminated)
			reset_in9      => '0',                            -- (terminated)
			reset_req_in9  => '0',                            -- (terminated)
			reset_in10     => '0',                            -- (terminated)
			reset_req_in10 => '0',                            -- (terminated)
			reset_in11     => '0',                            -- (terminated)
			reset_req_in11 => '0',                            -- (terminated)
			reset_in12     => '0',                            -- (terminated)
			reset_req_in12 => '0',                            -- (terminated)
			reset_in13     => '0',                            -- (terminated)
			reset_req_in13 => '0',                            -- (terminated)
			reset_in14     => '0',                            -- (terminated)
			reset_req_in14 => '0',                            -- (terminated)
			reset_in15     => '0',                            -- (terminated)
			reset_req_in15 => '0'                             -- (terminated)
		);

	rst_controller_001 : component altera_reset_controller
		generic map (
			NUM_RESET_INPUTS          => 1,
			OUTPUT_RESET_SYNC_EDGES   => "deassert",
			SYNC_DEPTH                => 2,
			RESET_REQUEST_PRESENT     => 0,
			RESET_REQ_WAIT_TIME       => 1,
			MIN_RST_ASSERTION_TIME    => 3,
			RESET_REQ_EARLY_DSRT_TIME => 1,
			USE_RESET_REQUEST_IN0     => 0,
			USE_RESET_REQUEST_IN1     => 0,
			USE_RESET_REQUEST_IN2     => 0,
			USE_RESET_REQUEST_IN3     => 0,
			USE_RESET_REQUEST_IN4     => 0,
			USE_RESET_REQUEST_IN5     => 0,
			USE_RESET_REQUEST_IN6     => 0,
			USE_RESET_REQUEST_IN7     => 0,
			USE_RESET_REQUEST_IN8     => 0,
			USE_RESET_REQUEST_IN9     => 0,
			USE_RESET_REQUEST_IN10    => 0,
			USE_RESET_REQUEST_IN11    => 0,
			USE_RESET_REQUEST_IN12    => 0,
			USE_RESET_REQUEST_IN13    => 0,
			USE_RESET_REQUEST_IN14    => 0,
			USE_RESET_REQUEST_IN15    => 0,
			ADAPT_RESET_REQUEST       => 0
		)
		port map (
			reset_in0      => audio_pll_0_reset_source_reset,     -- reset_in0.reset
			clk            => audio_pll_0_audio_clk_clk,          --       clk.clk
			reset_out      => rst_controller_001_reset_out_reset, -- reset_out.reset
			reset_req      => open,                               -- (terminated)
			reset_req_in0  => '0',                                -- (terminated)
			reset_in1      => '0',                                -- (terminated)
			reset_req_in1  => '0',                                -- (terminated)
			reset_in2      => '0',                                -- (terminated)
			reset_req_in2  => '0',                                -- (terminated)
			reset_in3      => '0',                                -- (terminated)
			reset_req_in3  => '0',                                -- (terminated)
			reset_in4      => '0',                                -- (terminated)
			reset_req_in4  => '0',                                -- (terminated)
			reset_in5      => '0',                                -- (terminated)
			reset_req_in5  => '0',                                -- (terminated)
			reset_in6      => '0',                                -- (terminated)
			reset_req_in6  => '0',                                -- (terminated)
			reset_in7      => '0',                                -- (terminated)
			reset_req_in7  => '0',                                -- (terminated)
			reset_in8      => '0',                                -- (terminated)
			reset_req_in8  => '0',                                -- (terminated)
			reset_in9      => '0',                                -- (terminated)
			reset_req_in9  => '0',                                -- (terminated)
			reset_in10     => '0',                                -- (terminated)
			reset_req_in10 => '0',                                -- (terminated)
			reset_in11     => '0',                                -- (terminated)
			reset_req_in11 => '0',                                -- (terminated)
			reset_in12     => '0',                                -- (terminated)
			reset_req_in12 => '0',                                -- (terminated)
			reset_in13     => '0',                                -- (terminated)
			reset_req_in13 => '0',                                -- (terminated)
			reset_in14     => '0',                                -- (terminated)
			reset_req_in14 => '0',                                -- (terminated)
			reset_in15     => '0',                                -- (terminated)
			reset_req_in15 => '0'                                 -- (terminated)
		);

	rst_controller_002 : component altera_reset_controller
		generic map (
			NUM_RESET_INPUTS          => 1,
			OUTPUT_RESET_SYNC_EDGES   => "deassert",
			SYNC_DEPTH                => 2,
			RESET_REQUEST_PRESENT     => 0,
			RESET_REQ_WAIT_TIME       => 1,
			MIN_RST_ASSERTION_TIME    => 3,
			RESET_REQ_EARLY_DSRT_TIME => 1,
			USE_RESET_REQUEST_IN0     => 0,
			USE_RESET_REQUEST_IN1     => 0,
			USE_RESET_REQUEST_IN2     => 0,
			USE_RESET_REQUEST_IN3     => 0,
			USE_RESET_REQUEST_IN4     => 0,
			USE_RESET_REQUEST_IN5     => 0,
			USE_RESET_REQUEST_IN6     => 0,
			USE_RESET_REQUEST_IN7     => 0,
			USE_RESET_REQUEST_IN8     => 0,
			USE_RESET_REQUEST_IN9     => 0,
			USE_RESET_REQUEST_IN10    => 0,
			USE_RESET_REQUEST_IN11    => 0,
			USE_RESET_REQUEST_IN12    => 0,
			USE_RESET_REQUEST_IN13    => 0,
			USE_RESET_REQUEST_IN14    => 0,
			USE_RESET_REQUEST_IN15    => 0,
			ADAPT_RESET_REQUEST       => 0
		)
		port map (
			reset_in0      => reset_reset_n_ports_inv,            -- reset_in0.reset
			clk            => audio_pll_0_audio_clk_clk,          --       clk.clk
			reset_out      => rst_controller_002_reset_out_reset, -- reset_out.reset
			reset_req      => open,                               -- (terminated)
			reset_req_in0  => '0',                                -- (terminated)
			reset_in1      => '0',                                -- (terminated)
			reset_req_in1  => '0',                                -- (terminated)
			reset_in2      => '0',                                -- (terminated)
			reset_req_in2  => '0',                                -- (terminated)
			reset_in3      => '0',                                -- (terminated)
			reset_req_in3  => '0',                                -- (terminated)
			reset_in4      => '0',                                -- (terminated)
			reset_req_in4  => '0',                                -- (terminated)
			reset_in5      => '0',                                -- (terminated)
			reset_req_in5  => '0',                                -- (terminated)
			reset_in6      => '0',                                -- (terminated)
			reset_req_in6  => '0',                                -- (terminated)
			reset_in7      => '0',                                -- (terminated)
			reset_req_in7  => '0',                                -- (terminated)
			reset_in8      => '0',                                -- (terminated)
			reset_req_in8  => '0',                                -- (terminated)
			reset_in9      => '0',                                -- (terminated)
			reset_req_in9  => '0',                                -- (terminated)
			reset_in10     => '0',                                -- (terminated)
			reset_req_in10 => '0',                                -- (terminated)
			reset_in11     => '0',                                -- (terminated)
			reset_req_in11 => '0',                                -- (terminated)
			reset_in12     => '0',                                -- (terminated)
			reset_req_in12 => '0',                                -- (terminated)
			reset_in13     => '0',                                -- (terminated)
			reset_req_in13 => '0',                                -- (terminated)
			reset_in14     => '0',                                -- (terminated)
			reset_req_in14 => '0',                                -- (terminated)
			reset_in15     => '0',                                -- (terminated)
			reset_req_in15 => '0'                                 -- (terminated)
		);

	reset_reset_n_ports_inv <= not reset_reset_n;

	rst_controller_reset_out_reset_ports_inv <= not rst_controller_reset_out_reset;

	rst_controller_002_reset_out_reset_ports_inv <= not rst_controller_reset_out_reset;--rst_controller_002_reset_out_reset;


	--rst_controller_002_reset_out_reset_ports_inv <= not rst_controller_002_reset_out_reset;

end architecture rtl; -- of TestP5
