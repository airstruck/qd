-- Drum kit

local REL = (...):gsub('[^.]*$', '')

local SoundUnit = require (REL .. 'soundunit')
local Osc = require (REL .. 'osc')
local Util = require (REL .. 'util')

local nullOsc = Osc { freq = 0 }

local function plan (t, clock, seq, rate, offset)
    local timestep = 1 / rate
    for line in seq:gmatch('[^\n]+') do
        local s, e, drumName, pattern = line:find('([^|]-)%s*|(.+)|')
        if drumName and pattern then
            local data = t.dataByName[drumName]
            local osc = t.oscsByName[drumName]
            if not osc then
                data = { time = 0, n = 0 }
                osc = assert(t[drumName](data))
                t.dataByName[drumName] = data
                t.oscsByName[drumName] = osc
                if t.oscs == nullOsc then
                    t.oscs = osc
                else
                    t.oscs = t.oscs + osc
                end
                clock:always(function (dt)
                    data.time = data.time + dt
                end)
            end
            local time = offset or 0
            for char in pattern:gmatch('.') do
                local n = tonumber(char, 36)
                if n then
                    clock:atSecond(time, function ()
                        data.time = 0
                        data.n = n
                    end)
                elseif char == '-' then
                elseif char == '|' then
                    time = time - timestep
                end
                time = time + timestep
            end
        end
    end
end

local function process (t, left, right)
    return t.oscs:process(left, right)
end
    
return function (t)
    t = SoundUnit(t)
    t.process = t.process or process
    t.plan = t.plan or plan
    t.dataByName = {}
    t.oscsByName = {}
    t.oscs = nullOsc
    
    return t
end
