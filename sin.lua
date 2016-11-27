-- Sine wave.

local SoundUnit = require((...):gsub('[^.]*$', '') .. 'soundunit')

local function process (t, v)
    return math.sin(v * math.pi)
end

return function (t)
    t = SoundUnit(t)
    t.process = process
    return t
end
