assert(rb,"Run fbneo-training-mode.lua")

guicustompage = {
	title = {
		text = "Street Fighter Alpha 3 - Training Mode Settings",
		x = interactivegui.boxxlength/2 - (#"Street Fighter Alpha 3 - Training Mode Settings")*2,
		y = 1,
	},
	guielements.leftarrow,
	guielements.rightarrow,
	{
		text = "Toggle Z3 HUD",
		x = 8,
		y = 30,
		olcolour = "black",
		handle = 1,
		info = {
			"Display Z3 specific informations",
		},
		func =	function()
				draw_hud = draw_hud + 1
				if draw_hud > 0 then
					draw_hud = -1
				end
			end,
		autofunc = function(this)
				if draw_hud == -1 then
					this.text = "Toggle Z3 HUD: Off"
				elseif draw_hud == 0 then
					this.text = "Toggle Z3 HUD: On"
				end
			end,
	},
	{
		text = "AutoBlock",
		x = 8,
		y = 50,
		olcolour = "black",
		handle = 2,
		info = {
			"Control guard / auto-block on P2",
			"Block everything: will guard any ground or jump attack",
			"Block ground attacks: useful to practice combos that start with a jump-in",
			"Block auto: Allow the first hit, block if you drop the combo",
			"Block random: useful to practice hit-confirms"
		},
		func =	function()
				autoblock_selector = autoblock_selector + 1
				if autoblock_selector > 3 then
					autoblock_selector = -1
				end
			end,
		autofunc = function(this)
				if autoblock_selector == -1 then
					this.text = "AutoBlock (P2): Disabled"
				elseif autoblock_selector == 0 then
					this.text = "AutoBlock (P2): Block everything"
				elseif autoblock_selector == 1 then
					this.text = "AutoBlock (P2): Block ground attacks"
				elseif autoblock_selector == 2 then
					this.text = "AutoBlock (P2): Block auto"
				elseif autoblock_selector == 3 then
					this.text = "AutoBlock (P2): Block random"
				end
			end,
	},
	{
		text = "Guard",
		x = 8,
		y = 70,
		olcolour = "black",
		handle = 3,
		info = {
			"Control Guard Gauge",
			"Can be normal or always full"
		},
		func =	function()
				guard_gauge_selector = guard_gauge_selector + 1
				if guard_gauge_selector > 1 then
					guard_gauge_selector = -1
				end
			end,
		autofunc = function(this)
				if guard_gauge_selector == -1 then
					this.text = "Guard Gauge (P2): Normal"
				elseif guard_gauge_selector == 0 then
					this.text = "Guard Gauge (P2): Always Full"
				end
			end,
	},
	{
		text = "Stun/Dizzy",
		x = 8,
		y = 90,
		olcolour = "black",
		handle = 3,
		info = {
			"Control Stun/Dizzy",
			"Can be normal, off (never dizzy) or on (always dizzy)"
		},
		func =	function()
				dizzy_selector = dizzy_selector + 1
				if dizzy_selector > 1 then
					dizzy_selector = -1
				end
			end,
		autofunc = function(this)
				if dizzy_selector == -1 then
					this.text = "Stun/Dizzy (P2): Normal"
				elseif dizzy_selector == 0 then
					this.text = "Stun/Dizzy (P2): Off (never dizzy)"
				elseif dizzy_selector == 1 then
					this.text = "Stun/Dizzy (P2): On (always dizzy)"
				end
			end,
	},
	{
		text = "Auto Counter Hit",
		x = 8,
		y = 110,
		olcolour = "black",
		handle = 4,
		info = {
		},
		func =	function()
				counter_hit_selector = counter_hit_selector + 1
				if counter_hit_selector > 1 then
					counter_hit_selector = -1
				end
			end,
		autofunc = function(this)
				if counter_hit_selector == -1 then
					this.text = "Toggle Auto Counter Hit: Off"
				elseif counter_hit_selector == 0 then
					this.text = "Toggle Auto Counter Hit: P1"
				elseif counter_hit_selector == 1 then
					this.text = "Toggle Auto Counter Hit: P2"
				end
			end,
	},
	{
		text = "Auto Air Tech",
		x = 150,
		y = 30,
		olcolour = "black",
		handle = 5,
		info = {
		},
		func =	function()
				air_tech_selector = air_tech_selector + 1
				if air_tech_selector > 1 then
					air_tech_selector = -1
				end
			end,
		autofunc = function(this)
				if air_tech_selector == -1 then
					this.text = "Toggle Auto Air Tech: Off"
				elseif air_tech_selector == 0 then
					this.text = "Toggle Auto Air Tech: P1"
				elseif air_tech_selector == 1 then
					this.text = "Toggle Auto Air Tech: P2"
				end
			end,
	},
	{
		text = "Air tech",
		x = 150,
		y = 50,
		olcolour = "black",
		handle = 6,
		info = {
		},
		func =	function()
				tech_type_selector = tech_type_selector + 1
				if tech_type_selector > 2 then
					tech_type_selector = 0
				end
			end,
		autofunc = function(this)
				if tech_type_selector == 0 then
					this.text = "Air Tech: Neutral"
				elseif tech_type_selector == 1 then
					this.text = "Air Tech: Backward"
				elseif tech_type_selector == 2 then
					this.text = "Air Tech: Forward"
				end
			end,
	},
	{
		text = "Crouch Cancel Training",
		x = 150,
		y = 70,
		olcolour = "black",
		handle = 10,
		info = {
		},
		func =	function()
				crouch_cancel_training_selector = crouch_cancel_training_selector + 1
				if crouch_cancel_training_selector > 1 then
					crouch_cancel_training_selector = -1
				end
			end,
		autofunc = function(this)
				if crouch_cancel_training_selector == -1 then
					this.text = "Crouch Cancel Training: Off"
				elseif crouch_cancel_training_selector == 0 then
					this.text = "Crouch Cancel Training: P1"
				elseif crouch_cancel_training_selector == 1 then
					this.text = "Crouch Cancel Training: P2"
				end
			end,
	},
	{
			text = "Advanced Settings",
			x = 8,
			y = 150,
			olcolour = "black",
			handle = 10,
			func = 	function() CIG("advancedsettings", 1) end,
	}
}
local advancedsettings = {
	title = {
		text = "Advanced settings",
		x = interactivegui.boxxlength/2 - 40,
		y = 1,
	},
	{
		text = "<",
		olcolour = "black",
		info = "Back",
		func =  function() CIG(interactivegui.previouspage,1) end,
	},
	{
		text = "Select stage",
		x = 8,
		y = 30,
		olcolour = "black",
		handle = 7,
		info = {
			"Background stage selection",
			"Must be changed on player select screen, before selecting character."
		},
		func =	function()
				stage_selector = stage_selector + 1
				if stage_selector > #characters+1 then
					stage_selector = 0
				end
			end,
		autofunc = 	function(this)
			if stage_selector == 0 then
				this.text = "Select stage: Disabled"
			elseif stage_selector <= #characters then
				this.text = "Select stage: "..characters[stage_selector].name
			else
				this.text = "Select stage: Final Stage"
			end
		end
	},
	{
		text = "Select Speed",
		x = 8,
		y = 50,
		olcolour = "black",
		handle = 8,
		info = {
			"",
		},
		func =	function()
				speed_selector = speed_selector + 1
				if speed_selector > 0 then
					speed_selector = -1
				end
			end,
		autofunc = function(this)
				if speed_selector == -1 then
					this.text = "Select Speed: Turbo"
				elseif speed_selector == 0 then
					this.text = "Select Speed: Normal"
				end
			end,
	},
	{
		text = "Disable Background Music",
		x = 8,
		y = 70,
		handle = 9,
		olcolour = "black",
		info = {
			"Disable background music",
			"Must be changed on player select screen, before selecting character."
		},
		func =	function()
			nomusic_selector = nomusic_selector + 1
			if nomusic_selector > 0 then
				nomusic_selector = -1
			end
		end,
		autofunc = function(this)
			if nomusic_selector == -1 then
				this.text = "Disable Background Music: Off"
			elseif nomusic_selector == 0 then
				this.text = "Disable Background Music: On"
			end
		end,
	},
}
guipages.advancedsettings = advancedsettings
------------------------------------------
-- Add-on
------------------------------------------
addonpage = {
	title = {
		text = "Add-On",
		x = interactivegui.boxxlength/2 - 10,
		y = 1,
	},
	{
		text = "<",
		olcolour = "black",
		info = "Back",
		func =  function() 
			interactivegui.page = 5
			interactivegui.selection = 1 
		end,
	},
}
guipages.addonpage = addonpage

addonbutton = {
		text = "Add-On",
		x = 210,
		y = 150,
		olcolour = "black",
		handle = 7,
		func = 	function() CIG("addonpage", 1) end,
		}

function insertAddonButton()
	if #addonpage > 1 then
		table.insert(guicustompage, addonbutton)
		formatGuiTables()
	end
end

function determineButtonYPos(_guipage)
	if #_guipage == 1 then 
		return 40
	else
		return _guipage[#_guipage].y+20
	end
end