--[[
    Copyright 2017 Matthew Hesketh <wrxck0@gmail.com>
    This code is licensed under the MIT. See LICENSE for details.
]]

local randomword = {}
local mattata = require('mattata')
local http = require('socket.http')
local json = require('dkjson')

function randomword:init()
    randomword.commands = mattata.commands(self.info.username)
    :command('randomword')
    :command('rw').table
    randomword.help = '/randomword - Generates a random word. Alias: /rw.'
end

function randomword.get_keyboard(language)
    return mattata.inline_keyboard():row(
        mattata.row():callback_data_button(
            language['randomword']['1'],
            'randomword:new'
        )
    )
end

function randomword:on_callback_query(callback_query, message, configuration, language)
    local str, res = http.request('http://www.setgetgo.com/randomword/get.php')
    if res ~= 200
    then
        return mattata.edit_message_text(
            message.chat.id,
            message.message_id,
            language['errors']['connection']
        )
    end
    return mattata.edit_message_text(
        message.chat.id,
        message.message_id,
        string.format(
            language['randomword']['2'],
            str:lower()
        ),
        'html',
        true,
        randomword.get_keyboard(language)
    )
end

function randomword:on_message(message, configuration, language)
    local str, res = http.request('http://www.setgetgo.com/randomword/get.php')
    if res ~= 200
    then
        return mattata.send_reply(
            message,
            language['errors']['connection']
        )
    end
    return mattata.send_message(
        message.chat.id,
        string.format(
            language['randomword']['2'],
            str:lower()
        ),
        'html',
        true,
        false,
        message.message_id,
        randomword.get_keyboard(language)
    )
end

return randomword