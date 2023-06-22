local hitboxes_file = "games/ssf2xjr1/addon/resources/hitboxes/"
local ini = false
local DEBUG = true

local FAIL_TIMEOUT = 50
local RESET_TIMEOUT = 60

-- Colors from sf6 combo trial
local comboMoveStatus = {
	next = "#c154c1",
	pending = "#ffffff",
	complete = "#fc8eac",
	fail = "#000000",
}

local ryuComboList = {
	{"Cr LK", "Cr LK", "Cr LK"},
	{"Hadouken HP"},
	{"Cr MK", "Hadouken HP"},
}

-- state
local comboData = {
    comboStep = 0,
    showError = false,
    failTimeout = -1, -- nil
    resetTimeout = -1, -- nil
    currentCombo = 1,
	comboComplete = false,
}

-- helpers
local function printTrial()
	-- title
	gui.text(60,50,"Combo Trial ("..comboData.currentCombo.."/"..#ryuComboList.."):")
	
	local nextStep = comboData.comboStep + 1

	-- completion exit
	if comboData.currentCombo > #ryuComboList then
		return
	end

	-- steps printing
	for i = 1, #ryuComboList[comboData.currentCombo] do
		-- next step color
		if i == nextStep then
			if comboData.showError then
				color = comboMoveStatus.fail
			else
				color = comboMoveStatus.next
			end	
			gui.text(50, 50 + 10 * i, ">>", color)
		-- pre and post steps color
		elseif i < nextStep then
			color = comboMoveStatus.complete
		else
			color = comboMoveStatus.pending
		end
		
		-- step print
		gui.text(60, 50 + 10 * i, ryuComboList[comboData.currentCombo][i], color)

		-- combo complete
		if comboData.comboStep == #ryuComboList[comboData.currentCombo] then
			gui.text(60, 50 + 10 * (nextStep), "SUCCESS!", color)
			comboData.comboComplete = true
		end
	end
end

-- given that it's a constant frame evaluation we only change steps incrementally, unless reset or restart happens
local function updateComboStep(newStep)
	if newStep > comboData.comboStep then
		comboData.comboStep = newStep
	end
end

-- main
local function comboTrials()
	-- Mimicking sf6 combo trial. Example: https://www.youtube.com/watch?v=trJYL24eCzE

	-- completion exit
	if comboData.currentCombo > #ryuComboList then
		gui.text(50, 50 + 10, "Combo Trial Complete")
		return
	end

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
			-- combo counter chances on hit so we need the hit change as the moment of reference
			if gamestate.P2.state == being_hit and gamestate.P2.prev.state ~= being_hit then
				-- variable to handle the very first init case
				local initComboStep = comboData.comboStep
				-- disable reset timeout
				comboData.resetTimeout = -1
				-- Start move case. Because we are coming from a non hit state
				if readMove(gamestate.P1, ryuComboList[comboData.currentCombo][gamestate.P2.combo_counter + 1]) then
					updateComboStep(gamestate.P2.combo_counter + 1)
					comboData.failTimeout = FAIL_TIMEOUT
				end
				-- Restart case. Only after fail status is marked and first combo moved happens
				if comboData.showError and comboData.comboStep > 0 and readMove(gamestate.P1, ryuComboList[comboData.currentCombo][1]) then
					comboData.showError = false
					comboData.comboStep = 1
					-- let's print and return to avoid bleeding in the next condition
					printTrial()
    				return
				end
				-- Fail case
				if gamestate.P2.combo_counter < comboData.comboStep and initComboStep ~= 0 then
					comboData.showError = true
					comboData.resetTimeout = RESET_TIMEOUT
				end
				
			end
			
			-- Combo case. As of the first hit
			if gamestate.P2.state == being_hit and gamestate.P2.prev.state == being_hit and
			   -- skip "start move case" dealt in the previous if
			   comboData.comboStep > 0 and
			   -- super important. So they first combo step and previous steps that are not
			   -- following up the combo sequence are not evaluated. Otherwise we would get
			   -- unnecessary fail cases.
			   -- This is also because in sf6 the first line will never be a fail
			   -- only as of the second line.
			   gamestate.P2.combo_counter + 1 >= comboData.comboStep and
			   -- blocked until restart case
			   comboData.showError == false and
			   -- avoid overflow
			   gamestate.P2.combo_counter + 1 <= #ryuComboList[comboData.currentCombo] then
				if readMove(gamestate.P1, ryuComboList[comboData.currentCombo][gamestate.P2.combo_counter + 1]) then
					updateComboStep(gamestate.P2.combo_counter + 1)
					comboData.failTimeout = FAIL_TIMEOUT
				-- this is the fail case where we perform a combo
				-- but not with the right moves
				-- the combo counter increases but not the combostep
				elseif gamestate.P2.combo_counter == comboData.comboStep then
					comboData.showError = true
					comboData.resetTimeout = RESET_TIMEOUT
				end
			end

			-- Fail timeout. sf6 style
			if comboData.failTimeout > 0 then
				comboData.failTimeout = comboData.failTimeout - 1
			elseif comboData.failTimeout == 0 then
				comboData.showError = true
				comboData.resetTimeout = RESET_TIMEOUT
				comboData.failTimeout = -1
			end

			-- Reset timeout. sf6 style
			if comboData.resetTimeout > 0 then
				comboData.resetTimeout = comboData.resetTimeout - 1
			elseif comboData.resetTimeout == 0 then
				comboData.showError = false
				comboData.resetTimeout = -1
				comboData.comboStep = 0
				-- jump to next combo only after reset, otherwise currentcombo index will fail
				if comboData.comboComplete then
					comboData.currentCombo = comboData.currentCombo + 1
					comboData.comboComplete = false
				end
			end
			printTrial()
		end

		--------------
		-- Reinitialization
		if characterChanged(gamestate.P1) then
			ini = false
		end
	end
end
table.insert(ST_functions, comboTrials) -- ST_functions = functions executed each frame by ssf2xjr1