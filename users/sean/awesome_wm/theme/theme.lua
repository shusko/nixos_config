local gears         = require("gears")
local lain          = require("lain")
local awful         = require("awful")
local wibox         = require("wibox")
local dpi           = require("beautiful.xresources").apply_dpi
local os            = os
local my_table      = awful.util.table or gears.table

-- Function to update the volume widget
local volume_widget = wibox.widget { text = "-%", widget = wibox.widget.textbox }
local function update_volume()
    awful.spawn.easy_async("pamixer --get-volume-human",
        -- stdout will contain the volume, e.g., "42%"
        function(stdout)
            volume_widget.text = stdout
        end
    )
end

local theme_dir  = os.getenv("HOME") .. "/.config/awesome/theme"
local theme      = {
    dir                                       = theme_dir,
    wallpaper                                 = theme_dir .. "/wall.png",
    font                                      = "Terminus 9",
    fg_normal                                 = "#DDDDFF",
    fg_focus                                  = "#EA6F81",
    titlebar_fg_focus                         = "#EA6F81",
    fg_urgent                                 = "#CC9393",
    bg_normal                                 = "#1A1A1A",
    titlebar_bg_normal                        = "#1A1A1A",
    bg_focus                                  = "#313131",
    titlebar_bg_focus                         = "#313131",
    bg_urgent                                 = "#1A1A1A",
    border_width                              = dpi(1),
    border_normal                             = "#3F3F3F",
    border_focus                              = "#7F7F7F",
    border_marked                             = "#CC9393",
    tasklist_bg_focus                         = "#1A1A1A",
    menu_height                               = dpi(16),
    menu_width                                = dpi(140),
    menu_submenu_icon                         = theme_dir .. "/icons/submenu.png",
    taglist_squares_sel                       = theme_dir .. "/icons/square_sel.png",
    taglist_squares_unsel                     = theme_dir .. "/icons/square_unsel.png",
    layout_tile                               = theme_dir .. "/icons/tile.png",
    layout_tileleft                           = theme_dir .. "/icons/tileleft.png",
    layout_tilebottom                         = theme_dir .. "/icons/tilebottom.png",
    layout_tiletop                            = theme_dir .. "/icons/tiletop.png",
    layout_fairv                              = theme_dir .. "/icons/fairv.png",
    layout_fairh                              = theme_dir .. "/icons/fairh.png",
    layout_spiral                             = theme_dir .. "/icons/spiral.png",
    layout_dwindle                            = theme_dir .. "/icons/dwindle.png",
    layout_max                                = theme_dir .. "/icons/max.png",
    layout_fullscreen                         = theme_dir .. "/icons/fullscreen.png",
    layout_magnifier                          = theme_dir .. "/icons/magnifier.png",
    layout_floating                           = theme_dir .. "/icons/floating.png",
    widget_ac                                 = theme_dir .. "/icons/ac.png",
    widget_battery                            = theme_dir .. "/icons/battery.png",
    widget_battery_low                        = theme_dir .. "/icons/battery_low.png",
    widget_battery_empty                      = theme_dir .. "/icons/battery_empty.png",
    widget_mem                                = theme_dir .. "/icons/mem.png",
    widget_cpu                                = theme_dir .. "/icons/cpu.png",
    widget_temp                               = theme_dir .. "/icons/temp.png",
    widget_net                                = theme_dir .. "/icons/net.png",
    widget_hdd                                = theme_dir .. "/icons/hdd.png",
    widget_music                              = theme_dir .. "/icons/note.png",
    widget_music_on                           = theme_dir .. "/icons/note_on.png",
    widget_vol                                = theme_dir .. "/icons/vol.png",
    widget_vol_low                            = theme_dir .. "/icons/vol_low.png",
    widget_vol_no                             = theme_dir .. "/icons/vol_no.png",
    widget_vol_mute                           = theme_dir .. "/icons/vol_mute.png",
    widget_mail                               = theme_dir .. "/icons/mail.png",
    widget_mail_on                            = theme_dir .. "/icons/mail_on.png",
    tasklist_plain_task_name                  = true,
    tasklist_disable_icon                     = true,
    useless_gap                               = dpi(5),
    titlebar_close_button_focus               = theme_dir .. "/icons/titlebar/close_focus.png",
    titlebar_close_button_normal              = theme_dir .. "/icons/titlebar/close_normal.png",
    titlebar_ontop_button_focus_active        = theme_dir .. "/icons/titlebar/ontop_focus_active.png",
    titlebar_ontop_button_normal_active       = theme_dir .. "/icons/titlebar/ontop_normal_active.png",
    titlebar_ontop_button_focus_inactive      = theme_dir .. "/icons/titlebar/ontop_focus_inactive.png",
    titlebar_ontop_button_normal_inactive     = theme_dir .. "/icons/titlebar/ontop_normal_inactive.png",
    titlebar_sticky_button_focus_active       = theme_dir .. "/icons/titlebar/sticky_focus_active.png",
    titlebar_sticky_button_normal_active      = theme_dir .. "/icons/titlebar/sticky_normal_active.png",
    titlebar_sticky_button_focus_inactive     = theme_dir .. "/icons/titlebar/sticky_focus_inactive.png",
    titlebar_sticky_button_normal_inactive    = theme_dir .. "/icons/titlebar/sticky_normal_inactive.png",
    titlebar_floating_button_focus_active     = theme_dir .. "/icons/titlebar/floating_focus_active.png",
    titlebar_floating_button_normal_active    = theme_dir .. "/icons/titlebar/floating_normal_active.png",
    titlebar_floating_button_focus_inactive   = theme_dir .. "/icons/titlebar/floating_focus_inactive.png",
    titlebar_floating_button_normal_inactive  = theme_dir .. "/icons/titlebar/floating_normal_inactive.png",
    titlebar_maximized_button_focus_active    = theme_dir .. "/icons/titlebar/maximized_focus_active.png",
    titlebar_maximized_button_normal_active   = theme_dir .. "/icons/titlebar/maximized_normal_active.png",
    titlebar_maximized_button_focus_inactive  = theme_dir .. "/icons/titlebar/maximized_focus_inactive.png",
    titlebar_maximized_button_normal_inactive = theme_dir .. "/icons/titlebar/maximized_normal_inactive.png",
}

