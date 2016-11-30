-- Timer

local SoundUnit = require((...):gsub('[^.]*$', '') .. 'soundunit')

local function always (t, f, arg)
    local i = #t.schedule.always + 1
    t.schedule.always[i] = f
    t.schedule.always.arg[i] = arg
end

local function atSample (t, index, f, arg)
    local funcs = t.schedule.sample[index] or { arg = {} }
    local i = #funcs + 1
    funcs[i] = f
    funcs.arg[i] = arg
    t.schedule.sample[index] = funcs
end

local function atSecond (t, time, f, arg)
    return t:atSample(math.floor(time * t.rate) * t.channels, f, arg)
end

local function process (t, v)
    return t.time
end

local function reflect (t)
    return t.seconds * t.rate, t.rate, t.bits, t.channels
end

local function reset (t)
    t.sample = -t.channels
    t.time = 0
end

local function tick (t)
    local lastTime = t.time
    t.sample = t.sample + t.channels
    t.time = t.sample * t.timeFactor
    local dt = t.time - lastTime
    for i = 1, #t.schedule.always do
        local f = t.schedule.always[i]
        local arg = t.schedule.always.arg[i]
        f(dt, arg)
    end
    local funcs = t.schedule.sample[t.sample]
    if funcs then for i = 1, #funcs do funcs[i](dt, funcs.arg[i]) end end
    if t.time < t.seconds then return true end 
end

return function (t)
    t = SoundUnit(t)
    t.always = t.always or always
    t.atSample = t.atSample or atSample
    t.atSecond = t.atSecond or atSecond
    t.process = t.process or process
    t.reflect = t.reflect or reflect
    t.reset = t.reset or reset
    t.tick = t.tick or tick
    t.seconds = t.seconds or 30
    t.rate = t.rate or 0x4000
    t.bits = t.bits or 16
    t.channels = t.channels or 2
    t.timeFactor = 1 / t.rate / t.channels
    t.sample = -t.channels
    t.time = 0
    t.schedule = {
        always = { arg = {} },
        sample = {},
    }
    return t
end

