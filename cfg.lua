--- 模块功能：配置文件
-- @author Shiyuki Software
-- @module cfg
-- @license MIT
-- @copyright Shiyuki Software
-- @release 2023.11

module(..., package.seeall)
-------------------- 短信转发 --------------------
-- 是否启用短信转发功能
enableSmsToUart = true

-------------------- 看门狗 --------------------
-- 是否启用软件看门狗
enableWatchdog = true
-- 超时时间（秒）
dogResetTime = 300
-- 喂狗时间（秒）
-- 注意：不要大于超时时间
dogFeedTime = 60

-------------------- UART端口 --------------------
-- 注意：如果你只需要通过USB UART AT端口输出短信JSON，就不要修改下面的参数！

-- 端口号
uartid = uart.USB
-- 波特率
baud = 0
-- 数据位
databits = 0
-- 校验位
partiy = uart.PAR_NONE
-- 停止位
stopbits = uart.STOP_1
