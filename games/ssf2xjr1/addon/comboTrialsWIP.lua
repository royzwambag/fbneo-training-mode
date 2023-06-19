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

local comboStatus = 'standby'
local comboRestart = false
local showErrorReady = false
local comboBlocked = false
local comboFail = false
local comboStep = 0
local preError = false
local comboError = false
local showError = false
local beforeError = nil
local twoSeconds = 220
local function printTrial()
	-- title
	gui.text(60,50,"Combo Trial (1/5):")
	
	local nextStep = comboStep + 1

	-- steps printing
	for i = 1, #ryuCombosArray2 do
		-- next step
		if i == nextStep then
			if showError then
				color = comboMoveStatus.fail
			else
				color = comboMoveStatus.next
			end	
			gui.text(50, 50 + 10 * i, ">>", color)
		-- pre and post steps
		elseif i < nextStep then
			color = comboMoveStatus.complete
		else
			color = comboMoveStatus.pending
		end
		-- combo complete
		if comboStep == #ryuCombosArray2 then
			gui.text(60, 50 + 10 * (nextStep), "SUCCESS!", color)
		end
		gui.text(60, 50 + 10 * i, ryuCombosArray2[i], color)
	end
end

local function updateComboStep(newStep)
	if newStep > comboStep then
		comboStep = newStep
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
			gui.text(60, 50 + 10 * 5, "comboStep: "..comboStep)
	
			-- init
			updateCurrMove(gamestate.P1)
			local lastMove = gamestate.P1.move
			-- gui.text(60, 50 + 10 * 8, "lastmove: "..lastMove)
			if lastMove == "" then
				-- comboStep = 0
				gui.text(60, 50 + 10 * 9, "dins")
				comboStatus = 'standby'
				
			end
			
			

			if comboStatus == 'fail' then
				if readMove(gamestate.P1, ryuCombosArray2[1]) == false then
					comboStatus = 'waitingForResetTrigger'
					-- gui.text(60, 50 + 10 * 9, tostring())
				end
			end

			if comboStatus == 'waitingForFailTrigger' then
				if isPressed(gamestate.P1, "LK") then
					showError = true
					comboStatus = 'fail'
				end
			end

			if comboStatus == 'blocked' then
				if isPressed(gamestate.P1, "LK") == false then
					comboStatus = 'waitingForFailTrigger'
				end
			end

			if comboStatus == 'started' then
				-- if gamestate.P2.combo_counter == 0 then
					-- comboStatus = 'blocked'
				
				if readMove(gamestate.P1, ryuCombosArray2[gamestate.P2.combo_counter + 1]) then
					comboStep = gamestate.P2.combo_counter + 1
				elseif gamestate.P2.combo_counter == 0 then
					comboStatus = 'blocked'
				end
				
				-- if readMove(gamestate.P1, ryuCombosArray2[gamestate.P2.combo_counter + 1]) then
					-- lua arrays start on 1, not 0
					-- updateComboStep(gamestate.P2.combo_counter + 1)
					
				-- end
				
			end

			
			if comboStatus == 'standby' then
				
				
				if readMove(gamestate.P1, ryuCombosArray2[gamestate.P2.combo_counter + 1]) then
					-- lua arrays start on 1, not 0
					updateComboStep(gamestate.P2.combo_counter + 1)
					-- comboError = false
					showError = false
					-- if showError == false then
					twoSeconds = 120
					comboStatus = 'started'
				end
			end
			
			if comboStatus == 'reset' then
				
				comboStep = 0
				showError = false
				comboStatus = 'started'
				
			end
			
			if comboStatus == 'waitingForResetTrigger' then
				if readMove(gamestate.P1, ryuCombosArray2[1]) then
					comboStatus = 'reset'
				end
			end

			

			gui.text(60, 50 + 10 * 7, "comboStatus: "..comboStatus)
			-- if preError == true then
			-- 	showError = true
			-- end

			-- if isPressed(gamestate.P1, "LK") == false then
			-- 	preError = true
			-- else
			-- 	preError = false
			-- end

			

			-- if gamestate.P2.combo_counter ~= 0 then
			-- 	showError = false
			-- end
			
			-- combo progression
			-- which also restarts the timeout
			

			
			-- gui.text(60, 50 + 10 * 5, "comboFail: "..tostring(comboFail))
			-- if comboFail and isPressed(gamestate.P1, "LK") then
			-- 	comboBlocked = true
			-- end

			-- if comboBlocked and isPressed(gamestate.P1, "LK") == false then
			-- 	showErrorReady = true
			-- end

			-- if showErrorReady and isPressed(gamestate.P1, "LK") then
			-- 	showError = true
			-- end

			-- if showError and isPressed(gamestate.P1, "LK") == false then
			-- 	comboRestart = true
			-- end

			-- if comboRestart and isPressed(gamestate.P1, "LK") then
			-- 	comboFail = false
			-- end

			-- if isPressed(gamestate.P1, "LK") and (comboStep == 0 or showError) then
			-- 	-- if gamestate.P2.combo_counter > comboStep then
			-- 	if gamestate.P2.combo_counter == comboStep then
			-- 		if readMove(gamestate.P1, ryuCombosArray2[gamestate.P2.combo_counter + 1]) then
			-- 			-- lua arrays start on 1, not 0
			-- 			comboStep = gamestate.P2.combo_counter + 1
			-- 			-- comboError = false
			-- 			showError = false
			-- 			-- if showError == false then
			-- 			twoSeconds = 120
			-- 		end
			-- 	end
			-- elseif isPressed(gamestate.P1, "LK") and comboStep > gamestate.P2.combo_counter then
			-- 	-- twoSeconds = twoSeconds - 1
			-- 	showError = true
			-- end
			
			-- reset cases
			
			-- 2. after 2 seconds of non combo moves
			-- lastMove ~= ryuCombosArray2[1] and gamestate.P2.combo_counter == 0
			-- if readMove(gamestate.P1, ryuCombosArray2[1]) and gamestate.P2.combo_counter == 0 or twoSeconds == 0 then
				-- comboStep = 0
				-- showError = false
				-- comboError = false
			-- end

			
			-- if isPressed(gamestate.P1, "LK") == false and comboStep ~= 0 and gamestate.P2.combo_counter == 0 then
			-- 	-- beforeErrorMove = readMove(gamestate.P1, lastMove)
			-- 	-- beforeErrorMove = lastMove
			-- 	comboError = true
			-- 	-- showError = false
			-- else
			-- 	comboError = false
				
			-- end

			-- print trial with corresponding comboStep (global var)
			printTrial()
			
			

			

			-- updateCurrMove(gamestate.P1)
			-- local firstMoveCached = ryuCombosArray2[gamestate.P2.combo_counter + 1] == gamestate.P1.move
			-- if firstMoveCached then
				-- printTrial(gamestate.P2.combo_counter + 1)
			-- end
			-- if gamestate.P2.combo_counter == 0 and readMove(gamestate.P1, ryuCombosArray2[1]) then
				-- comboStep = 0
			-- end
		end
		--------------
		-- Reinitialization
		if characterChanged(gamestate.P1) then
			ini = false
		end
	end
end
table.insert(ST_functions, comboTrials) -- ST_functions = functions executed each frame by ssf2xjr1