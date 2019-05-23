#!/bin/lua

local function is_empty(s)
  return s == nil or s == ''
end

local function is_pin(v)
  local x = string.match(v, '^[0-9#*]+$');
  return is_empty(x)
end

PIN = session:getVariable("sip_h_X-Request-PIN");
Duration = session:getVariable("sip_h_X-Request-Duration");
WaitTime = session:getVariable("sip_h_X-Request-WaitTime");

if is_empty(Duration) then
  session:consoleLog("err", "Got empty Duration value\n");
  return;
end

if is_empty(WaitTime) then
  session:consoleLog("err", "Got empty WaitTime value\n");
  return;
end

if is_empty(PIN) then
  session:consoleLog("err", "Got empty PIN value\n");
  return;
end

if is_pin(PIN) then
  session:consoleLog("err", "Got bad PIN value: " .. PIN .. "\n");
  return;
end

pin_length = string.len(PIN);
pin_regex = string.gsub(PIN, "\*", "\\*")
session:consoleLog("err", "Got bad PIN regex: " .. pin_regex .. "\n");

session:consoleLog("info", "Got PIN: " .. PIN .. " Duration: " .. Duration .. " WaitTime: " .. WaitTime .."\n")

digits = session:playAndGetDigits(pin_length, pin_length, 1, WaitTime, "", "silence_stream://1000", "silence_stream://1000", pin_regex)

if is_empty(digits) then
  session:consoleLog("err", "PIN check failed. Destroing call\n");
  session:setVariable("sip_bye_h_X-ExitCode", "404");
  session:hangup("USER_BUSY");
  return;
end

session:consoleLog("info", "PIN check passed. Waiting call for: " .. WaitTime .. "ms\n");
session:execute("playback", "silence_stream://" .. WaitTime)
session:setVariable("sip_bye_h_X-ExitCode", "200");
session:hangup("NORMAL_CLEARING");

