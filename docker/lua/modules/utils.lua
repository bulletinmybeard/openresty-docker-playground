-- Enforces a list of allowed HTTP request methods.
function allowed_request_methods(...)
    local allowed_methods = {...} or {} -- Get allowed methods from arguments.
    local request_method = ngx.req.get_method()

    -- Check if the current request method is within the allowed list.
    for _, method in ipairs(allowed_methods) do
        if method == request_method then
            return -- Method is allowed, proceed silently.
        end
    end

    -- Method not allowed, generate a 405 response with details.
    res_405("Request method " .. request_method .. " not allowed. Use " .. table.concat(allowed_methods, ", ") ..  " instead.")
end

-- Loads and parses a YAML configuration file.
function load_yaml_config(config_file_path)
    local lyaml = require 'lyaml'

    -- Attempt to open the configuration file.
    local file_path = config_file_path or "/opt/config.yaml" -- Use default path if none provided.
    local file, err = io.open(file_path, "r")

    if not file or err then
        error("Error opening file: " .. err) -- Handle file access errors.
    end

    -- Read file contents and close the file.
    local contents = file:read("*all")
    file:close()

    -- Parse the YAML data and return the resulting Lua tabl
    return lyaml.load(contents)
end

-- Retrieves a value from a nested table structure, providing an optional default.
function get_table_field(table, field_path, default_value)
    local current_level = table
    local fields = string.split(field_path, ".")

    -- Traverse the table structure based on the dot-separated field path.
    for _, field_name in ipairs(fields) do
        if type(current_level) == "table" and current_level[field_name] ~= nil then
            current_level = current_level[field_name]
        else
            return default_value -- Field not found, return the default.
        end
    end

    -- Return the final value or the default if the full path wasn't found.
    return current_level[fields[#fields]] or default_value
end
