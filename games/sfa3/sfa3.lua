assert(rb,"Run fbneo-training-mode.lua") -- make sure the main script is being run
-- z3 training mode by @asunaro. Most of the code is borrowed from my work on ssf2xjr1's training mode
--require("games/sfa3/character_specific")
require("games/sfa3/gamestate")
require("games/sfa3/constants")

-- use a custom config file if one exists, otherwise load defaults
if fexists("games/sfa3/customconfig.lua") then
	dofile("games/sfa3/customconfig.lua")
else
	customconfig = {
		counter_hit_selector = -1,
		air_tech_selector = -1,
		tech_type_selector = 0,
		crouch_cancel_training_selector = -1,
		nomusic_selector = -1,
		stage_selector = 0,
		draw_hud = -1,
	}
end

----------------------------
----------------------------
-- Initialization
----------------------------
----------------------------
local first_load = true
-- Initialize RNG
math.randomseed(os.time())
math.random(); math.random(); math.random()
--
gamestate.reset_player_objects()
gamestate.read_game_vars()
gamestate.read_player_vars(gamestate.P1)
gamestate.read_player_vars(gamestate.P2)
gamestate.prev	  = gamestate.stock_game_vars()
gamestate.P1.prev = gamestate.stock_player_vars(gamestate.P1)
gamestate.P2.prev = gamestate.stock_player_vars(gamestate.P2)
---------------------------
---------------------------
-- Peon's General Functions
---------------------------
---------------------------
p1maxhealth = 144
p2maxhealth = 144
p1maxmeter = 0x90
p2maxmeter = 0x90


local p1health = 0xFF8450
local p1redhealth = 0xff8452
local p2health = 0xFF8850
local p2redhealth = 0xFF8852

local p1meter = 0xFF851F
local p2meter = 0xFF891F

local p1direction = 0xff840b
local p2direction = 0xff880b

local p1combocounter = 0xff885e
local p2combocounter = 0xff845e

translationtable = {
	"left",
	"right",
	"up",
	"down",
	"button1",
	"button2",
	"button3",
	"button4",
	"button5",
	"button6",
	"coin",
	"start",
	["Left"] = 1,
	["Right"] = 2,
	["Up"] = 3,
	["Down"] = 4,
	["Weak Punch"] = 5,
	["Medium Punch"] = 6,
	["Strong Punch"] = 7,
	["Weak Kick"] = 8,
	["Medium Kick"] = 9,
	["Strong Kick"] = 10,
	["Coin"] = 11,
	["Start"] = 12,
}

gamedefaultconfig = {
	hud = {
		combotextx=179,
		combotexty=42,
		comboenabled=true,
		p1healthx=33,
		p1healthy=18,
		p1healthenabled=true,
		p2healthx=340,
		p2healthy=18,
		p2healthenabled=true,
		p1meterx=176,
		p1metery=210,
		p1meterenabled=true,
		p2meterx=205,
		p2metery=210,
		p2meterenabled=true,
	},
}

function playerOneFacingLeft()
	return rb(p1direction)==0
end

function playerTwoFacingLeft()
	return rb(p2direction)==0
end

function playerOneInHitstun()
	return rb(p2combocounter)~=0
end

function playerTwoInHitstun()
	return rb(p1combocounter)~=0
end

function readPlayerOneHealth()
	return rw(p1health)
end

function writePlayerOneHealth(health)
	ww(p1health, health)
	ww(p1redhealth, health)
end

function readPlayerTwoHealth()
	return rw(p2health)
end

function writePlayerTwoHealth(health)
	ww(p2health, health)
	ww(p2redhealth, health)
end

function readPlayerOneMeter()
	return rb(p1meter)
end

function writePlayerOneMeter(meter)
	wb(p1meter, meter)
end

function readPlayerTwoMeter()
	return rb(p2meter)
end

function writePlayerTwoMeter(meter)
	wb(p2meter, meter)
end

local infiniteTime = function()
	wb(0xFF8109, 99)
end
-----------------------------
-----------------------------
-- General Functions
-----------------------------
-----------------------------
function countFrames(event_frame_count)
	local frame_count = event_frame_count
	if gamestate.prev.frame_number == gamestate.frame_number then
		return frame_count
	end
	if was_frameskip then
		return frame_count + 2
	end
	return frame_count + 1
