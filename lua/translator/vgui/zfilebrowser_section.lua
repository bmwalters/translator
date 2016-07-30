-- Created by Zerf

local function NormalizePath(path)
	return (string.gsub(string.match(path, "^[\\/ \t\n]*(.-)[\\/ \t\n]*$") or path, "[\\/]+", "/"))
end

local PANEL = {}

PANEL.icons = {
	["<directory>"] = Material("icon16/folder.png"),
	["<file>"] = Material("icon16/page_white_text.png"),
	png = Material("icon16/palette.png")
}
PANEL.icons.jpg = PANEL.icons.png
PANEL.icons.jpeg = PANEL.icons.png
PANEL.icons.vtf = PANEL.icons.png

PANEL.LineColor = Color(255, 255, 255)
PANEL.AltLineColor = Color(229, 229, 229)
PANEL.HighlightedLineColor = Color(208, 217, 250)
PANEL.SelectedLineColor = Color(89, 138, 246)

AccessorFunc(PANEL, "_path", "Path")

function PANEL:Init()
	self.files = {}

	self.canvas = vgui.Create("Panel", self)

	self.VBar = vgui.Create("DVScrollBar", self)
	self.VBar:SetZPos(20)
	self.VBar.SetVisible = function() end
end

function PANEL:GetFolder() return self._folder end

function PANEL:SetFolder(path)
	self._folder = path
	self:Update()
end

local function PaintLine(line, w, h)
	surface.SetFont("DermaDefault")

	local color
	if line.selected then
		color = PANEL.SelectedLineColor
	elseif line.highlighted then
		color = PANEL.HighlightedLineColor
	else
		color = (line.altline and PANEL.AltLineColor or PANEL.LineColor)
	end

	surface.SetDrawColor(color)
	surface.DrawRect(0, 0, w, h)

	surface.SetDrawColor(color_white)
	surface.SetMaterial(line.icon)
	surface.DrawTexturedRect(3, (h - 16) / 2, 16, 16)

	local _, th = surface.GetTextSize(line.text)

	surface.SetTextColor(color_black)
	surface.SetTextPos(22, (h - th) / 2)
	surface.DrawText(line.text)
end

function PANEL:Update()
	self.files = {}

	if not self._folder then return end

	local f, d = file.Find(NormalizePath(self._folder .. "/*"), self._path)
	if not f then return end
	table.sort(f)
	table.sort(d)

	local combined = {}
	for _, name in ipairs(d) do
		combined[#combined + 1] = {file = false, name = name}
	end
	for _, name in ipairs(f) do
		combined[#combined + 1] = {file = true, name = name}
	end

	for i, data in ipairs(combined) do
		local panel = vgui.Create("Panel", self.canvas)
		panel:SetPos(0, (i - 1) * 20)
		panel:SetSize(self:GetWide(), 20)

		panel.altline = i % 2 == 0
		panel.text = data.name
		panel.rowindex = i
		panel.isfile = data.file

		if data.file then
			local ext = string.GetExtensionFromFilename(data.name)
			panel.icon = self.icons[ext] or self.icons["<file>"]
		else
			panel.icon = self.icons["<directory>"]
		end

		panel.Paint = PaintLine
		panel.OnMousePressed = function(line) self:LinePressed(line) end
		panel.OnCursorEntered = function(line) line.highlighted = true end
		panel.OnCursorExited = function(line) line.highlighted = false end

		self.files[i] = panel
	end

	self.dirty = true
end

function PANEL:LinePressed(line)
	self:GetParent():GetParent():LinePressed(self, line)
end

function PANEL:PerformLayout()
	local w, h = self:GetSize()

	if IsValid(self.VBar) then
		self.VBar:SetPos(w - 16, 0)
		self.VBar:SetSize(16, h)
		self.VBar:SetUp(self.VBar:GetTall(), self.canvas:GetTall())

		w = w - 16
	end

	self.canvas:SetPos(0, self.VBar:GetOffset())
	self.canvas:SetSize(w, self.canvas:GetTall())

	local dataheight = self:DataLayout()

	if self.dirty then
		self.dirty = false

		self.canvas:SetTall(dataheight)
		self:InvalidateLayout(true)
	end
end

function PANEL:DataLayout()
	local y = 0

	local w = self:GetWide()

	for _, panel in pairs(self.files) do
		panel:SetPos(0, y)
		panel:SetWide(w)
		y = y + panel:GetTall()
	end

	return y
end

function PANEL:Paint(w, h)
	surface.SetDrawColor(color_white)
	surface.DrawRect(0, 0, w, h)
end

function PANEL:OnMouseWheeled(delta)
	self.VBar:OnMouseWheeled(delta)
end

derma.DefineControl("ZFileBrowser_Section", "A file browser section", PANEL, "Panel")
