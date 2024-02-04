module traffic_and_pedestrian_light_controller (
output reg [6:0] hex1, hex3, hex5, hex7, hex0, hex2, hex4, hex6,
input sw9, clk_27, reset, key_1, key_2, key_3
);

 reg clk_1, clk_walk;
(* keep *) reg state_1, state_2, state_3, state_4, state_5, state_6, state_4_a, state_4_w, state_4_fd, state_4_d, state_1_w, state_1_fd, state_1_d;
(* keep *) reg state_1_dwell, state_2_d, state_3_d, state_4_dwell, state_5_d, state_6_d, state_4_d_a, state_4_d_w, state_4_d_fd, state_4_d_d, state_1_d_w, state_1_d_fd, state_1_d_d;
(* keep *) reg entering_state_1, entering_state_2, entering_state_3, entering_state_4, entering_state_5, entering_state_6, entering_state_4_a, entering_state_1_w, 
entering_state_4_w, entering_state_1_fd, entering_state_4_fd, entering_state_1_d, entering_state_4_d;
(* keep *) reg staying_in_state_1, staying_in_state_2, staying_in_state_3, staying_in_state_4, staying_in_state_5, staying_in_state_6, staying_in_state_4_a, staying_in_state_1_w, staying_in_state_1_fd,
staying_in_state_1_d, staying_in_state_4_w, staying_in_state_4_fd, staying_in_state_4_d;
(* keep *) reg [5:0] timer;

reg [23:0] max_count;
reg [23:0] count;
reg [23:0] max_count_walk_clk;
reg [23:0] count_walk_clk;

////////////// Making 1 Hz clock from 27 Mhz clock //////////////////////// 
always @ (posedge clk_27)
if(sw9)
max_count_walk_clk = 24'd675000; // this is ten times faster so it less by factor of 10
else
max_count_walk_clk = 24'd6750000; // half of 27 MHz as we are counting only posedges


always @ (posedge clk_27)
if(count_walk_clk == max_count_walk_clk) // 
begin
clk_walk=~clk_walk; // toggle 
count_walk_clk = 24'd0; // restet counter 
end
else
count_walk_clk++;
//////////////////// Ends here /////////////////////////////


reg turn_left_request;

