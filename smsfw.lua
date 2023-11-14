--- 模块功能：短信功能，将短信输出到USB UART AT串口
-- @author Shiyuki Software
-- @module sms.smsfw
-- @license MIT
-- @copyright Shiyuki Software
-- @release 2023.11
module(..., package.seeall)

require "sms"

enableSmsToUart = true

uartid = uart.USB
baud = 0
databits = 0
partiy = uart.PAR_NONE
stopbits = uart.STOP_1

-----------------------------------------短信接收功能测试[开始]-----------------------------------------
local function onNewSms(num, data, datetime)
    -- log.info("testSms.procnewsms", num, common.gb2312ToUtf8(data), datetime)
    local sms = common.gb2312ToUtf8(data)
    local phone = num;
    log.info("SMS RECEIVED. SENDING TO UART...")
    sendSmsToUART(num, sms, datetime)
end

sms.setNewSmsCb(onNewSms)
-----------------------------------------短信接收功能测试[结束]-----------------------------------------

function sendSmsToUART(num, sms, datetime)
    if (enableSmsToUart == false) then
        return
    else
        uart.write(uartid,'@$from$:$'..num..'$,$data$:$'..sms..'$@')
        log.info("uart write ok")
    end
end

--[[
-----------------------------------------短信发送测试[开始]-----------------------------------------
local function sendtest1(result, num, data)
    log.info("testSms.sendtest1", result, num, data)
end

local function sendtest2(result, num, data)
    log.info("testSms.sendtest2", result, num, data)
end

local function sendtest3(result, num, data)
    log.info("testSms.sendtest3", result, num, data)
end

local function sendtest4(result, num, data)
    log.info("testSms.sendtest4", result, num, data)
end

sys.subscribe("SMS_READY", function()
    sys.timerStart(function()
        sms.send("10086", "10086", sendtest1)
        -- sms.send("10086",common.utf8ToGb2312("第2条短信"),sendtest2)
        -- sms.send("10086","qeiuqwdsahdkjahdkjahdkja122136489759725923759823hfdskfdkjnbzndkjhfskjdfkjdshfkjdsfks83478648732432qeiuqwdsahdkjahdkjahdkja122136489759725923759823hfdskfdkjnbzndkjhfskjdfkjdshfkjdsfks83478648732432qeiuqwdsahdkjahdkjahdkja122136489759725923759823hfdskfdkjnbzndkjhfskjdfkjdshfkjdsfks83478648732432",sendtest3)
        -- sms.send("10086",common.utf8ToGb2312("华康是的撒qeiuqwdsahdkjahdkjahdkja122136489759725923759823hfdskfdkjnbzndkjhfskjdfkjdshfkjdsfks83478648732432qeiuqwdsahdkjahdkjahdkja122136489759725923759823hfdskfdkjnbzndkjhfskjdfkjdshfkjdsfks83478648732432qeiuqwdsahdkjahdkjahdkja122136489759725923759823hfdskfdkjnbzndkjhfskjdfkjdshfkjdsfks83478648732432"),sendtest4)
    end, 10000)
end)
-----------------------------------------短信发送测试[结束]-----------------------------------------
--
]] -- 
uart.setup(uartid,baud,databits,partiy,stopbits)
log.info("uart setup ok")