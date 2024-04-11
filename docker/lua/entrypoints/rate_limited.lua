local limit = ngx.shared.limit
local key = ngx.var.remote_addr
local value, flags = limit:get(key)

if value then
    if value >= 5 then
        return ngx.exit(503)
    else
        limit:incr(key, 1)
    end
else
    limit:set(key, 1, 60) -- 5 requests per minute.
end

res_ok("OK")