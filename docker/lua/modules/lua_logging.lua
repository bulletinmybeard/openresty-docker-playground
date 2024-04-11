local cjson = require "cjson.safe"

local LuaLogger = {}
LuaLogger.__index = LuaLogger

-- Constructor
function LuaLogger:new(options)
    options = options or {}

    local self = setmetatable({}, LuaLogger)

    -- Set the log file path, with a default if not provided in options.
    self.log_file_path = options.log_file_path or "/var/log/lua/default.log"

    -- Prioritize options.max_log_level, then config, otherwise default to "ERR".
    self.max_log_level = (config["nginx"]["log_level"] or "ERR"):upper()
    if options.max_log_level then
        self.max_log_level = (options.max_log_level):upper()
    end

    return self
end

-- Colorize log level (private)
function LuaLogger:_colorize_log_level_message(level)
    -- Uses ANSI color codes for terminal readability.
    local color_codes = {
        DEBUG = "\27[38;5;45m", -- Lighter blue
        INFO = "\27[32m",       -- Green
        WARN = "\27[33m",       -- Yellow
        ERR = "\27[31m",        -- Red
        CRIT = "\27[31;1m"      -- Bold red
    }
    -- Constructs a formatted prefix with log level and timestamp.
    return color_codes[level]
            .. "[" .. level .. " @ "
            .. os.date("%Y-%m-%d %H:%M:%S") .. "]"
            .. "\27[0m" -- Reset color
end

-- Log method (private)
function LuaLogger:_log(level, message, ...)

    local all_log_levels = {
        DEBUG = 1, INFO = 2, WARN = 3, ERR = 4, CRIT = 5
    }

    local log_level = all_log_levels[level]
    local max_level = all_log_levels[self.max_log_level]

    -- Validate the configured maximum log level.
    if not max_level then
        ngx.log(ngx.ERR, "Invalid max log level specified: " .. self.max_log_level)
        return
    end

    -- Log only if the message's level is allowed by the configured maximum level.
    if log_level >= max_level then
        local file = io.open(self.log_file_path, "a+")
        if file then
            local args = {...} or {}

            -- Check if the message is a table and serialize it if so.
            if type(message) == "table" then
                local success, result = pcall(cjson.encode, message)
                if success then
                    message = result
                else
                    message = "Error serializing table: " .. result
                end
            else
                message = tostring(message)
            end

            -- Process and append any additional arguments.
            for _, arg in ipairs(args) do
                if type(arg) ~= "nil" then
                    if type(arg) == "table" then
                        -- Serialize tables.
                        message = message .. " " .. cjson.encode(arg)
                    else
                        message = message .. " " .. tostring(arg)
                    end
                end
            end

            -- Append a new line to the log file.
            local log_entry = self:_colorize_log_level_message(level) .. " " .. message .. "\n"

            file:write(log_entry)
            file:close()

            if level == "DEBUG" then
                ngx.log(ngx.DEBUG, message)
            elseif level == "INFO" then
                ngx.log(ngx.INFO, message)
            elseif level == "WARN" then
                ngx.log(ngx.WARN, message)
            elseif level == "ERR" then
                ngx.log(ngx.ERR, message)
            elseif level == "CRIT" then
                ngx.log(ngx.CRIT, message)
            else
                ngx.log(ngx.ERR, "Invalid log level specified: " .. level)
            end
        else
            ngx.log(ngx.ERR, "Unable to open log file")
        end
    end
end

-- Public logging methods: These provide a convenient interface
-- by calling the private _log function with the appropriate level.
function LuaLogger:debug(message, ...)
    self:_log("DEBUG", message, ...)
end

function LuaLogger:info(message, ...)
    self:_log("INFO", message, ...)
end

function LuaLogger:warn(message, ...)
    self:_log("WARN", message, ...)
end

function LuaLogger:err(message, ...)
    self:_log("ERR", message, ...)
end

function LuaLogger:crit(message, ...)
    self:_log("CRIT", message, ...)
end

return LuaLogger