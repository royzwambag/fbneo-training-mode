----------------------------------------------------------------
-- Inspired by Grouflon 3rd Strike Training mode 
-- https://github.com/Grouflon/3rd_training_lua
----------------------------------------------------------------
require("games/sfa3/memory_addresses")
require("games/sfa3/constants")

gamestate = {
frame_number = 0,
--turbo = 0,
curr_state = 0,
is_in_match = false,
--screen_x = 0,
--screen_y = 0,
--patched = false,
player_objects = {},

P1 = nil,
P2 = nil,
--hit_counter = 0
}

function make_player_object(_id, _base, _prefix)
	return {
	id = _id,
	base = _base,
	addresses = addresses.players[_id],
	prefix = _prefix,
	}
end

function gamestate.reset_player_objects()
	gamestate.player_objects = {
	make_player_object(1, addresses.players[1].base, "P1"),
	make_player_object(2, addresses.players[2].base, "P2")
	}

	gamestate.P1 = gamestate.player_objects[1]
	gamestate.P2 = gamestate.player_objects[2]
end

function gamestate.read_game_vars()
	--------------------------
	-- frame number and speed
	--------------------------
	gamestate.frame_number 	= rb(addresses.global.frame_number)
	gamestate.turbo 		= rb(addresses.global.turbo)
	--gamestate.frameskip		= rb(addresses.global.frameskip)
	--gamestate.round_timer	= rb(addresses.global.round_timer)
	---------------------
	-- current state
	---------------------
	gamestate.curr_state 	= rb(addresses.global.curr_gamestate)
	gamestate.is_in_match 	= (gamestate.curr_state == 0x06)
	---------------------
	-- counters
	---------------------
	--gamestate.hit_counter 	= rb(addresses.global.hit_counter)
	---------------------
	-- screen related
	---------------------
	--gamestate.screen_x		= rw(addresses.global.screen_x)
	--gamestate.screen_y		= rw(addresses.global.screen_y)
end

function gamestate.stock_game_vars()
	return {
	--------------------------
	-- frame number and speed
	--------------------------
	frame_number 			= gamestate.frame_number,
	--turbo					= gamestate.turbo,
	--frameskip				= gamestate.frameskip,
	--round_timer				= gamestate.round_timer,
	---------------------
	-- current state
	---------------------
	curr_state				= gamestate.curr_state,
	is_in_match				= gamestate.is_in_match,
	---------------------
	-- counters
	---------------------
	--hit_counter				= gamestate.hit_counter,
	}
end

function gamestate.read_player_vars(_player_obj)
	_player_obj.state  					= rb(_player_obj.addresses.state)
	_player_obj.substate  				= rb(_player_obj.addresses.substate)
	_player_obj.air_state				= rb(_player_obj.addresses.air_state)
	_player_obj.pos_x					= rw(_player_obj.addresses.pos_x)
	_player_obj.pos_y					= rw(_player_obj.addresses.pos_y)
	_player_obj.flip_input				= (rb(_player_obj.addresses.flip_x) == 1)
	_player_obj.normal_move				= (rb(_player_obj.addresses.normal_move) == 0x01)
	_player_obj.special_move			= (rb(_player_obj.addresses.special_move) == 0x01)
	_player_obj.super_move				= (rb(_player_obj.addresses.super_move) == 0x01)
	_player_obj.projectile_ready		= (rb(_player_obj.addresses.projectile_ready) == 0x01)
<<<<<<< HEAD
	_player_obj.special_cancel_ready	= (rb(_player_obj.addresses.special_cancel_ready) > 0x00)
	_player_obj.super_cancel_ready		= (rb(_player_obj.addresses.super_cancel_ready) > 0x00)
=======
	_player_obj.cancel_ready			= (rb(_player_obj.addresses.cancel_ready) > 0x00)
