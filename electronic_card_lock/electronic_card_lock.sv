module electronic_card_lock(
input wire clk_27, key_2, 
input wire key_0, key_1,
input wire [15:0] entry_code_on_card, 
input wire [1:0] card_type,
output reg card_read, 
output reg trip_lock_for_guest,  
output reg [15:0] guest_LFSR, 
output reg [15:0] maid_LFSR
);

reg [15:0] reset_for_guest_card;
reg [15:0] reset_for_maid_card;
assign reset_for_guest_card = 16'h8001;
assign reset_for_maid_card = 16'h8001;

reg [15:0] occupant;
reg [15:0]  next_occupant;

reg [15:0] current_maid;
reg [15:0]  next_maid;


reg reset_guest, reset_guest_maid;


//////////////////////////// guest_LFSR ///////////////////////////////////////// 

reg guestx;
reg d0;


always @ *
guestx=guest_LFSR[10];


always @ (posedge card_read)
if(card_type==2'b10 && entry_code_on_card==reset_for_guest_card)
guest_LFSR=16'h0;
else if(guest_LFSR==16'h0 && card_type==2'b00)
guest_LFSR=entry_code_on_card;
else if(card_type==2'b00 && entry_code_on_card==next_occupant)
guest_LFSR={guest_LFSR[14:0], d0};


always @ (posedge card_read)
if(card_type==2'b10 && entry_code_on_card==reset_for_guest_card)
occupant=16'h0;
else if(guest_LFSR==16'h0 && card_type==2'b00)
next_occupant=entry_code_on_card;
else if(card_type==2'b00 && entry_code_on_card==next_occupant)
begin
occupant<=next_occupant;
next_occupant={guest_LFSR[14:0], d0};
end
 
always @ *
d0=guest_LFSR[1]^(guest_LFSR[2]^(guest_LFSR[15]^guestx));
 
/////////////////////////////////////////////////////////////////////////////////// 
 
 
///////////////////////////////////// trip_lock ////////////////////////////////////////////
 
 always @ (posedge card_read)
if(maid_LFSR==16'h0 && card_type==2'b01)
trip_lock_for_guest=1'b1;
else if(card_type==2'b01 && entry_code_on_card==current_maid)
trip_lock_for_guest=1'b1;
else if(card_type==2'b01 && entry_code_on_card==next_maid)
trip_lock_for_guest=1'b1;
else if(guest_LFSR==16'h0 && card_type==2'b00)
trip_lock_for_guest=1'b1;
else if(card_type==2'b00 && entry_code_on_card==occupant)
trip_lock_for_guest=1'b1;
else if(card_type==2'b00 && entry_code_on_card==next_occupant)
trip_lock_for_guest=1'b1;
else
trip_lock_for_guest=1'b0; 




//////////////////////////// maid_LFSR ///////////////////////////////////////// 


reg maidx;
reg d1;

always @ *
maidx=maid_LFSR[10];


always @ (posedge card_read)
if(card_type==2'b11 && entry_code_on_card==reset_for_maid_card)
maid_LFSR=16'h0;
else if(maid_LFSR==16'h0 && card_type==2'b01)
maid_LFSR=entry_code_on_card;
else if(card_type==2'b01 && entry_code_on_card==next_maid)
maid_LFSR={maid_LFSR[14:0], d1};


always @ (posedge card_read)
if(card_type==2'b11 && entry_code_on_card==reset_for_maid_card)
current_maid=16'h0;
else if(maid_LFSR==16'h0 && card_type==2'b01)
next_maid=entry_code_on_card;
else if(card_type==2'b01 && entry_code_on_card==next_maid)
begin
current_maid<=next_maid;
next_maid={maid_LFSR[14:0], d1};
end


always @ *
d1=maid_LFSR[1]^(maid_LFSR[2]^(maid_LFSR[15]^maidx));


////////////////////////////////////////  Part B ////////////////////////////////////////////////////////// 

always @ (*)
if(key_0==1'b0)
card_read<=1'b0;
else if(key_1==1'b0)
card_read<=1'b1;
else 
card_read<=card_read;





endmodule 