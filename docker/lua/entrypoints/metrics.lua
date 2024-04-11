local metrics = ngx.shared.metrics

-- Increment a request counter.
local request_count = metrics.request_count or 0
metrics.request_count = request_count + 1

-- Store the current timestamp.
metrics.last_update = ngx.now()

local payload = {
    request_count = metrics.request_count,
    last_update = metrics.last_update
}

res_ok(cjson.encode(payload))