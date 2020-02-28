local testFunctions = require("test_a.lua")
local testConfig = require("test_b.lua")

print(testFunctions:RandomThing(0xC0FFEE))
print(testConfig.b)
print(testConfig.test_a:RandomThing(0))