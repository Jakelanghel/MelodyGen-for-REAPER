-- Get folder of this script
local info = debug.getinfo(1, "S").source:sub(2)
local script_dir = info:match("(.+)[/\\]")

-- Add subfolders to package.path
package.path = package.path
  .. ";" .. script_dir .. "/?.lua"
  .. ";" .. script_dir .. "/ui/?.lua"
  .. ";" .. script_dir .. "/reaper_integration/?.lua"

-- Require modules
local ui = require("ui.run_ui")
local reaper_integration = require("reaper_integration.reaper_integration")
local create_track = reaper_integration.create_track

-- Create ImGui context
local ctx = reaper.ImGui_CreateContext("Melody Generator")

-- Start UI loop
ui.run_ui(ctx, create_track)
