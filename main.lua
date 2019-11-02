local function findImports(script)
	local imports = {}
	for match in script:gmatch("require%s*%(?%s*['\"][%w_/\\%.]+['\"]%s*%)?") do
		imports[match:match("%(?%s*['\"]([%w_/\\%.]+)['\"]%s*%)?")] = match
	end
	return imports
end

local function replaceImports(script)
	for i,v in next, findImports(script) do
		local file = io.open(i)
		local source = replaceImports(file:read("*all")):gsub("\t+", " "):gsub("\n+", " ")
		file:close()
		script = script:gsub(v:gsub("([^%w])", "%%%1"), ("(function(...) %s end)(...)"):format(source))
	end
	return script
end

local mainScript, newMain = io.open("main.lua", "r"), io.open("newScript.lua", "w+")
newMain:write(replaceImports(mainScript:read("*all")))
mainScript:close()
newMain:close()