always @ (posedge state_3 or negedge reset or posedge entering_state_4_a or negedge key_1)
if(reset == 1'b0)
turn_left_request=1'b0;
else if(state_3 == 1'b1 )
begin
if(key_1==1'b0)
turn_left_request=1'b1;
else
turn_left_request=1'b0;
end
else
turn_left_request=1'b0;



////////////// Making 1 Hz clock from 27 Mhz clock //////////////////////// 
always @ (posedge clk_27)
if(sw9)
max_count = 24'd1350000; // this is ten times faster so it less by factor of 10
else
max_count = 24'd13500000; // half of 27 MHz as we are counting only posedges


always @ (posedge clk_27)
if(count == max_count) // 
begin
clk_1=~clk_1; // toggle 
count = 24'd0; // restet counter 
end
else
count++;
//////////////////// Ends here /////////////////////////////



////////// if Key 1 pressed for left turn of southbound //////////////////////////
//always @ ( negedge key_1 or negedge staying_in_state_4_a or negedge reset)
//if(reset == 1'b0)
//key_1_pressed = 1'b0;
//else if(key_1 == 1'b0) //// key are active low (normaly they are high if we press it it will be low)
//key_1_pressed = 1'b1;
//else
//key_1_pressed = 1'b0;
////////////////////////////////////////////////////////////////////////////




reg walk_request;

////////// if Key 2 or 3 pressed for walk request //////////////////////////
//always @ ( negedge key_2 or negedge key_3 or negedge entering_state_1_w or negedge entering_state_4_w or negedge reset)
//if(reset == 1'b0)
//walk_request = 1'b0;
//else if(key_2 == 1'b0 || key_3 == 1'b0) //// key are active low (normaly they are high if we press it it will be low)
//walk_request = 1'b1;
//else
//walk_request = 1'b0;



always @ (*)
if(reset==1'b0)
walk_request = 1'b0;
else if(staying_in_state_1_w || staying_in_state_4_w)
walk_request = 1'b0;
else if(key_2 == 1'b0 || key_3==1'b0)
walk_request = 1'b1;
//else
//walk_request = 1'b0;

////////////////////////////////////////////////////////////////////////////





//////////// Timer set for each state ///////////////////////////////////////
always @ (posedge clk_1 or negedge reset)
if (reset == 1'b0)
timer <= 6'd60; // time for state 1
else if (entering_state_1_w == 1'b1 )
timer <= 6'd10;
else if(entering_state_4_w == 1'b1)
timer <= 6'd10;
else if(entering_state_1_fd == 1'b1 )
timer <= 6'd20;
else if(entering_state_4_fd == 1'b1)
timer <= 6'd20;
else if(entering_state_4_d == 1'b1)
timer <= 6'd30;
else if(entering_state_1_d == 1'b1)
timer <=6'd30;
else if (entering_state_1 == 1'b1)
timer <= 6'd60; // time for state 1
else if (entering_state_2 == 1'b1)
timer <= 6'd6; // time for state 2
else if(entering_state_3 == 1'b1)
timer <= 6'd2;
else if (entering_state_4 == 1'b1)
timer <= 6'd60; // time for state 1
else if(entering_state_4_a)
timer <= 6'd20;
else if (entering_state_5 == 1'b1)
timer <= 6'd6; // time for state 2
else if(entering_state_6 == 1'b1)
timer <= 6'd2;
else if (timer == 6'd1)
timer <= timer; // never decrement below 1
else
timer <= timer - 6'd1;
//////////////////////////////////////////////////////////////////




///////////////////// State 1 ///////////////////////////////////////////////
always @ (posedge clk_1 or negedge reset)
if (reset == 1'b0) // keys are active low
state_1 <= 1'b1;
else
state_1 <= state_1_dwell; //logic for entering state 1


always @ *
if( (state_6 == 1'b1) && (timer == 6'd1) && (walk_request == 1'b0))
entering_state_1 <= 1'b1;
else
entering_state_1 <= 1'b0; //logic for staying in state 1


always @ *
if( (state_1 == 1'b1) && (timer != 6'd1) )
staying_in_state_1 <= 1'b1;
else
staying_in_state_1 <= 1'b0; // make the d-input for state_1 flip/flop


always @ *
if( entering_state_1 == 1'b1 ) // enter state 1 on next posedge clk
state_1_dwell <= 1'b1;
else if ( staying_in_state_1 == 1'b1 ) // stay in state 1 on next posedge clk
state_1_dwell <= 1'b1;
else // not in state 1 on next posedge clk
state_1_dwell <=1'b0;
///////////////////////////////////////////////////////////////////////////////////





///////////////////// State 1 walk ///////////////////////////////////////////////
always @ (posedge clk_1 or negedge reset)
if (reset == 1'b0) // keys are active low
state_1_w <= 1'b0;
else
state_1_w <= state_1_d_w; //logic for entering state 1


always @ *
if( (state_6 == 1'b1) && (timer == 6'd1) && (walk_request == 1'b1) )
entering_state_1_w <= 1'b1;
else
entering_state_1_w <= 1'b0; //logic for staying in state 1


always @ *
if( (state_1_w == 1'b1) && (timer != 6'd1) )
staying_in_state_1_w <= 1'b1;
else
staying_in_state_1_w <= 1'b0; // make the d-input for state_1 flip/flop


always @ *
if( entering_state_1_w == 1'b1 ) // enter state 1 on next posedge clk
state_1_d_w <= 1'b1;
else if ( staying_in_state_1_w == 1'b1 ) // stay in state 1 on next posedge clk
state_1_d_w <= 1'b1;
else // not in state 1 on next posedge clk
state_1_d_w <=1'b0;
///////////////////////////////////////////////////////////////////////////////////









///////////////////// State 1 flash do not walk ///////////////////////////////////////////////
always @ (posedge clk_1 or negedge reset)
if (reset == 1'b0) // keys are active low
state_1_fd <= 1'b0;
else
state_1_fd <= state_1_d_fd; //logic for entering state 1


always @ *
if( (state_1_w == 1'b1) && (timer == 6'd1) )
entering_state_1_fd <= 1'b1;
else
entering_state_1_fd <= 1'b0; //logic for staying in state 1


always @ *
if( (state_1_fd == 1'b1) && (timer != 6'd1) )
staying_in_state_1_fd <= 1'b1;
else
staying_in_state_1_fd <= 1'b0; // make the d-input for state_1 flip/flop


always @ *
if( entering_state_1_fd == 1'b1 ) // enter state 1 on next posedge clk
state_1_d_fd <= 1'b1;
else if ( staying_in_state_1_fd == 1'b1 ) // stay in state 1 on next posedge clk
state_1_d_fd <= 1'b1;
else // not in state 1 on next posedge clk
state_1_d_fd <=1'b0;
///////////////////////////////////////////////////////////////////////////////////







///////////////////// State 1 do not walk///////////////////////////////////////////////
always @ (posedge clk_1 or negedge reset)
if (reset == 1'b0) // keys are active low
state_1_d <= 1'b0;
else
state_1_d <= state_1_d_d; //logic for entering state 1


always @ *
if( (state_1_fd == 1'b1) && (timer == 6'd1) )
entering_state_1_d <= 1'b1;
else
entering_state_1_d <= 1'b0; //logic for staying in state 1


always @ *
if( (state_1_d == 1'b1) && (timer != 6'd1) )
staying_in_state_1_d <= 1'b1;
else
staying_in_state_1_d <= 1'b0; // make the d-input for state_1 flip/flop


always @ *
if( entering_state_1_d == 1'b1 ) // enter state 1 on next posedge clk
state_1_d_d <= 1'b1;
else if ( staying_in_state_1_d == 1'b1 ) // stay in state 1 on next posedge clk
state_1_d_d <= 1'b1;
else // not in state 1 on next posedge clk
state_1_d_d <=1'b0;
///////////////////////////////////////////////////////////////////////////////////










////////////////////// State 2 ///////////////////////////////////
always @ (posedge clk_1 or negedge reset)
if (reset == 1'b0) // keys are active low
state_2 <= 1'b0;
else
state_2 <= state_2_d; //logic for entering state 2


always @ *
if( (state_1 || state_1_d) && (timer == 6'd1) )
entering_state_2 <= 1'b1;
else
entering_state_2 <= 1'b0; //logic for staying in state 2


always @ *
if( (state_2 == 1'b1) && (timer != 6'd1) )
staying_in_state_2 <= 1'b1;
else
staying_in_state_2 <= 1'b0; // make the d-input for state_2 flip/flop


always @ *
if( entering_state_2 == 1'b1 ) // enter state 2 on next posedge clk
state_2_d <= 1'b1;
else if ( staying_in_state_2 == 1'b1 ) // stay in state 2 on next posedge clk
state_2_d <= 1'b1;
else // not in state 2 on next posedge clk
state_2_d <=1'b0;
///////////////////////////////////////////////////////////////////////////// 




//////////////////////////// State 3 /////////////////////////////////////////////////// 
always @ (posedge clk_1 or negedge reset)
if (reset == 1'b0) // keys are active low
state_3 <= 1'b0;
else
state_3 <= state_3_d; //logic for entering state 3


always @ *
if( (state_2 == 1'b1) && (timer == 6'd1) )
entering_state_3 <= 1'b1;
else
entering_state_3 <= 1'b0; //logic for staying in state 3


always @ *
if( (state_3 == 1'b1) && (timer != 6'd1) )
staying_in_state_3 <= 1'b1;
else
staying_in_state_3 <= 1'b0; // make the d-input for state_3 flip/flop


always @ *
if( entering_state_3 == 1'b1 ) // enter state 3 on next posedge clk
state_3_d <= 1'b1;
else if ( staying_in_state_3 == 1'b1 ) // stay in state 3 on next posedge clk
state_3_d <= 1'b1;
else // not in state 3 on next posedge clk
state_3_d <=1'b0;
//////////////////////////////////////////////////////////////////////////////




////////////////// State 4_a ////////////////////////////////////
always @ (posedge clk_1 or negedge reset)
if (reset == 1'b0) // keys are active low
state_4_a <= 1'b0;
else
state_4_a <= state_4_d_a; //logic for entering state 4_a


always @ *
if( (state_3 == 1'b1) && (timer == 6'd1) && (turn_left_request) )
entering_state_4_a <= 1'b1;
else
entering_state_4_a <= 1'b0; //logic for staying in state 4_a


always @ *
if( (state_4_a == 1'b1) && (timer != 6'd1) )
staying_in_state_4_a <= 1'b1;
else
staying_in_state_4_a <= 1'b0; // make the d-input for state_4_a flip/flop


always @ *
if( entering_state_4_a == 1'b1 ) // enter state 4_a on next posedge clk
state_4_d_a <= 1'b1;
else if ( staying_in_state_4_a == 1'b1 ) // stay in state 4_a on next posedge clk
state_4_d_a <= 1'b1;
else // not in state 4_a on next posedge clk
state_4_d_a <=1'b0;
//////////////////////////////////////////////////////////////////////////////////








///////////////////// State 4 walk ///////////////////////////////////////////////
always @ (posedge clk_1 or negedge reset)
if (reset == 1'b0) // keys are active low
state_4_w <= 1'b0;
else
state_4_w <= state_4_d_w; //logic for entering state 1


always @ *
if( (state_3==1'b1 || state_4_a==1'b1) && (timer == 6'd1) && (walk_request == 1'b1) && (turn_left_request == 1'b0))
entering_state_4_w <= 1'b1;
else
entering_state_4_w <= 1'b0; //logic for staying in state 1


always @ *
if( (state_4_w == 1'b1) && (timer != 6'd1) )
staying_in_state_4_w <= 1'b1;
else
staying_in_state_4_w <= 1'b0; // make the d-input for state_1 flip/flop


always @ *
if( entering_state_4_w == 1'b1 ) // enter state 1 on next posedge clk
state_4_d_w <= 1'b1;
else if ( staying_in_state_4_w == 1'b1 ) // stay in state 1 on next posedge clk
state_4_d_w <= 1'b1;
else // not in state 1 on next posedge clk
state_4_d_w <=1'b0;
///////////////////////////////////////////////////////////////////////////////////









///////////////////// State 4 flash do not walk ///////////////////////////////////////////////
always @ (posedge clk_1 or negedge reset)
if (reset == 1'b0) // keys are active low
state_4_fd <= 1'b0;
else
state_4_fd <= state_4_d_fd; //logic for entering state 1


always @ *
if( (state_4_w == 1'b1) && (timer == 6'd1) )
entering_state_4_fd <= 1'b1;
else
entering_state_4_fd <= 1'b0; //logic for staying in state 1


always @ *
if( (state_4_fd == 1'b1) && (timer != 6'd1) )
staying_in_state_4_fd <= 1'b1;
else
staying_in_state_4_fd <= 1'b0; // make the d-input for state_1 flip/flop


always @ *
if( entering_state_4_fd == 1'b1 ) // enter state 1 on next posedge clk
state_4_d_fd <= 1'b1;
else if ( staying_in_state_4_fd == 1'b1 ) // stay in state 1 on next posedge clk
state_4_d_fd <= 1'b1;
else // not in state 1 on next posedge clk
state_4_d_fd <=1'b0;
///////////////////////////////////////////////////////////////////////////////////







///////////////////// State 4 do not walk///////////////////////////////////////////////
always @ (posedge clk_1 or negedge reset)
if (reset == 1'b0) // keys are active low
state_4_d <= 1'b0;
else
state_4_d <= state_4_d_d; //logic for entering state 1


always @ *
if( (state_4_fd == 1'b1) && (timer == 6'd1) )
entering_state_4_d <= 1'b1;
else
entering_state_4_d <= 1'b0; //logic for staying in state 1


always @ *
if( (state_4_d == 1'b1) && (timer != 6'd1) )
staying_in_state_4_d <= 1'b1;
else
staying_in_state_4_d <= 1'b0; // make the d-input for state_1 flip/flop


always @ *
if( entering_state_4_d == 1'b1 ) // enter state 1 on next posedge clk
state_4_d_d <= 1'b1;
else if ( staying_in_state_4_d == 1'b1 ) // stay in state 1 on next posedge clk
state_4_d_d <= 1'b1;
else // not in state 1 on next posedge clk
state_4_d_d <=1'b0;
///////////////////////////////////////////////////////////////////////////////////







////////////////////////////      State 4       ////////////////////////////////////////////////////////
always @ (posedge clk_1 or negedge reset)
if (reset == 1'b0) // keys are active low
state_4 <= 1'b0;
else
state_4 <= state_4_dwell; //logic for entering state 4_a


always @ *
if( (state_3 || state_4_a )  && (timer == 6'd1) && (turn_left_request ==1'b0) && (walk_request==1'b0) )
entering_state_4 <= 1'b1;
else
entering_state_4 <= 1'b0; //logic for staying in state 4


always @ *
if( (state_4 == 1'b1) && (timer != 6'd1) )
staying_in_state_4 <= 1'b1;
else
staying_in_state_4 <= 1'b0; // make the d-input for state_4 flip/flop


always @ *
if( entering_state_4 == 1'b1 ) // enter state 4 on next posedge clk
state_4_dwell <= 1'b1;
else if ( staying_in_state_4 == 1'b1 ) // stay in state 4 on next posedge clk
state_4_dwell <= 1'b1;
else // not in state 4 on next posedge clk
state_4_dwell <=1'b0;
//////////////////////////////////////////////////////////////////////////////////////////////////////////////



////////////////////////////////// State 5 ////////////////////////////////////////////////////////////////////
always @ (posedge clk_1 or negedge reset)
if (reset == 1'b0) // keys are active low
state_5 <= 1'b0;
else
state_5 <= state_5_d; //logic for entering state 5


always @ *
if( (state_4 || state_4_d) && (timer == 6'd1) )
entering_state_5 <= 1'b1;
else
entering_state_5 <= 1'b0; //logic for staying in state 5


always @ *
if( (state_5 == 1'b1) && (timer != 6'd1) )
staying_in_state_5 <= 1'b1;
else
staying_in_state_5 <= 1'b0; // make the d-input for state_5 flip/flop


always @ *
if( entering_state_5 == 1'b1 ) // enter state 5 on next posedge clk
state_5_d <= 1'b1;
else if ( staying_in_state_5 == 1'b1 ) // stay in state 5 on next posedge clk
state_5_d <= 1'b1;
else // not in state 5 on next posedge clk
state_5_d <=1'b0;
////////////////////////////////////////////////////////////////////////////////////////////////








//////////////////////////////////////////// State 6 ////////////////////////////////////////////////
always @ (posedge clk_1 or negedge reset)
if (reset == 1'b0) // keys are active low
state_6 <= 1'b0;
else
state_6 <= state_6_d; //logic for entering state 6


always @ *
if( (state_5 == 1'b1) && (timer == 6'd1) )
entering_state_6 <= 1'b1;
else
entering_state_6 <= 1'b0; //logic for staying in state 6


always @ *
if( (state_6 == 1'b1) && (timer != 6'd1) )
staying_in_state_6 <= 1'b1;
else
staying_in_state_6 <= 1'b0; // make the d-input for state_6 flip/flop


always @ *
if( entering_state_6 == 1'b1 ) // enter state 6 on next posedge clk
state_6_d <= 1'b1;
else if ( staying_in_state_6 == 1'b1 ) // stay in state 6 on next posedge clk
state_6_d <= 1'b1;
else // not in state 6 on next posedge clk
state_6_d <=1'b0;
/////////////////////////////////////////////////////////////////////////////////////////////////////





reg northbound_green, northbound_amber, northbound_red, 
southbound_green, southbound_amber, southbound_red, southbound_turn_left,
eastbound_green, eastbound_amber, eastbound_red,
westbound_green, westbound_amber, westbound_red;

reg nbnd_walk_w, nbnd_walk_fd,nbnd_walk_d,
sbnd_walk_w, sbnd_walk_fd, sbnd_walk_d,
 ebnd_walk_w,  ebnd_walk_fd,  ebnd_walk_d,
 wbnd_walk_w,  wbnd_walk_fd,  wbnd_walk_d;

/////////////////////// NorthBound Walk ///////////////////////////////////////
always @ *
if(state_4_w) 
nbnd_walk_w=1'b1;
else
nbnd_walk_w=1'b0;


always @ *
if(state_4_fd) 
nbnd_walk_fd=1'b1;
else
nbnd_walk_fd=1'b0;


always @ *
if(state_4_fd || state_4_w) 
nbnd_walk_d=1'b0;
else
nbnd_walk_d=1'b1;

always @ (posedge clk_walk)
if(nbnd_walk_d)
hex6=7'b0100001;
else if(nbnd_walk_w)
hex6=7'b1011111;
else 
begin 
if(hex6==7'b0100001)
hex6=7'b1111111;
else
hex6=7'b0100001;
end 

/////////////////////////////////////////////////////////////////////////////////////////////




/////////////////////// SouthBound Walk ///////////////////////////////////////
always @ *
if(state_4_w) 
sbnd_walk_w=1'b1;
else
sbnd_walk_w=1'b0;


always @ *
if(state_4_fd) 
sbnd_walk_fd=1'b1;
else
sbnd_walk_fd=1'b0;


always @ *
if(state_4_fd || state_4_w) 
sbnd_walk_d=1'b0;
else
sbnd_walk_d=1'b1;


always @ (posedge clk_walk)
if(sbnd_walk_d)
hex4=7'b0100001;
else if(sbnd_walk_w)
hex4=7'b1011111;
else 
begin 
if(hex4==7'b0100001)
hex4=7'b1111111;
else
hex4=7'b0100001;
end 

/////////////////////////////////////////////////////////////////////////////////////////////






/////////////////////// WestBound Walk ///////////////////////////////////////
always @ *
if(state_1_w) 
wbnd_walk_w=1'b1;
else
wbnd_walk_w=1'b0;


always @ *
if(state_1_fd) 
wbnd_walk_fd=1'b1;
else
wbnd_walk_fd=1'b0;


always @ *
if(state_1_fd || state_1_w) 
wbnd_walk_d=1'b0;
else
wbnd_walk_d=1'b1;


always @ (posedge clk_walk)
if(wbnd_walk_d)
hex2=7'b0100001;
else if(wbnd_walk_w)
hex2=7'b1011111;
else 
begin 
if(hex2==7'b0100001)
hex2=7'b1111111;
else
hex2=7'b0100001;
end 
/////////////////////////////////////////////////////////////////////////////////////////////





/////////////////////// EastBound Walk ///////////////////////////////////////
always @ *
if(state_1_w) 
ebnd_walk_w=1'b1;
else
ebnd_walk_w=1'b0;


always @ *
if(state_1_fd) 
ebnd_walk_fd=1'b1;
else
ebnd_walk_fd=1'b0;


always @ *
if(state_1_fd || state_1_w) 
ebnd_walk_d=1'b0;
else
ebnd_walk_d=1'b1;

always @ (posedge clk_walk)
if(ebnd_walk_d)
hex0=7'b0100001;
else if(ebnd_walk_w)
hex0=7'b1011111;
else 
begin 
if(hex0==7'b0100001)
hex0=7'b1111111;
else
hex0=7'b0100001;
end 
/////////////////////////////////////////////////////////////////////////////////////////////





/////////////////  Norht Bound Light /////////////////////////////
always @ * 
if(state_1 | state_2 | state_3 | state_6 | state_4_a | state_1_w | state_1_fd | state_1_d)
northbound_red = 1'b1;
else 
northbound_red = 1'b0;


always @ *
if(state_4 | state_4_w | state_4_fd | state_4_d)
northbound_green = 1'b1;
else
northbound_green = 1'b0;


always @ *
if(state_5)
northbound_amber=1'b1;
else
northbound_amber=1'b0;
/////////////////////////////////////////////////



/////////////// South Bound Light ///////////////////////////
always @ * 
if(state_4_a)
begin
southbound_turn_left=1'b1;
end
else
southbound_turn_left=1'b0;

always @ * 
if(state_1 | state_2 | state_3 | state_6 | state_1_w | state_1_fd | state_1_d)
southbound_red = 1'b1;
else 
southbound_red = 1'b0;

always @ *
if(state_4 | state_4_w | state_4_fd | state_4_d)
southbound_green = 1'b1;
else
southbound_green = 1'b0;

always @ *
if(state_5)
southbound_amber=1'b1;
else
southbound_amber=1'b0;
/////////////////////////////////////////////////////////////



///////////////// East Bound Light ///////////////////////////////////////////////
always @ *
if ( state_3 | state_4 | state_5 | state_6 | state_4_a | state_4_w | state_4_fd | state_4_d) 
eastbound_red = 1'b1;
else 
eastbound_red = 1'b0;

always @ * 
if(state_1 | state_1_w | state_1_fd | state_1_d)
eastbound_green = 1'b1;
else
eastbound_green = 1'b0;


always @ *
if(state_2)
eastbound_amber = 1'b1;
else 
eastbound_amber = 1'b0;
//////////////////////////////////////////////////////////////////////////



///////////////////////////// West Bound Light ////////////////////////////////
always @ *
if ( state_3 | state_4 | state_5 | state_6 | state_4_a | state_4_w | state_4_fd | state_4_d)
 westbound_red = 1'b1;
else westbound_red = 1'b0;

always @ * 
if(state_1 | state_1_w | state_1_fd | state_1_d)
westbound_green = 1'b1;
else
westbound_green = 1'b0;

always @ *
if(state_2)
westbound_amber = 1'b1;
else 
westbound_amber = 1'b0;
///////////////////////////////////////////////////////////////////////////////////




///////////// North Bound Light ////////////////////
always @ *
if(northbound_red)
hex7=7'b1111110;
else if(northbound_green)
hex7=7'b1110111;
else if(northbound_amber)
hex7=7'b0111111;
else
hex7=7'b1111111;
//////////////////////////////////////////////////



///////////// South Bound Light ////////////////////
always @ *
if(southbound_turn_left)
hex5=7'b0111001;
else if(southbound_red)
hex5=7'b1111110;
else if( southbound_green)
hex5=7'b1110111;
else if(southbound_amber)
hex5=7'b0111111;
else
hex5=7'b1111111;
//////////////////////////////////////////////////////



///////////// West Bound Light ////////////////////
always @ *
if(westbound_red)
hex1=7'b1111110;
else if(westbound_green)
hex1=7'b1110111;
else if(westbound_amber)
hex1=7'b0111111;
else
hex1=7'b1111111;
///////////////////////////////////////////////////////



///////////// East Bound Light ////////////////////
always @ *
if(eastbound_red)
hex3=7'b1111110;
else if(eastbound_green)
hex3=7'b1110111;
else if(eastbound_amber)
hex3=7'b0111111;
else
hex3=7'b1111111;
////////////////////////////////////////////////////


endmodule
