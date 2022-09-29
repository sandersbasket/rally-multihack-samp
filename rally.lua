script_name("Rally killer")
script_author("sanders")
--lib 
local sampev = require('lib.samp.events')
local imgui = require('ImGui')
local sw, sh = getScreenResolution()
local vKeys = require('vKeys')
local ffi = require "ffi"
local effil = require 'effil'
local mem = require "memory"
local lanes = require('lanes').configure()
local requests = require 'requests'
local encoding = require 'encoding'
local inicfg = require 'inicfg'
encoding.default = 'CP1251'
u8 = encoding.UTF8
-- set imgui
local window = imgui.ImBool(false)
local mainIni = inicfg.load({ -- CFG
    config =
{
    buttoncaptchaNew = false,
    floodnNew = false,
    tagsNew = false,
    ptimeNew = false,
    nClearNew = false,
    max5New = false,
    aenterNew = false,
    waitaenterNew = 0,
    presentimeNew = false,
    capthatrue = 0,
    сapthafalse = 0, 
    capthas = 0,
    captime1 = nil,
    captime2 = nil,
    captime3 = nil, 
    captime4 = nil,
    captime5 = nil, 
    captwaits = nil 
}
}, "_rally")
-- 
CFG =
{
    CheckBoxes =
    {
        Enable = imgui.ImBool(false)
    },
    Sliders =
    {
        Smooth = imgui.ImFloat(1.0),
        FieldOfVisible = imgui.ImFloat(1.0)
    }
}
-- set imgui 

local buttoncaptcha = imgui.ImBool(mainIni.config.buttoncaptchaNew)
local floodn =  imgui.ImBool(mainIni.config.floodnNew)
local tags = imgui.ImBool(mainIni.config.tagsNew)
local ptime = imgui.ImBool(mainIni.config.ptimeNew)
local nClear = imgui.ImBool(mainIni.config.nClearNew)
local max5 = imgui.ImBool(mainIni.config.max5New)
local aenter = imgui.ImBool(mainIni.config.aenterNew)
local waitaenter = imgui.ImInt(mainIni.config.waitaenterNew)
local presentime = imgui.ImBool(mainIni.config.presentimeNew)
local col = imgui.ImBool(false)
local antikey = imgui.ImBool(true)
local antirvano4ka = imgui.ImBool(true)
local delchars = imgui.ImBool(false)
local delcars = imgui.ImBool(false)
local switch = false
local capthatrue = mainIni.config.capthatrue
local сapthafalse = mainIni.config.сapthafalse
local capthas = mainIni.config.capthas
local captime1 = mainIni.config.captime1
local captime2 = mainIni.config.captime2
local captime3 = mainIni.config.captime3
local captime4 = mainIni.config.captime4
local captime5 = mainIni.config.captime5
local captwaits = mainIni.config.captwaits
-- checklibs

--  
local familys = {"Family", "Dynasty", "Corporation", "Squad", "Crew", "Empire", "Brotherhood"}
--
local time = nil
local captime = nil
local t = 0
local captcha = ''
local captchaTable = {}
--


local status = inicfg.load(mainIni, '_rally.ini')
if not doesFileExist('moonloader/config/_rally.ini') then inicfg.save(mainIni, '_rally.ini') end



function main() 
    if not isSampfuncsLoaded() or not isSampLoaded() then return end 
    while not isSampAvailable() do wait(100) end
    print('{FF00FF}Rally loaded!')
    sampRegisterChatCommand('slapdown', slapd)
    sampRegisterChatCommand('slap', slap)
    sampRegisterChatCommand('sc', sc)
    while true do 
        wait(0)
        if not initialized then
            if not isSampAvailable() then return false end
            lua_thread.create(Aimbot)
            initialized = true
        end
        imgui.Process = window.v
        if testCheat('XXX') then  
            window.v = not window.v
        end
        if buttoncaptcha.v then  
            if wasKeyPressed(0x4E) and not sampIsChatInputActive() and not sampIsDialogActive() then showCaptcha() end
            local result, button, list, input = sampHasDialogRespond(8812)
            if result then
              if button == 1 then
                if input == captcha..'0' then 
                    sampAddChatMessage(string.format('{ff00ff}[_rally] {ffffff}Капча введена верно [%.3f]', os.clock() - captime), -1) 
                    capthatrue = capthatrue + 1
                    capthas = capthas + 1
                    mainIni.config.capthatrue = capthatrue
                    mainIni.config.capthas = capthas
                    if captime1 == nil then  
                        captime1 = os.clock() - captime
                        mainIni.config.captime1 = captime1
                    elseif captime1 ~= nil and captime2 == nil then  
                        captime2 = os.clock() - captime
                        mainIni.config.captime2 = captime2
                    elseif captime1 ~= nil and captime2 ~= nil and captime3 == nil then  
                        captime3 = os.clock() - captime
                        mainIni.config.captime3 = captime3
                    elseif captime1 ~= nil and captime2 ~= nil and captime3 ~= nil and captime4 == nil then  
                        captime4 = os.clock() - captime
                        mainIni.config.captime4 = captime4
                    elseif captime1 ~= nil and captime2 ~= nil and captime3 ~= nil and captime4 ~= nil and captime5 == nil then  
                        captime5 = os.clock() - captime
                        mainIni.config.captime5 = captime5
                    elseif captime1 ~= nil and captime2 ~= nil and captime3 ~= nil and captime4 ~= nil and captime5 ~= nil then  
                        sampAddChatMessage('{ff00ff}[_rally] {ffffff}Сбрасываю среднее время ввода, вводите капчи заново!', -1)
                        sampAddChatMessage('{ff00ff}[_rally] {ffffff}Прошлый результат: '..captwaits, -1)
                        captime1 = nil  
                        captime2 = nil  
                        captime3 = nil  
                        captime4 = nil  
                        captime5 = nil  
                    end
                    inicfg.save(mainIni, '_rally.ini')
                elseif input ~= captcha..'0' then
                    sampAddChatMessage(string.format('{ff00ff}[_rally] {ffffff}Капча введена неверно! [%.3f] ('..captcha..'0|'..input..')', os.clock() - captime), -1)
                    сapthafalse = сapthafalse + 1
                    capthas = capthas + 1
                    mainIni.config.сapthafalse = сapthafalse
                    mainIni.config.capthas = capthas
                    if captime1 == nil then  
                        captime1 = os.clock() - captime
                        mainIni.config.captime1 = captime1
                    elseif captime1 ~= nil and captime2 == nil then  
                        captime2 = os.clock() - captime
                        mainIni.config.captime2 = captime2
                    elseif captime1 ~= nil and captime2 ~= nil and captime3 == nil then  
                        captime3 = os.clock() - captime
                        mainIni.config.captime3 = captime3
                    elseif captime1 ~= nil and captime2 ~= nil and captime3 ~= nil and captime4 == nil then  
                        captime4 = os.clock() - captime
                        mainIni.config.captime4 = captime4
                    elseif captime1 ~= nil and captime2 ~= nil and captime3 ~= nil and captime4 ~= nil and captime5 == nil then  
                        captime5 = os.clock() - captime
                        mainIni.config.captime5 = captime5
                    elseif captime1 ~= nil and captime2 ~= nil and captime3 ~= nil and captime4 ~= nil and captime5 ~= nil then  
                        sampAddChatMessage('{ff00ff}[_rally] {ffffff}Сбрасываю среднее время ввода, вводите капчи заново!', -1)
                        sampAddChatMessage('{ff00ff}[_rally] {ffffff}Прошлый результат: '..captwaits, -1)
                        captime1 = nil  
                        captime2 = nil  
                        captime3 = nil  
                        captime4 = nil  
                        captime5 = nil  
                    end
                    inicfg.save(mainIni, '_rally.ini')
                end
              end
              removeTextdraws()
            end
        end
        if sampIsDialogActive() and sampGetDialogCaption():find('Проверка на робота') then
            if nClear.v then sampSetCurrentDialogEditboxText(string.gsub(sampGetCurrentDialogEditboxText(), '[^1234567890]','')) end
            if max5.v then
              local text = sampGetCurrentDialogEditboxText()
              if #text > 5 then sampSetCurrentDialogEditboxText(text:sub(1, 5)) end
            end
        end
        if col.v then
            kol()
        end
        if delchars.v and isKeyDown(0x45) then 
            dekchars() 
        end
        if delcars.v and isKeyDown(0x52) then 
            dekcars() 
        end
        if presentime.v then  
           local timer = os.date('%X')
           printStringNow(timer, 1000)
        end
        if isKeyJustPressed(0x5A) then  
            switch = not switch
            nobike()
        end
        captimes()
    end 
