local mainScript = io.open("test.lua", "r")

local function findImports(script)
	local imports = {}
	for match in script:gmatch("require%s*%(?%s*['\"][%w_/\\%.]+['\"]%s*%)?") do
		imports[match:match("%(?%s*['\"]([%w_/\\%.]+)['\"]%s*%)?")] = match
	end
	return imports
end

local function replaceImports(script)
	local imports = findImports(script)
	for i,v in next, imports do
		local file = io.open(i)
		local source = replaceImports(file:read("*all"))
		file:close()
		script = script:replace(v, ("(function(...) %s end)(...)"):format(source))
	end
	return script
end

local mainScriptSource = mainScript:read("*all")
mainScript:close()

local newMain = io.open("newScript.lua", "w+")
newMain:write(replaceImports(mainScriptSource))
newMain:close()