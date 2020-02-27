local testFunctions = (function(...)local n={}local function r(n)return n+3735928559 end function n:RandomThing(n)return n+r(n)end return n end)(...)
local testConfig = (function(...)return{CoolOption=7,b=math.random,test_a=(function(...)local n={}local function t(n)return n+3735928559 end function n:RandomThing(n)return n+t(n)end return n end)(...)} end)(...)

print(testFunctions:RandomThing(0xC0FFEE))
print(testConfig.b)
print(testConfig.test_a:RandomThing(0))