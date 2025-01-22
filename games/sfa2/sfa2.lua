
assert(rb,"Run fbneo-training-mode.lua") -- make sure the main script is being run

p1maxhealth = 144
p2maxhealth = 144
p1maxmeter = 144
p2maxmeter = 144


local p1health = 0xFF8450
local p1redhealth = 0xff8452
local p2health = 0xFF8850
local p2redhealth = 0xFF8852

local p1meter = 0xFF849E
local p2meter = 0xFF889E

local p2Stun = 0xFF8937
local p2StunThreshold = 0xFF893A

local p2cantech = 0xFF8467
local p1attackout = 0xFF8532
local p2notactionable = 0xFF8805
local p2juggle = 0xFF2849
local p2Hitstun = 0xff885e
local p2HitstunTimer = 0xFF845F
local p2Jumping = 0xff8830
local p2FacingDirection = 0xFF8931
local p2KnockedDown = 0xFF8934
local p2HitState = 0xFF8405

-- Frame Counts
local startFrame = nil 
local startFrameTechRoll = nil
local autoBlockTimer = nil
local startFrameAirTechRoll = nil


local leftRightSwap = nil


-- GUI Values
throwTech_selector = 0
techRoll_selector = 0
rollType_selector = 0
alphaCounter_selector = 0
alphaCounterType_selector = 0
p2State_selector = 0
Stun_selector = 0
p2Block_selector = 0
AirRoll_selector = 0
AirRollType_selector = 0

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
		combotextx=180,
		combotexty=42,
		comboenabled=true,
		p1healthx=18,
		p1healthy=18,
		p1healthenabled=true,
		p2healthx=355,
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
	return rb(0xff8931)==1
end

function playerTwoFacingLeft()
	return rb(0xff8931)==0
end

function playerOneInHitstun()
	return rb(0xff845e)~=0
end

function playerTwoInHitstun()
	return rb(0xff885e)~=0
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
	return rw(p1meter)
end

function writePlayerOneMeter(meter)
	ww(p1meter, meter)
end

function readPlayerTwoMeter()
	return rw(p2meter)
end

function writePlayerTwoMeter(meter)
	ww(p2meter, meter)
end

local infiniteTime = function()
	wb(0xff8109, 99)
end

-- L/R direction input swap 
function setP2Direction()
        if rb(p2FacingDirection) == 1 then
            leftRightSwap = "P2 Left"
        else
            leftRightSwap = "P2 Right"
        end
end


-- Tech Throws P2
local p2ThrowTech = function()
    if throwTech_selector == 1 and rb(p2cantech) == 1 then
		joypad.set({[leftRightSwap] = true, ["P2 Medium Punch"] = true}) 
	end
end

-- State P2
local p2State = function()
	if p2State_selector == 1 and rb(p1attackout) == 0 and rb(p2notactionable) == 0 then
		joypad.set({["P2 Up"] = true})
	end  
	if p2State_selector == 2 and rb(p1attackout) == 0 and rb(p2notactionable) == 0 then
		joypad.set({["P2 Down"] = true})
	end
	-- To stop standing when in no block + crouch
	if p2State_selector == 2 and rb(p2notactionable) == 0 and p2Block_selector == 0 then
		joypad.set({["P2 Down"] = true})
	end
end

-- Blocking P2
local p2Block = function()
	if p2Block_selector == 1 and rb(p1attackout) == 1 then
		if p2State_selector <= 1 then
			joypad.set({[leftRightSwap] = true})
		end
		if p2State_selector == 2 then
			joypad.set({["P2 Down"] = true, [leftRightSwap] = true})
		end 
    end
	-- Auto Block
	if p2Block_selector == 2 and rb(p2notactionable) == 2 then
		-- start timer
		startAutoBlockTimer = 1
	end
	if startAutoBlockTimer == 1 and not autoBlockTimer then
		autoBlockTimer = emu.framecount()
	end 
	if rb(p1attackout) == 1 and p2State_selector <= 1 and autoBlockTimer and emu.framecount() - autoBlockTimer < 60 then
		joypad.set({[leftRightSwap] = true})
		startAutoBlockTimer = 0
	end
	-- Make it so the opponent still crouches when an attack is out and auto block isn't triggered
	if rb(p1attackout) == 1 and p2Block_selector == 2 and p2State_selector == 2 and rb(p2Hitstun) == 0 then
		joypad.set({["P2 Down"] = true})
		startAutoBlockTimer = 0
	end
	-- Crouching block
	if rb(p1attackout) == 1 and p2State_selector == 2 and autoBlockTimer and emu.framecount() - autoBlockTimer < 60 then
		joypad.set({["P2 Down"] = true, [leftRightSwap] = true})
		startAutoBlockTimer = 0
	end
	-- Timer Reset
	if rb(p1attackout) == 0 and autoBlockTimer and emu.framecount() - autoBlockTimer > 60 then
		autoBlockTimer = nil
		startAutoBlockTimer = nil
	end
end

local p2BlockRandom = function()
	if p2Block_selector == 3 and rb(p1attackout) == 1 and rb(p2notactionable) == 0 and not standingRandomBlock then
		standingRandomBlock = math.random(2)
		if standingRandomBlock == 1 and p2State_selector <= 1 and rb(p1attackout) == 1 then
			joypad.set({[leftRightSwap] = true})
		end
		if standingRandomBlock == 1 and p2State_selector == 2 and rb(p1attackout) == 1 then
			joypad.set({["P2 Down"] = true, [leftRightSwap] = true})
		end
    end
	if p2Block_selector == 3 and rb(p1attackout) == 0 then
		standingRandomBlock = nil
	end
end



-- Alpha counter P2
	-- Needs a fuckin' projectile version
	-- Also needs something to deal with meaty attacks
