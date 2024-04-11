local jwt = require "resty.jwt"

local auth_header = ngx.var.http_authorization
if not auth_header then
    res_401("Missing Authorization header")
end

local _, _, jwt_token = string.find(auth_header, "Bearer%s+(.+)")
local jwt_obj = jwt:verify(config["nginx"]["jwt_secret"], jwt_token)

res_ok(cjson.encode(jwt_obj))