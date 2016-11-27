local meta = {}

local function SoundUnit (t)
    t = setmetatable(t or {}, meta)
    t.isSoundUnit = true
    return t
end

function meta.__call (t, left, right)
    local l, r = t:process(left, right)
    return l, r or right and t:process(right) or l
end

local function META_OP (op, symbol)
    (loadstring or load)(
        ([[
        local SoundUnit, meta = ...
        
        local function #op_callable (t, left, right)
            local l1, r1 = t[1](left, right)
            local l2, r2 = t[2](left, right)
            return l1 #symbol l2, (r1 or l1) #symbol (r2 or l2)
        end
        
        local function #op_after_table (t, left, right)
            local l1, r1 = t[1][1], t[1][2]
            local l2, r2 = t[2](left, right)
            return l1 #symbol l2, (r1 or l1) #symbol r2
        end

        local function #op_before_table (t, left, right)
            local l1, r1 = t[1](left, right)
            local l2, r2 = t[2][1], t[2][2]
            return l1 #symbol l2, r1 #symbol (r2 or l2)
        end
        
        local function #op_after_number (t, left, right)
            local l1 = t[1]
            local l2, r2 = t[2](left, right)
            return l1 #symbol l2, l1 #symbol r2
        end

        local function #op_before_number (t, left, right)
            local l1, r1 = t[1](left, right)
            local l2 = t[2]
            return l1 #symbol l2, r1 #symbol l2
        end

        local function #op (t)
            t = SoundUnit(t)
            t.name = '#op operator'
            local a, b = t[1], t[2]
            local typeA, typeB = type(a), type(b)
            t.process = typeA == 'number' and #op_after_number
                or typeB == 'number' and #op_before_number
                or typeA == 'function' or typeB == 'function'
                or (a.isSoundUnit and b.isSoundUnit) and #op_callable
                or a.isSoundUnit and #op_before_table
                or b.isSoundUnit and #op_after_table
            return t
        end

        function meta.__#op (a, b)
            return #op { a, b }
        end
        ]]):gsub('#op', op):gsub('#symbol', symbol)
    )(SoundUnit, meta)
end

META_OP('add', '+')
META_OP('sub', '-')
META_OP('mul', '*')
META_OP('div', '/')
META_OP('mod', '%%')
META_OP('pow', '^')

local function concat_process (t, left, right)
    local l1, r1 = t[1](left, right)
    local l2, r2 = t[2](l1, r1)
    return l2, r2
end

local function concat (t)
    t = SoundUnit(t)
    t.name = 'concat operator'
    t.process = concat_process
    return t
end

function meta.__concat (a, b)
    return concat { a, b }
end

return SoundUnit

