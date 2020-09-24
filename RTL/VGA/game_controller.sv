module game_controller 	
 ( 
	input	logic  clk,
	input	logic  resetN, 
	input	logic	 [2:0] hit_type,
	input	logic	 [7:0] random_number,
	input	logic	 start_of_frame,
	
	output logic [3:0] life_counter,	
	output logic [7:0] score_counter,	
	output logic sound,					//TODO
	output logic [2:0] what_to_create	

  ) ;
  
  

const int initial_life = 3;
const int initial_score = 0;
const int create_nothing = 0;
const int no_hit = 0;
const int life = 1;
const int coin = 2;
const int good_collision =	3;
const int bad_collision =	4;
  
logic [10:0] start_of_frame_counter;   
  

  
always_ff @(posedge clk or negedge resetN) begin
		
		//***********TODO**************//
		//*****set initial values?*****//
		//*****************************//
		
		if(!resetN) begin
			life_counter <= initial_life; 
			score_counter <= initial_score;
			what_to_create <= create_nothing;
		end
		
		else begin 			//Synchronous
		
			if (hit_type != no_hit) begin
				case (hit_type)
					life: life_counter <= life_counter + 1;
					coin: score_counter <= score_counter + 1;
					good_collision: score_counter <= score_counter + 2;
					bad_collision: life_counter <= life_counter - 1;
				endcase
			end
			
			if (start_of_frame) begin
				start_of_frame_counter <= start_of_frame_counter + 1;
			end
			
			//**********TODO**********//
			//Enter here an algorithm that decides what to create based on rand and start_of_frame_counter//
			
			
			//**********TODO**********//
			//CHANGE RAND module rise input source//
		end
	
	end
 
endmodule