end

function captimes()
    if captime1 ~= nil and captime2 ~= nil and captime3 ~= nil and captime4 ~= nil and captime5 ~= nil then  
        captwaits = (captime1 + captime2 + captime3 + captime4 + captime5)/5
        mainIni.config.captwaits = captwaits
        inicfg.save(mainIni, '_rally.ini')
    end
end

function sc()
    setCharHealth(PLAYER_PED, 0)
end

function slap()
	local x, y, z = getCharCoordinates(PLAYER_PED)
	setCharCoordinates(PLAYER_PED, x, y, z + 5.0)
end

function slapd()
	local x, y, z = getCharCoordinates(PLAYER_PED)
	setCharCoordinates(PLAYER_PED, x, y, z - 5.0)
end

function nobike()
    setCharCanBeKnockedOffBike(PLAYER_PED, switch)
    if switch then 
        addOneOffSound(0.0, 0.0, 0.0, 1138)
    end 
end

function dekchars()
    for _, handle in ipairs(getAllChars()) do
        if doesCharExist(handle) then
            local _, id = sampGetPlayerIdByCharHandle(handle)
            if id ~= myid then
                emul_rpc('onPlayerStreamOut', { id })
            end
        end
    end
end

function dekcars()
    for k, v in pairs(getAllVehicles()) do
        if doesVehicleExist(v) then
            deleteCar(v)
        end
    end
end

function kol()
    for _, pedv in ipairs(getAllChars()) do
        if doesCharExist(pedv) then
            if pedv ~= playerPed then
                setCharCollision(pedv, false)
            end
        end
    end
end

function showCaptcha()
    removeTextdraws()
    t = t + 1
    sampTextdrawCreate(t, "LD_SPAC:white", 220, 120)
    sampTextdrawSetLetterSizeAndColor(t, 0, 6.5, 0x80808080)
    sampTextdrawSetBoxColorAndSize(t, 1, 0xFF1A2432, 380, 0.000000)
       
    t = t + 1
    sampTextdrawCreate(t, "LD_SPAC:white", 225, 125)
    sampTextdrawSetLetterSizeAndColor(t, 0, 5.5, 0x80808080)
    sampTextdrawSetBoxColorAndSize(t, 1, 0xFF759DA3, 375, 0.000000)
    nextPos = -30.0;
       
    math.randomseed(os.time())
    for i = 1, 4 do
        a = math.random(0, 9)
        table.insert(captchaTable, a)
        captcha = captcha..a
    end
       
    for i = 0, 4 do
        nextPos = nextPos + 30
        t = t + 1
        sampTextdrawCreate(t, "usebox", 240 + nextPos, 130)
        sampTextdrawSetLetterSizeAndColor(t, 0, 4.5, 0x80808080)
        sampTextdrawSetBoxColorAndSize(t, 1, 0xFF1A2432, 30, 25.000000)
        sampTextdrawSetAlign(t, 2)
        if i < 4 then GenerateTextDraw(captchaTable[i + 1], 240 + nextPos, 130, 3 + i * 2)
        else GenerateTextDraw(0, 240 + nextPos, 130, 3 + i * 10) end
    end
    captchaTable = {}
    sampShowDialog(8812, '{F89168}Проверка на робота', '{FFFFFF}Введите {C6FB4A}5{FFFFFF} символов, которые\nвидно на {C6FB4A}вашем{FFFFFF} экране.', 'Принять', 'Отмена', 1)
    captime = os.clock()
end

function randomFloat(lower, greater)
    return lower + math.random()  * (greater - lower);
end

