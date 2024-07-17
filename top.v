`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11.07.2024 11:34:25
// Design Name: 
// Module Name: top
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module top(
    input clk, start,
    input [bits-1:0] din,
    output reg mosi, 
    output sclk,
    output [bits-1:0]dout
    
    );
    
    parameter board_clk = 10_000;
    parameter clk_value = 100_000;
    parameter bits = 12;
    reg sclkt = 0;
    integer count = 0;
    reg cs,done;
    
    always@(posedge clk) begin 
    
    if(count < (clk_value/board_clk)) begin
        count <= count + 1;
    end
    else begin count <= 0;  sclkt <= ~sclkt; end
    end

    reg [bits-1:0]temp;
    parameter idle = 0; 
    parameter send = 1; 
    parameter start_tx = 2; 
    parameter end_tx = 3;  
    
    reg[1:0] state = idle;
    integer bit_index = 0;
    
    always@(posedge sclkt) begin
    
    case(state)
    idle : begin 
            temp <= 0;
            cs <= 1;
            mosi <= 0;
            done <= 0;
            bit_index <= 0;
            if(start) begin state <= start_tx; 
            end
            else state <= idle;
    end
    
    start_tx : begin
            cs <= 0;
            temp <= din;
            state <= send;
    end
    
    send : begin
            if(bit_index <= bits) begin
            mosi <= temp[bit_index];
            bit_index <= bit_index + 1;
            state <= send;
            end
            
            else begin
            bit_index <= 0;
            state <= end_tx;
            end
            
    end
    
    end_tx : begin
            cs <= 1;
            mosi <= 0;
            done <= 1;
            state <= idle;    
    end
    endcase
    
    end
    assign sclk = sclkt;
    
////receiver rx spi
    reg [bits-1:0]shiftrx = 0;
    reg bit_index_rx = 0;
    reg rxdone = 0;
    reg [bits-1:0]dout_t;
    reg tx;
    
    always@(posedge sclk) begin    
    if(!cs) begin 
        tx <= mosi;
        shiftrx <= {shiftrx[bits-2:0],mosi};
        bit_index_rx <= bit_index_rx + 1;
        rxdone <= 0;
        if(bit_index >= bits-1) begin
            shiftrx <= {shiftrx[bits-1:0],mosi};
            rxdone <= 1;
            dout_t <= shiftrx;
            bit_index_rx <= 0;
        end
        else rxdone <= 0;
    end
    else begin
        bit_index_rx <= 0;
        rxdone <= 0;
    end
    
    end
    
    reverse_bits dut(.da_in(dout_t),.da_out(dout));
endmodule

module reverse_bits(input [11:0]da_in,
                    output [11:0] da_out
                    );
    integer i = 0;
    reg [11:0] temp = 0;
    always@(*) begin
        for(i=0; i<12; i=i+1) begin
            temp[i] = da_in[11-i];  
        end
    end
    assign da_out = temp;
endmodule