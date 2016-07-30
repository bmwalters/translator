-- Created by Zerf

include("dhscrollbar.lua")

local PANEL = {}

function PANEL:Init()
	self.canvas = vgui.Create("Panel", self)

	self.HBar = vgui.Create("DHScrollBar", self)
	self.HBar:SetZPos(20)

	self.sections = {}

	for _ = 1, 10 do
		self:AddSection()
	end

	print(#self.sections)
end

function PANEL:AddSection()
	local panel = vgui.Create("Panel", self.canvas)
	panel.color = ColorRand()
	function panel:Paint(w, h)
		surface.SetDrawColor(self.color)
		surface.DrawRect(0, 0, w, h)
	end
	panel:SetSize(math.random(50, 200), self:GetTall())

	self.sections[#self.sections + 1] = panel
	self.dirty = true
	self:InvalidateLayout()
end

function PANEL:PerformLayout()
	local w, h = self:GetSize()

	if IsValid(self.HBar) then
		self.HBar:SetPos(0, h - 16)
		self.HBar:SetSize(w, 16)
		self.HBar:SetUp(self.HBar:GetWide(), self.canvas:GetWide())

		h = h - 16
	end

	self.canvas:SetPos(self.HBar:GetOffset(), 0)
	self.canvas:SetSize(self.canvas:GetWide(), h)

	local datawidth = self:DataLayout()

	if self.dirty then
		self.dirty = false

		self.canvas:SetWide(datawidth)
		self:InvalidateLayout(true)
	end
end

function PANEL:DataLayout()
	local x = 0

	local h = self:GetTall()

	for _, panel in ipairs(self.sections) do
		panel:SetPos(x, 0)
		panel:SetSize(panel:GetWide(), h)
		x = x + panel:GetWide()
	end

	return x
end

function PANEL:SizeToContents()
	self:SetTall(self.canvas:GetTall())
end

function PANEL:OnMouseWheeled(delta)
	return self.HBar:OnMouseWheeled(delta)
end

derma.DefineControl("ZFileBrowser", "A better file browser", PANEL, "Panel")