end
-----------------------------
-- Input related
-----------------------------
local player_keys = {
	"Up",
	"Down",
	"Left",
	"Right",
	"Weak Punch",
	"Medium Punch",
	"Strong Punch",
	"Weak Kick",
	"Medium Kick",
	"Strong Kick",
}
local player_keys_extra = {
	"Start",
	"Coin",
}
function clearInputSet(player)
	inputs.properties.enableinputset = true 
	if player == 1 then
		for i = 1, #player_keys do
			inputs.setinputs["P1 "..player_keys[i]] = false
		end
	elseif player == 2 then
		for i = 1, #player_keys do
			--print(player_keys[i])
			inputs.setinputs["P2 "..player_keys[i]] = false
		end
	end
	setInputs()
end 

function modifyInputSet(player, ...)
	inputs.properties.enableinputset = true 
	local dir1, dir2, button1, button2, button3, button4, button5, button6 = ...
	if type(dir1)=="number" then
		local a = {{"Down", "Left"}, {"Down"}, {"Down", "Right"}, {"Left"}, {}, {"Right"}, {"Up", "Left"}, {"Up"}, {"Up", "Right"}} -- numpad
		dir2 = a[dir1][2]
		dir1 = a[dir1][1]
	end
	local a = {{"Weak Punch"}, {"Medium Punch"}, {"Strong Punch"}, {"Weak Kick"}, {"Medium Kick"}, {"Strong Kick"}}
	if type(button1) =="number" then
		button1 = a[button1][1]
	end
	if type(button2) =="number" then
		button2 = a[button2][1]
	end
	if type(button3) =="number" then
		button3 = a[button3][1]
	end
	if type(button4) =="number" then
		button4 = a[button4][1]
	end
	if type(button5) =="number" then
		button5 = a[button5][1]
	end
	if type(button6) =="number" then
		button6 = a[button6][1]
	end
	
	
	if player == 1 then 
		if dir1 then inputs.setinputs["P1 "..dir1] = true end
		if dir2 then inputs.setinputs["P1 "..dir2] = true end
		if button1 then inputs.setinputs["P1 "..button1] = true end
		if button2 then inputs.setinputs["P1 "..button2] = true end
		if button3 then inputs.setinputs["P1 "..button3] = true end
		if button4 then inputs.setinputs["P1 "..button4] = true end
		if button5 then inputs.setinputs["P1 "..button5] = true end
		if button6 then inputs.setinputs["P1 "..button6] = true end
	end

	if player == 2 then
		if dir1 then inputs.setinputs["P2 "..dir1] = true end
		if dir2 then inputs.setinputs["P2 "..dir2] = true end
		if button1 then inputs.setinputs["P2 "..button1] = true end
		if button2 then inputs.setinputs["P2 "..button2] = true end
		if button3 then inputs.setinputs["P2 "..button3] = true end
		if button4 then inputs.setinputs["P2 "..button4] = true end
		if button5 then inputs.setinputs["P2 "..button5] = true end
		if button6 then inputs.setinputs["P2 "..button6] = true end
	end
	setInputs()
end
--------------------------
--	Messages
--------------------------
------------------------------------------------------------
--	 Messages -- Borrowed from sako.lua by Born2SPD
------------------------------------------------------------
-- Messages in the middle of the screen
msg1 = ""
msg2 = ""
msg3 = ""
-- Messages following the players
msg_p1 = ""
msg_p2 = ""
-- Messages timer
MSG_FRAMELIMIT = 600
msg_fcount = 0
player_msg_fcount = 0

function update_msg(code)
	if code == 0 then -- reset general messages
		msg1 = ""
		msg2 = ""
		msg3 = ""
		msg_fcount = 0
	elseif code == -1 then -- reset player messages
		msg_p1 = ""
		msg_p2 = ""
		player_msg_fcount = 0
	elseif code == 1 then
		msg1 = "	Down was not held when landing"
		msg_fcount = MSG_FRAMELIMIT-120
	elseif code == 2 then 
		msg1 = "	You jumped as soon as you landed."
		msg2 = "	Hold down when you hit the ground"
		msg_fcount = MSG_FRAMELIMIT-120
	elseif code == 3 then
		msg1 = "Down was held too long, you went into full crouching state"
		msg_fcount = MSG_FRAMELIMIT-120
	elseif code == 4 then
		msg1 = "Jump or walk before your character goes into neutral state"
		msg_fcount = MSG_FRAMELIMIT-120
	elseif code == 5 then
		msg1 = "	You stopped walking or didn’t attack"
		msg_fcount = MSG_FRAMELIMIT-120
	elseif code == 6 then
		msg1 = "    Cross under : crouch cancel wasn’t necessary"
		msg_fcount = MSG_FRAMELIMIT-120
	elseif code == 99 then 
		msg1 = "	You did not attempt to jump or walk"
		msg_fcount = MSG_FRAMELIMIT-120
	elseif code == 100 then 
		msg1 = "		Crouch cancel acheived !"
		msg_fcount = MSG_FRAMELIMIT-120
	elseif code == 101 then 
		msg1 = "		Walk cancel acheived !"
		msg_fcount = MSG_FRAMELIMIT-120
	end 
