-- Delay

local SoundUnit = require((...):gsub('[^.]*$', '') .. 'soundunit')

local function process (t, left, right)
    local i = (t.index % t.len) + 1
    t.index = t.index + 1
    if t.leftSamples[i] then
        left = left * t.dry + t.leftSamples[i] * t.wet
        right = right * t.dry + t.rightSamples[i] * t.wet
    else
        left = left * t.dry
        right = right * t.dry
    end
    t.leftSamples[i] = t.echo and right or left
    t.rightSamples[i] = t.echo and left or right
    return left, right
end

return function (t)
    t = SoundUnit(t)
    t.process = process
    t.leftSamples = {}
    t.rightSamples = {}
    t.index = 0
    t.dry = t.dry or 1
    t.wet = t.wet or 0.5
    t.len = t.len or 11025
    return t
end

