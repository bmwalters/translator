function Translator.OpenEditor(project)
	local frame = vgui.Create("DFrame")
	frame:SetSize(600, 400)
	frame:SetTitle("Translate " .. project.name)
	frame:Center()
	frame:MakePopup()

	local left = vgui.Create("DScrollPanel", frame)
	left:SetPos(0, 24)
	left:SetSize(200, 550)

	for i = 1, 10 do
		local panel = vgui.Create("Panel", left)
		panel:SetPos(0, (i - 1) * 60)
		panel:SetSize(200, 60)
		panel.color = ColorRand()
		function panel:Paint(w, h)
			surface.SetDrawColor(self.color)
			surface.DrawRect(0,0,w,h)
		end
	end

	local right = vgui.Create("Panel", frame)
	right:SetPos(200, 24)
	right:SetSize(400, 576)
	function right:Paint(w, h)
		surface.SetDrawColor(color_black)
		surface.DrawRect(0, 0, w, h)
	end
end

concommand.Add("test_openeditor", function()
	Translator.OpenEditor({ name = "Test Project (TTT)", path = "gamemodes/terrortown/gamemode/lang", format = "TTT" })
end)
