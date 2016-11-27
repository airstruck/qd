-- ADSR envelope

local SoundUnit = require((...):gsub('[^.]*$', '') .. 'soundunit')

local function calcAttackLevel (t)
    return t.data.onTime / t.attack
end

local function calcDecayLevel (t)
    return (1 - (t.data.onTime - t.attack) / t.decay) * (1 - t.sustain)
        + t.sustain 
end

local function calcGatedLevel (t)
    return t.data.onTime == 0 and 0
        or t.data.onTime <= t.attack and calcAttackLevel(t)
        or t.data.onTime <= t.attack + t.decay and calcDecayLevel(t)
        or t.sustain 
end

local function calcReleaseLevel (t)
    local initial = calcGatedLevel(t)
    return initial - t.data.offTime / t.release * initial
end

local function process (t, v)
    local prev = t.value
    t.value = t.data.gate and calcGatedLevel(t)
        or t.data.offTime <= t.release and calcReleaseLevel(t)
        or 0
    local diff = t.value - prev
    local adiff = math.abs(diff)
    if adiff > t.maxSpeed then
        t.value = diff / adiff * t.maxSpeed + prev
    end
    
    return t.value * v
end

return function (t)
    t = SoundUnit(t)
    t.process = process
    t.attack = t.attack or 0
    t.decay = t.decay or 0
    t.sustain = t.sustain or 0
    t.release = t.release or 0
    t.maxSpeed = t.maxSpeed or 0.005 -- prevents popping
    t.value = 0
    assert(t.data)
    return t
end

