-- Saw wave.

local SoundUnit = require((...):gsub('[^.]*$', '') .. 'soundunit')

local function process (t, v)
    return -v
end

return function (t)
    t = SoundUnit(t)
    t.process = process
    return t
end

