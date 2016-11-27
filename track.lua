local REL = (...):gsub('[^.]*$', '')

local SoundUnit = require (REL .. 'soundunit')
local Osc = require (REL .. 'osc')

local nullOsc = Osc { freq = 0 }

local function addVoice (t, clock, voice)
    if t.knownVoices[voice] then return end
    t.knownVoices[voice] = true
    t.sound = t.sound == nullOsc and voice or (t.sound + voice)
    t.output = clock .. t.sound
end

local function plan (t, clock, seq, rate, offset)
    local timestep = 1 / rate
    for line in seq:gmatch('[^\n]+') do
        local s, e, voiceName, pattern = line:find('([^|]-)%s*|(.+)|')
        if voiceName and pattern then
            local voice = assert(t[voiceName])
            local time = 0
            addVoice(t, clock, voice)
            for char in pattern:gmatch('.') do
                local reg = t.registry[char]
                if reg then
                    voice:plan(clock, reg.seq, reg.rate, time)
                    time = time + timestep
                elseif char == '-' then
                    time = time + timestep
                end
            end
        end
    end
end

local function register (t, char, seq, rate)
    t.registry[char] = { seq = seq, rate = rate }
end

local function process (t, left, right)
    return t.output:process(left, right)
end

return function (t)
    t = SoundUnit(t)
    t.process = t.process or process
    t.plan = t.plan or plan
    t.register = t.register or register
    t.sound = nullOsc
    t.output = nullOsc
    t.registry = {}
    t.knownVoices = {}
    
    return t
end