function showCaptcha()
    removeTextdraws()
    t = t + 1
    sampTextdrawCreate(t, "LD_SPAC:white", 220, 120)
    sampTextdrawSetLetterSizeAndColor(t, 0, 6.5, 0x80808080)
    sampTextdrawSetBoxColorAndSize(t, 1, 0xFF1A2432, 380, 0.000000)
       
    t = t + 1
    sampTextdrawCreate(t, "LD_SPAC:white", 225, 125)
    sampTextdrawSetLetterSizeAndColor(t, 0, 5.5, 0x80808080)
    sampTextdrawSetBoxColorAndSize(t, 1, 0xFF759DA3, 375, 0.000000)
    nextPos = -30.0;
       
    math.randomseed(os.time())
    for i = 1, 4 do
        a = math.random(0, 9)
        table.insert(captchaTable, a)
        captcha = captcha..a
    end
       
    for i = 0, 4 do
        nextPos = nextPos + 30
        t = t + 1
        sampTextdrawCreate(t, "usebox", 240 + nextPos, 130)
        sampTextdrawSetLetterSizeAndColor(t, 0, 4.5, 0x80808080)
        sampTextdrawSetBoxColorAndSize(t, 1, 0xFF1A2432, 30, 25.000000)
        sampTextdrawSetAlign(t, 2)
        if i < 4 then GenerateTextDraw(captchaTable[i + 1], 240 + nextPos, 130, 3 + i * 2)
        else GenerateTextDraw(0, 240 + nextPos, 130, 3 + i * 10) end
    end
    captchaTable = {}
    sampShowDialog(8812, '{F89168}Проверка на робота', '{FFFFFF}Введите {C6FB4A}5{FFFFFF} символов, которые\nвидно на {C6FB4A}вашем{FFFFFF} экране.', 'Принять', 'Отмена', 1)
    captime = os.clock()
end

function removeTextdraws()
  if t > 0 then
    for i = 1, t do sampTextdrawDelete(i) end
    t = 0
    captcha = ''
    captime = nil
  end
end

function GenerateTextDraw(id, PosX, PosY)
  if id == 0 then
    t = t + 1
    sampTextdrawCreate(t, "LD_SPAC:white", PosX - 5, PosY + 7)
    sampTextdrawSetLetterSizeAndColor(t, 0, 3, 0x80808080)
    sampTextdrawSetBoxColorAndSize(t, 1, 0xFF759DA3, PosX+5, 0.000000)
  elseif id == 1 then
    for i = 0, 1 do
        t = t + 1
        if i == 0 then offsetX = 3; offsetBX = 15 else offsetX = -3; offsetBX = -15; end
        sampTextdrawCreate(t, "LD_SPAC:white", PosX - offsetX, PosY)
        sampTextdrawSetLetterSizeAndColor(t, 0, 4.5, 0x80808080)
        sampTextdrawSetBoxColorAndSize(t, 1, 0xFF759DA3, PosX-offsetBX, 0.000000)
    end
  elseif id == 2 then
    for i = 0, 1 do
        t = t + 1
        if i == 0 then offsetX = -8; offsetY = 7 offsetBX = 15 else offsetX = 6; offsetY = 25 offsetBX = -15; end
        sampTextdrawCreate(t, "LD_SPAC:white", PosX - offsetX, PosY + offsetY)
        sampTextdrawSetLetterSizeAndColor(t, 0, 0.8, 0x80808080)
        sampTextdrawSetBoxColorAndSize(t, 1, 0xFF759DA3, PosX-offsetBX, 0.000000)
    end
  elseif id == 3 then
    for i = 0, 1 do
        t = t + 1
        if i == 0 then size = 0.8; offsetY = 7 else size = 1; offsetY = 25 end
        sampTextdrawCreate(t, "LD_SPAC:white", PosX+10, PosY+offsetY)
        sampTextdrawSetLetterSizeAndColor(t, 0, 1, 0x80808080)
        sampTextdrawSetBoxColorAndSize(t, 1, 0xFF759DA3, PosX-15, 0.000000)
    end
  elseif id == 4 then
    for i = 0, 1 do
        t = t + 1
        if i == 0 then size = 1.8; offsetX = -10; offsetY = 0 offsetBX = 10 else size = 2; offsetX = -10; offsetY = 25 offsetBX = 15; end
        sampTextdrawCreate(t, "LD_SPAC:white", PosX - offsetX, PosY + offsetY)
        sampTextdrawSetLetterSizeAndColor(t, 0, size, 0x80808080)
        sampTextdrawSetBoxColorAndSize(t, 1, 0xFF759DA3, PosX-offsetBX, 0.000000)
    end
  elseif id == 5 then
    for i = 0, 1 do
        t = t + 1
        if i == 0 then size = 0.8; offsetX = 8; offsetY = 7 offsetBX = -15 else size = 1; offsetX = -10; offsetY = 25 offsetBX = 15; end
        sampTextdrawCreate(t, "LD_SPAC:white", PosX - offsetX, PosY + offsetY)
        sampTextdrawSetLetterSizeAndColor(t, 0, size, 0x80808080)
        sampTextdrawSetBoxColorAndSize(t, 1, 0xFF759DA3, PosX-offsetBX, 0.000000)
    end
  elseif id == 6 then
    for i = 0, 1 do
        t = t + 1
        if i == 0 then size = 0.8; offsetX = 7.5; offsetY = 7 offsetBX = -15 else size = 1; offsetX = -10; offsetY = 25 offsetBX = 10; end
        sampTextdrawCreate(t, "LD_SPAC:white", PosX - offsetX, PosY + offsetY)
        sampTextdrawSetLetterSizeAndColor(t, 0, size, 0x80808080)
        sampTextdrawSetBoxColorAndSize(t, 1, 0xFF759DA3, PosX-offsetBX, 0.000000)
    end
  elseif id == 7 then
    t = t + 1
    sampTextdrawCreate(t, "LD_SPAC:white", PosX - 13, PosY + 7)
    sampTextdrawSetLetterSizeAndColor(t, 0, 3.75, 0x80808080)
    sampTextdrawSetBoxColorAndSize(t, 1, 0xFF759DA3, PosX+5, 0.000000)
  elseif id == 8 then
    for i = 0, 1 do
        t = t + 1
        if i == 0 then size = 0.8; offsetY = 7 else size = 1; offsetY = 25 end
        sampTextdrawCreate(t, "LD_SPAC:white", PosX+10, PosY+offsetY)
        sampTextdrawSetLetterSizeAndColor(t, 0, 1, 0x80808080)
        sampTextdrawSetBoxColorAndSize(t, 1, 0xFF759DA3, PosX-10, 0.000000)
    end
  elseif id == 9 then
    for i = 0, 1 do
        t = t + 1
        if i == 0 then size = 0.8; offsetY = 6; offsetBX = 10; else size = 1; offsetY = 25; offsetBX = 15; end
        sampTextdrawCreate(t, "LD_SPAC:white", PosX+10, PosY+offsetY)
        sampTextdrawSetLetterSizeAndColor(t, 0, 1, 0x80808080)
        sampTextdrawSetBoxColorAndSize(t, 1, 0xFF759DA3, PosX-offsetBX, 0.000000)
    end
  end