local markup     = lain.util.markup
local separators = lain.util.separators

-- Textclock
local clockicon  = wibox.widget.imagebox(theme.widget_clock)
local clock      = awful.widget.watch(
    "date +'%a %d %b %R'", 60,
    function(widget, stdout)
        widget:set_markup(" " .. markup.font(theme.font, stdout))
    end
)

-- Calendar
theme.cal        = lain.widget.cal({
    attach_to = { clock },
    notification_preset = {
        font = "Terminus 10",
        fg   = theme.fg_normal,
        bg   = theme.bg_normal
    }
})

-- Mail IMAP check
-- local mailicon   = wibox.widget.imagebox(theme.widget_mail)
--[[ commented because it needs to be set before use
mailicon:buttons(my_table.join(awful.button({ }, 1, function () awful.spawn(mail) end)))
theme.mail = lain.widget.imap({
    timeout  = 180,
    server   = "server",
    mail     = "mail",
    password = "keyring get mail",
    settings = function()
        if mailcount > 0 then
            widget:set_markup(markup.font(theme.font, " " .. mailcount .. " "))
            mailicon:set_image(theme.widget_mail_on)
        else
            widget:set_text("")
            mailicon:set_image(theme.widget_mail)
        end
    end
})
--]]

-- -- MPD
-- local musicplr = awful.util.terminal .. " -title Music -e ncmpcpp"
-- local mpdicon = wibox.widget.imagebox(theme.widget_music)
-- mpdicon:buttons(my_table.join(
--     awful.button({ "Mod4" }, 1, function() awful.spawn(musicplr) end),
--     awful.button({}, 1, function()
--         os.execute("mpc prev")
--         theme.mpd.update()
--     end),
--     awful.button({}, 2, function()
--         os.execute("mpc toggle")
--         theme.mpd.update()
--     end),
--     awful.button({}, 3, function()
--         os.execute("mpc next")
--         theme.mpd.update()
--     end)))
-- theme.mpd = lain.widget.mpd({
--     settings = function()
--         if mpd_now.state == "play" then
--             artist = " " .. mpd_now.artist .. " "
--             title  = mpd_now.title .. " "
--             mpdicon:set_image(theme.widget_music_on)
--         elseif mpd_now.state == "pause" then
--             artist = " mpd "
--             title  = "paused "
--         else
--             artist = ""
--             title  = ""
--             mpdicon:set_image(theme.widget_music)
--         end
--
--         widget:set_markup(markup.font(theme.font, markup("#EA6F81", artist) .. title))
--     end
-- })

-- / fs
-- local fsicon = wibox.widget.imagebox(theme.widget_hdd)
--[[ commented because it needs Gio/Glib >= 2.54
theme.fs = lain.widget.fs({
    notification_preset = { fg = theme.fg_normal, bg = theme.bg_normal, font = "Terminus 10" },
    settings = function()
        widget:set_markup(markup.font(theme.font, " " .. fs_now["/"].percentage .. "% "))
    end
})
--]]

-- MEM
local memicon = wibox.widget.imagebox(theme.widget_mem)
local mem = lain.widget.mem({
    settings = function()
        local fmt = string.format(" %.2f GB ", mem_now.used / 1024)
        widget:set_markup(markup.font(theme.font, fmt))
    end
})

-- CPU
local cpuicon = wibox.widget.imagebox(theme.widget_cpu)
local cpu = lain.widget.cpu({
    settings = function()
        widget:set_markup(markup.font(theme.font, " " .. cpu_now.usage .. "% "))
    end
})

