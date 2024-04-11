-- In order to make environment variables available throughout NGINX,
-- they need to be added to the `nginx.conf` file using the `env` directive.

local OPENRESTY_VERSION = os.getenv("OPENRESTY_VERSION")
local HOSTNAME = os.getenv("HOSTNAME")
local APP_NAME = os.getenv("APP_NAME")
local APP_VERSION = os.getenv("APP_VERSION")

-- For demo purposes only!!!
res_ok(cjson.encode({
    OPENRESTY_VERSION = OPENRESTY_VERSION,
    HOSTNAME = HOSTNAME,
    APP_NAME = APP_NAME,
    APP_VERSION = APP_VERSION
}))
