-- Hard clipping

local SoundUnit = require((...):gsub('[^.]*$', '') .. 'soundunit')

local function process (t, mono)
    return math.min(math.max(t.min, mono), t.max)
end

return function (t)
    t = SoundUnit(t)
    t.process = process
    t.max = t.max or 1
    t.min = t.min or -t.max
    return t
end

