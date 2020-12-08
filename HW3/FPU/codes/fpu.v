module fpu #(
    parameter DATA_WIDTH = 32,
    parameter INST_WIDTH = 1
)(
    input                   i_clk,
    input                   i_rst_n,
    input  [DATA_WIDTH-1:0] i_data_a,
    input  [DATA_WIDTH-1:0] i_data_b,
    input  [INST_WIDTH-1:0] i_inst,
    input                   i_valid,
    output [DATA_WIDTH-1:0] o_data,
    output                  o_valid
);

    // homework
    reg [DATA_WIDTH-1:0] o_data_r, o_data_w;
 	reg                  o_valid_r, o_valid_w;
	reg [31:0]           temp_a;
	reg [31:0]           temp_b;
	reg [31:0]           out;
	reg [31:0]           n;
	reg                  round;
	reg                  sticky;
	reg [64:0]           mul_out;
	
	assign o_data = o_data_r;
	assign o_valid =o_valid_r;
	
	
	always @(*) begin
	    if (i_valid) begin
	        case(i_inst)
				// fp adder
				1'd0:begin
				    // a為正 b為正
					if (~i_data_a[31] & ~i_data_b[31])begin
					    // exponent_b 較大
						if (i_data_a[30:23] < i_data_b[30:23])begin
					        temp_a = i_data_a[22:0];
							temp_b = i_data_b[22:0];
							temp_a[23] = 1;
							temp_b[23] = 1;
							n = i_data_b[30:23] - i_data_a[30:23];				
							round = temp_a[n-1];
							temp_a = temp_a >>n;
							out = temp_a+temp_b;							
							
							o_data_w = out;
							o_data_w[30:23] = i_data_b[30:23];
							o_data_w[31] = 0;
							if (round == 1 )begin
							    o_data_w = o_data_w+1;
							end	
						end
						// exponent_a 較大
						else if (i_data_a[30:23] > i_data_b[30:23])begin
						    temp_a = i_data_a[22:0];
							temp_b = i_data_b[22:0];
							temp_a[23] = 1;
							temp_b[23] = 1;
							n = i_data_a[30:23] - i_data_b[30:23];
							round = temp_b[n-1];
							temp_b = temp_b >>n;
							out = temp_a+temp_b;
   							
							o_data_w = out;
							o_data_w[30:23] = i_data_a[30:23];
							o_data_w[31] = 0;
							if (round == 1)begin
							    o_data_w = o_data_w+1;
							end
						end
						// exponent 一樣大
						else begin
						    temp_a = i_data_a[22:0];
							temp_b = i_data_b[22:0];
							temp_a[23] = 1;
							temp_b[23] = 1;
							out = temp_a+temp_b;
							round = out[0];
							out = out >> 1;
	
							o_data_w = out;
					        o_data_w[30:23] = i_data_a[30:23]+1;
						    o_data_w[31] = 0; 
							if (round == 1)begin
							    o_data_w = o_data_w+1;
							end
                        end
					end	
					// a為正 b為負
					else if (~i_data_a[31] & i_data_b[31])begin 
					    // exponent_b 較大
						if (i_data_a[30:23] < i_data_b[30:23])begin
					        temp_a = i_data_a[22:0];
							temp_b = i_data_b[22:0];
							temp_a[23] = 1;
							temp_b[23] = 1;
							n = i_data_b[30:23] - i_data_a[30:23];
							round = temp_a[n-1];
							temp_a = temp_a >>n;
							out = temp_b-temp_a;							
							o_data_w = out;
							o_data_w[30:23] = i_data_b[30:23];
							o_data_w[31] = 1;
							if (round == 1 )begin
							    o_data_w = o_data_w-1;
							end
						end
						// exponent_a 較大
						else if (i_data_a[30:23] > i_data_b[30:23])begin
					        temp_a = i_data_a[22:0];
							temp_b = i_data_b[22:0];
							temp_a[23] = 1;
							temp_b[23] = 1;
							n = i_data_a[30:23] - i_data_b[30:23];
							round = temp_b[n-1];
							temp_b = temp_b >>n;
							out = temp_a-temp_b;							
							o_data_w = out;
							o_data_w[30:23] = i_data_a[30:23];
							o_data_w[31] = 0;
							if (round == 1 )begin
							    o_data_w = o_data_w-1;
							end
						end
						// exponent 一樣大
						else begin
						    temp_a = i_data_a[22:0];
							temp_b = i_data_b[22:0];
							temp_a[23] = 1;
							temp_b[23] = 1;
							// precision_a較大
							if (temp_a > temp_b)begin
							    out = temp_a-temp_b;
							    n = 0;
								while(out[23-n] == 0)begin
								    n = n+1;
								end
							    out = out << n;
	                            o_data_w = out;
					            o_data_w[30:23] = i_data_a[30:23]-n;
						        o_data_w[31] = 0; 
							end
							// precision_b較大
							else if (temp_a < temp_b)begin
							    out = temp_b-temp_a;
							    n = 0;
								while(out[23-n] == 0)begin
								    n = n+1;
								end
							    out = out << n;
	                            o_data_w = out;
					            o_data_w[30:23] = i_data_a[30:23]-n;
						        o_data_w[31] = 1;
							end  
							// precision一樣大
							else begin
							    o_data_w = 0;
							end
						end						
					end	
					// a為負 b為正
					else if (i_data_a[31] & ~i_data_b[31])begin 
					    // exponent_b 較大
						if (i_data_a[30:23] < i_data_b[30:23])begin
					        temp_a = i_data_a[22:0];
							temp_b = i_data_b[22:0];
							temp_a[23] = 1;
							temp_b[23] = 1;
							n = i_data_b[30:23] - i_data_a[30:23];
							round = temp_a[n-1];
							temp_a = temp_a >>n;
							out = temp_b-temp_a;							
							o_data_w = out;
							o_data_w[30:23] = i_data_b[30:23];
							o_data_w[31] = 0;
							if (round == 1 )begin
							    o_data_w = o_data_w-1;
							end
						end
						// exponent_a 較大
						else if (i_data_a[30:23] > i_data_b[30:23])begin
					        temp_a = i_data_a[22:0];
							temp_b = i_data_b[22:0];
							temp_a[23] = 1;
							temp_b[23] = 1;
							n = i_data_a[30:23] - i_data_b[30:23];
							round = temp_b[n-1];
							temp_b = temp_b >>n;
							out = temp_a-temp_b;							
							o_data_w = out;
							o_data_w[30:23] = i_data_a[30:23];
							o_data_w[31] = 1;
							if (round == 1 )begin
							    o_data_w = o_data_w-1;
							end
						end
						// exponent 一樣大
						else begin
						    temp_a = i_data_a[22:0];
							temp_b = i_data_b[22:0];
							temp_a[23] = 1;
							temp_b[23] = 1;
							// precision_a較大
							if (temp_a > temp_b)begin
							    out = temp_a-temp_b;
							    n = 0;
								while(out[23-n] == 0)begin
								    n = n+1;
								end
							    out = out << n;
	                            o_data_w = out;
					            o_data_w[30:23] = i_data_a[30:23]-n;
						        o_data_w[31] = 1; 
							end
							// precision_b較大
							else if (temp_a < temp_b)begin
							    out = temp_b-temp_a;
							    n = 0;
								while(out[23-n] == 0)begin
								    n = n+1;
								end
							    out = out << n;
	                            o_data_w = out;
					            o_data_w[30:23] = i_data_a[30:23]-n;
						        o_data_w[31] = 0;
							end  
							// a,b一樣大
							else begin
							    o_data_w = 0;
							end
						end				
					end
					// a為負 b為負
					if (i_data_a[31] & i_data_b[31])begin
					    // exponent_b 較大
						if (i_data_a[30:23] < i_data_b[30:23])begin
					        temp_a = i_data_a[22:0];
							temp_b = i_data_b[22:0];
							temp_a[23] = 1;
							temp_b[23] = 1;
							n = i_data_b[30:23] - i_data_a[30:23];				
							round = temp_a[n-1];
							temp_a = temp_a >>n;
							out = temp_a+temp_b;							
							
							o_data_w = out;
							o_data_w[30:23] = i_data_b[30:23];
							o_data_w[31] = 1;
							if (round == 1 )begin
							    o_data_w = o_data_w+1;
							end	
						end
						// exponent_a 較大
						else if (i_data_a[30:23] > i_data_b[30:23])begin
						    temp_a = i_data_a[22:0];
							temp_b = i_data_b[22:0];
							temp_a[23] = 1;
							temp_b[23] = 1;
							n = i_data_a[30:23] - i_data_b[30:23];
							round = temp_b[n-1];
							temp_b = temp_b >>n;
							out = temp_a+temp_b;
   							
							o_data_w = out;
							o_data_w[30:23] = i_data_a[30:23];
							o_data_w[31] = 1;
							if (round == 1)begin
							    o_data_w = o_data_w+1;
							end
						end
						// exponent 一樣大
						else begin
						    temp_a = i_data_a[22:0];
							temp_b = i_data_b[22:0];
							temp_a[23] = 1;
							temp_b[23] = 1;
							out = temp_a+temp_b;
							round = out[0];
							out = out >> 1;
	
							o_data_w = out;
					        o_data_w[30:23] = i_data_a[30:23]+1;
						    o_data_w[31] = 1; 
							if (round == 1)begin
							    o_data_w = o_data_w+1;
							end
                        end
						
					end	
					o_valid_w = 1;
				end
				// fp multiplier
				1'd1:begin 
					// a,b 不同號
					if (i_data_a[31] & ~i_data_b[31]|~i_data_a[31] & i_data_b[31])begin
						if (1 == 1) begin
						    temp_a = i_data_a[22:0];
							temp_b = i_data_b[22:0];
							temp_a[23] = 1;
							temp_b[23] = 1;
							mul_out = temp_a*temp_b;
							round = mul_out[22];
							mul_out = mul_out >> 23;
							
							if (mul_out[24] == 1) begin
							    round = mul_out[0];
								mul_out = mul_out >> 1;								
							    o_data_w = mul_out;
							    o_data_w[30:23] = i_data_a[30:23]+i_data_b[30:23]-127+1;
						        o_data_w[31] = 1;
								if (round == 1)begin
								    o_data_w = o_data_w+1;
								end
							end
							else begin
							    o_data_w = mul_out;
							    o_data_w[30:23] = i_data_a[30:23]+i_data_b[30:23]-127;
						        o_data_w[31] = 1;
								if (round == 1)begin
								    o_data_w = o_data_w+1;
								end
						    end
						end
					end 
                    // a,b 同號
					if (i_data_a[31] & i_data_b[31]|~i_data_a[31] & ~i_data_b[31])begin
						if (1 == 1) begin
						    temp_a = i_data_a[22:0];
							temp_b = i_data_b[22:0];
							temp_a[23] = 1;
							temp_b[23] = 1;
							mul_out = temp_a*temp_b;
							round = mul_out[22];
							mul_out = mul_out >> 23;
							
							if (mul_out[24] == 1) begin
							    round = mul_out[0];
							    mul_out = mul_out >> 1;
							    o_data_w = mul_out;
							    o_data_w[30:23] = i_data_a[30:23]+i_data_b[30:23]-127+1;
						        o_data_w[31] = 0;
								if (round == 1)begin
								    o_data_w = o_data_w+1;
								end
							end
							else begin
							    o_data_w = mul_out;
							    o_data_w[30:23] = i_data_a[30:23]+i_data_b[30:23]-127;
						        o_data_w[31] = 0;
								if (round == 1)begin
								    o_data_w = o_data_w+1;
								end
						    end
						end
					end
				    o_valid_w = 1;
				end
				default:begin
					o_data_w = 0;
					o_valid_w = 1;
			    end		
			endcase	
        end else begin
			o_data_w = 0;
			o_valid_w = 0; 
		end
    end
	
	always @(posedge i_clk or negedge i_rst_n)begin
	    if(~i_rst_n)begin
		    o_data_r <= 0;
			o_valid_r <= 0;
		end else begin
            o_data_r <= o_data_w;
			o_valid_r <= o_valid_w;
		end
    end

endmodule