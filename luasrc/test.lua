local cjson = require("cjson.safe")
local pass_gen = require("pass_gen")
local db_func = require("db_func")
local server_info = require("server_info")

ngx.req.read_body()
local post_args = ngx.req.get_post_args()
-- ngx.say("ngx.get_body_data: ", ngx.req.get_body_data())

local check = 0
local param = {}
local wret = { ["result"]=1 }
param[ "account" ] = post_args["account"] or ""
param[ "loginkey" ] = post_args["loginkey"] or ""
param[ "curtime" ] = post_args["curtime"] or ""
param[ "devid" ] = post_args["devid"] or ""
local version = post_args["version"]

for k,v in pairs(param) do
    if v == "" then
        check = check + 1
    end
end

if check > 0 then
    wret[ "result" ] = 2
    ngx.say(cjson.encode(wret))
    ngx.exit(200)
end 

local accid,password = db_func:get_account_info(param["account"])
if accid == 0 then
    wret["result"] = 1
    ngx.say(cjson.encode(wret))
    ngx.exit(200)
end

local key = pass_gen.loginkey(param["account"],password,param["curtime"])
if param["loginkey"] ~= key then
    wret[ "result" ] = 3
    ngx.say(cjson.encode(wret))
    ngx.exit(200)
end 

wret["accid"] = accid
wret["valid_time"] = pass_gen.serverkeyValidTime()
wret["login_ticket"] = pass_gen.serverkey(accid,wret["valid_time"]) 
wret["server_list"] = server_info.getall(version)
wret["login_history"] = server_info.loginhistory(accid)
ngx.say(cjson.encode(wret))
