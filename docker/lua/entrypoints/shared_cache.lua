local cache = ngx.shared.content_cache
local content = cache:get("key")

if not content then
    content = "This is just some content being stored in the shared content cache."
    cache:set("key", content, 60)
end

res_ok(content)