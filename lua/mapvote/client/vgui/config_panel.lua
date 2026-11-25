---@class ConfigPanel : CBScrollPanel
local PANEL = {}

function PANEL:Init()
    self.largestLabelWidth = 0
end

function PANEL:Paint( w, h )
    draw.RoundedBox( 10, 0, 0, w, h, MapVote.style.colorPrimaryBG )
end

function PANEL:AddConfigPanel( displayName, panel )
    local row = self:configRow( displayName )
    panel:SetParent( row )
    self:AddItem( row )
end

function PANEL:configRow( displayName )
    local w = self:GetWide()
    local optionPanel = vgui.Create( "CBPanel", self ) --[[@as Panel]]
    optionPanel:SetHovering( true )
    optionPanel:SetChildHover( true )
    optionPanel:SetSize( w, 35 )
    optionPanel:Dock( TOP )
    optionPanel:DockMargin( 0, 0, 0, 2 )

    local label = vgui.Create( "CBLabel", optionPanel ) --[[@as DLabel]]
    label:SetText( displayName )
    label:DockMargin( 5, 0, 0, 0 )
    label:Dock( LEFT )
    label:SetFont( "MapVote_ConfigItem" )
    label:SizeToContents()
    self.largestLabelWidth = math.max( self.largestLabelWidth, label:GetWide() )
    optionPanel.label = label
    return optionPanel
end

function PANEL:PerformLayout()
    for _, child in pairs( self:GetCanvas():GetChildren() ) do
        if child.label then
            child.label:SetWide( self.largestLabelWidth + 50 )
        end
    end
end

surface.CreateFont( "MapVote_ConfigItem", {
    font = "Tahoma",
    extended = true,
    size = 13,
    weight = 800,
    antialias = true,
    shadow = true
} )

function PANEL:AddSeperator( text )
    local seperator = vgui.Create( "MapVote_Seperator", self )
    seperator:SetText( text )
    seperator:Dock( TOP )
    seperator:DockMargin( 5, 5, 5, 5 )
    self:AddItem( seperator )
end

---@param displayName string
---@param itemType SchemaType
function PANEL:AddConfigItem( displayName, itemType, action, startingValue )
    local optionPanel = self:configRow( displayName )
    if itemType.name == "optional" then
        -- TODO handle this
        ---@cast itemType SchemaTypeWithSubType
        itemType = itemType.type
    end

    local errLabel
    local entryPanel
    if itemType.name == "int" then
        itemType = itemType --[[@as SchemaTypeNumber]]

        entryPanel = vgui.Create( "MapVote_NumberWang", optionPanel ) --[[@as DNumberWang]]
        entryPanel:SetSize( 100, 25 )
        entryPanel:SetMax( itemType.max or 1e10 )
        entryPanel:SetMin( itemType.min or -1e10 )
        entryPanel:SetValue( startingValue )
        ---@diagnostic disable-next-line: duplicate-set-field
        entryPanel.OnValueChanged = function( _, val )
            local ok, err = itemType:Validate( val )
            errLabel:SetText( err or "" )
            errLabel:Dock( LEFT )
            if ok then
                action( val )
            end
        end
    elseif itemType.name == "bool" then
        entryPanel = vgui.Create( "DCheckBox", optionPanel )
        entryPanel:SetSize( 15, 15 )
        entryPanel:SetValue( startingValue or false )
        ---@diagnostic disable-next-line: duplicate-set-field
        entryPanel.OnChange = function( _, val )
            local ok, err = itemType:Validate( val )
            errLabel:SetText( err or "" )
            errLabel:Dock( LEFT )
            if ok then
                action( val )
            end
        end
    elseif itemType.name == "number" then
        itemType = itemType --[[@as SchemaTypeNumber]]

        entryPanel = vgui.Create( "MapVote_NumberWang", optionPanel ) --[[@as DNumberWang]]
        entryPanel:SetMax( itemType.max or 1e10 )
        entryPanel:SetMin( itemType.min or -1e10 )
        entryPanel:SetValue( startingValue or 0 )
        ---@diagnostic disable-next-line: duplicate-set-field
        entryPanel.OnValueChanged = function( _, val )
            local ok, err = itemType:Validate( val )
            errLabel:SetText( err or "" )
            errLabel:Dock( LEFT )
            if ok then
                action( val )
            end
        end
        entryPanel:SetSize( 100, 25 )
    elseif itemType.name == "string" then
        entryPanel = vgui.Create( "MapVote_TextEntry", optionPanel ) --[[@as DTextEntry]]
        entryPanel:SetSize( 300, 25 )
        entryPanel:SetValue( startingValue or "" )

        ---@diagnostic disable-next-line: duplicate-set-field
        entryPanel.OnValueChanged = function( _, val )
            local ok, err = itemType:Validate( val )
            errLabel:SetText( err or "" )
            errLabel:Dock( LEFT )
            if ok then
                action( val )
            end
        end
    elseif itemType.name == "list" then
        if startingValue then
            startingValue = table.concat( startingValue, ", " )
        end
        entryPanel = vgui.Create( "MapVote_TextEntry", optionPanel ) --[[@as DTextEntry]]
        entryPanel:SetSize( 100, 25 )
        entryPanel:SetValue( startingValue or "" )
        entryPanel:SetEnabled( true )
        entryPanel.OnValueChanged = function( _, val )
            val = string.Split( val, "," )
            for i = #val, 1, -1 do
                val[i] = string.Trim( val[i] )
                if val[i] == "" then
                    table.remove( val, i )
                end
            end
            local ok, err = itemType:Validate( val )
            errLabel:SetText( err or "" )
            errLabel:Dock( LEFT )
            if ok then
                action( val )
            end
        end
    else
        error( "Unknown type " .. itemType.name )
    end
    entryPanel:Dock( LEFT )
    if itemType.name == "bool" then
        entryPanel:DockMargin( 0, 10, 0, 10 )
    else
        entryPanel:DockMargin( 0, 5, 0, 5 )
    end

    errLabel = vgui.Create( "CBLabel", optionPanel ) --[[@as DLabel]]
    errLabel:SetText( "" )
    errLabel:Dock( LEFT )
    errLabel:SetSize( 500, 25 )
    errLabel:SetColor( MapVote.style.colorRed )

    if not entryPanel then
        error( "Unknown type " .. itemType.name )
    end
    self:AddItem( optionPanel )
end

vgui.Register( "MapVote_ConfigPanel", PANEL, "CBScrollPanel" )
