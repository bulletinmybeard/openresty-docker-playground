local jwt = require "resty.jwt"

local auth_header = ngx.var.http_authorization
if not auth_header then
    res_401()
end

local _, _, jwt_token = string.find(auth_header, "Bearer%s+(.+)")
if not jwt_token then
    res_401()
end

local jwt_obj = jwt:verify(config["nginx"]["jwt_secret"], jwt_token)
if not jwt_obj.valid then
    res_401(verified.reason)
end

res_ok("YAY, you are authenticated!")