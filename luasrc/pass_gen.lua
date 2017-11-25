local loginkeyStr = "loginkey"
local valid = 10800
local ticketStr = "ticket"

local function loginkey(account,password,curtime)
    return ngx.md5(account .. password .. curtime .. loginkeyStr) 
end

local function serverkey(accid,tm)
    return ngx.md5(accid .. tm .. ticketStr)
end

local function serverkeyValidTime()
    return ngx.time() + valid
end

local _M = {
    loginkey = loginkey,
    serverkey = serverkey,
    serverkeyValidTime = serverkeyValidTime
}

return _M