>>>>>>> 57f862227796cfa452a11b484f2d94392f761ead
	_player_obj.is_attacking			= (_player_obj.normal_move or _player_obj.special_move or  _player_obj.super_move)
	--_player_obj.guard_regen			= rb(_player_obj.addresses.guard_regen)
	_player_obj.guard_meter				= rb(_player_obj.addresses.guard_meter)
	_player_obj.guard_damage			= rb(_player_obj.addresses.guard_damage)
	_player_obj.jump_animation			= rb(_player_obj.addresses.jump_animation)
	_player_obj.counter_hit_related		= rb(_player_obj.addresses.counter_hit_related)
	_player_obj.been_air_counter_hit	= ((rb(_player_obj.addresses.jump_animation) ~= 0x00 and rb(_player_obj.addresses.jump_animation) ~= 0x05 and rb(_player_obj.addresses.jump_animation) ~= 0xFB) or rb(0xFF888F) == 0x4C)
	_player_obj.character				= rb(_player_obj.addresses.character)
	_player_obj.ism						= rb(_player_obj.addresses.ism)
	_player_obj.dizzy					= (rb(_player_obj.addresses.dizzy) == 0x01)
	_player_obj.air_tech				= rb(_player_obj.addresses.air_tech)
	_player_obj.hitfreeze_counter		= rb(_player_obj.addresses.hitfreeze_counter)
	_player_obj.hitstun_counter		    = rb(_player_obj.addresses.hitstun_counter)
	_player_obj.hitstun_related		    = rb(_player_obj.addresses.hitstun_related)
	_player_obj.in_hitfreeze			= (_player_obj.hitfreeze_counter ~= 0)
	_player_obj.stun_counter			= rb(_player_obj.addresses.stun_counter)
	_player_obj.stun_meter				= rb(_player_obj.addresses.stun_meter)
	_player_obj.stun_threshold			= rb(_player_obj.addresses.stun_threshold)
	_player_obj.destun_meter			= rb(_player_obj.addresses.destun_meter)
	_player_obj.curr_input				= rw(_player_obj.addresses.curr_input)
	_player_obj.prev_input				= rw(_player_obj.addresses.prev_input)
end

function gamestate.stock_player_vars(_player_obj)
	return {
	state					= _player_obj.state,
	substate				= _player_obj.substate,
	air_state				= _player_obj.air_state,
	pos_x					= _player_obj.pos_x,
	pos_y					= _player_obj.pos_y,
	-- normal_move				= _player_obj.normal_move,
	-- special_move				= _player_obj.special_move,
	-- super_move				= _player_obj.super_move,
	-- special_cancel_ready		= _player_obj.special_cancel_ready,
	-- super_cancel_ready		= _player_obj.super_cancel_ready,
	projectile_ready		= _player_obj.projectile_ready,
	is_attacking			= _player_obj.is_attacking,
	-- guard_regen				= _player_obj.guard_regen,
	-- guard_meter				= _player_obj.guard_meter,
	-- guard_damage			= _player_obj.guard_damage,	
	jump					= _player_obj.jump,
	counter_hit_related		= _player_obj.counter_hit_related,	
	been_air_counter_hit	= _player_obj.been_air_counter_hit,
	-- character			= _player_obj.character,
	-- ism					= _player_obj.ism,
	-- air_tech				= _player_obj.air_tech,
	dizzy					= _player_obj.dizzy,
	hitfreeze_counter		= _player_obj.hitfreeze_counter,
	in_hitfreeze			= _player_obj.in_hitfreeze,
	-- hitstun_counter			= _player_obj.hitstun_counter,
	-- hitstun_related		    = _player_objhitstun_related,
	-- stun_counter				= _player_obj.stun_counter,
	-- stun_meter				= _player_obj.stun_meter,
	-- stun_threshold			= _player_obj.stun_threshold,
	-- destun_meter				= _player_obj.destun_meter,
	-- curr_input				= _player_obj.curr_input,
	-- prev_input				= _player_obj.prev_input,
	}
end