-- Tube distortion.

local SoundUnit = require((...):gsub('[^.]*$', '') .. 'soundunit')

local function process (t, v)
    for i = 1, t.count do
        v = 1.5 * v - (v ^ 3) * 0.5
    end
    return v
end

return function (t)
    t = SoundUnit(t)
    t.process = process
    t.count = t.count or 1
    return t
end