end

function reset_msg()
	update_msg(0)
end

function reset_player_msg()
	update_msg(-1)
end

--local function get_player_msg_x(_player_obj)
	--return (_player_obj.pos_x-gamestate.screen_x)-15
--end

--local function get_player_msg_y(_player_obj)
	--local character = _player_obj.character
	--local screen_y = 0
	
	--if character == Boxer or character == Zangief then
		--screen_y = 125
	--elseif character == Claw or character == Hawk or character == Sagat then
		--screen_y = 115
	--elseif character == Deejay then
		--screen_y = 130
	--else
		--screen_y = 140
	--end
	--return screen_y-_player_obj.pos_y
--end 

local function draw_messages()
	if msg_fcount >= MSG_FRAMELIMIT then
		reset_msg()
	elseif msg_fcount > 0 then
		msg_fcount = countFrames(msg_fcount)
	end
	if player_msg_fcount >= MSG_FRAMELIMIT then
		reset_player_msg()
	elseif player_msg_fcount > 0 then
		player_msg_fcount = countFrames(player_msg_fcount)
	end
	gui.text(92,56,msg1)
	gui.text(92,64,msg2)
	gui.text(92,72,msg3)
	--gui.text(get_player_msg_x(gamestate.P1),get_player_msg_y(gamestate.P1),msg_p1)
	--gui.text(get_player_msg_x(gamestate.P2),get_player_msg_y(gamestate.P2),msg_p2)
end

function str(bool)
	if bool then
		return "true"
	else
		return "false"
	end
end
--------------------------------
--------------------------------
-- Basic Z3 Functions
--------------------------------
--------------------------------
local function setCounterHit(_player_obj)
	local attacker = _player_obj
	local defender = {}
	if attacker.id == 1 then
		defender = gamestate.P2
	elseif attacker.id == 2 then
		defender = gamestate.P1
	end
	
	if attacker.state == doing_normal_move or attacker.air_state == jump_attack or attacker.state == doing_special_move then
		wb(defender.addresses.is_attacking,0x01)
		wb(defender.addresses.counter_hit_related,0x00)
	end 
	if defender.substate == being_hit then 
		wb(defender.addresses.is_attacking,0x00)
		wb(defender.addresses.counter_hit_related,0xFF)
	end
end

counter_hit_selector = customconfig.counter_hit_selector
local function autoCounterHit()
	if counter_hit_selector == 0 or crouch_cancel_training_selector == 0 then
		setCounterHit(gamestate.P1)
	elseif counter_hit_selector == 1 or crouch_cancel_training_selector == 1 then
		setCounterHit(gamestate.P2)
	end
end

air_tech_selector = customconfig.air_tech_selector
tech_type_selector = customconfig.tech_type_selector
local jump_error = 0

local function doRecover(_player_obj)
	local attacker = _player_obj
	local defender = {}
	if attacker.id == 1 then
		defender = gamestate.P2
	elseif attacker.id == 2 then
		defender = gamestate.P1
	end
	
	if jump_error == 1 or (defender.been_air_counter_hit and attacker.state == idle) then
		inputs.properties.enablehold = false
		if tech_type_selector == 0 then -- Neutral Tech
			modifyInputSet(defender.id,5,5,2,3)
		elseif tech_type_selector == 1 then	-- Backward Tech
			if defender.flip_input then
				modifyInputSet(defender.id,4,5,2,3)
			else
				modifyInputSet(defender.id,6,5,2,3)
			end
		elseif tech_type_selector == 2 then	-- Forward Tech
			if defender.flip_input then
				modifyInputSet(defender.id,6,5,2,3)
			else
				modifyInputSet(defender.id,4,5,2,3)
			end
		end
	else
		for i, _ in pairs(inputs.properties.p2hold) do
			if inputs.properties.p2hold[i] then
				inputs.properties.enablehold = true
				return
			end
		end
	end
end

local function autoRecover()
	if air_tech_selector == 0 or crouch_cancel_training_selector == 1 then
		doRecover(gamestate.P2)
	elseif air_tech_selector == 1 or crouch_cancel_training_selector == 0 then
		doRecover(gamestate.P1)
	end
