


module Traffic_controller_test (
										//////////// CLOCK //////////
										input							CLOCK_27,
										input		          		CLOCK_50,
										input		          		CLOCK2_50,
										input		          		CLOCK3_50,

										//////////// LED //////////
										output		   [8:0]		LEDG,
										output reg	      [17:0]	LEDR,

										//////////// KEY //////////
										input		      [3:0]		KEY,

										//////////// SW //////////
										input		      [17:0]	SW,

										//////////// SEG7 //////////
										output		   [6:0]		HEX0,
										output		   [6:0]		HEX1,
										output		   [6:0]		HEX2,
										output		   [6:0]		HEX3,
										output		   [6:0]		HEX4,
										output		   [6:0]		HEX5,
										output		   [6:0]		HEX6,
										output		   [6:0]		HEX7,

										//////////// LCD //////////
										output		        		LCD_BLON,
										inout		      [7:0]		LCD_DATA,
										output		          	LCD_EN,
										output		          	LCD_ON,
										output		          	LCD_RS,
										output		        		LCD_RW


);

//=============================================================================
//
//   Traffic Controller Testbench
//
//=============================================================================

Traffic_Testbench  exam_test_bench( 			.clk(CLOCK_27),
															.CLOCK_50(CLOCK_50),
															.northbound_Hex(north_hex),
															.north_walk_Hex(north_walk_hex),
															.southbound_Hex(south_hex),
															.south_walk_Hex(south_walk_hex),
															.eastbound_Hex(east_hex),
															.east_walk_Hex(east_walk_hex),
															.westbound_Hex(west_hex),
															.west_walk_Hex(west_walk_hex),
															
															//test signals
															.disable_test(SW[0]),		//return to normal operation
															.gold_module_toggel(SW[1]), //outputs connected to gold test module
															.walk_NS_request_in(KEY[3]),
															.walk_EW_request_in(KEY[2]),
															.left_turn_input(KEY[1]),
															.reset_in(KEY[0]),
															
															.reset(reset),
															.debug(debug),
															.left_turn_request(left_turn_request),
															.walk_NS_request(walk_NS_request),
															.walk_EW_request(walk_EW_request),
															.clock_to_your_module(clk),
															
															.nb_h(HEX7),
															.nb_w(HEX6),
															.sb_h(HEX5),
															.sb_w(HEX4),
															.eb_h(HEX3),
															.eb_w(HEX2),
															.wb_h(HEX1),
															.wb_w(HEX0),
															
															.clk_out(LEDG[8]),
															.test_error(LEDG[0]),
															
															.LCD_BLON(LCD_BLON),
															.LCD_DATA(LCD_DATA),
												            .LCD_EN(LCD_EN),
												            .LCD_ON(LCD_ON),
												            .LCD_RS(LCD_RS),
												        	.LCD_RW(LCD_RW)
															
									);
									
wire [6:0] north_hex, south_hex, east_hex, west_hex;
wire [6:0] north_walk_hex, south_walk_hex, east_walk_hex, west_walk_hex;
wire reset, debug, left_turn_request, walk_NS_request, walk_EW_request, clk; 

//======================================================================================================
//Instatiate your Traffic controller here



		traffic_and_pedestrian_light_controller	myTLC(
																.clk_27(clk),
																.sw9(debug),
																.reset(reset),
																.key_1(left_turn_request),
																.key_3(walk_NS_request),
																.key_2(walk_EW_request),
																
																.hex7(north_hex),
																.hex5(south_hex),
																.hex3(east_hex),
																.hex1(west_hex),
																
//																.northbound_amber(north_hex[6]),
//																.southbound_amber(south_hex[6]),
//																.eastbound_amber(east_hex[6]),
//																.westbound_amber(west_hex[6]),
//																.northbound_red(north_hex[0]),
//																.southbound_red(south_hex[0]),
//																.eastbound_red(east_hex[0]),
//																.westbound_red(west_hex[0]),
//																.southbound_arrow(south_hex[2:1]),
																
//																.westbound_walk_light({west_walk_hex[5], west_walk_hex[6], west_walk_hex[4:1]}),
//																.eastbound_walk_light({east_walk_hex[5], east_walk_hex[6], east_walk_hex[4:1]}),
//																.southbound_walk_light({south_walk_hex[5], south_walk_hex[6], south_walk_hex[4:1]}),
//																.northbound_walk_light({north_walk_hex[5], north_walk_hex[6], north_walk_hex[4:1]})
																.hex6(north_walk_hex),
																.hex4(south_walk_hex),
																.hex2(east_walk_hex),
																.hex0(west_walk_hex)
																);
																
//																assign west_walk_hex[0] = 1'b1;
//																assign east_walk_hex[0] = 1'b1;
//																assign north_walk_hex[0] = 1'b1;
//																assign south_walk_hex[0] = 1'b1;
//																assign north_hex[5:4] = 2'd3;
//																assign north_hex[2:1] = 2'd3;
//																assign west_hex[5:4] = 2'd3;
//																assign west_hex[2:1] = 2'd3;
//																assign east_hex[5:4] = 2'd3;
//																assign east_hex[2:1] = 2'd3;
//																assign south_hex[5:4] = 2'd3;
															

																											 
endmodule
