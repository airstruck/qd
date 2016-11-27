-- Fold distortion

local SoundUnit = require((...):gsub('[^.]*$', '') .. 'soundunit')

local function process (t, v)
    local max = math.abs(t.limit)
    return v > max and (max - (v - max)) * t.factor
        or v < -max and (-max + (-v - max)) * t.factor
        or v
end

return function (t)
    t = SoundUnit(t)
    t.process = process
    t.limit = t.limit or 0.5
    t.factor = t.factor or 0.5
    return t
end

