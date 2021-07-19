---@meta

---
---Core functionality to render or draw elements into the screen.
---@class renderer
renderer = {}

---
---Represents a color used by the rendering functions.
---@class renderer.color
---@field public r number Red
---@field public g number Green
---@field public b number Blue
---@field public a number Alpha
renderer.color = {}

---
---Represent options that affect a font's rendering.
---@class renderer.fontoptions
---@field public antialiasing "'grayscale'" | "'subpixel'"
---@field public hinting "'slight'" | "'none'" | '"full"'
renderer.fontoptions = {}

---
---@class renderer.font
renderer.font = {}

---
---Create a new font object.
---
---@param path string
---@param size number
---@param options renderer.fontoptions
---
---@return renderer.font
function renderer.font.load(path, size, options) end

---
---Clones a font object into a new one.
---
---@param size? number Optional new size for cloned font.
---
---@return renderer.font
function renderer.font:copy(size) end

---
---Set the amount of characters that represent a tab.
---
---@param chars integer Also known as tab width.
function renderer.font:set_tab_size(chars) end

---
---Get the width in pixels of the given text when
---rendered with this font.
---
---@param text string
---
---@return number
function renderer.font:get_width(text) end

---
---Get the width in subpixels of the given text when
---rendered with this font.
---
---@param text string
---
---@return number
function renderer.font:get_width_subpixel(text) end

---
---Get the height in pixels that occupies a single character
---when rendered with this font.
---
---@return number
function renderer.font:get_height() end

---
---Gets the font subpixel scale.
---
---@return number
function renderer.font:subpixel_scale() end

---
---Get the current size of the font.
---
---@return number
function renderer.font:get_size() end

---
---Set a new size for the font.
---
---@param size number
function renderer.font:set_size(size) end

---
---Assistive functionality to replace characters in a
---rendered text with other characters.
---@class renderer.replacements
renderer.replacements = {}

---
---Create a new character replacements object.
---
---@return renderer.replacements
function renderer.replacements.new() end

---
---Add to internal map a character to character replacement.
---
---@param original_char string Should be a single character like '\t'
---@param replacement_char string Should be a single character like '»'
function renderer.replacements:add(original_char, replacement_char) end

---
---Toggles drawing debugging rectangles on the currently rendered sections
---of the window to help troubleshoot the renderer.
---
---@param enable boolean
function renderer.show_debug(enable) end

---
---Get the size of the screen area been rendered.
---
---@return number width
---@return number height
function renderer.get_size() end

---
---Tell the rendering system that we want to build a new frame to render.
function renderer.begin_frame() end

---
---Tell the rendering system that we finished building the frame.
function renderer.end_frame() end

---
---Set the region of the screen where draw operations will take effect.
---
---@param x number
---@param y number
---@param width number
---@param height number
function renderer.set_clip_rect(x, y, width, height) end

---
---Draw a rectangle.
---
---@param x number
---@param y number
---@param width number
---@param height number
---@param color renderer.color
function renderer.draw_rect(x, y, width, height, color) end

---
---Draw text.
---
---@param font renderer.font
---@param text string
---@param x number
---@param y number
---@param color renderer.color
---@param replace renderer.replacements
---@param color_replace renderer.color
---
---@return number x_subpixel
function renderer.draw_text(font, text, x, y, color, replace, color_replace) end

---
---Draw text at subpixel level.
---
---@param font renderer.font
---@param text string
---@param x number
---@param y number
---@param color renderer.color
---@param replace renderer.replacements
---@param color_replace renderer.color
---
---@return number x_subpixel
function renderer.draw_text_subpixel(font, text, x, y, color, replace, color_replace) end
