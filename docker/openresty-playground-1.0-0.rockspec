rockspec_format = "3.0"

package = "openresty-playground"
version = "1.0-0"

source = {
    url = "/opt/openresty-playground-1.0-0.tar.gz"
}

description = {
    summary = "LUA dependencies"
}

dependencies = {
    "lua >= 5.1",
    "luafilesystem 1.8.0-1",
    "lua-resty-auto-ssl 0.13.1-1",
    "lua-resty-jwt 0.2.3-0",
    "lua-resty-http 0.17.2-0",
    "lua-cjson 2.1.0.10-1",
    "lub 1.1.0-1",
    "lyaml 6.2.8-1",
    "magick 1.6.0-1"
}
