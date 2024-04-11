allowed_request_methods("POST")

ngx.req.read_body()
local body = ngx.req.get_body_data()
if not body then
    res_400("Empty request body")
end

local data, err = cjson.decode(body)
logger:info("Processing POST data:", data)
if not data then
    res_400("Failed to decode JSON request payload")
end

res_ok(cjson.encode({
    data = data,
    processed = os.date("!%Y-%m-%dT%TZ"),
    status = "success"
}))
