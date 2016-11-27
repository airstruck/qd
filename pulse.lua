-- Pulse wave.

local SoundUnit = require((...):gsub('[^.]*$', '') .. 'soundunit')

local function process (t, v)
    return v < t.width and -1 or 1
end

return function (t)
    t = SoundUnit(t)
    t.process = process
    t.width = t.width or 0
    return t
end