end

function ShowHelpMarker(desc)
    imgui.TextDisabled('(?)')
    if imgui.IsItemHovered() then
        imgui.BeginTooltip()
        imgui.PushTextWrapPos(450.0)
        imgui.TextUnformatted(desc)
        imgui.PopTextWrapPos()
        imgui.EndTooltip()
    end
end

function sampev.onPlayerSync(id, data)
	if antirvano4ka.v then
		local x, y, z = getCharCoordinates(PLAYER_PED)
		if x - data.position.x > -1.5 and x - data.position.x < 1.5 then
			if (data.moveSpeed.x >= 1.5 or data.moveSpeed.x <= -1.5) or (data.moveSpeed.y >= 1.5 or data.moveSpeed.y <= -1.5) or (data.moveSpeed.z >= 0.5 or data.moveSpeed.z <= -0.5) then
				data.moveSpeed.x, data.moveSpeed.y, data.moveSpeed.z = 0, 0, 0
			end
		end
	end
	return {id, data}
end

function sampev.onVehicleSync(id, vehid, data)
	if antirvano4ka.v then
		local x, y, z = getCharCoordinates(PLAYER_PED)
		if x - data.position.x > -1.5 and x - data.position.x < 1.5 then
			if (data.moveSpeed.x >= 1.5 or data.moveSpeed.x <= -1.5) or (data.moveSpeed.y >= 1.5 or data.moveSpeed.y <= -1.5) or (data.moveSpeed.z >= 0.5 or data.moveSpeed.z <= -0.5) then
				data.moveSpeed.x, data.moveSpeed.y, data.moveSpeed.z = 0, 0, 0
				data.position.x = data.position.x - 5
			end
		end
	end
	return {id, vehid, data}
end

function sampev.onPlayerChatBubble() 
    if tags.v then
        return false 
    end
end

function sampev.onCreate3DText(id, color, position, distance, testLOS, attachedPlayerId, attachedVehicleId, text)
    if time ~= nil and HLcfg.main.ptime then
      local _, pid = sampGetPlayerIdByCharHandle(playerPed)
        pname = sampGetPlayerNickname(pid)
      for pizda in text:gmatch('[^\n\r]+') do
        pizda = pizda:match('{FFFFFF}Владелец: {AFAFAF}(.+)')
        if pizda ~= nil and pizda ~= pname then return sampAddChatMessage(string.format('{ff00ff}[_rally] {ffffff}Дом куплен игроком {20B2AA}%s {ffffff}[%.3f]', pizda, os.clock() - time), -1) end
      end
      for pizda in text:gmatch('[^\n\r]+') do
        pizda = pizda:match('{73B461}Владелец: {FFFFFF}(.+)')
        if pizda ~= nil and pizda ~= pname then return sampAddChatMessage(string.format('{ff00ff}[_rally] {ffffff}Бизнес куплен игроком {20B2AA}%s {ffffff}[%.3f]', pizda, os.clock() - time), -1) end
      end
    end
end

function fix(angle)
    if angle > math.pi then
        angle = angle - (math.pi * 2)
    elseif angle < -math.pi then
        angle = angle + (math.pi * 2)
    end
    return angle
end

function GetNearestPed(fov)
    local maxDistance = 35
    local nearestPED = -1
    for i = 0, sampGetMaxPlayerId(true) do
        if sampIsPlayerConnected(i) then
            local find, handle = sampGetCharHandleBySampPlayerId(i)
            if find then
                if isCharOnScreen(handle) then
                    if not isCharDead(handle) then
                        local _, currentID = sampGetPlayerIdByCharHandle(PLAYER_PED)
                        local enPos = {getCharCoordinates(handle)}
                        local myPos = {getActiveCameraCoordinates()}
                        local vector = {myPos[1] - enPos[1], myPos[2] - enPos[2], myPos[3] - enPos[3]}
                        if isWidescreenOnInOptions() then coefficentZ = 0.0778 else coefficentZ = 0.103 end
                        local angle = {(math.atan2(vector[2], vector[1]) + 0.04253), (math.atan2((math.sqrt((math.pow(vector[1], 2) + math.pow(vector[2], 2)))), vector[3]) - math.pi / 2 - coefficentZ)}
                        local view = {fix(representIntAsFloat(readMemory(0xB6F258, 4, false))), fix(representIntAsFloat(readMemory(0xB6F248, 4, false)))}
                        local distance = math.sqrt((math.pow(angle[1] - view[1], 2) + math.pow(angle[2] - view[2], 2))) * 57.2957795131
                        if distance > fov then check = true else check = false end
                        if not check then
                            local myPos = {getCharCoordinates(PLAYER_PED)}
                            local distance = math.sqrt((math.pow((enPos[1] - myPos[1]), 2) + math.pow((enPos[2] - myPos[2]), 2) + math.pow((enPos[3] - myPos[3]), 2)))
                            if (distance < maxDistance) then
                                nearestPED = handle
                                maxDistance = distance
                            end
                        end
                    end
                end
            end
        end
    end
    return nearestPED
end

function Aimbot()
    if CFG.CheckBoxes.Enable.v and isKeyDown(vKeys.VK_RBUTTON) and isKeyDown(vKeys.VK_LBUTTON) then
        local handle = GetNearestPed(CFG.Sliders.FieldOfVisible.v)
        if handle ~= -1 then
            local myPos = {getActiveCameraCoordinates()}
            local enPos = {getCharCoordinates(handle)}
            local vector = {myPos[1] - enPos[1], myPos[2] - enPos[2], myPos[3] - enPos[3]}
            if isWidescreenOnInOptions() then coefficentZ = 0.0778 else coefficentZ = 0.103 end
            local angle = {(math.atan2(vector[2], vector[1]) + 0.04253), (math.atan2((math.sqrt((math.pow(vector[1], 2) + math.pow(vector[2], 2)))), vector[3]) - math.pi / 2 - coefficentZ)}
            local view = {fix(representIntAsFloat(readMemory(0xB6F258, 4, false))), fix(representIntAsFloat(readMemory(0xB6F248, 4, false)))}
            local difference = {angle[1] - view[1], angle[2] - view[2]}
            local smooth = {difference[1] / CFG.Sliders.Smooth.v, difference[2] / CFG.Sliders.Smooth.v}
            setCameraPositionUnfixed((view[2] + smooth[2]), (view[1] + smooth[1]))
        end
    end
    return false
