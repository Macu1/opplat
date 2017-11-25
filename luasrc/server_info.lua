local serverlist = {{["id"]=1,["state"]=1}, {["id"]=2,["state"]=2}}

local function getall(accid)
    return serverlist
end

local function loginhistory(accid)
    return serverlist
end

local function filter(serverlist,version)
    return serverlist
end

local _M = {
    getall = getall,
    loginhistory = loginhistory
}

return _M

