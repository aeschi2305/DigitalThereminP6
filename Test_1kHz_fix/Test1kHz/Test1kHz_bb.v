
module Test1kHz (
	clk_clk,
	codecdigitalinterface_BCLK,
	codecdigitalinterface_DACDAT,
	codecdigitalinterface_DACLRCK,
	codeci2c_SDAT,
	codeci2c_SCLK,
	reset_reset_n);	

	input		clk_clk;
	input		codecdigitalinterface_BCLK;
	output		codecdigitalinterface_DACDAT;
	input		codecdigitalinterface_DACLRCK;
	inout		codeci2c_SDAT;
	output		codeci2c_SCLK;
	input		reset_reset_n;
endmodule
