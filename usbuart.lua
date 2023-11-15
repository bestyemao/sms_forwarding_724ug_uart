--- 模块功能：USB UART AT串口输出
-- @author Shiyuki Software
-- @module usbuart
-- @license MIT
-- @copyright Shiyuki Software
-- @release 2023.11
module(..., package.seeall)

require "cfg"
--[[
函数名：sendSmsToUART
功能  ：将接收到的短信内容发送至UART端口
参数  ：num：电话号码，sms：短信内容，datetime：短信接收时间日期（暂未使用）
返回值：无
]]
function sendSmsToUART(num, sms, datetime)
    if (enableSmsToUart == false) then
        return
    else
        uart.write(cfg.uartid, '@$from$:$' .. num .. '$,$data$:$' .. sms .. '$@')
        log.debug("uart write ok")
    end
end


--[[
函数名：uartOn
功能  ：从UART端口读取数据，并根据数据请求类型，发送消息事件
参数  ：无
返回值：无
]]
uart.on(cfg.uartid, "receive", function()
    rawData = ""
    -- 循环读取收到的数据
    while true do
        -- 每次读取一行
        local s = uart.read(cfg.uartid, "*l")
        if string.len(s) ~= 0 then
            rawData = rawData .. s
        else
            break
        end
    end

    -- 做一个判断。如果接收到的数据不是以{开头的，则说明一定不是JSON
    -- 原因是合宙提供的json的解析库有问题，按理来说应该解析出来的是nil，但是输入数字可以正常解析
    if(string.sub(rawData,1,1)~="{") then
        log.warn("Not JSON!")
        return
    end

    log.debug(rawData)
    local jsonData = json.decode(rawData)
    
    if jsonData then
        if jsonData.type then --如果接收到的json string有type字段则推事件
            sys.publish("UART_ADD", jsonData)
        else--否则不推
            log.warn("Illegal JSON Format, lookup README.")
        end
    else
        log.warn("Not JSON!")
    end

end)

--初始化UART端口
uart.setup(cfg.uartid, cfg.baud, cfg.databits, cfg.partiy, cfg.stopbits)
log.debug("uart setup ok")
