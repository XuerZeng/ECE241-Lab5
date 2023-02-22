module part3 (ClockIn, Resetn, Start, Letter, DotDashOut, NewBitOut);
	input ClockIn;
	input [2:0] Letter;
	input Resetn;
	input Start;
	output NewBitOut;
	output DotDashOut;
	wire enable;
	wire [11:0] morseCode;
	wire [7:0] counter;
	
	
		
	
	mux8to1 p0(Letter[2:0], morseCode[11:0]);
	rateDivider p1(ClockIn, enable, counter, Resetn,Start);
	assign NewBitOut = enable;
	shiftRegister p2(morseCode, Resetn, ClockIn, Start, enable, DotDashOut);	

	
	

endmodule



module mux8to1 (select, morseCode);

	input [2:0] select;
	output reg[11:0] morseCode;
	
	always @(*)
	    begin
		case (select)
		    3'b000: morseCode = 12'b101110000000;
		    
		    3'b001: morseCode = 12'b111010101000;

		    3'b010: morseCode = 12'b111010111010;

		    3'b011: morseCode = 12'b111010100000;
	
		    3'b100: morseCode = 12'b100000000000;

		    3'b101: morseCode = 12'b101011101000;

		    3'b110: morseCode = 12'b111011101000;

		    3'b111: morseCode = 12'b101010100000;

		    default: morseCode = 12'b0;
		endcase
	    end



endmodule

 

module rateDivider (clock, enable, counter, reset,start);
	input clock,reset,start;
	output enable;
	output reg[7:0] counter;
	
	//reg [7:0] D = 8'b11111001;
	
		
	
	always @(posedge clock)
	begin
		if(counter == 8'b0)

		begin
		    
		    counter <= 8'd249;
		    
		end
		
		else if(start == 1'b1)

		begin
		    counter <=8'b0;
		end

		else if(reset == 1'b0)

		begin
		    counter <= 8'd249;
		    
		end
		
		
		else

		begin
		    
		    counter <= counter - 1;
		    
		end
	end
	assign enable = (counter == 8'b0)? 1:0;
	
	
	

endmodule

		


module shiftRegister(morse, reset,clock,start,newBit,outBit);
	input newBit, reset, clock,start;
	input [11:0] morse;
	reg [11:0] Q;
	output outBit;
	reg tempBit;
	
	

	always@ (posedge clock)
	begin
	    if(reset == 1'b0)
	    begin
		
		 Q<= 12'b0;
		
		
	    end	
	    else if(newBit==1'b1 && start ==0)

	    begin
		
		tempBit <= Q[11];
		Q <= (Q << 1);

		
	    end

	    else if(start == 1'b1)

	    begin
		Q <= morse;
		
		
	    end
	    	   
	end
	
	assign outBit = tempBit;
	
	
endmodule
