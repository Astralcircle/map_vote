---@class MapVote_Frame : CBFrame
local PANEL = {}

function surface.DrawTexturedRectRotatedPoint( x, y, w, h, rot, x0, y0 )
    local c = math.cos( math.rad( rot ) )
    local s = math.sin( math.rad( rot ) )

    local newx = y0 * s - x0 * c
    local newy = y0 * c + x0 * s

    surface.DrawTexturedRectRotated( x + newx, y + newy, w, h, rot )
end

function PANEL:SetHideOnClose( hide )
    self.hideOnClose = hide
end

function PANEL:Init()
    self.btnClose.DoClick = function()
        if self.hideOnClose then
            self:SetVisible( false )
            return
        end

        self:Close()
    end
end

local basePanel = baseclass.Get( "Panel" )

function PANEL:SetVisible( v )
    self:OnVisibilityChanged( v )
    return basePanel.SetVisible( self, v )
end

function PANEL:OnVisibilityChanged( _ ) end

vgui.Register( "MapVote_Frame", PANEL, "CBFrame" )