-- Battery
local baticon = wibox.widget.imagebox(theme.widget_battery)
local bat = lain.widget.bat({
    settings = function()
        if bat_now.status and bat_now.status ~= "N/A" then
            if bat_now.ac_status == 1 then
                baticon:set_image(theme.widget_ac)
            elseif not bat_now.perc and tonumber(bat_now.perc) <= 5 then
                baticon:set_image(theme.widget_battery_empty)
            elseif not bat_now.perc and tonumber(bat_now.perc) <= 15 then
                baticon:set_image(theme.widget_battery_low)
            else
                baticon:set_image(theme.widget_battery)
            end
            widget:set_markup(markup.font(theme.font, " " .. bat_now.perc .. "% "))
        else
            widget:set_markup(markup.font(theme.font, " AC "))
            baticon:set_image(theme.widget_ac)
        end
    end
})

-- Volume
local volicon = wibox.widget.imagebox(theme.widget_vol)
-- Update the volume widget every 10 seconds to deal with bluetooth for now
gears.timer {
    timeout   = 10,
    autostart = true,
    callback  = update_volume()
}
-- Mouse bindings for the widget (optional)
volume_widget:buttons(
    awful.util.table.join(
        awful.button({}, 1, function() -- left click
            awful.spawn("pamixer --toggle-mute", false)
            update_volume()
        end),
        awful.button({}, 4, function() -- scroll up
            awful.spawn("pamixer --increase 5", false)
            update_volume()
        end),
        awful.button({}, 5, function() -- scroll down
            awful.spawn("pamixer --decrease 5", false)
            update_volume()
        end)
    )
)

-- Net
local neticon = wibox.widget.imagebox(theme.widget_net)
local net     = lain.widget.net({
    settings = function()
        widget:set_markup(markup.font(theme.font,
            markup("#7AC82E", " " .. string.format("%06.1f", net_now.received))
            .. " " ..
            markup("#46A8C3", " " .. string.format("%06.1f", net_now.sent) .. " ")))
    end
})

-- Separators
local spr     = wibox.widget.textbox(' ')
local arrl_dl = separators.arrow_left(theme.bg_focus, "alpha")
local arrl_ld = separators.arrow_left("alpha", theme.bg_focus)

function theme.at_screen_connect(s)
    -- Quake application
    s.quake = lain.util.quake({ app = awful.util.terminal })

    -- If wallpaper is a function, call it with the screen
    local wallpaper = theme.wallpaper
    if type(wallpaper) == "function" then
        wallpaper = wallpaper(s)
    end
    gears.wallpaper.maximized(wallpaper, s, true)

    -- Tags
    awful.tag(awful.util.tagnames, s, awful.layout.layouts[1])

    -- Create a promptbox for each screen
    s.mypromptbox = awful.widget.prompt()
    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    s.mylayoutbox = awful.widget.layoutbox(s)
    s.mylayoutbox:buttons(my_table.join(
        awful.button({}, 1, function() awful.layout.inc(1) end),
        awful.button({}, 2, function() awful.layout.set(awful.layout.layouts[1]) end),
        awful.button({}, 3, function() awful.layout.inc(-1) end),
        awful.button({}, 4, function() awful.layout.inc(1) end),
        awful.button({}, 5, function() awful.layout.inc(-1) end)))
    -- Create a taglist widget
    s.mytaglist = awful.widget.taglist(s, awful.widget.taglist.filter.all, awful.util.taglist_buttons)

    -- Create a tasklist widget
    s.mytasklist = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, awful.util.tasklist_buttons)

    -- Create the wibox
    s.mywibox = awful.wibar({ position = "top", screen = s, height = dpi(18), bg = theme.bg_normal, fg = theme.fg_normal })

    -- Add widgets to the wibox
    s.mywibox:setup {
        layout = wibox.layout.align.horizontal,
        { -- Left widgets
            layout = wibox.layout.fixed.horizontal,
            --spr,
            s.mytaglist,
            s.mypromptbox,
            spr,
        },
        s.mytasklist, -- Middle widget
        {             -- Right widgets
            layout = wibox.layout.fixed.horizontal,
            spr,
            spr,
            wibox.widget.systray(),
            spr,
            arrl_ld,
            wibox.container.background(volicon, theme.bg_focus),
            wibox.container.background(volume_widget, theme.bg_focus),
            arrl_dl,
            memicon,
            mem.widget,
            arrl_ld,
            wibox.container.background(cpuicon, theme.bg_focus),
            wibox.container.background(cpu.widget, theme.bg_focus),
            arrl_dl,
            baticon,
            bat.widget,
            arrl_ld,
            wibox.container.background(neticon, theme.bg_focus),
            wibox.container.background(net.widget, theme.bg_focus),
            arrl_dl,
            spr,
            clock,
            spr,
            arrl_ld,
            wibox.container.background(spr, theme.bg_focus),
            wibox.container.background(s.mylayoutbox, theme.bg_focus),
        },
    }
end

return theme
