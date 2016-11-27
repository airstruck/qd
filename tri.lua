-- Triangle wave.

local SoundUnit = require((...):gsub('[^.]*$', '') .. 'soundunit')

local function process (t, v)
    return math.abs(2 * v) - 1
end

return function (t)
    t = SoundUnit(t)
    t.process = process
    return t
end

