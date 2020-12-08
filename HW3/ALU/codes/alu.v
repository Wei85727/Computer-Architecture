module alu #(
    parameter DATA_WIDTH = 32,
    parameter INST_WIDTH = 4
)(
    input                   i_clk,
    input                   i_rst_n,
    input  [DATA_WIDTH-1:0] i_data_a,
    input  [DATA_WIDTH-1:0] i_data_b,
    input  [INST_WIDTH-1:0] i_inst,
    input                   i_valid,
    output [DATA_WIDTH-1:0] o_data,
    output                  o_overflow,
    output                  o_valid
);

    // homework
	reg [DATA_WIDTH-1:0] o_data_r, o_data_w;
	reg                  o_overflow_r, o_overflow_w;
 	reg                  o_valid_r, o_valid_w;
	reg                  n;
	reg [31:0]           temp;
	
	reg signed [DATA_WIDTH-1:0] signed_data_a, signed_data_b;
	
	
	assign o_data = o_data_r;
    assign o_overflow = o_overflow_r;
	assign o_valid =o_valid_r;
	
	always @(*) begin
	    if (i_valid) begin
	        case(i_inst)
				4'd0:begin
				    {o_overflow_w, o_data_w}= i_data_a + i_data_b;
					if ((~o_data_w[31] & i_data_a[31] & i_data_b[31])|(o_data_w[31] & ~i_data_a[31] & ~i_data_b[31]))begin
						o_overflow_w = 1;
				    end		
					else
					    o_data_w = i_data_a + i_data_b;
					o_valid_w = 1;
				end	
				4'd1:begin
				    {o_overflow_w, o_data_w} = i_data_a - i_data_b;
					if ((o_data_w[31] & ~i_data_a[31] & i_data_b[31])|(~o_data_w[31] & i_data_a[31] & ~i_data_b[31]))begin
						o_overflow_w = 1;
				    end	
					else
					    o_data_w = i_data_a - i_data_b;
					o_valid_w = 1;
				end	
				4'd2:begin
				    if (i_data_a[31] == 1 & i_data_b[31] == 1)begin
					    o_data_w = i_data_a * i_data_b;
						if (o_data_w[31] == 1) begin
						    o_overflow_w = 1;
						end
                        else begin
                        o_data_w = i_data_a * i_data_b;
					    end
					end
					else if (i_data_a[31] == 0 & i_data_b[31] == 1)begin
                        o_data_w = i_data_a*i_data_b;	
                        if (o_data_w[31] == 0) begin
                            o_overflow_w = 1;
                        end	
                        else begin						
				            temp = ~i_data_b+1;
						    temp = temp*i_data_a;
						    o_data_w = ~temp+1;
						end
					end
					else if	(i_data_a[31] == 1 & i_data_b[31] == 0)begin
					    o_data_w = i_data_a*i_data_b;	
                        if (o_data_w[31] == 0) begin
                            o_overflow_w = 1;
                        end
						else begin
					        temp = ~i_data_a+1;
						    temp = temp*i_data_b;
						    o_data_w = ~temp+1;
						end
					end
                    else begin
						o_data_w = i_data_a*i_data_b;	
                        if (o_data_w[31] == 1) begin
                            o_overflow_w = 1;
                        end
                        else begin
                            o_data_w = i_data_a*i_data_b;
                        end							
					end
					o_valid_w = 1;
				end
				4'd3:begin
				    if ((i_data_a[31] == 0) & (i_data_b[31] == 1))
					    o_data_w = i_data_a;
					else if ((i_data_a[31] == 1) & (i_data_b[31] == 0))
                        o_data_w = i_data_b;				
					else begin
					    if (i_data_a > i_data_b) 
					        o_data_w = i_data_a;
					    else 
					        o_data_w = i_data_b;
					end		
					o_valid_w = 1;
				end
				4'd4:begin
				    if ((i_data_a[31] == 0) & (i_data_b[31] == 1))
					    o_data_w = i_data_b;
					else if ((i_data_a[31] == 1) & (i_data_b[31] == 0))
                        o_data_w = i_data_a;				
					else begin
					    if (i_data_a > i_data_b) 
					        o_data_w = i_data_b;
					    else 
					        o_data_w = i_data_a;
					end		
					o_valid_w = 1;
				end
			    4'd5:begin
				    {o_overflow_w, o_data_w} = i_data_a + i_data_b;
	                o_valid_w = 1;			
				end
				4'd6:begin
				    {o_overflow_w, o_data_w} = i_data_a - i_data_b;
					o_valid_w = 1;
				end
				4'd7:begin
				    {o_overflow_w, o_data_w} = i_data_a * i_data_b;
					o_valid_w = 1;
				end
				4'd8:begin
				    if (i_data_a > i_data_b) 
					    o_data_w = i_data_a;
					else 
					    o_data_w = i_data_b;
					o_valid_w = 1;
				end
				4'd9:begin
				    if (i_data_a < i_data_b) 
					    o_data_w = i_data_a;
					else 
					    o_data_w = i_data_b;
					o_valid_w = 1;
				end
				4'd10:begin
				    o_data_w = i_data_a & i_data_b;
					o_valid_w = 1;
				end
				4'd11:begin
				    o_data_w = i_data_a | i_data_b;
					o_valid_w = 1;
				end
				4'd12:begin
				    o_data_w = i_data_a ^ i_data_b;
					o_valid_w = 1;
				end
				4'd13:begin
				    o_data_w = ~i_data_a;
					o_valid_w = 1;
				end
				//4'd14:begin
					//for(n=0;n<32;n=n+1)begin
					  //  o_data_w[n] <= i_data_a[31-n]; 
					//o_valid_w = 1;
					//end
				//end
				4'd14:begin
				    o_data_w[0] = i_data_a[31];
					o_data_w[1] = i_data_a[30];
					o_data_w[2] = i_data_a[29];
					o_data_w[3] = i_data_a[28];
					o_data_w[4] = i_data_a[27];
					o_data_w[5] = i_data_a[26];
					o_data_w[6] = i_data_a[25];
					o_data_w[7] = i_data_a[24];
					o_data_w[8] = i_data_a[23];
					o_data_w[9] = i_data_a[22];
					o_data_w[10] = i_data_a[21];
					o_data_w[11] = i_data_a[20];
					o_data_w[12] = i_data_a[19];
					o_data_w[13] = i_data_a[18];
					o_data_w[14] = i_data_a[17];
					o_data_w[15] = i_data_a[16];
					o_data_w[16] = i_data_a[15];
					o_data_w[17] = i_data_a[14];
					o_data_w[18] = i_data_a[13];
					o_data_w[19] = i_data_a[12];
					o_data_w[20] = i_data_a[11];
					o_data_w[21] = i_data_a[10];
					o_data_w[22] = i_data_a[9];
					o_data_w[23] = i_data_a[8];
					o_data_w[24] = i_data_a[7];
					o_data_w[25] = i_data_a[6];
					o_data_w[26] = i_data_a[5];
					o_data_w[27] = i_data_a[4];
					o_data_w[28] = i_data_a[3];
					o_data_w[29] = i_data_a[2];
					o_data_w[30] = i_data_a[1];
					o_data_w[31] = i_data_a[0];					
                    o_valid_w = 1;				
				end
				default:begin
				    o_overflow_w = 0;
					o_data_w = 0;
					o_valid_w = 1;
			    end		
			endcase	
        end else begin
		    o_overflow_w = 0;
			o_data_w = 0;
			o_valid_w = 0; 
		end
    end	

    always @(posedge i_clk or negedge i_rst_n)begin
	    if(~i_rst_n)begin
		    o_data_r <= 0;
			o_overflow_r <= 0;
			o_valid_r <= 0;
		end else begin
            o_data_r <= o_data_w;
		    o_overflow_r <= o_overflow_w;
			o_valid_r <= o_valid_w;
		end
    end 		
endmodule