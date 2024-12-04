module spi_master(mclk,reset,load, read,miso,start,data_in,data_out,mosi,sclk,cs);
  input mclk,reset,load,miso,start,read;
  input [7:0]data_in;
  output [7:0]data_out;
  output reg mosi,cs;
  output sclk;
  integer count; 

  reg [7:0]shift_reg;
  reg [7:0]data_out_reg

  assign data_out = read ? data_out_reg: 8'h0;

  assign sclk=mclk;
  
  always @(posedge sclk,negedge reset)
    if(!reset)
      begin
        shift_reg<='b0;
        cs<='b0;
        mosi<='b0;
        data_out_reg<='b0;
      end
    else begin 
      if(start) begin 
        if(load) begin
          shift_reg<=data_in;
          count<=0;
        end
        else if(read)
          data_out_reg<=shift_reg;
        else if(count<8)begin
          shift_reg<={miso,shift_reg[7:1]};
          mosi<=shift_reg[0];
          count<=count+1;
        end
      end
      z
  
endmodule

