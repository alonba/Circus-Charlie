//-- Alex Grinshpun Apr 2017
//-- Dudy Nov 13 2017
// System-Verilog Alex Grinshpun May 2018
// New coding convention dudy December 2018
// New bitmap dudy NOvember 2019
// (c) Technion IIT, Department of Electrical Engineering 2019 



module	smileyBitMap4Bit	(	
					input	logic	clk,
					input	logic	resetN,
					input logic	[10:0] offsetX,// offset from top left  position 
					input logic	[10:0] offsetY,
					input	logic	InsideRectangle, //input that the pixel is within a bracket 

					output	logic	drawingRequest, //output that the pixel should be dispalyed 
					output	logic	[7:0] RGBout  //rgb value from the bitmap 
);
// generating a smiley bitmap 

localparam  int OBJECT_HEIGHT_Y = 32;
localparam  int OBJECT_WIDTH_X = 32;

localparam logic [3:0] TRANSPARENT_ENCODING = 4'hF ;// RGB value in the bitmap representing a transparent pixel 
logic [3:0] RGBout4  ;// RGB in 4 bits 

logic [0:OBJECT_WIDTH_X-1] [0:OBJECT_HEIGHT_Y-1] [4-1:0] object_colors = {
{128'hFFFFFFFFFFFFB444444BFFFFFFFFFFFF},
{128'hFFFFFFFFFB400448844004BFFFFFFFFF},
{128'hFFFFFFFB004AEEEEEEEEA400BFFFFFFF},
{128'hFFFFFF404EEEEEEEEEEEEEE404FFFFFF},
{128'hFFFFF40AEEEEEEEEEEEEEEEEA04FFFFF},
{128'hFFFF44EEEEEEEEEEEEEEEEEEEE44FFFF},
{128'hFFF40EEEEEEEEEEEEEEEEEEEEEE04FFF},
{128'hFFB0AEEEEEEEEEEEEEEEEEEEEEEA0BFF},
{128'hFF04EEEEEEEEEEEEEEEEEEEEEEEE40FF},
{128'hFB0EEEEEEEEEEEEEEEEEEEEEEEEEE0BF},
{128'hF44EEEEEEAAEEEEEAAEEEEEEEEEEE44F},
{128'hF0AEEEEEE04EEEEE40EEEEEEEEEEEA0F},
{128'hB0EEEEEEA04EEEEE00AEEEEEEEEEEE0B},
{128'h44EEEEEE804EEEEA00EEEEEEEEEEEE44},
{128'h44EEEEEEA0AEEEEE08EEEEEEEEEEEE44},
{128'h48EEEEEEEEEEEEEEEEEEEEEEEEEEEE84},
{128'h48EEEEEEEEEEEEEEEEEEEEEEEEEEEE84},
{128'h44EEAEEEEEEEEEEEEEEEEEEEAEEEEE44},
{128'h44EE0AEEEEEEEEEEEEEEEEEA0EEEEE44},
{128'hB0EE44EEEEEEEEEEEEEEEEEA0AEEEE0B},
{128'hF0AEE8AEEEEEEEEEEEEEEEE4AEEEEA0F},
{128'hF44EEE4AEEEEEEEEEEEEEE4AEEEEE44F},
{128'hFB0EEEE4AEEEEEEEEEEEE4AEEEEEE0BF},
{128'hFF04EEEE48EEEEEEEEEA4AEEEEEE40FF},
{128'hFFB0AEEEEA48AEEEEA44EEEEEEEA0BFF},
{128'hFFF40EEEEEEA84444AAEEEEEEEE04FFF},
{128'hFFFF44EEEEEEEEEEEEEEEEEEEE44FFFF},
{128'hFFFFF40AEEEEEEEEEEEEEEEEA04FFFFF},
{128'hFFFFFF404EEEEEEEEEEEEEE404FFFFFF},
{128'hFFFFFFFB004AEEEEEEEEA400BFFFFFFF},
{128'hFFFFFFFFFB400448844004BFFFFFFFFF},
{128'hFFFFFFFFFFFFB444444BFFFFFFFFFFFF}
};

// pipeline (ff) to get the pixel color from the array 	 

//======--------------------------------------------------------------------------------------------------------------=
always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN) begin
		RGBout4 <=	8'h00;
	end
	else begin
		if (InsideRectangle == 1'b1 )  // inside an external bracket 
			RGBout4 <= object_colors[offsetY][offsetX];	//get RGB from the colors table  
		else 
			RGBout4 <= TRANSPARENT_ENCODING ; // force color to transparent so it will not be displayed 
	end 
end

//======--------------------------------------------------------------------------------------------------------------=
// decide if to draw the pixel or not 
assign drawingRequest = (RGBout4 != TRANSPARENT_ENCODING ) ? 1'b1 : 1'b0 ; // get optional transparent command from the bitmpap   

assign RGBout = {RGBout4[3],  {2{RGBout4[2]}}, {3{RGBout4[1]}}, {2{RGBout4[0]}} }  ; // extend the bits to 8 bit   


endmodule