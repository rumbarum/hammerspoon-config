-- hammerspoon config

require('luarocks.loader')

require('johngrib.hammerspoon.caffein'):init({'shift'}, 'f15')
require('modules.mouse'):init('f14')

local f13_mode = hs.hotkey.modal.new()
local f14_mode = hs.hotkey.modal.new()
local f15_mode = hs.hotkey.modal.new()
local f16_mode = hs.hotkey.modal.new()
local vim_mode = require('modules.vim'):init(f13_mode)

hs.hotkey.bind({}, 'f15', function() f15_mode:enter() end, function() f15_mode:exit() end)
hs.hotkey.bind({}, 'f16', function() f16_mode:enter() end, function() f16_mode:exit() end)

do  -- hints
    f13_mode:bind({}, 'space', hs.hints.windowHints)
    hs.hints.hintChars = {'u', 'i', 'o', 'p', 'h', 'j', 'k', 'l', 'm', ',', '.' }
end

do  -- f13 (vimlike)
    hs.hotkey.bind({}, 'f13', vim_mode.on, vim_mode.off)
    hs.hotkey.bind({'cmd'}, 'f13', vim_mode.on, vim_mode.off)
    hs.hotkey.bind({'shift'}, 'f13', vim_mode.on, vim_mode.off)

    f13_mode:bind({'shift'}, 'r', hs.reload, vim_mode.close)
end

do  -- f13 (tab move)
    local tabTable = {}

    tabTable['Slack'] = {
        left = { mod = {'option'}, key = 'up' },
        right = { mod = {'option'}, key = 'down' }
    }
    tabTable['Safari'] = {
        left = { mod = {'control', 'shift'}, key = 'tab' },
        right = { mod = {'control'}, key = 'tab' }
    }
    tabTable['터미널'] = {
        left = { mod = {'control', 'shift'}, key = 'tab' },
        right = { mod = {'control'}, key = 'tab' }
    }
    tabTable['_else_'] = {
        left = { mod = {'control'}, key = 'pageup' },
        right = { mod = {'control'}, key = 'pagedown' }
    }

    local function tabMove(dir)
        return function()
            local activeAppName = hs.application.frontmostApplication():name()
            local tab = tabTable[activeAppName] or tabTable['_else_']
            hs.eventtap.keyStroke(tab[dir]['mod'], tab[dir]['key'])
        end
    end

    f13_mode:bind({}, ',', tabMove('left'), vim_mode.close, tabMove('left'))
    f13_mode:bind({}, '.', tabMove('right'), vim_mode.close, tabMove('right'))
end

do  -- app manager
    local app_man = require('modules.appman')
    local mode = f15_mode

    -- mode:bind({}, 'c', app_man:toggle('Google Chrome'))
    mode:bind({}, 'c', function() hs.eventtap.keyStroke({'ctrl'}, '2') end)
    mode:bind({}, 'i', app_man:toggle('IntelliJ IDEA'))
    -- mode:bind({}, 't', app_man:toggle('iTerm'))
    mode:bind({}, 'l', app_man:toggle('Line'))
    mode:bind({}, 'q', app_man:toggle('Sequel Pro'))
    mode:bind({}, 'v', app_man:toggle('MacVim'))
    mode:bind({}, 'n', app_man:toggle('Notes'))
    mode:bind({}, 's', app_man:toggle('Slack'))
    mode:bind({}, 'f', app_man:toggle('Safari'))

    mode:bind({'shift'}, 'tab', app_man.focusPreviousScreen)
    mode:bind({}, 'tab', app_man.focusNextScreen)

    hs.hotkey.bind({'cmd', 'shift'}, 'space', app_man:toggle('Terminal'))
end

do  -- winmove
    local win_move = require('johngrib.hammerspoon.winmove')
    local mode = f15_mode

    mode:bind({}, '1', win_move.left_bottom)
    mode:bind({}, '2', win_move.bottom)
    mode:bind({}, '3', win_move.right_bottom)
    mode:bind({}, '4', win_move.left)
    mode:bind({}, '5', win_move.full_screen)
    mode:bind({}, '6', win_move.right)
    mode:bind({}, '7', win_move.left_top)
    mode:bind({}, '8', win_move.top)
    mode:bind({}, '9', win_move.right_top)
    mode:bind({}, '-', win_move.prev_screen)
    mode:bind({}, '=', win_move.next_screen)
end

do  -- clipboard history
    local clipboard = require('modules.clipboard')
    clipboard.setSize(10)
    f15_mode:bind({}, '`', clipboard.showList)
    f15_mode:bind({'shift'}, '`', clipboard.clear)
end

hs.alert.show('loaded')

