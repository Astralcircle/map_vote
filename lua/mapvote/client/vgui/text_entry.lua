local PANEL = {}

function PANEL:Init()
    self.textEntry = vgui.Create( "DTextEntry", self ) --[[@as DTextEntry]]
    self.textEntry:Dock( FILL )
    self.textEntry:SetFont( "DermaDefaultBold" )
    ---@diagnostic disable-next-line: duplicate-set-field
    self.textEntry.OnChange = function()
        self:OnValueChanged( self.textEntry:GetValue() )
    end
end

function PANEL:SetPlaceholderText( text )
    self.textEntry:SetPlaceholderText( text )
end

function PANEL:SetEnabled( enabled )
    self.textEntry:SetEnabled( enabled )
end

function PANEL:SetValue( val )
    self.textEntry:SetValue( val )
end

function PANEL:OnValueChanged( _ )
end

vgui.Register( "MapVote_TextEntry", PANEL, "Panel" )
