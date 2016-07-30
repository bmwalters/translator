include("vgui/zfilebrowser.lua")

print("Loaded Translator.")

local function OpenProjectBrowser(callback)
	local frame = vgui.Create("DFrame")
	frame:SetSize(500, 250)
	frame:SetSizable(true)
	frame:Center()
	frame:SetDeleteOnClose(true)
	frame:SetTitle("Open Project")
	frame:MakePopup()

	local filebrowser = vgui.Create("ZFileBrowser", frame)
	filebrowser:Dock(FILL)
	filebrowser:SetSearchPath("GAME")
	filebrowser:SetBaseFolder("/")
	filebrowser:AddSection("/")

	function filebrowser:OnFileSelected(path)
		callback(path)
		frame:Close()
	end
end

function OpenMain()
	local frame = vgui.Create("DFrame")
	frame:SetTitle("Translator")
	frame:SetMinWidth(160 + 210 + 120)
	frame:SetMinHeight(170)
	frame:SetSize(520, 300)
	frame:SetSizable(true)
	frame:Center()
	frame:MakePopup()

	local list = vgui.Create("DListView", frame)
	list:SetMultiSelect(false)
	list:AddColumn("Project"):SetMinWidth(160)
	list:AddColumn("Location"):SetMinWidth(210)
	list:AddColumn("Type"):SetMinWidth(120)
	for _ = 1, 2 do
		list:AddLine("Trouble in Terrorist Town", "/gamemodes/terrortown/gamemode/lang", "Aletheia Form")
	end
	list:Dock(FILL)

	local add = vgui.Create("DButton", frame)
	add:SetTall(30)
	add:Dock(BOTTOM)
	add:SetText("Add Project")

	function add:DoClick()
		OpenProjectBrowser(function(path)
			print(path)
		end)
	end
end
