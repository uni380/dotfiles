hs.hotkey.alertDuration = 0
hs.hints.showTitleThresh = 0
hs.window.animationDuration = 0

modal_list = {}

--------------------------------------------------------------------------------
-- Helper functions {{{
--------------------------------------------------------------------------------

function showavailableHotkey()
    if not hotkeytext then
        local hotkey_list=hs.hotkey.getHotkeys()
        local mainScreen = hs.screen.mainScreen()
        local mainRes = mainScreen:fullFrame()
        local hkbgrect = hs.geometry.rect(mainRes.w/5,mainRes.h/5,mainRes.w/5*3,mainRes.h/5*3)
        hotkeybg = hs.drawing.rectangle(hkbgrect)
        -- hotkeybg:setStroke(false)
        hotkeybg:setFillColor({red=0,blue=0,green=0,alpha=0.5})
        hotkeybg:setRoundedRectRadii(10,10)
        hotkeybg:setLevel(hs.drawing.windowLevels.modalPanel)
        hotkeybg:setBehavior(hs.drawing.windowBehaviors.stationary)
        local hktextrect = hs.geometry.rect(hkbgrect.x+40,hkbgrect.y+30,hkbgrect.w-80,hkbgrect.h-60)
        hotkeytext = hs.drawing.text(hktextrect,"")
        hotkeytext:setLevel(hs.drawing.windowLevels.modalPanel)
        hotkeytext:setBehavior(hs.drawing.windowBehaviors.stationary)
        hotkeytext:setClickCallback(nil,function() hotkeytext:delete() hotkeytext=nil hotkeybg:delete() hotkeybg=nil end)
        hotkey_filtered = {}
        for i=1,#hotkey_list do
            if hotkey_list[i].idx ~= hotkey_list[i].msg then
                table.insert(hotkey_filtered,hotkey_list[i])
            end
        end
        local availablelen = 70
        local hkstr = ''
        for i=2,#hotkey_filtered,2 do
            local tmpstr = hotkey_filtered[i-1].msg .. hotkey_filtered[i].msg
            if string.len(tmpstr)<= availablelen then
                local tofilllen = availablelen-string.len(hotkey_filtered[i-1].msg)
                hkstr = hkstr .. hotkey_filtered[i-1].msg .. string.format('%'..tofilllen..'s',hotkey_filtered[i].msg) .. '\n'
            else
                hkstr = hkstr .. hotkey_filtered[i-1].msg .. '\n' .. hotkey_filtered[i].msg .. '\n'
            end
        end
        if math.fmod(#hotkey_filtered,2) == 1 then hkstr = hkstr .. hotkey_filtered[#hotkey_filtered].msg end
        local hkstr_styled = hs.styledtext.new(hkstr, {font={name="Courier-Bold",size=16}, color=white, paragraphStyle={lineSpacing=12.0,lineBreak='truncateMiddle'}})
        hotkeytext:setStyledText(hkstr_styled)
        hotkeybg:show()
        hotkeytext:show()
    else
        hotkeytext:delete()
        hotkeytext=nil
        hotkeybg:delete()
        hotkeybg=nil
    end
end

function exit_others(except)
    for i = 1, #modal_list do
        if modal_list[i] ~= except then
            modal_list[i]:exit()
        end
    end
end

-- }}}

--------------------------------------------------------------------------------
-- View mode {{{
--------------------------------------------------------------------------------

viewM = hs.hotkey.modal.new()
table.insert(modal_list, viewM)
function viewM:entered()
    hs.alert.show('View mode entered')
    if hotkeytext then
        hotkeytext:delete()
        hotkeytext=nil
        hotkeybg:delete()
        hotkeybg=nil
    end
end
function viewM:exited()
    hs.alert.show('View mode exited')
    if hotkeytext then
        hotkeytext:delete()
        hotkeytext=nil
        hotkeybg:delete()
        hotkeybg=nil
    end
end
viewM:bind('', 'escape', function() viewM:exit() end)
viewM:bind('', 'Q', function() viewM:exit() end)
viewM:bind('', 'tab', function() showavailableHotkey() end)
viewM:bind('', 'H', 'Scroll Leftward', function() hs.eventtap.scrollWheel({1,0},{},"line") end, nil, function() hs.eventtap.scrollWheel({1,0},{},"line") end)
viewM:bind('', 'L', 'Scroll Rightward', function() hs.eventtap.scrollWheel({-1,0},{},"line") end, nil, function() hs.eventtap.scrollWheel({-1,0},{},"line") end)
viewM:bind('', 'J', 'Scroll Downward', function() hs.eventtap.scrollWheel({0,-1},{},"line") end, nil, function() hs.eventtap.scrollWheel({0,-1},{},"line") end)
viewM:bind('', 'K', 'Scroll Upward', function() hs.eventtap.scrollWheel({0,1},{},"line") end, nil, function() hs.eventtap.scrollWheel({0,1},{},"line") end)
viewM:bind('ctrl', 'H', 'Move Mouse Leftward by 50px', function() moveMouseBy(-50,0) end, nil, function() moveMouseBy(-50,0) end)
viewM:bind('ctrl', 'L', 'Move Mouse Rightward by 50px', function() moveMouseBy(50,0) end, nil, function() moveMouseBy(50,0) end)
viewM:bind('ctrl', 'K', 'Move Mouse Upward by 50px', function() moveMouseBy(0,-50) end, nil, function() moveMouseBy(0,-50) end)
viewM:bind('ctrl', 'J', 'Move Mouse Downward by 50px', function() moveMouseBy(0,50) end, nil, function() moveMouseBy(0,50) end)
viewM:bind('shift', 'H', 'Move Mouse Leftward by 10px', function() moveMouseBy(-10,0) end, nil, function() moveMouseBy(-10,0) end)
viewM:bind('shift', 'L', 'Move Mouse Rightward by 10px', function() moveMouseBy(10,0) end, nil, function() moveMouseBy(10,0) end)
viewM:bind('shift', 'K', 'Move Mouse Upward by 10px', function() moveMouseBy(0,-10) end, nil, function() moveMouseBy(0,-10) end)
viewM:bind('shift', 'J', 'Move Mouse Downward by 10px', function() moveMouseBy(0,10) end, nil, function() moveMouseBy(0,10) end)
viewM:bind({'ctrl','shift'}, 'H', 'Move Mouse Leftward by 1px', function() moveMouseBy(-1,0) end, nil, function() moveMouseBy(-1,0) end)
viewM:bind({'ctrl','shift'}, 'L', 'Move Mouse Rightward by 1px', function() moveMouseBy(1,0) end, nil, function() moveMouseBy(1,0) end)
viewM:bind({'ctrl','shift'}, 'K', 'Move Mouse Upward by 1px', function() moveMouseBy(0,-1) end, nil, function() moveMouseBy(0,-1) end)
viewM:bind({'ctrl','shift'}, 'J', 'Move Mouse Downward by 1px', function() moveMouseBy(0,1) end, nil, function() moveMouseBy(0,1) end)
viewM:bind('', ',', 'Left Mouse Click', function() clickWithMouse('left') end, nil, nil)
viewM:bind('', '.', 'Right Mouse Click', function() clickWithMouse('right') end, nil, nil)

function moveMouseBy(offsetx,offsety)
    local currentpos = hs.mouse.getRelativePosition()
    local newpos = hs.geometry.point(currentpos.x+offsetx,currentpos.y+offsety)
    hs.mouse.setRelativePosition(newpos)
end

function clickWithMouse(opts)
    local currentpos = hs.mouse.getRelativePosition()
    if opts == 'left' then
        hs.eventtap.leftClick(currentpos)
    elseif opts == 'right' then
        hs.eventtap.rightClick(currentpos)
    end
end

-- }}}

--------------------------------------------------------------------------------
-- Resize mode {{{
--------------------------------------------------------------------------------

resizeM = hs.hotkey.modal.new()
table.insert(modal_list, resizeM)
function resizeM:entered()
    hs.alert.show('Resize mode entered')
    resize_current_winnum = 1
    resize_win_list = hs.window.visibleWindows()
    if hotkeytext then
        hotkeytext:delete()
        hotkeytext=nil
        hotkeybg:delete()
        hotkeybg=nil
    end
end
function resizeM:exited()
    hs.alert.show('Resize mode exited')
    if hotkeytext then
        hotkeytext:delete()
        hotkeytext=nil
        hotkeybg:delete()
        hotkeybg=nil
    end
end

function resize_win(direction)
    local win = hs.window.focusedWindow()
    if win then
        local f = win:frame()
        local screen = win:screen()
        local max = screen:fullFrame()
        local stepw = max.w/30
        local steph = max.h/30
        if direction == "right" then f.w = f.w+stepw end
        if direction == "left" then f.w = f.w-stepw end
        if direction == "up" then f.h = f.h-steph end
        if direction == "down" then f.h = f.h+steph end
        if direction == "halfright" then f.x = max.w/2 f.y = 0 f.w = max.w/2 f.h = max.h end
        if direction == "halfleft" then f.x = 0 f.y = 0 f.w = max.w/2 f.h = max.h end
        if direction == "halfup" then f.x = 0 f.y = 0 f.w = max.w f.h = max.h/2 end
        if direction == "halfdown" then f.x = 0 f.y = max.h/2 f.w = max.w f.h = max.h/2 end
        if direction == "cornerNE" then f.x = max.w/2 f.y = 0 f.w = max.w/2 f.h = max.h/2 end
        if direction == "cornerSE" then f.x = max.w/2 f.y = max.h/2 f.w = max.w/2 f.h = max.h/2 end
        if direction == "cornerNW" then f.x = 0 f.y = 0 f.w = max.w/2 f.h = max.h/2 end
        if direction == "cornerSW" then f.x = 0 f.y = max.h/2 f.w = max.w/2 f.h = max.h/2 end
        if direction == "center" then f.x = (max.w-f.w)/2 f.y = (max.h-f.h)/2 end
        if direction == "fcenter" then f.x = stepw*5 f.y = steph*5 f.w = stepw*20 f.h = steph*20 end
        if direction == "fullscreen" then f = max end
        if direction == "shrink" then f.x = f.x+stepw f.y = f.y+steph f.w = f.w-(stepw*2) f.h = f.h-(steph*2) end
        if direction == "expand" then f.x = f.x-stepw f.y = f.y-steph f.w = f.w+(stepw*2) f.h = f.h+(steph*2) end
        if direction == "mright" then f.x = f.x+stepw end
        if direction == "mleft" then f.x = f.x-stepw end
        if direction == "mup" then f.y = f.y-steph end
        if direction == "mdown" then f.y = f.y+steph end
        win:setFrame(f)
    else
        hs.alert.show("No focused window!")
    end
end

resizeM:bind('', 'escape', function() resizeM:exit() end)
resizeM:bind('', 'Q', function() resizeM:exit() end)
resizeM:bind('', 'tab', function() showavailableHotkey() end)
resizeM:bind('', 'H', 'Shrink Leftward', function() resize_win('left') end, nil, function() resize_win('left') end)
resizeM:bind('', 'L', 'Stretch Rightward', function() resize_win('right') end, nil, function() resize_win('right') end)
resizeM:bind('', 'J', 'Stretch Downward', function() resize_win('down') end, nil, function() resize_win('down') end)
resizeM:bind('', 'K', 'Shrink Upward', function() resize_win('up') end, nil, function() resize_win('up') end)
resizeM:bind('', 'F', 'Fullscreen', function() resize_win('fullscreen') end, nil, nil)
resizeM:bind('', 'C', 'Center Window', function() resize_win('center') end, nil, nil)
resizeM:bind('ctrl', 'C', 'Resize & Center', function() resize_win('fcenter') end, nil, nil)
resizeM:bind('ctrl', 'H', 'Lefthalf of Screen', function() resize_win('halfleft') end, nil, nil)
resizeM:bind('ctrl', 'J', 'Downhalf of Screen', function() resize_win('halfdown') end, nil, nil)
resizeM:bind('ctrl', 'K', 'Uphalf of Screen', function() resize_win('halfup') end, nil, nil)
resizeM:bind('ctrl', 'L', 'Righthalf of Screen', function() resize_win('halfright') end, nil, nil)
resizeM:bind('ctrl', 'Y', 'NorthWest Corner', function() resize_win('cornerNW') end, nil, nil)
resizeM:bind('ctrl', 'U', 'SouthWest Corner', function() resize_win('cornerSW') end, nil, nil)
resizeM:bind('ctrl', 'I', 'SouthEast Corner', function() resize_win('cornerSE') end, nil, nil)
resizeM:bind('ctrl', 'O', 'NorthEast Corner', function() resize_win('cornerNE') end, nil, nil)
resizeM:bind('', '=', 'Stretch Outward', function() resize_win('expand') end, nil, function() resize_win('expand') end)
resizeM:bind('', '-', 'Shrink Inward', function() resize_win('shrink') end, nil, function() resize_win('shrink') end)
resizeM:bind('shift', 'H', 'Move Leftward', function() resize_win('mleft') end, nil, function() resize_win('mleft') end)
resizeM:bind('shift', 'L', 'Move Rightward', function() resize_win('mright') end, nil, function() resize_win('mright') end)
resizeM:bind('shift', 'J', 'Move Downward', function() resize_win('mdown') end, nil, function() resize_win('mdown') end)
resizeM:bind('shift', 'K', 'Move Upward', function() resize_win('mup') end, nil, function() resize_win('mup') end)
resizeM:bind('cmd', 'H', 'Focus Westward', function() cycle_wins_pre() end, nil, function() cycle_wins_pre() end)
resizeM:bind('cmd', 'L', 'Focus Eastward', function() cycle_wins_next() end, nil, function() cycle_wins_next() end)

function cycle_wins_next()
    resize_win_list[resize_current_winnum]:focus()
    resize_current_winnum = resize_current_winnum + 1
    if resize_current_winnum > #resize_win_list then resize_current_winnum = 1 end
end

function cycle_wins_pre()
    resize_win_list[resize_current_winnum]:focus()
    resize_current_winnum = resize_current_winnum - 1
    if resize_current_winnum < 1 then resize_current_winnum = #resize_win_list end
end

resizeextra_lefthalf_keys = resizeextra_lefthalf_keys or {{"cmd", "alt"}, "left"}
if string.len(resizeextra_lefthalf_keys[2]) > 0 then
    hs.hotkey.bind(resizeextra_lefthalf_keys[1], resizeextra_lefthalf_keys[2], "Lefthalf of Screen", function() resize_win('halfleft') end)
end
resizeextra_righthalf_keys = resizeextra_righthalf_keys or {{"cmd", "alt"}, "right"}
if string.len(resizeextra_righthalf_keys[2]) > 0 then
    hs.hotkey.bind(resizeextra_righthalf_keys[1], resizeextra_righthalf_keys[2], "Righthalf of Screen", function() resize_win('halfright') end)
end
resizeextra_fullscreen_keys = resizeextra_fullscreen_keys or {{"cmd", "alt"}, "up"}
if string.len(resizeextra_fullscreen_keys[2]) > 0 then
    hs.hotkey.bind(resizeextra_fullscreen_keys[1], resizeextra_fullscreen_keys[2], "Fullscreen", function() resize_win('fullscreen') end)
end
resizeextra_fcenter_keys = resizeextra_fcenter_keys or {{"cmd", "alt"}, "down"}
if string.len(resizeextra_fcenter_keys[2]) > 0 then
    hs.hotkey.bind(resizeextra_fcenter_keys[1], resizeextra_fcenter_keys[2], "Resize & Center", function() resize_win('fcenter') end)
end
resizeextra_center_keys = resizeextra_center_keys or {{"cmd", "alt"}, "return"}
if string.len(resizeextra_center_keys[2]) > 0 then
    hs.hotkey.bind(resizeextra_center_keys[1], resizeextra_center_keys[2], "Center Window", function() resize_win('center') end)
end

-- }}}

--------------------------------------------------------------------------------
-- Modal manager {{{
--------------------------------------------------------------------------------

modalmgr_keys = modalmgr_keys or {{"cmd"}, "space"}
modalmgr = hs.hotkey.modal.new(modalmgr_keys[1], modalmgr_keys[2], 'Toggle Modal Supervisor')
function modalmgr:entered()
    if resizeM then
        if launch_resizeM == nil then launch_resizeM = false end
        if launch_resizeM == true then resizeM:enter() end
    end
end

function modalmgr:exited()
    exit_others(nil)
    if hotkeytext then
        hotkeytext:delete()
        hotkeytext=nil
        hotkeybg:delete()
        hotkeybg=nil
    end
end
modalmgr:bind(modalmgr_keys[1], modalmgr_keys[2], "Toggle Modal Supervisor", function() modalmgr:exit() end)

if resizeM then
    resizeM_keys = resizeM_keys or {"alt", "R"}
    if string.len(resizeM_keys[2]) > 0 then
        modalmgr:bind(resizeM_keys[1], resizeM_keys[2], 'Enter Resize Mode', function() exit_others(resizeM) resizeM:enter() end)
    end
end

if viewM then
    viewM_keys = viewM_keys or {"alt", "V"}
    if string.len(viewM_keys[2]) > 0 then
        modalmgr:bind(viewM_keys[1], viewM_keys[2], 'Enter View Mode', function() exit_others(viewM) viewM:enter() end)
    end
end

winhints_keys = winhints_keys or {"alt", "tab"}
if string.len(winhints_keys[2]) > 0 then
    modalmgr:bind(winhints_keys[1], winhints_keys[2], 'Show Windows Hint', function() exit_others(nil) hs.hints.windowHints() end)
end

if modalmgr then
    if launch_modalmgr == nil then launch_modalmgr = true end
    if launch_modalmgr == true then modalmgr:enter() end
end

-- }}}

-- vim:foldmethod=marker:foldenable
