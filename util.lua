-- http://www.phy.mtu.edu/~suits/NoteFreqCalcs.html

local f0 = 440
local a = 2 ^ (1 / 12)

local function semitoneToFreq (n)
    return f0 * a ^ n
end

local function noteToSemitone (note)
    local tone, semi, oct = note:match('^(.)(.)(.?)')
    oct = tonumber(oct == '' and semi or oct)
    semi = semi:find('[b-]') and -1 or semi:find('[#+]') and 1 or 0
    return (('C_D_EF_G_A_B'):find(tone:upper()) - 10 + semi) + 12 * (oct - 4)
end

local noteToFreqCache = {}

local function noteToFreq (note)
    if not noteToFreqCache[note] then
        noteToFreqCache[note] = semitoneToFreq(noteToSemitone(note))
    end
    return noteToFreqCache[note]
end

return {
    semitoneToFreq = semitoneToFreq,
    noteToSemitone = noteToSemitone,
    noteToFreq = noteToFreq,
}

