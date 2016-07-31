Translator.Projects = Translator.Projects or {}

-- FORMAT:Check is used to determine if a given path is of this type
-- FORMAT:Parse is used to convert various language file types into a common format:
-- { langname = { identifier = value, identifier = value }, ... }
-- FORMAT:Dump is used to convert back from the common format to the specific one
Translator.Formats = {}
function Translator.DefineFormat(name, data)
	Translator.Formats[name] = data
end

for _, f in pairs((file.Find("lua/translator/formats/*", "GAME"))) do
	include("formats/" .. f)
	print("Loaded format ", f)
end

function Translator.DetectProjectFormat(path)
	for type, data in pairs(Translator.Formats) do
		if data:Check(path) then
			return type
		end
	end
end

include("vgui/zfilebrowser.lua")
include("cl_list.lua")
include("cl_editor.lua")

concommand.Add("translator", Translator.OpenProjectList, nil, "Opens the main Translator window")

print("Loaded Translator.")
