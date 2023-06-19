local hitboxes_file = "games/ssf2xjr1/addon/resources/hitboxes/"
local ini = false
local DEBUG = true

local comboMoveStatus = {
	next = "#c154c1",
	pending = "#ffffff",
	complete = "#fc8eac",
	fail = "#000000",
}

local colorTest = {"white", "red"}
local comboMoveStatusColors = {
	next = "#c154c1",
	pending = "#ffffff",
	complete = "#fc8eac",
	fail = "#000000",
}

local ryuCombosArray = {"J HK_F", "Cr HK", "Hadouken HP"}
local ryuCombosArray2 = {"Cr LK", "Cr LK", "Cr LK"}

local lastIndex = 0
local function printTrial(reference)
	if reference > lastIndex then
		lastIndex = reference
	end

	gui.text(60,50,"Combo Trial (1/5):")
	
	for i = 1, 3 do
		if lastIndex == i then
			color = "red"
		else
			color = "white"
		end
		gui.text(60, 50 + 10 * i, ryuCombosArray2[i], color)
	end
end

local function comboTrials()
	-- Initialization
	if not ini then
		print(hitboxes_file..readCharacterName(gamestate.P1).."_hitboxes.lua")
		if fexists(hitboxes_file..readCharacterName(gamestate.P1).."_hitboxes.lua") then
			dofile(hitboxes_file..readCharacterName(gamestate.P1).."_hitboxes.lua")
			if DEBUG then
				print(">>> "..printName(gamestate.P1).."'s hitboxes loaded")
			end
		else
			if DEBUG then
				print(">>> Can't find "..printName(gamestate.P1).."'s hitboxes")
			end
		end
		ini = true
	else
		if gamestate.P1.character == Ryu then
			printTrial(0)
			updateCurrMove(gamestate.P1)

			if ryuCombosArray2[gamestate.P2.combo_counter + 1] == gamestate.P1.move then
				printTrial(gamestate.P2.combo_counter + 1)
			end
		end
		--------------
		-- Reinitialization
		if characterChanged(gamestate.P1) then
			ini = false
		end
	end
end
table.insert(ST_functions, comboTrials) -- ST_functions = functions executed each frame by ssf2xjr1