end
---------------------------
---------------------------
-- Crouch Cancel Training
--------------------------
---------------------------
local crouch_cancel_step = 0
local function crouchCancelTraining(_player_obj)

	local attacker = _player_obj
	local defender = {}
	if attacker.id == 1 then
		defender = gamestate.P2
	elseif attacker.id == 2 then
		defender = gamestate.P1
	end
	
	if crouch_cancel_training_selector > -1 then
		modifyInputSet(defender.id,8)
		if jump_error == 1 and not defender.been_air_counter_hit then 
			jump_error = 0
		end 
		
		if crouch_cancel_step == 0 and defender.been_air_counter_hit and attacker.state == jumping then 
			crouch_cancel_step = 1
		end 
		
		if crouch_cancel_step > 0 and attacker.state == 0x08 then 
			crouch_cancel_step = 0
			update_msg(6)
			return
		end
		
		if crouch_cancel_step == 1 and attacker.prev.state == jumping and attacker.state == crouching then -- crouch_cancel_step 0 réussi : Le perso a atterri baissé 
			crouch_cancel_step = 2 
			return
		elseif crouch_cancel_step == 1 and attacker.prev.state == jumping and (attacker.state ~= crouching or attacker.state ~= v_trigger) then -- Echec au crouch_cancel_step 1 : Down n'a pas été maintenu 
			if attacker.state ~= jumping then 
				update_msg(1)
				crouch_cancel_step = 0
			elseif attacker.state == jumping and attacker.prev.air_state == 0x04 and attacker.air_state == 0x00 then -- Bug : Down n'a pas été maintenu mais le perso n'était pas considéré comme idle
				update_msg(1)
				crouch_cancel_step = 0
				jump_error = 1
			end 
		end 
	
		if crouch_cancel_step == 2 and attacker.prev.state == crouching and attacker.state == jumping then  -- Crouch cancel réussi
			update_msg(100)
			crouch_cancel_step = 0 
			return
		elseif crouch_cancel_step == 2 and attacker.prev.state == crouching and attacker.state == walking then -- Tentative de walk cancel
			crouch_cancel_step = 3 
			return
		elseif crouch_cancel_step == 2 and attacker.prev.state == crouching and attacker.state == 0x00 and (attacker.air_state) == 0x04 then  -- Echec au crouch_cancel_step 2. Le perso s'est accroupi
			update_msg(3)
			crouch_cancel_step = 0
			return
		elseif crouch_cancel_step == 2 and attacker.prev.state == crouching and attacker.state == 0x00 then -- Echec au crouch_cancel_step 2. Le perso s'est relevé
			update_msg(4)
			crouch_cancel_step = 0 
			return 
		elseif crouch_cancel_step == 2 and attacker.state == 0x00 then -- Echec au crouch_cancel_step 2 : Erreur générale, aucune tentative de walk ou de crouch cancel, mais le perso n'est pas idle pour autant
			update_msg(99)
			crouch_cancel_step = 0
			return
		end 
		
		if crouch_cancel_step == 3 and (attacker.state == doing_normal_move or attacker.state == doing_special_move) then -- Walk cancel réussi
			update_msg(101)
			crouch_cancel_step = 0
		elseif crouch_cancel_step == 3 and attacker.state == jumping then -- Crouch cancel réussi mais le perso a un peu avancé 
			update_msg(100)
			crouch_cancel_step = 0
		elseif crouch_cancel_step == 3 and attacker.state == idle then -- Echec au crouch_cancel_step 3. Le perso n'a pas attaqué assez vite
			update_msg(5)
			crouch_cancel_step = 0
		end
	end
end
crouch_cancel_training_selector = customconfig.crouch_cancel_training_selector
local function toggleCrouchCancelTraining()
	if crouch_cancel_training_selector == 0 then
		crouchCancelTraining(gamestate.P1)
	elseif crouch_cancel_training_selector == 1 then
		crouchCancelTraining(gamestate.P2)
	end
end
--------------------------
-- Choosing a stage
--------------------------
-- stage_selector = customconfig.stage_selector
stage_selector = 0
local stageSelect = function()
	if stage_selector == 0 then
		return
	end
	if gamestate.curr_state == 0x02 then
		wb(addresses.global.stage_select,stage_infos[stage_selector].id)
	end
end
-----------------------------
-- Enable/Disable background music
-----------------------------
nomusic_selector = customconfig.nomusic_selector
local nomusicControl = function()
	if nomusic_selector == -1 then
		return
	end
	if nomusic_selector == 0 then
		if gamestate.prev.curr_state == 0x04 and gamestate.curr_state == 0x06 then -- When the "FIGHT" message disappears
			wb(0xFFEE81,0x20)
			wb(0xFFEE83,0x20)
		end
	end
