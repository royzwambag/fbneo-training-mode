-------------------------------------------------------
-- Memory addresses for Z3
-- Inspired by Grouflon 3rd Strike Training mode
-- https://github.com/Grouflon/3rd_training_lua
-- Made by Asunaro
-------------------------------------------------------
addresses = {
  global = {
	curr_gamestate		= 0xFF800D,
    frame_number		= 0xFF8080,   
	--slowdown			= ,	
	--match_state		= ,   
	stage_select		= 0xFF8101,
	turbo				= 0xFF8116,
	super_freeze		= 0xFF8125,
	--round_timer		= ,
	--hit_counter		= ,
    --screen_x			= ,
    --screen_y			= ,
  },
  players = {
    {
      base 	= 0xFF8400,
      --input = ,
    },
    {
      base 	= 0xFF8800,
      --input = ,
    }
  }
}

for i = 1, 2 do
  addresses.players[i].substate          	= addresses.players[i].base + 0x05  -- byte
  addresses.players[i].state        	  	= addresses.players[i].base + 0x06  -- byte
  addresses.players[i].air_state          	= addresses.players[i].base + 0x07  -- byte
  addresses.players[i].pos_x          		= addresses.players[i].base + 0x10  -- wordsigned
  addresses.players[i].pos_y          		= addresses.players[i].base + 0x14	-- wordsigned
  addresses.players[i].flip_x          		= addresses.players[i].base + 0x0B  -- wordsigned
  addresses.players[i].destun_meter         = addresses.players[i].base + 0x3B  -- byte
  addresses.players[i].jump_animation       = addresses.players[i].base + 0x4A  -- byte
  addresses.players[i].hitfreeze_counter    = addresses.players[i].base + 0x5F	-- byte
  addresses.players[i].normal_move        	= addresses.players[i].base + 0xA9  -- byte
  addresses.players[i].counter_hit_related  = addresses.players[i].base + 0xC7  -- byte
  addresses.players[i].special_move        	= addresses.players[i].base + 0xCE  -- byte
  addresses.players[i].character  			= addresses.players[i].base + 0x102  -- byte
  addresses.players[i].ism		  			= addresses.players[i].base + 0x132  -- byte
  addresses.players[i].super_move  			= addresses.players[i].base + 0x216  -- byte
  addresses.players[i].projectile_ready		= addresses.players[i].base + 0x238  -- byte
<<<<<<< HEAD
  addresses.players[i].hitstun_related		= addresses.players[i].base + 0x23D  -- byte
  addresses.players[i].special_cancel_ready	= addresses.players[i].base + 0x23E  -- byte
=======
  addresses.players[i].cancel_ready			= addresses.players[i].base + 0x23E  -- byte
>>>>>>> 57f862227796cfa452a11b484f2d94392f761ead
  addresses.players[i].guard_regen		    = addresses.players[i].base + 0x24B  -- byte  
  addresses.players[i].guard_meter	        = addresses.players[i].base + 0x24C  -- byte
  addresses.players[i].guard_damage         = addresses.players[i].base + 0x24D  -- byte
  addresses.players[i].hitstun_counter      = addresses.players[i].base + 0x269  -- byte
  addresses.players[i].air_tech             = addresses.players[i].base + 0x27A  -- byte
  addresses.players[i].super_cancel_ready	= addresses.players[i].base + 0x293  -- byte
  addresses.players[i].dizzy        		= addresses.players[i].base + 0x2CF  -- byte  
  addresses.players[i].stun_counter	        = addresses.players[i].base + 0x2CB  -- byte
  addresses.players[i].stun_meter          	= addresses.players[i].base + 0x2CC  -- byte
  addresses.players[i].stun_threshold       = addresses.players[i].base + 0x2CD  -- byte
  addresses.players[i].curr_input       	= addresses.players[i].base + 0x370 -- word
  addresses.players[i].prev_input      		= addresses.players[i].base + 0x372 -- word
end