module hit_controller 	
 ( 
	input	logic  clk,
	input	logic  resetN, 
	input	logic	 drawing_request_player,
	input	logic	 drawing_request_fire_ring,
	input	logic	 drawing_request_poop,
	input	logic	 drawing_request_life,
	input	logic	 drawing_request_bird,
	input	logic	 drawing_request_rail,
	input	logic	 drawing_request_coin,
	input logic	[10:0] pixelY, // current Y pixel 

	output logic [2:0] hit_type	
  ) ;
  
const int no_hit = 0;
const int life = 1;
const int coin = 2;
const int good_collision =	3;
const int bad_collision =	4;


always_ff @(posedge clk or negedge resetN) begin
	
	//*******TODO******//
	//CHANGE hit logic, use X,Y pixel to analyse if this is a bad or good collision//
	//USE Y pixel to determine if this is a good or bad collision// 
	
	if(!resetN) begin
		hit_type <= no_hit; 
	end
	else begin //Synchronous
		if (drawing_request_player) begin
			if (drawing_request_life) begin
				hit_type <= life;
			end
			else if (drawing_request_coin) begin
				hit_type <= coin;
			end
			else if (drawing_request_fire_ring || drawing_request_rail) begin // CHANGE//
				hit_type <= good_collision;
			end
			else if (drawing_request_poop || drawing_request_bird) begin //CHANGE//
				hit_type <= bad_collision;
			end
		end
		else begin
			hit_type <= no_hit;
		end
	end
	
end

endmodule
