//-- Alex Grinshpun Apr 2017
//-- Dudy Nov 13 2017
// System-Verilog Alex Grinshpun May 2018
// New coding convention dudy December 2018


module	player_move	(	
 
					input	logic	clk,
					input	logic	resetN,
					input	logic	start_Of_frame,  // short pulse every start of frame 30Hz 
					input	logic	small_jump,  //Small jump if space is pressed
					input	logic	high_jump, //High jump if Enter is pressed  
					
					output	logic	[10:0]	topLeftX,// output the top left corner 
					output	logic	[10:0]	topLeftY
					
);


// a module used to generate a ball trajectory.  

parameter int INITIAL_X = 20;
parameter int INITIAL_Y = 400;
//parameter int INITIAL_X_SPEED = 30;
parameter int INITIAL_Y_SPEED = 0;
parameter int Y_ACCEL = -5; 
parameter int HIGH_JUMP_INITIAL_SPEED = 100;
parameter int SMALL_JUMP_INITIAL_SPEED = 50;



const int	MULTIPLIER	=	64;
// multiplier is used to work with integers in high resolution 
// we devide at the end by multiplier which must be 2^n 
//const int	x_FRAME_SIZE	=	639 * MULTIPLIER;
const int	y_FRAME_SIZE	=	479 * MULTIPLIER;


//int Xspeed, topLeftX_tmp; // local parameters 
int Yspeed, topLeftY_tmp;
//logic toggleY_d; 


//  calculation x Axis speed 

//======--------------------------------------------------------------------------------------------------------------=
//always_ff@(posedge clk or negedge resetN)
//begin
//	if(!resetN)
//		Xspeed	<= INITIAL_X_SPEED;
	//else 	begin
		//	
			//if ((topLeftX_tmp <= 0 ) && (Xspeed < 0) ) // hit left border while moving right
				//Xspeed <= -Xspeed ; 
			
			//if ( (topLeftX_tmp >= x_FRAME_SIZE) && (Xspeed > 0 )) // hit right border while moving left
				//Xspeed <= -Xspeed ; 
	//end
//end


//  calculation Y Axis speed using gravity

//======--------------------------------------------------------------------------------------------------------------=
always_ff@(posedge clk or negedge resetN) begin
	if(!resetN) begin 
		Yspeed	<= INITIAL_Y_SPEED;
		//toggleY_d = 1'b0 ; 
	end 
	else begin
		//toggleY_d <= toggleY ; // for edge detect 
		//	if ((toggleY == 1'b1 ) && (toggleY_d== 1'b0)) // detect toggle command rising edge from user  
		//	Yspeed <= -Yspeed ; 
		//else begin ; 
		

			if (start_Of_frame == 1'b1 && (topLeftY_tmp != (INITIAL_Y * MULTIPLIER))) begin 
				Yspeed <= Yspeed  - Y_ACCEL ; // deAccelerate : slow the speed down every clock tick 
			end
			
			if (topLeftY_tmp == (INITIAL_Y * MULTIPLIER))  begin
				if(small_jump) begin
					Yspeed <= SMALL_JUMP_INITIAL_SPEED;
				end
				else if (high_jump) begin
					Yspeed <= HIGH_JUMP_INITIAL_SPEED;
				end
			end

			
			//if ((topLeftY_tmp <= 0 ) && (Yspeed < 0 )) // hit top border heading up
				//Yspeed <= -Yspeed ; 
			
			if ( ( topLeftY_tmp >= INITIAL_Y) && (Yspeed < 0 )) //On landing 
				Yspeed <= 0 ; 
		//end 

	end
end

// position calculate 

//======--------------------------------------------------------------------------------------------------------------=
always_ff@(posedge clk or negedge resetN) begin
	if (!resetN) begin
		//topLeftX_tmp	<= INITIAL_X * MULTIPLIER;
		topLeftY_tmp	<= INITIAL_Y * MULTIPLIER;
	end
	else begin
			if (start_Of_frame == 1'b1) begin // perform only 30 times per second 
						
				//if (X_direction)  //select the direction 
					//topLeftX_tmp  <= topLeftX_tmp + Xspeed; 
				//else 
					//topLeftX_tmp  <= topLeftX_tmp - Xspeed; 
			
				topLeftY_tmp  <= topLeftY_tmp + Yspeed;
			
				
			end
	end
end

//======--------------------------------------------------------------------------------------------------------------=
//get a better (64 times) resolution using integer   
//assign 	topLeftX = topLeftX_tmp / MULTIPLIER ;   // note:  it must be 2^n 
assign 	topLeftY = topLeftY_tmp / MULTIPLIER ;    
assign 	topLeftX = INITIAL_X;

endmodule
