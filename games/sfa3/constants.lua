-------------------
-- Player state
-------------------
idle           		= 0x00
crouching			= 0x02 -- Not crouched, but doing the movement of crouching
walking				= 0x04
jumping				= 0x06
doing_normal_move  	= 0x0A
doing_special_move 	= 0x0E
v_trigger			= 0x10
-------------------
-- Player substate
-------------------
being_hit          = 0x02
-------------------
-- Player air state
-------------------
jump_attack        = 0x06
-------------------
-- Stage
-------------------
stage_infos = {
	{name = "Adon", id = 10},
	{name = "Birdie",id = 16},
	{name = "Blanka",id = 50},
	{name = "Cammy",id = 44},
	{name = "Chun Li",id = 8},
	{name = "Claw",id = 56},
	{name = "Cody",id = 54},
	{name = "Dan",id = 24},
	{name = "Dhalsim",id = 30},
	{name = "Dictator",id = 42},
	{name = "Dictator (Arcade)",id = 20},
	{name = "E.Honda",id = 48},
	{name = "Gen",id = 34},
	{name = "Gouki",id = 4},
	{name = "Guy",id = 14},
	{name = "Karin",id = 58},
	{name = "Ken",id = 2},
	{name = "Nash",id = 6},
	{name = "Rolento",id = 28},
	{name = "Rose",id = 18},
	{name = "Ryu",id = 0},
	{name = "R.Mika",id = 52},
	{name = "Sagat",id = 22},
	{name = "Sakura",id = 26},
	{name = "Sodom",id = 12},
	{name = "Zangief",id = 32},
}