module FFT_PE(
			 clk, 
			 rst, 			 
			 a, 
			 b,
			 power,			 
			 ab_valid, 
			 fft_a, 
			 fft_b,
			 fft_pe_valid
			 );
input clk, rst; 		 
input signed [31:0] a, b;
input [2:0] power;
input ab_valid;		
output reg [31:0] fft_a, fft_b;
output reg fft_pe_valid;
reg signed [31:0] temp_a[7:0],WR;
reg signed [31:0] temp_b[7:0],WI;
reg [4:0]load,stage,load1;
reg signed [31:0] br1,bi1;

always @(posedge clk or posedge rst) begin
	if (rst) begin
		fft_pe_valid <= 1'd0;
		load <= 5'd0;
		load1 <= 5'd0;
		stage <= 5'd0;
		 WR[0] <= 32'hff000000;
	end
	else if(ab_valid && load1 < 8)begin
	  load1 <= load1 + 5'd1;
	  temp_a[load1] <= a;
	  temp_b[load1] <= b;
	  if (load1 == 5'd8) begin
		load <= 5'd0;
		load1 <= 5'd10;
	  end
	end
	else begin
	  stage <= stage + 5'd1;
	  if (load < 8) begin
		if(stage == 5'd0)begin
			fft_a <= {temp_a[load][31:16] + temp_b[load][31:16],temp_a[load][15:0] + temp_b[load][15:0]};
			br1 <= (temp_a[load][31:16] - temp_b[load][31:16]) * WR + (temp_b[load][15:0] - temp_a[load][15:0]) * WI;
			bi1 <= (temp_a[load][31:16] - temp_b[load][31:16])* WI + (temp_a[load][15:0] - temp_b[load][15:0]) * WR;
		end
		else if (stage == 5'd1) begin
			fft_pe_valid <= 1'd1;
			fft_b[31:16] <= br1[31:16];
			fft_b[15:0] <= bi1[31:16];
		end
		else if (stage == 5'd2) begin
			fft_pe_valid <= 1'd0;
			load <= load + 5'd1;
			stage <= 5'd0;
		end
	  end	  
	  	end
end
endmodule

