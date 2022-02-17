module FAS(
       clk, 
       rst, 
       data_valid, 
       data, 
       fft_d0,fft_d1,fft_d2,fft_d3,fft_d4,fft_d5,fft_d6,fft_d7,
       fft_d8,fft_d9,fft_d10,fft_d11,fft_d12,fft_d13,fft_d14,fft_d15,
       fft_valid,
       done,
       freq
       );      
input	clk;
input	rst;
input	data_valid;
input signed [15:0] data;
output reg signed [31:0] fft_d0,fft_d1,fft_d2,fft_d3,fft_d4,fft_d5,fft_d6,fft_d7, 
              fft_d8,fft_d9,fft_d10,fft_d11,fft_d12,fft_d13,fft_d14,fft_d15;
output reg fft_valid;
output reg done;                      
output reg[3:0] freq;
reg [9:0] load1,load;
reg signed [31:0] temp[9:0][15:0];
reg [4:0] count;//1 of 16
reg [4:0] num;//1 of 10
reg [4:0] stage;
reg signed [31:0]br[7:0];
reg signed [31:0]bi[7:0];
reg signed [31:0] wi[7:0];
reg signed [31:0] wr[7:0];
reg next;

always @(posedge clk or posedge rst) begin
       if (rst) begin
           fft_valid <= 1'd0;
           done <= 1'd0;   
           load1 <= 10'd0;
           count <= 5'd0;
           num <= 5'd0;
           load <= 10'd0;
           stage <= -5'd2;
           next <= 1'd0;
           wi[0] <= 32'h0000000;
           wr[0] <= 32'h00010000;
           wi[1] <= 32'hFFFF9E09;
           wr[1] <= 32'h0000EC83;
           wi[2] <= 32'hFFFF4AFC;
           wr[2] <= 32'h0000B504;
           wi[3] <= 32'hFFFF137D;
           wr[3] <= 32'h000061F7;
           wi[4] <= 32'hFFFF0000;
           wr[4] <= 32'h00000000;
           wi[5] <= 32'hFFFF137D;
           wr[5] <= 32'hFFFF9E09;
           wi[6] <= 32'hFFFF4AFC;
           wr[6] <= 32'hFFFF4AFC;
           wi[7] <= 32'hFFFF9E09;
           wr[7] <= 32'hFFFF137D;
       end
       else if (data_valid == 1'd1 && next == 1'd0) begin
          load1 <= load1 + 10'd1;
          count <= count + 5'd1;
          temp[num][count] <= {data,16'h0000};   
          if (count == 15) begin
              num <= num + 5'd1;
              count <= 5'd0;
          end
          if (load1 == 10'd161) begin
                 next <= 1'd1;
                 stage <= -5'd1;
          end
       end
       else begin
         stage <= stage + 5'd1;
         if (load < 10'd10) begin
              if (stage == -5'd1) begin
                     
              end
              else if(stage == 5'd0)begin
                     temp[load][0] <= {temp[load][0][31:16] + temp[load][8][31:16],temp[load][0][15:0] + temp[load][8][15:0]};
                     temp[load][1] <= {temp[load][1][31:16] + temp[load][9][31:16],temp[load][1][15:0] + temp[load][9][15:0]};
                     temp[load][2] <= {temp[load][2][31:16] + temp[load][10][31:16],temp[load][2][15:0] + temp[load][10][15:0]};
                     temp[load][3] <= {temp[load][3][31:16] + temp[load][11][31:16],temp[load][3][15:0] + temp[load][11][15:0]};
                     temp[load][4] <= {temp[load][4][31:16] + temp[load][12][31:16],temp[load][4][15:0] + temp[load][12][15:0]};
                     temp[load][5] <= {temp[load][5][31:16] + temp[load][13][31:16],temp[load][5][15:0] + temp[load][13][15:0]};
                     temp[load][6] <= {temp[load][6][31:16] + temp[load][14][31:16],temp[load][6][15:0] + temp[load][14][15:0]};
                     temp[load][7] <= {temp[load][7][31:16] + temp[load][15][31:16],temp[load][7][15:0] + temp[load][15][15:0]};
                     temp[load][8] <= {br[0][31:16],bi[0][31:16]};
                     temp[load][9] <= {br[1][31:16],bi[1][31:16]};
                     temp[load][10] <= {br[2][31:16],bi[2][31:16]};
                     temp[load][11] <= {br[3][31:16],bi[3][31:16]};
                     temp[load][12] <= {br[4][31:16],bi[4][31:16]};
                     temp[load][13] <= {br[5][31:16],bi[5][31:16]};
                     temp[load][14] <= {br[6][31:16],bi[6][31:16]};
                     temp[load][15] <= {br[7][31:16],bi[7][31:16]};
              end
              else if (stage == 5'd1) begin
                     
              end
              else if (stage == 5'd2) begin
                     temp[load][0] <= {temp[load][0][31:16] + temp[load][4][31:16],temp[load][0][15:0] + temp[load][4][15:0]};
                     temp[load][1] <= {temp[load][1][31:16] + temp[load][5][31:16],temp[load][1][15:0] + temp[load][5][15:0]};
                     temp[load][2] <= {temp[load][2][31:16] + temp[load][6][31:16],temp[load][2][15:0] + temp[load][6][15:0]};
                     temp[load][3] <= {temp[load][3][31:16] + temp[load][7][31:16],temp[load][3][15:0] + temp[load][7][15:0]};
                     temp[load][4] <= {br[0][31:16],bi[0][31:16]};
                     temp[load][5] <= {br[1][31:16],bi[1][31:16]};
                     temp[load][6] <= {br[2][31:16],bi[2][31:16]};
                     temp[load][7] <= {br[3][31:16],bi[3][31:16]};
                     temp[load][8] <= {temp[load][8][31:16] + temp[load][12][31:16],temp[load][8][15:0] + temp[load][12][15:0]};
                     temp[load][9] <= {temp[load][9][31:16] + temp[load][13][31:16],temp[load][9][15:0] + temp[load][13][15:0]};
                     temp[load][10] <= {temp[load][10][31:16] + temp[load][14][31:16],temp[load][10][15:0] + temp[load][14][15:0]};
                     temp[load][11] <= {temp[load][11][31:16] + temp[load][15][31:16],temp[load][11][15:0] + temp[load][15][15:0]};
                     temp[load][12] <= {br[4][31:16],bi[4][31:16]};
                     temp[load][13] <= {br[5][31:16],bi[5][31:16]};
                     temp[load][14] <= {br[6][31:16],bi[6][31:16]};
                     temp[load][15] <= {br[7][31:16],bi[7][31:16]};
              end
              else if (stage == 5'd3) begin
                     
              end
              else if (stage == 5'd4) begin
                     temp[load][0] <= {temp[load][0][31:16] + temp[load][2][31:16],temp[load][0][15:0] + temp[load][2][15:0]};
                     temp[load][1] <= {temp[load][1][31:16] + temp[load][3][31:16],temp[load][1][15:0] + temp[load][3][15:0]};
                     temp[load][4] <= {temp[load][4][31:16] + temp[load][6][31:16],temp[load][4][15:0] + temp[load][6][15:0]};
                     temp[load][5] <= {temp[load][5][31:16] + temp[load][7][31:16],temp[load][5][15:0] + temp[load][7][15:0]};
                     temp[load][8] <= {temp[load][8][31:16] + temp[load][10][31:16],temp[load][8][15:0] + temp[load][10][15:0]};
                     temp[load][9] <= {temp[load][9][31:16] + temp[load][11][31:16],temp[load][9][15:0] + temp[load][11][15:0]};
                     temp[load][12] <= {temp[load][12][31:16] + temp[load][14][31:16],temp[load][12][15:0] + temp[load][14][15:0]};
                     temp[load][13] <= {temp[load][13][31:16] + temp[load][15][31:16],temp[load][13][15:0] + temp[load][15][15:0]};
                     temp[load][2] <= {br[0][31:16],bi[0][31:16]};
                     temp[load][3] <= {br[1][31:16],bi[1][31:16]};
                     temp[load][6] <= {br[2][31:16],bi[2][31:16]};
                     temp[load][7] <= {br[3][31:16],bi[3][31:16]};
                     temp[load][10] <= {br[4][31:16],bi[4][31:16]};
                     temp[load][11] <= {br[5][31:16],bi[5][31:16]};
                     temp[load][14] <= {br[6][31:16],bi[6][31:16]};
                     temp[load][15] <= {br[7][31:16],bi[7][31:16]};
              end
              else if (stage == 5'd5) begin
                     
              end
              else if (stage == 5'd6) begin
                      fft_valid <= 1'd1;
                     fft_d0 <= {temp[load][0][31:16] + temp[load][1][31:16],temp[load][0][15:0] + temp[load][1][15:0]};
                     fft_d4 <= {temp[load][2][31:16] + temp[load][3][31:16],temp[load][2][15:0] + temp[load][3][15:0]};
                     fft_d2 <= {temp[load][4][31:16] + temp[load][5][31:16],temp[load][4][15:0] + temp[load][5][15:0]};
                     fft_d6 <= {temp[load][6][31:16] + temp[load][7][31:16],temp[load][6][15:0] + temp[load][7][15:0]};
                     fft_d1 <= {temp[load][8][31:16] + temp[load][9][31:16],temp[load][8][15:0] + temp[load][9][15:0]};
                     fft_d5 <= {temp[load][10][31:16] + temp[load][11][31:16],temp[load][10][15:0] + temp[load][11][15:0]};
                     fft_d3 <= {temp[load][12][31:16] + temp[load][13][31:16],temp[load][12][15:0] + temp[load][13][15:0]};
                     fft_d7 <= {temp[load][14][31:16] + temp[load][15][31:16],temp[load][14][15:0] + temp[load][15][15:0]};
                     fft_d8 <= {br[0][31:16],bi[0][31:16]};
                     fft_d12 <= {br[1][31:16],bi[1][31:16]};
                     fft_d10 <= {br[2][31:16],bi[2][31:16]};
                     fft_d14 <= {br[3][31:16],bi[3][31:16]};
                     fft_d9 <= {br[4][31:16],bi[4][31:16]};
                     fft_d13 <= {br[5][31:16],bi[5][31:16]};
                     fft_d11 <= {br[6][31:16],bi[6][31:16]};
                     fft_d15 <= {br[7][31:16],bi[7][31:16]};
              end
              else if (stage == 5'd7) begin
                     fft_valid <= 1'd0;
                     load <= load + 10'd1;
                     stage <= -5'd1;
                     if (load == 10'd9) begin
                            done <= 1'd1;
                     end
              end
         end
       end

end
always @(*) begin
       if(stage == -5'd1)begin
              br[0] <= $signed(temp[load][0][31:16] - temp[load][8][31:16]) * wr[0] + $signed(temp[load][8][15:0] - temp[load][0][15:0]) * wi[0];
              bi[0] <= $signed(temp[load][0][31:16] - temp[load][8][31:16])* wi[0] + $signed(temp[load][0][15:0] - temp[load][8][15:0]) * wr[0];
              br[1] <= $signed(temp[load][1][31:16] - temp[load][9][31:16]) * wr[1] + $signed(temp[load][9][15:0] - temp[load][1][15:0]) * (wi[1]);
              bi[1] <= $signed(temp[load][1][31:16] - temp[load][9][31:16])* wi[1] + $signed(temp[load][1][15:0] - temp[load][9][15:0]) * wr[1];
              br[2] <= $signed(temp[load][2][31:16] - temp[load][10][31:16]) * wr[2] + $signed(temp[load][10][15:0] - temp[load][2][15:0]) * wi[2];
              bi[2] <= $signed(temp[load][2][31:16] - temp[load][10][31:16])* wi[2] + $signed(temp[load][2][15:0] - temp[load][10][15:0]) * wr[2];
              br[3] <= $signed(temp[load][3][31:16] - temp[load][11][31:16]) * wr[3] + $signed(temp[load][11][15:0] - temp[load][3][15:0]) * wi[3];
              bi[3] <= $signed(temp[load][3][31:16] - temp[load][11][31:16])* wi[3] + $signed(temp[load][3][15:0] - temp[load][11][15:0]) * wr[3];
              br[4] <= $signed(temp[load][4][31:16] - temp[load][12][31:16]) * wr[4] + $signed(temp[load][12][15:0] - temp[load][4][15:0]) * wi[4];
              bi[4] <= $signed(temp[load][4][31:16] - temp[load][12][31:16])* wi[4] + $signed(temp[load][4][15:0] - temp[load][12][15:0]) * wr[4];
              br[5] <= $signed(temp[load][5][31:16] - temp[load][13][31:16]) * wr[5] + $signed(temp[load][13][15:0] - temp[load][5][15:0]) * wi[5];
              bi[5] <= $signed(temp[load][5][31:16] - temp[load][13][31:16])* wi[5] + $signed(temp[load][5][15:0] - temp[load][13][15:0]) * wr[5];
              br[6] <= $signed(temp[load][6][31:16] - temp[load][14][31:16]) * wr[6] + $signed(temp[load][14][15:0] - temp[load][6][15:0]) * wi[6];
              bi[6] <= $signed(temp[load][6][31:16] - temp[load][14][31:16])* wi[6] + $signed(temp[load][6][15:0] - temp[load][14][15:0]) * wr[6];
              br[7] <= $signed(temp[load][7][31:16] - temp[load][15][31:16]) * wr[7] + $signed(temp[load][15][15:0] - temp[load][7][15:0]) * wi[7];
              bi[7] <= $signed(temp[load][7][31:16] - temp[load][15][31:16])* wi[7] + $signed(temp[load][7][15:0] - temp[load][15][15:0]) * wr[7];
       end
       else if (stage == 5'd0) begin
              
       end
       else if (stage == 5'd1) begin
              br[0] <= $signed(temp[load][0][31:16] - temp[load][4][31:16]) * wr[0] + $signed(temp[load][4][15:0] - temp[load][0][15:0]) * wi[0];
              bi[0] <= $signed(temp[load][0][31:16] - temp[load][4][31:16])* wi[0] + $signed(temp[load][0][15:0] - temp[load][4][15:0]) * wr[0];
              br[1] <= $signed(temp[load][1][31:16] - temp[load][5][31:16]) * wr[2] + $signed(temp[load][5][15:0] - temp[load][1][15:0]) * wi[2];
              bi[1] <= $signed(temp[load][1][31:16] - temp[load][5][31:16])* wi[2] + $signed(temp[load][1][15:0] - temp[load][5][15:0]) * wr[2];
              br[2] <= $signed(temp[load][2][31:16] - temp[load][6][31:16]) * wr[4] + $signed(temp[load][6][15:0] - temp[load][2][15:0]) * wi[4];
              bi[2] <= $signed(temp[load][2][31:16] - temp[load][6][31:16])* wi[4] + $signed(temp[load][2][15:0] - temp[load][6][15:0]) * wr[4];
              br[3] <= $signed(temp[load][3][31:16] - temp[load][7][31:16]) * wr[6] + $signed(temp[load][7][15:0] - temp[load][3][15:0]) * wi[6];
              bi[3] <= $signed(temp[load][3][31:16] - temp[load][7][31:16])* wi[6] + $signed(temp[load][3][15:0] - temp[load][7][15:0]) * wr[6];
              br[4] <= $signed(temp[load][8][31:16] - temp[load][12][31:16]) * wr[0] + $signed(temp[load][12][15:0] - temp[load][8][15:0]) * wi[0];
              bi[4] <= $signed(temp[load][8][31:16] - temp[load][12][31:16])* wi[0] + $signed(temp[load][8][15:0] - temp[load][12][15:0]) * wr[0];
              br[5] <= $signed(temp[load][9][31:16] - temp[load][13][31:16]) * wr[2] + $signed(temp[load][13][15:0] - temp[load][9][15:0]) * wi[2];
              bi[5] <= $signed(temp[load][9][31:16] - temp[load][13][31:16])* wi[2] + $signed(temp[load][9][15:0] - temp[load][13][15:0]) * wr[2];
              br[6] <= $signed(temp[load][10][31:16] - temp[load][14][31:16]) * wr[4] + $signed(temp[load][14][15:0] - temp[load][10][15:0]) * wi[4];
              bi[6] <= $signed(temp[load][10][31:16] - temp[load][14][31:16])* wi[4] + $signed(temp[load][10][15:0] - temp[load][14][15:0]) * wr[4];
              br[7] <= $signed(temp[load][11][31:16] - temp[load][15][31:16]) * wr[6] + $signed(temp[load][15][15:0] - temp[load][11][15:0]) * wi[6];
              bi[7] <= $signed(temp[load][11][31:16] - temp[load][15][31:16])* wi[6] + $signed(temp[load][11][15:0] - temp[load][15][15:0]) * wr[6];
       end
       else if (stage == 5'd2) begin
              
       end
       else if (stage == 5'd3) begin
              br[0] <= $signed(temp[load][0][31:16] - temp[load][2][31:16]) * wr[0] + $signed(temp[load][2][15:0] - temp[load][0][15:0]) * wi[0];
              bi[0] <= $signed(temp[load][0][31:16] - temp[load][2][31:16])* wi[0] + $signed(temp[load][0][15:0] - temp[load][2][15:0]) * wr[0];
              br[1] <= $signed(temp[load][1][31:16] - temp[load][3][31:16]) * wr[4] + $signed(temp[load][3][15:0] - temp[load][1][15:0]) * wi[4];
              bi[1] <= $signed(temp[load][1][31:16] - temp[load][3][31:16])* wi[4] + $signed(temp[load][1][15:0] - temp[load][3][15:0]) * wr[4];
              br[2] <= $signed(temp[load][4][31:16] - temp[load][6][31:16]) * wr[0] + $signed(temp[load][6][15:0] - temp[load][4][15:0]) * wi[0];
              bi[2] <= $signed(temp[load][4][31:16] - temp[load][6][31:16])* wi[0] + $signed(temp[load][4][15:0] - temp[load][6][15:0]) * wr[0];
              br[3] <= $signed(temp[load][5][31:16] - temp[load][7][31:16]) * wr[4] + $signed(temp[load][7][15:0] - temp[load][5][15:0]) * wi[4];
              bi[3] <= $signed(temp[load][5][31:16] - temp[load][7][31:16])* wi[4] + $signed(temp[load][5][15:0] - temp[load][7][15:0]) * wr[4];
              br[4] <= $signed(temp[load][8][31:16] - temp[load][10][31:16]) * wr[0] + $signed(temp[load][10][15:0] - temp[load][8][15:0]) * wi[0];
              bi[4] <= $signed(temp[load][8][31:16] - temp[load][10][31:16])* wi[0] + $signed(temp[load][8][15:0] - temp[load][10][15:0]) * wr[0];
              br[5] <= $signed(temp[load][9][31:16] - temp[load][11][31:16]) * wr[4] + $signed(temp[load][11][15:0] - temp[load][9][15:0]) * wi[4];
              bi[5] <= $signed(temp[load][9][31:16] - temp[load][11][31:16])* wi[4] + $signed(temp[load][9][15:0] - temp[load][11][15:0]) * wr[4];
              br[6] <= $signed(temp[load][12][31:16] - temp[load][14][31:16]) * wr[0] + $signed(temp[load][14][15:0] - temp[load][12][15:0]) * wi[0];
              bi[6] <= $signed(temp[load][12][31:16] - temp[load][14][31:16])* wi[0] + $signed(temp[load][12][15:0] - temp[load][14][15:0]) * wr[0];
              br[7] <= $signed(temp[load][13][31:16] - temp[load][15][31:16]) * wr[4] + $signed(temp[load][15][15:0] - temp[load][13][15:0]) * wi[4];
              bi[7] <= $signed(temp[load][13][31:16] - temp[load][15][31:16])* wi[4] + $signed(temp[load][13][15:0] - temp[load][15][15:0]) * wr[4];
       end
       else if (stage == 5'd4) begin
              
       end
       else if (stage == 5'd5) begin
              br[0] <= $signed(temp[load][0][31:16] - temp[load][1][31:16]) * wr[0] + $signed(temp[load][1][15:0] - temp[load][0][15:0]) * wi[0];
              bi[0] <= $signed(temp[load][0][31:16] - temp[load][1][31:16])* wi[0] + $signed(temp[load][0][15:0] - temp[load][1][15:0]) * wr[0];
              br[1] <= $signed(temp[load][2][31:16] - temp[load][3][31:16]) * wr[0] + $signed(temp[load][3][15:0] - temp[load][2][15:0]) * wi[0];
              bi[1] <= $signed(temp[load][2][31:16] - temp[load][3][31:16])* wi[0] + $signed(temp[load][2][15:0] - temp[load][3][15:0]) * wr[0];
              br[2] <= $signed(temp[load][4][31:16] - temp[load][5][31:16]) * wr[0] + $signed(temp[load][5][15:0] - temp[load][4][15:0]) * wi[0];
              bi[2] <= $signed(temp[load][4][31:16] - temp[load][5][31:16])* wi[0] + $signed(temp[load][4][15:0] - temp[load][5][15:0]) * wr[0];
              br[3] <= $signed(temp[load][6][31:16] - temp[load][7][31:16]) * wr[0] + $signed(temp[load][7][15:0] - temp[load][6][15:0]) * wi[0];
              bi[3] <= $signed(temp[load][6][31:16] - temp[load][7][31:16])* wi[0] + $signed(temp[load][6][15:0] - temp[load][7][15:0]) * wr[0];
              br[4] <= $signed(temp[load][8][31:16] - temp[load][9][31:16]) * wr[0] + $signed(temp[load][9][15:0] - temp[load][8][15:0]) * wi[0];
              bi[4] <= $signed(temp[load][8][31:16] - temp[load][9][31:16])* wi[0] + $signed(temp[load][8][15:0] - temp[load][9][15:0]) * wr[0];
              br[5] <= $signed(temp[load][10][31:16] - temp[load][11][31:16]) * wr[0] + $signed(temp[load][11][15:0] - temp[load][10][15:0]) * wi[0];
              bi[5] <= $signed(temp[load][10][31:16] - temp[load][11][31:16])* wi[0] + $signed(temp[load][10][15:0] - temp[load][11][15:0]) * wr[0];
              br[6] <= $signed(temp[load][12][31:16] - temp[load][13][31:16]) * wr[0] + $signed(temp[load][13][15:0] - temp[load][12][15:0]) * wi[0];
              bi[6] <= $signed(temp[load][12][31:16] - temp[load][13][31:16])* wi[0] + $signed(temp[load][12][15:0] - temp[load][13][15:0]) * wr[0];
              br[7] <= $signed(temp[load][14][31:16] - temp[load][15][31:16]) * wr[0] + $signed(temp[load][15][15:0] - temp[load][14][15:0]) * wi[0];
              bi[7] <= $signed(temp[load][14][31:16] - temp[load][15][31:16])* wi[0] + $signed(temp[load][14][15:0] - temp[load][15][15:0]) * wr[0];
       end
end
endmodule

