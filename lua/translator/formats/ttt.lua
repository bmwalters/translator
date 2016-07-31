local FORMAT = {}

function FORMAT:Check(path)
	if not file.IsDir(path, "GAME") then return false end

	local files = file.Find(path .. "/*", "GAME")

	for _, fname in pairs(files) do
		if fname == "chef.lua" then continue end

		local contents = file.Read(path .. "/" .. fname, "GAME")

		return string.match(contents, "local L = LANG.CreateLanguage%(")
	end
end

function FORMAT:Parse(path)
	local files = file.Find(path .. "/*", "GAME")

	local data = {}
		-- temporarily create lang stuff to capture data
		LANG = {
			CreateLanguage = function(name)
			data[name] = {}
			return data[name]
		end
	}

	for _, fname in pairs(files) do
		local contents = file.Read(path .. "/" .. fname, "GAME")

		RunString(contents)
	end

	LANG = nil

	return data
end

function FORMAT:Dump(data)
end

Translator.DefineFormat("TTT", FORMAT)
