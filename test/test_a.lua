local tests = {}

local function getNumber(number)
    return number + 0xDEADBEEF
end

function tests:RandomThing(number)
    return number + getNumber(number)
end

return tests