assert(rb,"Run fbneo-training-mode.lua")

guicustompage = {
	title = {
		text = "Street Fighter Alpha 2 - Training Mode Settings",
		x = interactivegui.boxxlength/2 - (#"Street Fighter Alpha 2 - Training Mode Settings")*2,
		y = 1,
	},
	guielements.leftarrow,
	guielements.rightarrow,
	{
		text = "State",
		x = 8,
		y = 30,
		olcolour = "black",
		handle = 1,
		info = {
		},
		func =	function()
			p2State_selector = p2State_selector + 1
			if p2State_selector > 2 then
				p2State_selector = 0
			end
		end,
	autofunc = function(this)
			if p2State_selector == 0 then
				this.text = "P2 State: Stand"
			elseif p2State_selector == 1 then
				this.text = "P2 State: Jump"
			elseif p2State_selector == 2 then
				this.text = "P2 State: Crouch"
			end
		end,
	},
	{
		text = "Block",
		x = 8,
		y = 45,
		olcolour = "black",
		handle = 2,
		info = {
		},
		func =	function()
			p2Block_selector = p2Block_selector + 1
			if p2Block_selector > 3 then
				p2Block_selector = 0
			end
		end,
	autofunc = function(this)
			if p2Block_selector == 0 then
				this.text = "No Block"
			elseif p2Block_selector == 1 then
				this.text = "Block All"
			elseif p2Block_selector == 2 then
				this.text = "Auto Block"
			elseif p2Block_selector == 3 then
				this.text = "Random Block"
			end
		end,
	},
	{
		text = "Stun Settings",
		x = 8,
		y = 60,
		olcolour = "black",
		handle = 3,
		info = {
		},
		func =	function()
			Stun_selector = Stun_selector + 1
			if Stun_selector > 2 then
				Stun_selector = 0
			end
			end,
		autofunc = function(this)
				if Stun_selector == 0 then
					this.text = "Normal Stun"
				elseif Stun_selector == 1 then
					this.text = "No Stun"
				elseif Stun_selector == 2 then
					this.text = "Forced Stun"
				end
			end,
	},
	{
		text = "Toggle Throw Tech",
		x = 8,
		y = 75,
		olcolour = "black",
		handle = 4,
		info = {
		},
		func =	function()
				throwTech_selector = throwTech_selector + 1
				if throwTech_selector > 1 then
					throwTech_selector = 0
				end
			end,
		autofunc = function(this)
				if throwTech_selector == 0 then
					this.text = "Toggle Throw Tech: Off"
				elseif throwTech_selector == 1 then
					this.text = "Toggle Throw Tech: On"
				end
			end,
	},
	{
		text = "Toggle Tech Roll",
		x = 8,
		y = 90,
		olcolour = "black",
		handle = 5,
		info = {
		},
		func =	function()
				techRoll_selector = techRoll_selector + 1
				if techRoll_selector > 1 then
					techRoll_selector = 0
				end
			end,
		autofunc = function(this)
				if techRoll_selector == 0 then
					this.text = "Toggle Tech Roll: Off"
				elseif techRoll_selector == 1 then
					this.text = "Toggle Tech Roll: On"
				end
			end,
	},
	{
		text = "Tech Roll",
		x = 170,
		y = 90,
		olcolour = "black",
		handle = 6,
		info = {
		},
		func =	function()
				rollType_selector = rollType_selector + 1
				if rollType_selector > 2 then
					rollType_selector = 0
				end
			end,
		autofunc = function(this)
				if rollType_selector == 0 then
					this.text = "Tech Roll: Light"
				elseif rollType_selector == 1 then
					this.text = "Tech Roll: Medium"
				elseif rollType_selector == 2 then
					this.text = "Tech Roll: Heavy"
				end
			end,
	},
	{
		text = "Toggle Air Tech Roll",
		x = 8,
		y = 105,
		olcolour = "black",
		handle = 7,
		info = {
		},
		func =	function()
				AirRoll_selector = AirRoll_selector + 1
				if AirRoll_selector > 1 then
					AirRoll_selector = 0
				end
			end,
		autofunc = function(this)
				if AirRoll_selector == 0 then
					this.text = "Toggle Air Tech Roll: Off"
				elseif AirRoll_selector == 1 then
					this.text = "Toggle Air Tech Roll: On"
				end
			end,
	},
	{
		text = "Air Tech Roll",
		x = 170,
		y = 105,
		olcolour = "black",
		handle = 8,
		info = {
		},
		func =	function()
				AirRollType_selector = AirRollType_selector + 1
				if AirRollType_selector > 2 then
					AirRollType_selector = 0
				end
			end,
		autofunc = function(this)
				if AirRollType_selector == 0 then
					this.text = "Air Tech Roll: Light"
				elseif AirRollType_selector == 1 then
					this.text = "Air Tech Roll: Medium"
				elseif AirRollType_selector == 2 then
					this.text = "Air Tech Roll: Heavy"
				end
				
			end,
	},
	{
		text = "Toggle Alpha Counter",
		x = 8,
		y = 120,
		olcolour = "black",
		handle = 9,
		info = {
		},
		func =	function()
				alphaCounter_selector = alphaCounter_selector + 1
				if alphaCounter_selector > 1 then
					alphaCounter_selector = 0
				end
			end,
		autofunc = function(this)
				if alphaCounter_selector == 0 then
					this.text = "Toggle Alpha Counter: Off"
				elseif alphaCounter_selector == 1 then
					this.text = "Toggle Alpha Counter: On"
				end
			end,
	},
	{
		text = "Alpha Counter",
		x = 170,
		y = 120,
		olcolour = "black",
		handle = 10,
		info = {
		},
		func =	function()
				alphaCounterType_selector = alphaCounterType_selector + 1
				if alphaCounterType_selector > 2 then
					alphaCounterType_selector = 0
				end
			end,
		autofunc = function(this)
				if alphaCounterType_selector == 0 then
					this.text = "Alpha Counter: Punch"
				elseif alphaCounterType_selector == 1 then
					this.text = "Alpha Counter: Kick"
				end
			end,
	},
}
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