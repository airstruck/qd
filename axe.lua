local REL = (...):gsub('[^.]*$', '')

local SoundUnit = require (REL .. 'soundunit')
local Osc = require (REL .. 'osc')
local Util = require (REL .. 'util')
local Sin = require (REL .. 'sin')

local nullOsc = Osc { freq = 0 }

local function updateGate (dt, data)
    if data.gate then
        data.onTime = data.onTime + dt
    else
        data.offTime = data.offTime + dt
    end
end

local function openGate (dt, args)
    args.osc.freq = Util.semitoneToFreq(args.semi + args.n)
    args.data.gate = true
    args.data.onTime = 0
    args.data.n = args.n
end

local function closeGate (dt, args)
    args.data.gate = false
    args.data.offTime = 0
end

local function plan (t, clock, seq, rate, offset)
    local timestep = 1 / rate
    for line in seq:gmatch('[^\n]+') do
        local s, e, note, pattern = line:find('([^|]-)%s*|(.+)|')
        if note and pattern then
            local semi = Util.noteToSemitone(note)
            local data = t.dataBySemitone[semi]
            local osc = t.oscsBySemitone[semi]
            local effect = t.effectBySemitone[semi]
            if not osc then
                data = {
                    clock = clock,
                    gate = false,
                    onTime = math.huge,
                    offTime = math.huge,
                }
                osc = Osc()
                effect = t.effect(data, t.context)
                t.dataBySemitone[semi] = data
                t.oscsBySemitone[semi] = osc
                t.effectBySemitone[semi] = effect
                if t.oscs == nullOsc then
                    t.oscs = osc .. effect
                else
                    t.oscs = t.oscs + (osc .. effect)
                end
                clock:always(updateGate, data)
            end
            local time = offset or 0
            for char in pattern:gmatch('.') do
                local n = tonumber(char, 36)
                if n then
                    clock:atSecond(time, openGate, {
                        data = data,
                        semi = semi,
                        osc = osc,
                        n = n,
                    })
                elseif char == '.' then
                    clock:atSecond(time, closeGate, {
                        data = data,
                        semi = semi,
                        osc = osc,
                    })
                elseif char == '|' then
                    time = time - timestep
                end
                time = time + timestep
            end
        end
    end
end

local function process (t, left, right)
    return t.oscs:process(left, right)
end

return function (t)
    t = SoundUnit(t)
    t.process = t.process or process
    t.plan = t.plan or plan
    t.effect = t.effect or Sin
    t.context = t.context or {}
    t.dataBySemitone = {}
    t.oscsBySemitone = {}
    t.effectBySemitone = {}
    t.oscs = nullOsc
    
    return t
end

