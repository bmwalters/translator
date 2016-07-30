-- Created by Zerf

include("dhscrollbar.lua")
include("zfilebrowser_section.lua")

local function NormalizePath(path)
	local trimmed = string.match(path, "^[\\/ \t\n]*(.-)[\\/ \t\n]*$") or path
	return (string.gsub(trimmed, "[\\/]+", "/"))
end

local function SplitPath(path)
	return string.Split(NormalizePath(path), "/")
end

local PANEL = {}

AccessorFunc(PANEL, "_searchpath", "SearchPath", FORCE_STRING)
AccessorFunc(PANEL, "_selectfolders", "AllowSelectFolders", FORCE_STRING)

function PANEL:GetBaseFolder()
	return self._basefolder
end

function PANEL:SetBaseFolder(str)
	self._basefolder = str
end

function PANEL:Init()
	self.canvas = vgui.Create("Panel", self)

	self.HBar = vgui.Create("DHScrollBar", self)
	self.HBar:SetZPos(20)
	self.HBar.SetVisible = function() end -- TODO

	self.sections = {}

	self:SetAllowSelectFolders(true)
end

function PANEL:AddSection(fullpath)
	local splitpath = SplitPath(fullpath)

	for _, path in ipairs(splitpath) do
		local section = vgui.Create("ZFileBrowser_Section", self.canvas)

		if #self.sections > 0 then
			path = (self.sections[#self.sections]):GetFolder() .. "/" .. path
		else
			path = self._basefolder .. "/" .. path
		end

		section:SetPath(self._searchpath)
		section:SetFolder(path)

		section:SetSize(200, self:GetTall() - self.HBar:GetTall())

		self.sections[#self.sections + 1] = section
		section.index = #self.sections
	end

	self.dirty = true
	self:InvalidateLayout()
end

function PANEL:RemoveSection()
	table.remove(self.sections):Remove()

	self.dirty = true
	self:InvalidateLayout()
end

function PANEL:LinePressed(section, line)
	local diff = #self.sections - section.index

	if diff > 0 then
		for _ = 1, diff do
			self:RemoveSection()
		end
	end

	if not line.isfile then
		self:AddSection(line.text)
	end

	if section.selectedline then
		if section.selectedline == line and (CurTime() < line.lastclick + 0.2) then
			self:LineDoubleClicked(section, line)
		else
			section.selectedline.selected = false
		end
	end

	section.selectedline = line
	line.selected = true
	line.lastclick = CurTime()
end

function PANEL:LineDoubleClicked(section, line)
	if (not line.isfolder) or self._selectfolders then
		self:OnFileSelected(NormalizePath(section:GetFolder() .. "/" .. line.text))
	end
end

PANEL.OnFileSelected = function(self, fullpath) print(fullpath) end -- override me

function PANEL:PerformLayout()
	local w, h = self:GetSize()

	if IsValid(self.HBar) then
		self.HBar:SetPos(0, h - 16)
		self.HBar:SetSize(w, 16)
		self.HBar:SetUp(self.HBar:GetWide(), self.canvas:GetWide())

		h = h - self.HBar:GetTall()
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

	local h = self:GetTall() - self.HBar:GetTall()

	for _, panel in ipairs(self.sections) do
		panel:SetPos(x, 0)
		panel:SetTall(h)
		panel:InvalidateLayout(true)
		x = x + panel:GetWide()
	end

	return x
end

function PANEL:SizeToContents()
	self:SetTall(self.canvas:GetTall())
end

derma.DefineControl("ZFileBrowser", "A better file browser", PANEL, "Panel")
