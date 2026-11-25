local PANEL = {}

function PANEL:Init()
    self.numberWang = vgui.Create( "DNumberWang", self ) --[[@as DNumberWang]]
    self.numberWang:SetTextColor( MapVote.style.colorTextPrimary )
    self.numberWang:SetCursorColor( MapVote.style.colorTextPrimary )
    self.numberWang:Dock( FILL )
    self.numberWang.m_bBackground = false
    self.numberWang:SetFont( "DermaDefaultBold" )

    ---@diagnostic disable-next-line: duplicate-set-field
    self.numberWang.OnValueChanged = function( _, val )
        self:OnValueChanged( val )
    end
end

function PANEL:Paint( w, h )
    surface.SetDrawColor( MapVote.style.colorPrimaryBG )
    surface.DrawRect( 0, 0, w, h )
    surface.SetDrawColor( 0, 0, 0, 255 )
    surface.DrawOutlinedRect( 0, 0, w, h, 1 )
end

function PANEL:SetMin( val )
    self.numberWang:SetMin( val )
end

function PANEL:SetMax( val )
    self.numberWang:SetMax( val )
end

function PANEL:SetValue( val )
    self.numberWang:SetValue( val )
end

function PANEL:OnValueChanged( _ )
end

vgui.Register( "MapVote_NumberWang", PANEL, "DPanel" )
