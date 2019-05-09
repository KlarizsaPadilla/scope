/*
 * Avalon memory-mapped peripheral that generates VGA & ADC interface
 *
 * Oscilloscope Project
 */


module scope(	input logic        	clk,
                input logic 	   	reset,
                input logic [15:0]  writedata,
                input logic 	   	write,
                input 		   		chipselect,
                input logic [2:0]  	address,

				//VGA logic
                output logic [7:0] 	VGA_R, VGA_G, VGA_B,
                output logic 	   	VGA_CLK, VGA_HS, VGA_VS, VGA_BLANK_n,
                output logic 	   	VGA_SYNC_n,
			
				//ADC logic
				output logic		ADC_CS_N,
				output logic 		ADC_SCLK,
				output logic 		ADC_DIN, 
				input logic			ADC_DOUT,
				
				output logic [6:0] 	HEX0, HEX1, HEX2, HEX3, HEX4, HEX5
			);


	logic	[11:0]	ADC_Sample; //12 bit binary value coming from ADC


	//initialize the values that will eventually be communicated through software
	// trigger, horizontal_sweep, vertical_sweep
	logic trigger;
	logic rising; //if 1, rising edge, else falling
	logic full_flag;
	
	assign rising = 1;
	assign full_flag = 0;

	//instantiate the adc
	adc adc0 (.CLOCK_50(clk), .ADC_CS_N(ADC_CS_N), .ADC_DIN(ADC_DIN), .ADC_SCLK(ADC_SCLK),
			.HEX0(HEX0), .HEX1(HEX1), .HEX2(HEX2), .HEX3(HEX3), .HEX4(HEX4), .HEX5(HEX5), .ADC_DOUT(ADC_DOUT));
	
	assign ADC_Sample=ADC
	
	//instantiate vga
	vga_ball v0 (.clk(clk), .reset(reset), .writedata(writedata), 
			.write(write), .chipselect(chipselect), .VGA_R(VGA_R), .VGA_G(VGA_G), .VGA_B(VGA_B), .VGA_CLK(VGA_CLK), .VGA_HS(VGA_HS), .VGA_VS(VGA_VS), .VGA_BLANK_n(VGA_BLANK_n) , 
			.VGA_SYNC_n(VGA_SYNC_n) ); //.sample(ADC_Sample), .full(full_flag)


endmodule
