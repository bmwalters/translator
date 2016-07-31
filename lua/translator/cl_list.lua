local function OpenProjectFileBrowser(callback)
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

function Translator.OpenProjectList()
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
	list:Dock(FILL)

	for _, project in ipairs(Translator.Projects) do
		list:AddLine(project.name, project.path, project.format).project = project
	end

	function list:DoDoubleClick(_, line)
		Translator.OpenEditor(line.project)
		frame:Remove()
	end

	local add = vgui.Create("DButton", frame)
	add:SetTall(30)
	add:Dock(BOTTOM)
	add:SetText("Add Project")

	function add:DoClick()
		Derma_StringRequest("Project Name", "Enter a name for the project.", "", function(projectname)
			OpenProjectFileBrowser(function(path)
				local format = Translator.DetectProjectFormat(path)
				if not format then print("No format found for given path.") return end

				local project = {name = projectname, path = path, format = format}
				Translator.Projects[#Translator.Projects + 1] = project
				list:AddLine(projectname, path, format).project = project
			end)
		end)
	end
end
