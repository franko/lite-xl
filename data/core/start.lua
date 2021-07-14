-- this file is used by lite-xl to setup the Lua environment when starting, parse command line options, and return the desired core, in a normal flow
VERSION = "1.16.11"
MOD_VERSION = "1"

SCALE = tonumber(os.getenv("LITE_SCALE")) or SCALE
PATHSEP = package.config:sub(1, 1)

EXEDIR = EXEFILE:match("^(.+)[/\\][^/\\]+$")
if MACOS_RESOURCES then
  DATADIR = MACOS_RESOURCES
else
  local prefix = EXEDIR:match("^(.+)[/\\]bin$")
  DATADIR = prefix and (prefix .. '/share/lite-xl') or (EXEDIR .. '/data')
end
USERDIR = (os.getenv("XDG_CONFIG_HOME") and os.getenv("XDG_CONFIG_HOME") .. "/lite-xl")
  or (HOME and (HOME .. '/.config/lite-xl') or (EXEDIR .. '/user'))

package.path = DATADIR .. '/?.lua;' .. package.path
package.path = DATADIR .. '/?/init.lua;' .. package.path
package.path = USERDIR .. '/?.lua;' .. package.path
package.path = USERDIR .. '/?/init.lua;' .. package.path

local function arg_error(error) io.stderr:write(ARGV[1] .. ": " .. error .. "\n") os.exit(-1) end
-- returns a lua table with both numeric and non-numeric keys like getoptlong
local function parse_args_to_dict_and_array(argv, t)
  local options, arg = { argv[1] }
  local function parse_value(value)
    if t[arg] == "i" and not tonumber(value) or (#t[arg] and #value == 0) then
     arg_error("error parsing argument " .. value)
   end
    options[arg], arg = t[arg] == "i" and tonumber(value) or value, nil
  end
  for i=2, #argv do
    if argv[i]:sub(1,1) == "-" then
      local equal, value = argv[i]:find("="), ""
      arg = argv[i]:sub(argv[i]:find("[^-]"), equal and equal - 1 or #argv[i])
      if t[arg] == nil then arg_error("unknown argument " .. argv[i]) end
      if #t[arg] == 0 or equal then
        parse_value(argv[i]:sub((equal or #argv[i])+1))
      end
    elseif arg then
      parse_value(argv[i])
    else
      table.insert(options, argv[i])
    end
  end
  if arg then arg_error("expected argument for " .. arg) end
  return options
end

ARGS = parse_args_to_dict_and_array(ARGV, {
  ["core"] = "s",
  ["version"] = "", ["v"] = ""
});
if ARGS["version"] or ARGS["v"] then print(VERSION) os.exit(0) end

return require(ARGS["core"] or 'core')

