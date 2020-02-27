package.path = "C:\\Users\\User\\Documents\\GitHub\\lua-merge\\LuaSrcDiet\\?.lua;" .. package.path
local Minifier = require("init")

local function findImports(script)
	local imports = {}
	for match in script:gmatch("require%s*%(?%s*['\"][%w_/\\%.]+['\"]%s*%)?") do
		imports[match:match("%(?%s*['\"]([%w_/\\%.]+)['\"]%s*%)?")] = match
	end
	return imports
end

local function replaceImports(script, path)
	for i,v in next, findImports(script) do
		local file = io.open(path .. i)
		local source = replaceImports(file:read("*all"), path)
		file:close()
		source = Minifier.optimize(Minifier.MAXIMUM_OPTS, source):gsub("\t+", " "):gsub("\n+", " ")
		script = script:gsub(v:gsub("([^%w])", "%%%1"), ("(function(...)%s end)(...)"):format(source))
	end
	return script
end

local mainScript, newMain = io.open("test/test.lua", "r"), io.open("output.lua", "w+")
newMain:write(replaceImports(mainScript:read("*all"), "test/"))
mainScript:close()
newMain:close()