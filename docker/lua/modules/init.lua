-- Include external modules for utility functions and response helpers.
require "utils"
require "responses"

-- Require the CJSON library for JSON serialization and deserialization.
cjson = require "cjson"

-- Load and parse the YAML configuration. Assumes a 'load_yaml_config' function is defined elsewhere.
config = load_yaml_config()

-- Require the custom logging module.
local LuaLogger = require "lua_logging"

-- Create a new instance of the LuaLogger class for logging purposes.
logger = LuaLogger:new()
