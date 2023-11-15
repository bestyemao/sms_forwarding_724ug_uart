--- 模块功能：短信功能，将短信输出到USB UART AT串口
-- @author Shiyuki Software
-- @module smsfw
-- @license MIT
-- @copyright Shiyuki Software
-- @release 2023.11
module(..., package.seeall)

require "sms"
require "usbuart"
require "cfg"


-----------------------------------------[FUNCTION START]-----------------------------------------
--[[
函数名：onNewSms
功能  ：接受短信的回调
参数  ：num: 电话号码，data: 短信内容，Datetime：接收日期
返回值：无
]]
local function onNewSms(num, data, datetime)
    -- log.debug("testSms.procnewsms", num, common.gb2312ToUtf8(data), datetime)
    local smsContent = common.gb2312ToUtf8(data) -- 转换为UTF8
    local phoneNum = num;
    log.debug("SMS RECEIVED. SENDING TO UART...")
    usbuart.sendSmsToUART(phoneNum, smsContent, datetime)
end

-- 设置接收短信时自动调用
sms.setNewSmsCb(onNewSms)
-----------------------------------------[FUNCTION END]-----------------------------------------

-----------------------------------------[FUNCTION START]-----------------------------------------
--[[
函数名：subscribe UART_ADD
功能  ：接受UART端口的回调
参数  ：data：UART接受短信的JSON，格式参考README
返回值：无
]]
sys.subscribe("UART_ADD", function(data)
    if data.type and data.to and data.content then --解析JSON
        if data.type == "sms" then --如果类型是sms则发送短信
            log.debug("SENDING SMS TO => " .. data.to)
            sms.send(data.to, data.content)
        else
            log.debug("Not sms request, skip.")
        end
    end
end)

-----------------------------------------[FUNCTION END]-----------------------------------------
