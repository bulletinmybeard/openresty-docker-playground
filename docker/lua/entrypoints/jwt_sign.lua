local jwt = require "resty.jwt"

allowed_request_methods("POST")

ngx.req.read_body()
local body = ngx.req.get_body_data()
if not body then
    res_400("Empty request body")
end

local data, err = cjson.decode(body)
if not data then
    logger:err("Failed to decode JSON: ", err)
    res_400("Failed to decode JSON")
end

local jwt_token = jwt:sign(
    config["nginx"]["jwt_secret"],
    {
        header={typ="JWT", alg="HS256"},
        payload=data
    }
)

res_ok(jwt_token)