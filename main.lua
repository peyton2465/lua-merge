local mainScript = io.open("test.lua", "r")
local testScript = [===[
	local te, st = require("test.lua")
	memes = require("lol.lua")

]===]


local function findImports(script)
	local imports = {}
	for match in script:gmatch("l?o?c?a?l?%s*.-%s*=?%s*require%s*%(?%s*['\"][%w_/\\%.]+['\"]%s*%)?\n") do
		local import = {}
		import.IsLocal = match:match("local%s*") ~= nil
		import.Name = match:match("l?o?c?a?l?%s*([%w_]+)%s*=") or #imports + 1
		import.SourcePath = match:match("require%s*%(?%s*['\"]([%w_/\\%.]+)['\"]%s*%)?")
		table.insert(imports, import)
	end
	return imports
end

local imports = findImports(mainScript:read("*all"))
mainScript:close()

for i,v in next, imports do
	for l,k in next, v do
		print(l,k)
  	end
end

local newMain = io.open("newScript.lua", "r")
-- write contents to new script