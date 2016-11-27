-- Soft clipping

local SoundUnit = require((...):gsub('[^.]*$', '') .. 'soundunit')

local TWO_OVER_PI = 2 / math.pi

local function process (t, signal)
    return math.atan(signal) * TWO_OVER_PI
end

return function (t)
    t = SoundUnit(t)
    t.process = process
    return t
end

