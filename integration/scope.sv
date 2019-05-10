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


	logic [11:0]	ADC_REG; //12 bit value coming from ADC, need to send only 8 bits to VGA

	//initialize the values that will eventually be communicated through software
	// trigger, horizontal_sweep, vertical_sweep
	logic [11:0] trigger;
	logic rising; //if 1, rising edge, else falling
	logic buffer_full;
	logic valid = 1'd 0;
	
	//assign valid = 1;
	//assign buffer = 0;

	//instantiate the adc
	adc adc0 (.CLOCK_50(clk), .ADC_CS_N(ADC_CS_N), .ADC_DIN(ADC_DIN), .ADC_SCLK(ADC_SCLK),
			.HEX0(HEX0), .HEX1(HEX1), .HEX2(HEX2), .HEX3(HEX3), .HEX4(HEX4), .HEX5(HEX5), .ADC_DOUT(ADC_DOUT), .ADC_REG(ADC_REG));
	
	//assign ADC_Sample=ADC
	
	//instantiate vga
	vga_ball v0 (.clk(clk), .reset(reset), .writedata(writedata), 
			.write(write), .chipselect(chipselect), .VGA_R(VGA_R), .VGA_G(VGA_G), .VGA_B(VGA_B), .VGA_CLK(VGA_CLK), .VGA_HS(VGA_HS), .VGA_VS(VGA_VS), .VGA_BLANK_n(VGA_BLANK_n) , 
			.VGA_SYNC_n(VGA_SYNC_n), .valid(valid), .trig(trigger), .full(buffer_full), .rising(rising), .sample(ADC_REG[11:3]) );

/*
	//every 12 sclk cycle, ADC_REG is ready. 1 sclk cycle is 4xclk. 12 sclk = 48 clk
	logic [5:0] counter = 6'd 0; 
	always_ff @ ( posedge clk )
	begin
		if(valid == 1'd 0 && counter <= 6'd 47)
		begin
			counter <= counter + 6'd 1;
			valid <= 1'd 0;
		end
		else if(valid == 1'd 0 && counter > 6'd 47)
		begin
			valid <= 1'd 1;
			counter <= 6'd 0;
		end

		else if(valid && !buffer_full)
		begin
		
		end
	end
*/

endmodule






