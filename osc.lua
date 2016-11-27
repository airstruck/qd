-- Osc

local SoundUnit = require((...):gsub('[^.]*$', '') .. 'soundunit')

local function process (t, time)
    if time ~= t.lastTime then
        local dt = time - t.lastTime
        t.value = (t.value + t.freq * 2 * dt) % 2
        t.lastTime = time
    end
    return t.value - 1
end

return function (t)
    t = SoundUnit(t)
    t.process = process
    t.value = t.value or 1
    t.freq = t.freq or 440
    t.lastTime = 0
    return t
end

