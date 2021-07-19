---@meta

---
---Utilites for managing current window, files and more.
---@class system
system = {}

---@alias system.fileinfotype
---|>'"file"'  # It is a file.
---| '"dir"'   # It is a directory.

---
---@class system.fileinfo
---@field public modified number A timestamp in seconds.
---@field public size number Size in bytes.
---@field public type system.fileinfotype Type of file
system.fileinfo = {}

---
---Core function used to retrieve the current event been triggered by SDL.
---
---The following is a list of event types emitted by this function and
---the arguments for each of them if applicable.
---
---Window events:
--- * "quit"
--- * "resized" -> width, height
--- * "exposed"
--- * "minimized"
--- * "maximized"
--- * "restored"
--- * "focuslost"
---
---File events:
--- * "filedropped" -> filename, x, y
---
---Keyboard events:
--- * "keypressed" -> key_name
--- * "keyreleased" -> key_name
--- * "textinput" -> text
---
---Mouse events:
--- * "mousepressed" -> button_name, x, y, amount_of_clicks
--- * "mousereleased" -> button_name, x, y
--- * "mousemoved" -> x, y, relative_x, relative_y
--- * "mousewheel" -> y
---
---@return string type
---@return any? arg1
---@return any? arg2
---@return any? arg3
---@return any? arg4
function system.poll_event() end

---
---Wait until an event is triggered.
---
---@param timeout number Amount of seconds, also supports fractions
---of a second, eg: 0.01
---
---@return boolean status True on success or false if there was an error.
function system.wait_event(timeout) end

---
---Change the cursor type displayed on screen.
---
---@param type string | "'arrow'" | "'ibeam'" | "'sizeh'" | "'sizev'" | "'hand'"
function system.set_cursor(type) end

---
---Change the window title.
---
---@param title string
function system.set_window_title(title) end

---@alias system.windowmode
---|>'"normal"'
---| '"minimized"'
---| '"maximized"'
---| '"fullscreen"'

---
---Change the window mode.
---
---@param mode system.windowmode
function system.set_window_mode(mode) end

---
---Retrieve the current window mode.
---
---@return system.windowmode mode
function system.get_window_mode() end

---
---Toggle between bordered and borderless.
---
---@param bordered boolean
function system.set_window_bordered(bordered) end

---
---When then window is run borderless (without system decorations), this
---function allows to set the size of the different regions that allow
---for custom window management.
---
---@param title_height number
---@param controls_width number This is for minimize, maximize, close, etc...
---@param resize_border number The amount of pixels reserved for resizing
function system.set_window_hit_test(title_height, controls_width, resize_border) end

---
---Get the size and coordinates of the window.
---
---@return number width
---@return number height
---@return number x
---@return number y
function system.get_window_size() end

---
---Sets the size and coordinates of the window.
---
---@param width number
---@param height number
---@param x number
---@param y number
function system.set_window_size(width, height, x, y) end

---
---Check if the window currently has focus.
---
---@return boolean
function system.window_has_focus() end

---
---Opens a message box to display an error message.
---
---@param title string
---@param message string
function system.show_fatal_error(title, message) end

---
---Change the current directory path which affects relative file operations.
---This function raises an error if the path doesn't exists.
---
---@param path string
function system.chdir(path) end

---
---Create a new directory, note that this function doesn't recursively
---creates the directories on the given path.
---
---@param directory_path string
---
---@return boolean created True on success or false on failure.
function system.mkdir(directory_path) end

---
---Gets a list of files and directories for a given path.
---
---@param path string
---
---@return table|nil list List of directories or nil if empty or error.
---@return string? message Error message in case of error.
function system.list_dir(path) end

---
---Converts a relative path from current directory to the absolute one.
---
---@param path string
---
---@return string
function system.absolute_path(path) end

---
---Get details about a given file or path.
---
---@param path string Can be a file or a directory path
---
---@return system.fileinfo|nil info Path details or nil if empty or error.
---@return string? message Error message in case of error.
function system.get_file_info(path) end

---
---Retrieve the text currently stored on the clipboard.
---
---@return string
function system.get_clipboard() end

---
---Set the content of the clipboard.
---
---@param text string
function system.set_clipboard(text) end

---
---Get amount of iterations since the application was launched
---also known as SDL_GetPerformanceCounter() / SDL_GetPerformanceFrequency()
---
---@return number
function system.get_time() end

---
---Sleep for the given amount of seconds.
---
---@param seconds number Also supports fractions of a second, eg: 0.01
function system.sleep(seconds) end

---
---Similar to os.execute() but does not return the exit status of the
---executed command and executes the process in a non blocking way by
---forking it to the background.
---
---@param command string The command to execute.
function system.exec(command) end

---
---Generates a matching score depending on how well the value of the
---given needle compares to that of the value in the haystack.
---
---@param haystack string
---@param needle string
---@param file boolean Reverse the algorithm to prioritize the end
---of the haystack, eg: with a haystack "/my/path/to/file" and a needle
---"file", will get better score than with this option not set to true.
---
---@return integer score
function system.fuzzy_match(haystack, needle, file) end

---
---Change the opacity (also known as transparency) of the window.
---
---@param opacity number A value from 0.0 to 1.0, the lower the value
---the less visible the window will be.
function system.set_window_opacity(opacity) end
