function Translator.OpenEditor(project)
	local frame = vgui.Create("DFrame")
	frame:SetSize(600, 400)
	frame:SetTitle("Translate " .. project.name)
	frame:Center()
	frame:MakePopup()

	local left = vgui.Create("Panel", frame)
	left:SetPos(0, 24)
	left:SetSize(200, 576)
	function left:Paint(w, h)
		surface.SetDrawColor(color_white)
		surface.DrawRect(0, 0, w, h)
	end

	local right = vgui.Create("Panel", frame)
	right:SetPos(200, 24)
	right:SetSize(400, 576)
	function right:Paint(w, h)
		surface.SetDrawColor(color_black)
		surface.DrawRect(0, 0, w, h)
	end
end
