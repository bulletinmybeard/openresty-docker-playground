local auth_token = ngx.req.get_headers()["X-API-TOKEN"]

if not auth_token or auth_token ~= config["nginx"]["auth_token"] then
    res_401()
end

res_ok("YAY, you are authenticated!")