local testFunctions = (function(...) local tests = {}  local function getNumber(number)     return number + 0xDEADBEEF end  function tests:RandomThing(number)     return number + getNumber(number) end  return tests end)(...)
local testConfig = (function(...) return {     CoolOption = 7,     b = math.random,     test_a = (function(...) local tests = {}  local function getNumber(number)     return number + 0xDEADBEEF end  function tests:RandomThing(number)     return number + getNumber(number) end  return tests end)(...) } end)(...)

print(testFunctions:RandomThing(0xC0FFEE))
print(testConfig.b)
print(testConfig.test_a:RandomThing(0))