end
-----------------------
--Dizzy meters
---- -------------------
--Determine the color of the bar based on the value (higher = darker)
local function diz_col(val,max_val,type)
	local color = 0x00000000
	local mv = max_val/6

	if type == 0 then
		if val <= mv then
			color = 0x00FF5DA0
		elseif val <= mv*2 then
			color = 0x54FF00A0
		elseif val <= mv*3 then
			color = 0xAEFF00A0
		elseif val <= mv*4 then
			color = 0xFAFF00A0
		elseif val <= mv*5 then
			color = 0xFF5400A0
		else
			color = 0xFF0026A0
		end
	else
		if val <= mv then
			color = 0x00FF5DA0
		elseif val <= mv*2 then
			color = 0x54FF00A0
		elseif val <= mv*3 then
			color = 0xAEFF00A0
		elseif val <= mv*4 then
			color = 0xFAFF00A0
		elseif val <= mv*5 then
			color = 0xFF5400A0
		else
			color = 0xFF0026A0
		end
	end
	return color
end

local p1_dizzy_drawn = false
local p2_dizzy_drawn = false

local function draw_dizzy()
	local p1_s = gamestate.P1.stun_meter
	local p1_c = gamestate.P1.stun_counter
	local p1_t = gamestate.P1.stun_threshold
	local p1_d = gamestate.P1.destun_meter

	local p2_s = gamestate.P2.stun_meter
	local p2_c = gamestate.P2.stun_counter
	local p2_t = gamestate.P2.stun_threshold
	local p2_d = gamestate.P2.destun_meter
	
	gui.text(154,41,p1_s.."/"..p1_t)
	gui.text(154,50,p1_c)
	gui.box(35,45,150,49,0x00000040,0x000000FF)
	gui.box(35,49,150,53,0x00000040,0x000000FF)
		
	gui.text(212,41,p2_s.."/"..p2_t)
	gui.text(212,50,p2_c)
	gui.box(233,45,348,49,0x00000040,0x000000FF)
	gui.box(233,49,348,53,0x00000040,0x000000FF)

	-- P1 Stun meter
	if p1_s > 0 then
		gui.box(35,45,(35+((115/gamestate.P1.stun_threshold)*p1_s)),49,diz_col(p1_s,p1_t,0),0x000000FF)
	end

	-- P1 Stun counter
	if p1_c > 0 then
		gui.box(35,49,(35+(0.45*p1_c)),53,diz_col(p1_c,255,1),0x000000FF)
	end

	-- P2 Stun meter
	if p2_s > 0 then
		gui.box(233,45,(233+((115/gamestate.P2.stun_threshold)*p2_s)),49,diz_col(p2_s,p2_t,0),0x000000FF)
	end

	-- P2 Stun counter
	if p2_c > 0 then
		gui.box(233,49,(233+(0.45*p2_c)),53,diz_col(p2_c,255,1),0x000000FF)
	end

	if gamestate.P1.dizzy then
		gui.box(3,100,11,190,0x00000040,0x000000FF)
		if p1_d > 0 then
			gui.box(3,190,11,(190-(0.35*p1_d)),0xFF0000B0,0x00000000)
		end
		gui.text(3,192,p1_d)
		p1_dizzy_drawn = true
	else
		p1_dizzy_drawn = false
	end

	if gamestate.P2.dizzy then
		gui.box(370,100,378,190,0x00000040,0x000000FF)
		if p2_d > 0 then
			gui.box(370,190,378,(190-(0.35*p2_d)),0xFF0000B0,0x00000000)
		end
		gui.text(365,192,p2_d)
		p2_dizzy_drawn = true
	else
		p2_dizzy_drawn = false
	end
end
------------------
-- Z3 HUD
------------------
draw_hud = customconfig.draw_hud
local function renderZ3HUD()
	if draw_hud < 0 then
		return
	else
		draw_dizzy()
	end
end
------------------
-- Main
------------------
local function updateGamestate()
	-- prev
	gamestate.prev = gamestate.stock_game_vars()
	gamestate.P1.prev = gamestate.stock_player_vars(gamestate.P1)
	gamestate.P2.prev = gamestate.stock_player_vars(gamestate.P2)
	-- curr
	gamestate.read_game_vars()
	gamestate.read_player_vars(gamestate.P1)
	gamestate.read_player_vars(gamestate.P2)
end

local function Z3_Training_basic_settings()
	infiniteTime()
	autoCounterHit()
	autoRecover()
	toggleCrouchCancelTraining()
	stageSelect()
	nomusicControl()
	renderZ3HUD()
end

Z3_functions = {updateGamestate, Z3_Training_basic_settings, draw_messages}

function Run() -- runs every frame
	for i = 1, #Z3_functions do
		Z3_functions[i]()
	end
end