local p2AlphaCounter = function()
	if rb(p2notactionable) == 2 and rb(p2Hitstun) == 0 and rb(p2KnockedDown) == 0 and rw(p2Jumping) == 0 and alphaCounter_selector == 1 and not startFrame then
		startFrame = emu.framecount()
    end
	if rb(p2notactionable) == 2 and  rb(p2Hitstun) == 0 and alphaCounter_selector == 1 and startFrame and emu.framecount() - startFrame <= 1 then
		joypad.set({[leftRightSwap] = true}) 
    end
    if rb(p2notactionable) == 2 and  rb(p2Hitstun) == 0 and alphaCounter_selector == 1 and startFrame and emu.framecount() - startFrame == 2 then
		joypad.set({["P2 Down"] = true, [leftRightSwap] = true}) 
    end
    if rb(p2notactionable) == 2 and  rb(p2Hitstun) == 0 and alphaCounter_selector == 1 and alphaCounterType_selector == 0 and startFrame and emu.framecount() - startFrame >= 3 then
        joypad.set({["P2 Down"] = true, ["P2 Medium Punch"] = true}) 
		startFrame = nil
    end
	if rb(p2notactionable) == 2 and  rb(p2Hitstun) == 0 and alphaCounter_selector == 1 and alphaCounterType_selector == 1 and startFrame and emu.framecount() - startFrame >= 3 then
        joypad.set({["P2 Down"] = true, ["P2 Medium Kick"] = true})
		startFrame = nil
    end
		if rb(p1attackout) == 0 and startFrame and rb(p2notactionable) == 0 then
		startFrame = nil
	end
end

-- Air Tech Roll P2
local p2AirTechRoll = function()
	if rb(p2notactionable) == 2 and rb(p2Hitstun) == 0 and rb(p2KnockedDown) == 0 and rw(p2Jumping) >= 1 and AirRoll_selector == 1 and not startFrameAirTechRoll then
		startFrameAirTechRoll = emu.framecount()
	end
	if rb(p2notactionable) == 2 and rb(p2Hitstun) == 0 and AirRoll_selector == 1 and startFrameAirTechRoll and emu.framecount() - startFrameAirTechRoll <= 1 then
		joypad.set({[leftRightSwap] = true}) 
	end
	if rb(p2notactionable) == 2 and rb(p2Hitstun) == 0 and AirRoll_selector == 1 and startFrameAirTechRoll and emu.framecount() - startFrameAirTechRoll == 2 then
		joypad.set({["P2 Down"] = true, [leftRightSwap] = true}) 
	end
	if rb(p2notactionable) == 2 and rb(p2Hitstun) == 0 and AirRoll_selector == 1 and AirRollType_selector == 0 and startFrameAirTechRoll and emu.framecount() - startFrameAirTechRoll >= 3 then
		joypad.set({["P2 Down"] = true, ["P2 Weak Punch"] = true}) 
		startFrameAirTechRoll = nil
	end
	if rb(p2notactionable) == 2 and rb(p2Hitstun) == 0 and AirRoll_selector == 1 and AirRollType_selector == 1 and startFrameAirTechRoll and emu.framecount() - startFrameAirTechRoll >= 3 then
		joypad.set({["P2 Down"] = true, ["P2 Medium Punch"] = true})
		startFrameAirTechRoll = nil
	end
	if rb(p2notactionable) == 2 and rb(p2Hitstun) == 0 and AirRoll_selector == 1 and AirRollType_selector == 2 and startFrameAirTechRoll and emu.framecount() - startFrameAirTechRoll >= 3 then
		joypad.set({["P2 Down"] = true, ["P2 Strong Punch"] = true})
		startFrameAirTechRoll = nil
	end
		if rb(p1attackout) == 0 and startFrameAirTechRoll and rb(p2notactionable) == 0 then
		startFrameAirTechRoll = nil
	end
end
	
-- Tech roll P2
local p2TechRoll = function()
    if techRoll_selector == 1 and rb(p2KnockedDown) == 1 and not startFrameTechRoll then
        startFrameTechRoll = emu.framecount()
    end
	if startFrameTechRoll and emu.framecount() - startFrameTechRoll == 5 then 
        joypad.set({[leftRightSwap] = true}) 
    end
    if startFrameTechRoll and emu.framecount() - startFrameTechRoll == 6 then 
        joypad.set({["P2 Down"] = true, [leftRightSwap] = true}) 
    end
    if rollType_selector == 0 and startFrameTechRoll and emu.framecount() - startFrameTechRoll == 7 then
        joypad.set({["P2 Down"] = true, ["P2 Weak Punch"] = true})
		startFrameTechRoll = nil
    end
	if rollType_selector == 1 and startFrameTechRoll and emu.framecount() - startFrameTechRoll == 7 then
        joypad.set({["P2 Down"] = true, ["P2 Medium Punch"] = true})
		startFrameTechRoll = nil
    end
	if rollType_selector == 2 and startFrameTechRoll and emu.framecount() - startFrameTechRoll == 7 then
        joypad.set({["P2 Down"] = true, ["P2 Strong Punch"] = true})
		startFrameTechRoll = nil
    end
	if rb(0xff885e) == 0 and startFrameTechRoll then
		startFrameTechRoll = nil
	end
end

-- P2 Stun Settings
function Stun()
	if Stun_selector == 1 then 
		wb(p2Stun, 0)
	end
	if Stun_selector == 2 then
		wb(p2Stun, rb(p2StunThreshold) - 1) 
	end
end

function Run() -- runs every frame
	setP2Direction()
	p2BlockRandom()
	p2Block()
	Stun()
	infiniteTime()
	p2AlphaCounter()
	p2AirTechRoll()
	p2TechRoll()
	p2ThrowTech()
	p2State()
end
