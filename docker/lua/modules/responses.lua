-- https://openresty-reference.readthedocs.io/en/latest/Lua_Nginx_API/#http-status-constants

-- Prepares data for output, serializing tables if necessary.
function res_process_data(message)
    if message then
        if type(message) == "table" then
            -- Serialize table into JSON.
            local success, result = pcall(cjson.encode, message)
            if success then
                return cjson.encode(result) -- Return serialized JSON data.
            end
        else
            -- Assumes message is a string or number; convert to string.
            return tostring(message)
        end
    end
end

-- Handles common logic for displaying processed messages.
function process_and_display_message(message)
    if message then
        ngx.say(res_process_data(message))
    end
end

-- Helper functions to generate HTTP responses with common status codes.
-- These streamline response generation and message formatting.
function res_ok(message)
    ngx.status = ngx.HTTP_OK
    process_and_display_message(message)
    ngx.exit(ngx.HTTP_OK)
end

function res_204(message)
    ngx.status = ngx.HTTP_NO_CONTENT
    process_and_display_message(message)
    ngx.exit(ngx.HTTP_NO_CONTENT) -- No message sent for 204
end

function res_400(message)
    ngx.status = ngx.HTTP_BAD_REQUEST
    process_and_display_message(message)
    ngx.exit(ngx.HTTP_BAD_REQUEST)
end

function res_401(message)
    ngx.status = ngx.HTTP_UNAUTHORIZED
    process_and_display_message(message)
    ngx.exit(ngx.HTTP_UNAUTHORIZED)
end

function res_404(message)
    ngx.status = ngx.HTTP_NOT_FOUND
    process_and_display_message(message)
    ngx.exit(ngx.HTTP_NOT_FOUND)
end

function res_405(message)
    ngx.status = ngx.HTTP_NOT_ALLOWED
    process_and_display_message(message)
    ngx.exit(ngx.HTTP_NOT_ALLOWED)
end

function res_500(message)
    ngx.status = ngx.HTTP_INTERNAL_SERVER_ERROR
    process_and_display_message(message)
    ngx.exit(ngx.HTTP_INTERNAL_SERVER_ERROR)
end

function res_502(message)
    ngx.status = ngx.HTTP_BAD_GATEWAY
    process_and_display_message(message)
    ngx.exit(ngx.HTTP_BAD_GATEWAY)
end

function res_502(message)
    ngx.status = ngx.HTTP_SERVICE_UNAVAILABLE
    process_and_display_message(message)
    ngx.exit(ngx.HTTP_SERVICE_UNAVAILABLE)
end
