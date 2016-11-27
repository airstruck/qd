-- Wrap (modular) clipping

local SoundUnit = require((...):gsub('[^.]*$', '') .. 'soundunit')

local function process (t, v)
    return (((v * 0.5 + 0.5) % 1) - 0.5) * 2
end

return function (t)
    t = SoundUnit(t)
    t.process = process
    return t
end