end

function sampev.onShowDialog(dialogID, style, title, button1, button2, txt)
    if aenter.v and dialogID == 8869 then
        lua_thread.create(function()
            wait(0)
            while true do wait(0)
                textsumfive = sampGetCurrentDialogEditboxText()
                if #textsumfive == 5 then
                    wait (waitaenter.v)
                    sampCloseCurrentDialogWithButton(1)
                    aenter.v = false
                    break
                end
            end
        end)
    end
    if antikey.v and txt:find('дал вам копию ключей от транспорта') then 
        sampCloseCurrentDialogWithButton(0) 
        return false 
    end
end


function imgui.OnDrawFrame()
    if window.v then  
        imgui.SetNextWindowPos(imgui.ImVec2(sw / 2, sh / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
        imgui.SetNextWindowSize(imgui.ImVec2(550, 380), imgui.Cond.FirstUseEver)
        imgui.Begin('_rally', window, imgui.WindowFlags.NoResize)
        imgui.BeginChild('left', imgui.ImVec2(150, 0), true)
		if not selected then selected = 1 end
		if imgui.Selectable('Main', false) then selected = 1 end
		if imgui.Selectable('Aimbot', false) then selected = 2 end
		if imgui.Selectable('Captcha', false) then selected = 3 end
        if imgui.Selectable('Cheats', false) then selected = 4 end
		if imgui.Selectable('Info', false) then selected = 5 end
		imgui.EndChild()
		imgui.SameLine()
		imgui.BeginChild('right', imgui.ImVec2(0, 0), true)
        if selected == 1 then
            imgui.BeginChild("##helps", imgui.ImVec2(360, 85), true, imgui.WindowFlags.NoScrollbar)
                imgui.Text(u8'Всего введенно каптч: '..capthas)
                imgui.Text(u8'Правильно введенных каптч: ')
                imgui.SameLine()
                imgui.TextColored(imgui.ImVec4(0, 143, 0, 1), tostring(capthatrue))
                imgui.Text(u8'Неправильных введенных каптч: ')
                imgui.SameLine()
                imgui.TextColored(imgui.ImVec4(255, 0, 0, 1), tostring(сapthafalse))
                imgui.Text(u8'Средний ввод капчи: ')
                imgui.SameLine()
                if captwaits ~= nil then  
                    imgui.TextColored(imgui.ImVec4(255, 125, 0, 255), tostring(captwaits)..' sec')
                else 
                    imgui.TextColored(imgui.ImVec4(255, 125, 0, 255), u8"Неопределенно")
                end
            imgui.EndChild()
            imgui.Checkbox(u8'Антирванка', antirvano4ka)
            ShowHelpMarker(u8'Защищает от простых рванок', imgui.SameLine())
            imgui.Checkbox(u8'Анти-ключи', antikey)
            ShowHelpMarker(u8'Вам не будет показываться диалог ключей', imgui.SameLine())
            imgui.Checkbox(u8'Флуд на N', floodn)
            ShowHelpMarker(u8'Если нажать на N до PayDay, то Вам не будет писать "Не флуди",\nа также не будет кд на повторное нажатие', imgui.SameLine())
            if imgui.Checkbox(u8'Отключить ники и семьи', tags) then
                pStSet = sampGetServerSettingsPtr()
                if tags.v then
                mem.setint8(pStSet + 56, 0)
                for i = 1, 2048 do
                    if sampIs3dTextDefined(i) then
                        local text, color, posX, posY, posZ, distance, ignoreWalls, player, vehicle = sampGet3dTextInfoById(i)
                        for ii = 1, #familys do if text:match(string.format('.+%s', familys[tonumber(ii)])) then sampDestroy3dText(i) end end
                    end
                end
            else
                mem.setint8(pStSet + 56, 1)
            end
        end
        ShowHelpMarker(u8'Отключит все ники и семьи', imgui.SameLine())
        imgui.Checkbox(u8'Время покупки другим человеком', ptime)
        ShowHelpMarker(u8'Пишет в чат за сколько другой игрок купил дом или бизнес', imgui.SameLine())
        imgui.Checkbox(u8'Удаление букв и символов с диалога капчи', nClear)
        ShowHelpMarker(u8'В диалог с капчей будет запрещено вводить всё кроме цифр', imgui.SameLine())
        imgui.Checkbox(u8'Ограничение в 5 символов', max5)
        ShowHelpMarker(u8'Запрещает вводить в диалог капчи больше 5 символов', imgui.SameLine())
        imgui.Checkbox(u8'Авто-ENTER', aenter)
        ShowHelpMarker(u8'Автоматически нажмет ENTER как вы введете 5 символов в диалог капчи', imgui.SameLine())
        if aenter.v then
            imgui.Text(u8'Задержка АвтоНажатия ENTER')
            ShowHelpMarker(u8'Установка задержки перед нажатием ETNER после того как вы напишите 5 цифр', imgui.SameLine())
            imgui.SliderInt(u8"##3", waitaenter, 0, 1000)
            imgui.SameLine(15, nil)
            imgui.NewLine()
        end
        imgui.Checkbox(u8'Таймер', presentime)
        ShowHelpMarker(u8'Показывает настоящее время', imgui.SameLine())
        if imgui.Button('Save', imgui.ImVec2(180, 25)) then  
            mainIni.config.buttoncaptchaNew = buttoncaptcha.v
            mainIni.config.floodnNew = floodn.v
            mainIni.config.tagsNew = tags.v
            mainIni.config.ptimeNew = ptime.v
            mainIni.config.nClearNew = nClear.v
            mainIni.config.max5New = max5.v
            mainIni.config.aenterNew = aenter.v 
            mainIni.config.waitaenterNew = waitaenter.v 
            mainIni.config.presentimeNew = presentime.v
            inicfg.save(mainIni, '_rally.ini')
            printStringNow('Saved', 1000)
            addOneOffSound(0.0, 0.0, 0.0, 1138)
            printStringNow('Saved', 1000)
        end
        imgui.SameLine()
        if imgui.Button('Clear-set', imgui.ImVec2(180, 25)) then  
            buttoncaptcha.v = false
            floodn.v = false
            tags.v = false
            ptime.v = false
            nClear.v = false
            max5.v = false
            delcars.v = false
            delchars.v = false
            col.v = false
            aenter.v = false
            waitaenter.v = 0
            presentime.v = false
            printStringNow('Clear', 1000)
            addOneOffSound(0.0, 0.0, 0.0, 1138)
            printStringNow('Clear', 1000)
        end
    end
    if selected == 2 then
        imgui.SliderFloat('Smooth', CFG.Sliders.Smooth, 1.0, 30.0, '%.1f')
        imgui.SliderFloat('FOV', CFG.Sliders.FieldOfVisible, 1.0, 50.0, '%.1f')
        imgui.Checkbox('Enable', CFG.CheckBoxes.Enable)
    end
    if selected == 3 then
        imgui.Checkbox(u8'Открывать капчу по кнопке', buttoncaptcha) 
        if imgui.Button(u8'Открыть капчу') then showCaptcha() end
        if imgui.Button(u8'Очистить текстдравы', imgui.SameLine()) then for i = 1, 400 do sampTextdrawDelete(i) end end
    end
    if selected == 4 then
        imgui.Checkbox(u8'Коллизия', col)
        ShowHelpMarker(u8'Коллизия на игроков', imgui.SameLine())
        imgui.Checkbox(u8'Удаление людей', delchars)
        ShowHelpMarker(u8'Удаляет людей при нажатии на E', imgui.SameLine())
        imgui.Checkbox(u8'Удаление машин', delcars)
        ShowHelpMarker(u8'Удаляет машины при нажатии на R', imgui.SameLine())
    end
    if selected == 5 then
        if imgui.Button(u8"Перейти на страницу автора", imgui.ImVec2(365, 30)) then imgui.OpenPopup(u8"Подтверждение##6")   end
        if imgui.BeginPopupModal(u8"Подтверждение##6", _, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoMove)  then
            if imgui.Button(u8"Да перейти##6", imgui.ImVec2(100, 30)) then
                os.execute('explorer "https://vk.com/sanders_scripts"')
                imgui.CloseCurrentPopup()
            end
            imgui.SameLine()
                 if imgui.Button(u8"Я передумал##6", imgui.ImVec2(100, 30)) then
                    imgui.CloseCurrentPopup()
                end
                imgui.EndPopup()
        end
    end
    imgui.EndChild()
    imgui.End()
    end
end




function samp_create_sync_data(sync_type, copy_from_player)
    local ffi = require 'ffi'
    local sampfuncs = require 'sampfuncs'
    -- from SAMP.Lua
    local raknet = require 'samp.raknet'
    require 'samp.synchronization'

    copy_from_player = copy_from_player or true
    local sync_traits = {
        player = {'PlayerSyncData', raknet.PACKET.PLAYER_SYNC, sampStorePlayerOnfootData},
        vehicle = {'VehicleSyncData', raknet.PACKET.VEHICLE_SYNC, sampStorePlayerIncarData},
        passenger = {'PassengerSyncData', raknet.PACKET.PASSENGER_SYNC, sampStorePlayerPassengerData},
        aim = {'AimSyncData', raknet.PACKET.AIM_SYNC, sampStorePlayerAimData},
        trailer = {'TrailerSyncData', raknet.PACKET.TRAILER_SYNC, sampStorePlayerTrailerData},
        unoccupied = {'UnoccupiedSyncData', raknet.PACKET.UNOCCUPIED_SYNC, nil},
        bullet = {'BulletSyncData', raknet.PACKET.BULLET_SYNC, nil},
        spectator = {'SpectatorSyncData', raknet.PACKET.SPECTATOR_SYNC, nil}
    }
    local sync_info = sync_traits[sync_type]
    local data_type = 'struct ' .. sync_info[1]
    local data = ffi.new(data_type, {})
    local raw_data_ptr = tonumber(ffi.cast('uintptr_t', ffi.new(data_type .. '*', data)))
    -- copy player's sync data to the allocated memory
    if copy_from_player then
        local copy_func = sync_info[3]
        if copy_func then
            local _, player_id
            if copy_from_player == true then
                _, player_id = sampGetPlayerIdByCharHandle(PLAYER_PED)
            else
                player_id = tonumber(copy_from_player)
            end
            copy_func(player_id, raw_data_ptr)
        end
    end
    -- function to send packet
    local func_send = function()
        local bs = raknetNewBitStream()
        raknetBitStreamWriteInt8(bs, sync_info[2])
        raknetBitStreamWriteBuffer(bs, raw_data_ptr, ffi.sizeof(data))
        raknetSendBitStreamEx(bs, sampfuncs.HIGH_PRIORITY, sampfuncs.UNRELIABLE_SEQUENCED, 1)
        raknetDeleteBitStream(bs)
    end
    -- metatable to access sync data and 'send' function
    local mt = {
        __index = function(t, index)
            return data[index]
        end,
        __newindex = function(t, index, value)
            data[index] = value
        end
    }
    return setmetatable({send = func_send}, mt)
end

function emul_rpc(hook, parameters)
    local bs_io = require 'samp.events.bitstream_io'
    local handler = require 'samp.events.handlers'
    local extra_types = require 'samp.events.extra_types'
    local hooks = {

        --[[ Outgoing rpcs
        ['onSendEnterVehicle'] = { 'int16', 'bool8', 26 },
        ['onSendClickPlayer'] = { 'int16', 'int8', 23 },
        ['onSendClientJoin'] = { 'int32', 'int8', 'string8', 'int32', 'string8', 'string8', 'int32', 25 },
        ['onSendEnterEditObject'] = { 'int32', 'int16', 'int32', 'vector3d', 27 },
        ['onSendCommand'] = { 'string32', 50 },
        ['onSendSpawn'] = { 52 },
        ['onSendDeathNotification'] = { 'int8', 'int16', 53 },
        ['onSendDialogResponse'] = { 'int16', 'int8', 'int16', 'string8', 62 },
        ['onSendClickTextDraw'] = { 'int16', 83 },
        ['onSendVehicleTuningNotification'] = { 'int32', 'int32', 'int32', 'int32', 96 },
        ['onSendChat'] = { 'string8', 101 },
        ['onSendClientCheckResponse'] = { 'int8', 'int32', 'int8', 103 },
        ['onSendVehicleDamaged'] = { 'int16', 'int32', 'int32', 'int8', 'int8', 106 },
        ['onSendEditAttachedObject'] = { 'int32', 'int32', 'int32', 'int32', 'vector3d', 'vector3d', 'vector3d', 'int32', 'int32', 116 },
        ['onSendEditObject'] = { 'bool', 'int16', 'int32', 'vector3d', 'vector3d', 117 },
        ['onSendInteriorChangeNotification'] = { 'int8', 118 },
        ['onSendMapMarker'] = { 'vector3d', 119 },
        ['onSendRequestClass'] = { 'int32', 128 },
        ['onSendRequestSpawn'] = { 129 },
        ['onSendPickedUpPickup'] = { 'int32', 131 },
        ['onSendMenuSelect'] = { 'int8', 132 },
        ['onSendVehicleDestroyed'] = { 'int16', 136 },
        ['onSendQuitMenu'] = { 140 },
        ['onSendExitVehicle'] = { 'int16', 154 },
        ['onSendUpdateScoresAndPings'] = { 155 },
        ['onSendGiveDamage'] = { 'int16', 'float', 'int32', 'int32', 115 },
        ['onSendTakeDamage'] = { 'int16', 'float', 'int32', 'int32', 115 },]]

        -- Incoming rpcs
        ['onInitGame'] = { 139 },
        ['onPlayerJoin'] = { 'int16', 'int32', 'bool8', 'string8', 137 },
        ['onPlayerQuit'] = { 'int16', 'int8', 138 },
        ['onRequestClassResponse'] = { 'bool8', 'int8', 'int32', 'int8', 'vector3d', 'float', 'Int32Array3', 'Int32Array3', 128 },
        ['onRequestSpawnResponse'] = { 'bool8', 129 },
        ['onSetPlayerName'] = { 'int16', 'string8', 'bool8', 11 },
        ['onSetPlayerPos'] = { 'vector3d', 12 },
        ['onSetPlayerPosFindZ'] = { 'vector3d', 13 },
        ['onSetPlayerHealth'] = { 'float', 14 },
        ['onTogglePlayerControllable'] = { 'bool8', 15 },
        ['onPlaySound'] = { 'int32', 'vector3d', 16 },
        ['onSetWorldBounds'] = { 'float', 'float', 'float', 'float', 17 },
        ['onGivePlayerMoney'] = { 'int32', 18 },
        ['onSetPlayerFacingAngle'] = { 'float', 19 },
        --['onResetPlayerMoney'] = { 20 },
        --['onResetPlayerWeapons'] = { 21 },
        ['onGivePlayerWeapon'] = { 'int32', 'int32', 22 },
        --['onCancelEdit'] = { 28 },
        ['onSetPlayerTime'] = { 'int8', 'int8', 29 },
        ['onSetToggleClock'] = { 'bool8', 30 },
        ['onPlayerStreamIn'] = { 'int16', 'int8', 'int32', 'vector3d', 'float', 'int32', 'int8', 32 },
        ['onSetShopName'] = { 'string256', 33 },
        ['onSetPlayerSkillLevel'] = { 'int16', 'int32', 'int16', 34 },
        ['onSetPlayerDrunk'] = { 'int32', 35 },
        ['onCreate3DText'] = { 'int16', 'int32', 'vector3d', 'float', 'bool8', 'int16', 'int16', 'encodedString4096', 36 },
        --['onDisableCheckpoint'] = { 37 },
        ['onSetRaceCheckpoint'] = { 'int8', 'vector3d', 'vector3d', 'float', 38 },
        --['onDisableRaceCheckpoint'] = { 39 },
        --['onGamemodeRestart'] = { 40 },
        ['onPlayAudioStream'] = { 'string8', 'vector3d', 'float', 'bool8', 41 },
        --['onStopAudioStream'] = { 42 },
        ['onRemoveBuilding'] = { 'int32', 'vector3d', 'float', 43 },
        ['onCreateObject'] = { 44 },
        ['onSetObjectPosition'] = { 'int16', 'vector3d', 45 },
        ['onSetObjectRotation'] = { 'int16', 'vector3d', 46 },
        ['onDestroyObject'] = { 'int16', 47 },
        ['onPlayerDeathNotification'] = { 'int16', 'int16', 'int8', 55 },
        ['onSetMapIcon'] = { 'int8', 'vector3d', 'int8', 'int32', 'int8', 56 },
        ['onRemoveVehicleComponent'] = { 'int16', 'int16', 57 },
        ['onRemove3DTextLabel'] = { 'int16', 58 },
        ['onPlayerChatBubble'] = { 'int16', 'int32', 'float', 'int32', 'string8', 59 },
        ['onUpdateGlobalTimer'] = { 'int32', 60 },
        ['onShowDialog'] = { 'int16', 'int8', 'string8', 'string8', 'string8', 'encodedString4096', 61 },
        ['onDestroyPickup'] = { 'int32', 63 },
        ['onLinkVehicleToInterior'] = { 'int16', 'int8', 65 },
        ['onSetPlayerArmour'] = { 'float', 66 },
        ['onSetPlayerArmedWeapon'] = { 'int32', 67 },
        ['onSetSpawnInfo'] = { 'int8', 'int32', 'int8', 'vector3d', 'float', 'Int32Array3', 'Int32Array3', 68 },
        ['onSetPlayerTeam'] = { 'int16', 'int8', 69 },
        ['onPutPlayerInVehicle'] = { 'int16', 'int8', 70 },
        --['onRemovePlayerFromVehicle'] = { 71 },
        ['onSetPlayerColor'] = { 'int16', 'int32', 72 },
        ['onDisplayGameText'] = { 'int32', 'int32', 'string32', 73 },
        --['onForceClassSelection'] = { 74 },
        ['onAttachObjectToPlayer'] = { 'int16', 'int16', 'vector3d', 'vector3d', 75 },
        ['onInitMenu'] = { 76 },
        ['onShowMenu'] = { 'int8', 77 },
        ['onHideMenu'] = { 'int8', 78 },
        ['onCreateExplosion'] = { 'vector3d', 'int32', 'float', 79 },
        ['onShowPlayerNameTag'] = { 'int16', 'bool8', 80 },
        ['onAttachCameraToObject'] = { 'int16', 81 },
        ['onInterpolateCamera'] = { 'bool', 'vector3d', 'vector3d', 'int32', 'int8', 82 },
        ['onGangZoneStopFlash'] = { 'int16', 85 },
        ['onApplyPlayerAnimation'] = { 'int16', 'string8', 'string8', 'bool', 'bool', 'bool', 'bool', 'int32', 86 },
        ['onClearPlayerAnimation'] = { 'int16', 87 },
        ['onSetPlayerSpecialAction'] = { 'int8', 88 },
        ['onSetPlayerFightingStyle'] = { 'int16', 'int8', 89 },
        ['onSetPlayerVelocity'] = { 'vector3d', 90 },
        ['onSetVehicleVelocity'] = { 'bool8', 'vector3d', 91 },
        ['onServerMessage'] = { 'int32', 'string32', 93 },
        ['onSetWorldTime'] = { 'int8', 94 },
        ['onCreatePickup'] = { 'int32', 'int32', 'int32', 'vector3d', 95 },
        ['onMoveObject'] = { 'int16', 'vector3d', 'vector3d', 'float', 'vector3d', 99 },
        ['onEnableStuntBonus'] = { 'bool', 104 },
        ['onTextDrawSetString'] = { 'int16', 'string16', 105 },
        ['onSetCheckpoint'] = { 'vector3d', 'float', 107 },
        ['onCreateGangZone'] = { 'int16', 'vector2d', 'vector2d', 'int32', 108 },
        ['onPlayCrimeReport'] = { 'int16', 'int32', 'int32', 'int32', 'int32', 'vector3d', 112 },
        ['onGangZoneDestroy'] = { 'int16', 120 },
        ['onGangZoneFlash'] = { 'int16', 'int32', 121 },
        ['onStopObject'] = { 'int16', 122 },
        ['onSetVehicleNumberPlate'] = { 'int16', 'string8', 123 },
        ['onTogglePlayerSpectating'] = { 'bool32', 124 },
        ['onSpectatePlayer'] = { 'int16', 'int8', 126 },
        ['onSpectateVehicle'] = { 'int16', 'int8', 127 },
        ['onShowTextDraw'] = { 134 },
        ['onSetPlayerWantedLevel'] = { 'int8', 133 },
        ['onTextDrawHide'] = { 'int16', 135 },
        ['onRemoveMapIcon'] = { 'int8', 144 },
        ['onSetWeaponAmmo'] = { 'int8', 'int16', 145 },
        ['onSetGravity'] = { 'float', 146 },
        ['onSetVehicleHealth'] = { 'int16', 'float', 147 },
        ['onAttachTrailerToVehicle'] = { 'int16', 'int16', 148 },
        ['onDetachTrailerFromVehicle'] = { 'int16', 149 },
        ['onSetWeather'] = { 'int8', 152 },
        ['onSetPlayerSkin'] = { 'int32', 'int32', 153 },
        ['onSetInterior'] = { 'int8', 156 },
        ['onSetCameraPosition'] = { 'vector3d', 157 },
        ['onSetCameraLookAt'] = { 'vector3d', 'int8', 158 },
        ['onSetVehiclePosition'] = { 'int16', 'vector3d', 159 },
        ['onSetVehicleAngle'] = { 'int16', 'float', 160 },
        ['onSetVehicleParams'] = { 'int16', 'int16', 'bool8', 161 },
        --['onSetCameraBehind'] = { 162 },
        ['onChatMessage'] = { 'int16', 'string8', 101 },
        ['onConnectionRejected'] = { 'int8', 130 },
        ['onPlayerStreamOut'] = { 'int16', 163 },
        ['onVehicleStreamIn'] = { 164 },
        ['onVehicleStreamOut'] = { 'int16', 165 },
        ['onPlayerDeath'] = { 'int16', 166 },
        ['onPlayerEnterVehicle'] = { 'int16', 'int16', 'bool8', 26 },
        ['onUpdateScoresAndPings'] = { 'PlayerScorePingMap', 155 },
        ['onSetObjectMaterial'] = { 84 },
        ['onSetObjectMaterialText'] = { 84 },
        ['onSetVehicleParamsEx'] = { 'int16', 'int8', 'int8', 'int8', 'int8', 'int8', 'int8', 'int8', 'int8', 'int8', 'int8', 'int8', 'int8', 'int8', 'int8', 'int8', 'int8', 24 },
        ['onSetPlayerAttachedObject'] = { 'int16', 'int32', 'bool', 'int32', 'int32', 'vector3d', 'vector3d', 'vector3d', 'int32', 'int32', 113 }

    }
    local handler_hook = {
        ['onInitGame'] = true,
        ['onCreateObject'] = true,
        ['onInitMenu'] = true,
        ['onShowTextDraw'] = true,
        ['onVehicleStreamIn'] = true,
        ['onSetObjectMaterial'] = true,
        ['onSetObjectMaterialText'] = true
    }
    local extra = {
        ['PlayerScorePingMap'] = true,
        ['Int32Array3'] = true
    }
        local hook_table = hooks[hook]
    if hook_table then
        local bs = raknetNewBitStream()
        if not handler_hook[hook] then
            local max = #hook_table-1
            if max > 0 then
                for i = 1, max do
                    local p = hook_table[i]
                    if extra[p] then extra_types[p]['write'](bs, parameters[i])
                    else bs_io[p]['write'](bs, parameters[i]) end
                end
            end
        else
            if hook == 'onInitGame' then handler.on_init_game_writer(bs, parameters)
            elseif hook == 'onCreateObject' then handler.on_create_object_writer(bs, parameters)
            elseif hook == 'onInitMenu' then handler.on_init_menu_writer(bs, parameters)
            elseif hook == 'onShowTextDraw' then handler.on_show_textdraw_writer(bs, parameters)
            elseif hook == 'onVehicleStreamIn' then handler.on_vehicle_stream_in_writer(bs, parameters)
            elseif hook == 'onSetObjectMaterial' then handler.on_set_object_material_writer(bs, parameters, 1)
            elseif hook == 'onSetObjectMaterialText' then handler.on_set_object_material_writer(bs, parameters, 2) end
        end
        raknetEmulRpcReceiveBitStream(hook_table[#hook_table], bs)
        raknetDeleteBitStream(bs)
    end
end