---@class MapVote_Seperator : Panel
local PANEL = {}

function PANEL:Init()
    self.text = ""
    self:SetTall( 22 )
end

function PANEL:SetText( text )
    self.text = text or ""
end

function PANEL:Paint( w, h )
    classicbox.cbdraw.SimpleText( self.text, 0, h / 2, color_white, "CBFont", "CBFont_Shadow", 3, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
end

vgui.Register( "MapVote_Seperator", PANEL, "Panel" )
