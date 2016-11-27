local Qd = {
    SoundUnit = require((...) .. '.soundunit'),
    
    Axe = require((...) .. '.axe'),
    Clamp = require((...) .. '.clamp'),
    Clock = require((...) .. '.clock'),
    Delay = require((...) .. '.delay'),
    Env = require((...) .. '.env'),
    Fold = require((...) .. '.fold'),
    Kit = require((...) .. '.kit'),
    Osc = require((...) .. '.osc'),
    Pulse = require((...) .. '.pulse'),
    Saw = require((...) .. '.saw'),
    Sin = require((...) .. '.sin'),
    Soft = require((...) .. '.soft'),
    Track = require((...) .. '.track'),
    Tri = require((...) .. '.tri'),
    Tube = require((...) .. '.tube'),
    Wrap = require((...) .. '.wrap'),
}

for k, v in pairs(require((...) .. '.util')) do
    Qd[k] = v
end

return Qd

