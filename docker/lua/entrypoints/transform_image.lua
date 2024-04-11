local magick = require "magick"

ngx.req.read_body()
local data = ngx.req.get_body_data()

if not data then
    res_400("No image data found in request")
end

logger:debug("Image dimensions (desired): ", ngx.var.arg_width, "x", ngx.var.arg_height)

local image = magick.load_image_from_blob(data)

logger:debug("Image dimensions (original): ", image:get_width(), "x", image:get_height())

local width = tonumber(ngx.var.arg_width) or image:get_width()
local height = tonumber(ngx.var.arg_height) or image:get_height()

logger:debug("Image dimensions (final): ", width, "x", height)

rotate_degrees = ngx.var.arg_degrees or 0
logger:debug("Image rotation: ", rotate_degrees)

image:resize(width, height)

ngx.header.content_type = "image/jpeg"
ngx.say(image:get_blob())
image:destroy()