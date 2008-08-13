require "runlocal"
local Cairo = require "oocairo"

local PI = 2 * math.asin(1)

local IMG_WD, IMG_HT, CIRCLE_LINE_WD = 250, 250, 25
local HATCH_SIZE, HATCH_LINE_WD = 12, 1.5

local function wood_pattern ()
    -- Create a repeating pattern based on a bitmap image.  The whole pattern
    -- is rotated slightly.
    local surface = Cairo.image_surface_create_from_png("examples/images/wood1.png")
    local pattern = Cairo.pattern_create_for_surface(surface)
    pattern:set_extend("repeat")
    local transform = Cairo.matrix_create()
    transform:rotate(0.3)
    pattern:set_matrix(transform)
    return pattern
end

local function cross_hatch_pattern ()
    -- A pattern of diagonal lines crossing over.  As a single image this will
    -- just look like a cross, but repeated will give a cross-hatch effect.
    -- This pattern has a transparent background (the default with 'argb32'
    -- image surfaces), so whatever's behind it will show through between
    -- the lines.
    local sz = HATCH_SIZE
    local surface = Cairo.image_surface_create("argb32", sz, sz)
    local cr = Cairo.context_create(surface)
    cr:move_to(0, 0)
    cr:line_to(sz, sz)
    cr:move_to(sz, 0)
    cr:line_to(0, sz)
    cr:set_line_width(HATCH_LINE_WD)
    cr:set_source_rgb(0, 0, 0)
    cr:stroke()
    return surface
end

local surface = Cairo.image_surface_create("rgb24", IMG_WD, IMG_HT)
local cr = Cairo.context_create(surface)

-- Light blue background.
cr:set_source_rgb(0.9, 0.9, 1)
cr:paint()

-- Set the path to a circle in the middle of the canvas.
cr:arc(IMG_WD / 2, IMG_HT / 2, IMG_WD / 2 - CIRCLE_LINE_WD / 2, 0, 2*PI)
--cr:set_source_rgb(0, 0, 0) cr:fill()

-- Fill in the circle with a pattern of smaller circles.
cr:set_source(wood_pattern(), 0, 0)
cr:fill_preserve()

-- Stroke the outline of the big circle with a cross-hatch pattern.
cr:set_source_surface(cross_hatch_pattern(), 0, 0)
cr:get_source():set_extend("repeat")
cr:set_line_width(CIRCLE_LINE_WD)
cr:stroke()

surface:write_to_png("repeated-pattern.png")

-- vi:ts=4 sw=4 expandtab
