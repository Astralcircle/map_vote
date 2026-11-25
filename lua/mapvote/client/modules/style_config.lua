MapVote.style = {
    colorPrimaryBG = Color( 44, 44, 44, 255 ),
    colorSecondaryBG = Color( 66, 66, 66 ),
    colorSecondaryFG = Color( 88, 88, 88 ),

    colorTextSecondary = Color( 200, 200, 200 ),
    colorTextPrimary = Color( 255, 255, 255 ),
    colorTextShadow = Color( 0, 0, 0, 200 ),
    colorSelected = Color( 103, 103, 103 ),

    colorRed = Color( 220, 90, 90 ),
    colorYellow = Color( 249, 226, 175 ),
    colorGreen = Color( 96, 170, 96 ),
    colorPurple = Color( 255, 255, 255 ),
    colorCloseButton = Color( 240, 62, 92 ),
    frameBackgroundBlur = 0,
    frameBlur = 0, -- if using a non transparent color this should always be 0
    frameCornerRadius = 5,
    configLabelFont = "MapVote_ConfigNameLabel",
    mapVoteTitleFont = "MapVote_Title",
    colorHovered = Color( 103, 103, 103 ),

    -- should the avatar icons fill bottom up
    bottomUpIconFilling = true,
}

-- fonts
surface.CreateFont( "MapVote_ConfigNameLabel", {
    font = "Tahoma", --  Use the font-name which is shown to you by your operating system Font Viewer, not the file name
    extended = true,
    size = 13,
    weight = 800,
    blursize = 0,
    scanlines = 0,
    antialias = true,
    underline = false,
    italic = false,
    strikeout = false,
    symbol = false,
    rotary = false,
    shadow = true,
    additive = false,
    outline = false,
} )

-- fonts
surface.CreateFont( "MapVote_Title", {
    font = "Tahoma", --  Use the font-name which is shown to you by your operating system Font Viewer, not the file name
    extended = true,
    size = 28,
    weight = 800,
    blursize = 0,
    scanlines = 0,
    antialias = true,
    underline = false,
    italic = false,
    strikeout = false,
    symbol = false,
    rotary = false,
    shadow = true,
    additive = false,
    outline = false,
} )
