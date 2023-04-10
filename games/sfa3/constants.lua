-------------------
-- Speed
-------------------
normal_speed = 0x00
turbo_speed = 0x08
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
throwing		   = 0x04
thrown			   = 0x06
-------------------
-- Player air state
-------------------
jump_attack        = 0x06
-------------------
-- Characters
-------------------
characters = {
	{name = "Adon", id =  0x5, stage_id = 10, stun_base = 40, guard_base = 64},
--	{name = "Boxer", id = , stage_id = , stun_base = , guard_base = 68},
	{name = "Birdie", id = 0x8, stage_id = 16, stun_base = 48, guard_base = 72},
	{name = "Blanka", id = 0x19, stage_id = 50, stun_base = 43, guard_base = 60},
	{name = "Cammy", id = 0x16, stage_id = 44, stun_base = 40, guard_base = 56},
	{name = "Chun Li", id = 0x4, stage_id = 8, stun_base = 40, guard_base = 56},
	{name = "Claw", id = 0x1C, stage_id = 56, stun_base = 40, guard_base = 56},
	{name = "Cody", id = 0x1B, stage_id = 54, stun_base = 40, guard_base = 64}, -- Voir V
	{name = "Dan", id = 0xC, stage_id = 24, stun_base = 40, guard_base = 60},
	{name = "Dhalsim", id = 0xF, stage_id = 30, stun_base = 40, guard_base = 60},
	{name = "Dictator", id = 0xA, stage_id = 42, stun_base = 40, guard_base = 64},
	{name = "E.Honda", id = 0x18, stage_id = 48, stun_base = 44, guard_base = 64},
	{name = "Gen", id = 0x11, stage_id = 34, stun_base = 40, guard_base = 64},
	{name = "Gouki", id = 0x2, stage_id = 4, stun_base = 34, guard_base = 60},
	{name = "Guy", id = 0x7, stage_id = 14, stun_base = 40, guard_base = 60},
	--	{name = "Juli", id = , stage_id = 44, stun_base = , guard_base = 56},
	--	{name = "Juni", id = , stage_id = 44, stun_base = , guard_base = 56},
	{name = "Karin", id = 0x1D, stage_id = 58, stun_base = 40, guard_base = 68},
	{name = "Ken", id = 0x1, stage_id = 2, stun_base = 40, guard_base = 60},
	{name = "Nash", id = 0x3, stage_id = 6, stun_base = 40, guard_base = 56},
	{name = "Rolento", id = 0xE, stage_id = 28, stun_base = 40, guard_base = 60},
	{name = "Rose", id = 0x9, stage_id = 18, stun_base = 40, guard_base = 60},
	{name = "Ryu", id = 0x00, stage_id = 0, stun_base = 40, guard_base = 60},
	{name = "R.Mika", id = 0x1A, stage_id = 52, stun_base = 40, guard_base = 64},
	{name = "Sagat", id = 0xB, stage_id = 22, stun_base = 40, guard_base = 60},
	{name = "Sakura", id = 0xD, stage_id = 26, stun_base = 40, guard_base = 68},
	{name = "Sodom", id = 0x6, stage_id = 12, stun_base = 46, guard_base = 64},
	{name = "Zangief", id = 0x10, stage_id = 32, stun_base = 50, guard_base = 72},
}
-------------------
-- ISM
-------------------
X_ism = 0xFF
Z_sim = 0x00
V_ism = 0x01