-- created by KrakenZ

local PANEL = {}

local DVScrollBar = baseclass.Get("DVScrollBar")

function PANEL:Init()

	self.Offset = 0
	self.Scroll = 0
	self.CanvasSize = 1
	self.BarSize = 1
	self.ScrollForce = 0 -- REMOVE ME

	self.RightButton = self:Add( "DButton" )
	self.RightButton:Dock( RIGHT )
	self.RightButton:SetText( "" )
	self.RightButton.DoClick = function ( self ) self:GetParent():AddScroll( 1 ) end
	self.RightButton.Paint = function( panel, w, h ) derma.SkinHook( "Paint", "ButtonRight", panel, w, h ) end

	self.LeftButton = self:Add( "DButton" )
	self.LeftButton:Dock( LEFT )
	self.LeftButton:SetText( "" )
	self.LeftButton.DoClick = function ( self ) self:GetParent():AddScroll( -1 ) end
	self.LeftButton.Paint = function( panel, w, h ) derma.SkinHook( "Paint", "ButtonLeft", panel, w, h ) end

	self.btnGrip = self:Add( "DScrollBarGrip" )

end

PANEL.SetEnabled = DVScrollBar.SetEnabled
PANEL.BarScale = DVScrollBar.BarScale
PANEL.SetUp = DVScrollBar.SetUp
PANEL.AddScroll = DVScrollBar.AddScroll
PANEL.AnimateTo = DVScrollBar.AnimateTo
PANEL.GetScroll = DVScrollBar.GetScroll
PANEL.GetOffset = DVScrollBar.GetOffset
PANEL.Paint = DVScrollBar.Paint
PANEL.OnMouseReleased = DVScrollBar.OnMouseReleased
PANEL.OnMouseWheeled = DVScrollBar.OnMouseWheeled
PANEL.Think = DVScrollBar.Think
PANEL.AddScrollForce = DVScrollBar.AddScrollForce -- REMOVE ME

function PANEL:SetScroll( scrll )

	if ( !self.Enabled ) then self.Scroll = 0 return end

	self.Scroll = math.Clamp( scrll, 0, self.CanvasSize )
	self:InvalidateLayout()

	local func = self:GetParent().OnHScroll

	if func then
		func( self:GetParent(), self:GetOffset() )
	else
		self:GetParent():InvalidateLayout()
	end

end

function PANEL:Grip()
	self.ScrollForce = nil -- REMOVE ME
	if ( !self.Enabled ) then return end
	if ( self.BarSize == 0 ) then return end

	self:MouseCapture( true )
	self.Dragging = true

	local x, y = self.btnGrip:ScreenToLocal( gui.MouseX(), 0 )
	self.HoldPos = x

	self.btnGrip.Depressed = true

end

function PANEL:OnMousePressed()

	local x, y = self:CursorPos()

	local PageSize = self.BarSize

	if ( x > self.btnGrip.x ) then
		self:SetScroll( self:GetScroll() + PageSize )
	else
		self:SetScroll( self:GetScroll() - PageSize )
	end

end

function PANEL:OnCursorMoved( x, y )

	if ( !self.Enabled ) then return end
	if ( !self.Dragging ) then return end

	local x = gui.MouseX()
	local y = 0
	local x, y = self:ScreenToLocal( x, y )

	-- Uck.
	x = x - self.LeftButton:GetWide()
	x = x - self.HoldPos

	local TrackSize = self:GetWide() - self:GetTall() * 2 - self.btnGrip:GetWide()

	x = x / TrackSize

	self:SetScroll( x * self.CanvasSize )

end

function PANEL:PerformLayout( w, h )

	local Scroll = self:GetScroll() / self.CanvasSize
	local BarSize = math.max( self:BarScale() * (w - (h * 2)), 10 )
	local Track = self:GetWide() - (h * 2) - BarSize
	Track = Track + 1
	Scroll = Scroll * Track

	self.RightButton:SetWide( h )
	self.LeftButton:SetWide( h )

	self.btnGrip:SetPos( h + Scroll, 0 )
	self.btnGrip:SetSize( BarSize, h )

end

derma.DefineControl( "DHScrollBar", "Horizontal scroll bar", PANEL, "Panel" )
