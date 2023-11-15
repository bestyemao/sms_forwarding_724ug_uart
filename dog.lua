--- 模块功能：软狗
-- @author openLuat
-- @module dog
-- @license MIT
-- @copyright openLuat
-- @release 2019.11.26
require "cfg"
module(..., package.seeall)

--[[
函数名：eatSoftDog
功能  ：喂狗
参数  ：无
返回值：无
]]
function eatSoftDog()
    log.debug("Dog Feeded")
    rtos.eatSoftDog()
end

--[[
函数名：closeSoftDog
功能  ：关闭软狗
参数  ：无
返回值：无
]]
function closeSoftDog()
    sys.timerStop(eatSoftDog)
    rtos.closeSoftDog()
end

-- 打开并设置软狗超时时间单位MS,超过设置时间没去喂狗，重启模块
if (cfg.enableWatchdog) then
    rtos.openSoftDog(cfg.dogResetTime * 1000)
    log.debug("Software Watchdog initialized.")
    -- 定时喂狗
    sys.timerLoopStart(eatSoftDog, cfg.dogFeedTime * 1000)
end

