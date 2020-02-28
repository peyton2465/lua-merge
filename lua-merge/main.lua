package.path = "LuaSrcDiet\\?.lua;" .. package.path
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
		print("Merging: " .. path .. i)
		source = Minifier.optimize(Minifier.MAXIMUM_OPTS, source):gsub("\t+", " "):gsub("\n+", " ")
		script = script:gsub(v:gsub("([^%w])", "%%%1"), ("(function(...)%s end)(...)"):format(source))
	end
	return script
end

local args = {...}
local path = assert(args[1], "Invalid Path (arg 1)")
local main = args[2] or "main.lua"
local minify = (args[3] and args[3] == "true") or false
local outputPath = path .. "merged.lua"

print(string.format("Merging Project: %s", path .. main))
local mainScript, newScript = io.open(path .. main, "r"), io.open(outputPath, "w+")
local output = mainScript:read("*all")
mainScript:close()
if minify then
	output = Minifier.optimize(Minifier.MAXIMUM_OPTS, output)
end
output = replaceImports(output, path)
newScript:write(output)
newScript:close()
print("Merge Complete: " .. outputPath)