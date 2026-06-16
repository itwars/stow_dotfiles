-- Hyprland Lua configuration
-- Converted from hyprland.conf to comply with Hyprland 0.55+ Lua API
-- See https://wiki.hypr.land/Configuring/Start/

-- Import Catppuccin Mocha color palette
local mocha = require("mocha")

-- Variables
local home     = os.getenv("HOME")
local terminal = "kitty"
local fileManager = "dolphin"
local menu     = "wofi --show drun --insensitive --allow-images"


-------------------
---- AUTOSTART ----
-------------------

-- See https://wiki.hypr.land/Configuring/Basics/Autostart/
hl.on("hyprland.start", function ()
    hl.exec_cmd("hyprctl setcursor catppuccin-mocha-dark-cursors 28")
    hl.exec_cmd("/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1")
    hl.exec_cmd("wl-paste --watch ~/.config/hypr/scripts/clipboard.sh")
    hl.exec_cmd("waybar & swaync & hyprpaper & hypridle &")
    hl.exec_cmd("~/.config/hypr/scripts/wallpaper-random.sh")
    hl.exec_cmd("keepassxc", { workspace = "special:magic silent" })
end)


------------------
---- MONITORS ----
------------------

-- See https://wiki.hypr.land/Configuring/Basics/Monitors/
hl.monitor({
    output   = "DP-3",
    mode     = "preferred",
    position = "auto",
    scale    = 1.0,
})

hl.monitor({
    output   = "eDP-1",
    mode     = "preferred",
    position = "auto",
    scale    = 1.6,
})


-------------------------------
---- ENVIRONMENT VARIABLES ----
-------------------------------

-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Environment-variables/
hl.env("XCURSOR_SIZE", "24")
hl.env("QT_QPA_PLATFORMTHEME", "qt6ct")


----------------------
---- LOOK & FEEL ----
----------------------

-- See https://wiki.hypr.land/Configuring/Basics/Variables/
hl.config({
    xwayland = {
        force_zero_scaling = true,
    },

    general = {
        border_size = 3,

        col = {
            active_border   = { colors = { "rgb(ff0000)", "rgb(ff7700)", "rgb(ffff00)", "rgb(00ff00)", "rgb(0000ff)", "rgb(8b00ff)" }, angle = 0 },
            inactive_border = "rgba(595959aa)",
        },

        resize_on_border = true,
        gaps_in  = 15,
        gaps_out = 25,
        layout   = "master",

        allow_tearing = false,
    },

    decoration = {
        rounding           = 3,
        active_opacity     = 0.9,
        inactive_opacity   = 0.6,
        fullscreen_opacity = 0.9,

        blur = {
            enabled          = true,
            size             = 3,
            passes           = 4,
            new_optimizations = true,
            ignore_opacity   = true,
            xray             = true,
            special          = true,
            popups           = true,
        },

        shadow = {
            enabled      = true,
            range        = 30,
            render_power = 30,
            color        = 0xff0a0a0a,
            offset       = "5 5",
        },
    },

    misc = {
        force_default_wallpaper = 0,
    },
})


----------------------
---- ANIMATIONS -----
----------------------

-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Animations/
hl.curve("overshot",     { type = "bezier", points = { {0.05, 0.9},  {0.1, 1.05}   } })
hl.curve("easeOutExpo",  { type = "bezier", points = { {0.16, 1},    {0.3, 1}      } })
hl.curve("easeOutBack",  { type = "bezier", points = { {0.34, 1.56}, {0.64, 1}     } })
hl.curve("easeInBack",   { type = "bezier", points = { {0.36, 0},    {0.66, -0.56} } })
hl.curve("easeInOutBack",{ type = "bezier", points = { {0.68, -0.6}, {0.32, 1.6}   } })
hl.curve("linear",       { type = "bezier", points = { {0, 0},       {1, 1}        } })

hl.animation({ leaf = "windows",      enabled = true, speed = 3,    bezier = "overshot",      style = "slide" })
hl.animation({ leaf = "windowsOut",   enabled = true, speed = 100, bezier = "easeOutExpo" })
hl.animation({ leaf = "windowsIn",    enabled = true, speed = 7,    bezier = "easeOutBack" })
hl.animation({ leaf = "windowsMove",  enabled = true, speed = 6,    bezier = "easeInOutBack", style = "slide" })
hl.animation({ leaf = "border",       enabled = true, speed = 5,    bezier = "default" })
hl.animation({ leaf = "fade",         enabled = true, speed = 5,    bezier = "easeOutBack" })
hl.animation({ leaf = "fadeDim",      enabled = true, speed = 5,    bezier = "easeOutBack" })
hl.animation({ leaf = "workspaces",   enabled = true, speed = 10,   bezier = "easeOutExpo" })
hl.animation({ leaf = "borderangle",  enabled = true, speed = 100,  bezier = "linear",        style = "loop" })


----------------------
------ LAYOUTS ------
----------------------

-- See https://wiki.hypr.land/Configuring/Layouts/Dwindle-Layout/ for more
hl.config({
    dwindle = {
        preserve_split = true,
    },
})

-- See https://wiki.hypr.land/Configuring/Layouts/Master-Layout/ for more
-- hl.config({
--     master = {
--         new_is_master = true,
--     },
-- })


----------------------
------ INPUT ---------
----------------------

hl.config({
    input = {
        kb_layout  = "fr",
        kb_variant = "mac",
        kb_model   = "",
        kb_options = "ctrl:nocaps",
        kb_rules   = "",

        follow_mouse = 1,
        sensitivity  = 0,

        touchpad = {
            natural_scroll = true,
        },
    },
})


----------------------------------
---- PER-DEVICE INPUT CONFIGS ----
----------------------------------

-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Devices/ for more
hl.device({
    name        = "semico-usb-keyboard",
    kb_layout   = "fr",
    kb_variant  = "",
})

hl.device({
    name        = "epic-mouse-v1",
    sensitivity = -0.5,
})


----------------------------
---- LAYER AND WINDOW RULES
----------------------------

hl.layer_rule({
    name  = "blur-off-waybar",
    match = { namespace = "waybar" },
    blur  = false,
})

-- Example windowrule v1
-- hl.window_rule({
--     name  = "float-kitty",
--     match = { class = "^(kitty)$" },
--     float = true,
-- })

-- Example windowrulev2
-- hl.window_rule({
--     name  = "float-kitty-v2",
--     match = { class = "^(kitty)$", title = "^(kitty)$" },
--     float = true,
-- })

-- See https://wiki.hypr.land/Configuring/Basics/Window-Rules/ for more
-- hl.window_rule({
--     name  = "suppress-maximize",
--     match = { class = ".*" },
--     suppress_event = "maximize",
-- })

-- hl.layer_rule({
--     name   = "no-anim-wofi",
--     match  = { namespace = "wofi" },
--     no_anim = true,
-- })


---------------------
---- KEYBINDINGS ----
---------------------

local mainMod = "SUPER"

-- Example binds, see https://wiki.hypr.land/Configuring/Basics/Binds/ for more

-- Sound through pactl
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("pactl set-sink-volume @DEFAULT_SINK@ +10%"))
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("pactl set-sink-volume @DEFAULT_SINK@ -10%"))
hl.bind("XF86AudioMute",        hl.dsp.exec_cmd("pactl set-sink-mute @DEFAULT_SINK@ toggle"))

-- Brightness through brightnessctl
hl.bind("XF86MonBrightnessUp",   hl.dsp.exec_cmd("brightnessctl set +5%"))
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl set 5%-"))

-- Core binds
hl.bind(mainMod .. " + RETURN",  hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + C",       hl.dsp.window.close())
hl.bind(mainMod .. " + M",       hl.dsp.exit())
hl.bind(mainMod .. " + V",       hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + SPACE",   hl.dsp.exec_cmd(menu))
hl.bind(mainMod .. " + L",       hl.dsp.exec_cmd("hyprlock"))

hl.bind("SUPER + SHIFT + R",     hl.dsp.exec_cmd("hyprctl reload"))
hl.bind("SUPER + SHIFT + D",     hl.dsp.exec_cmd("hyprctl keyword monitor eDP-1, disable"))
hl.bind("SUPER + SHIFT + F",     hl.dsp.exec_cmd("hyprctl keyword monitor eDP-1, enable"))

hl.bind("PRINT",                 hl.dsp.exec_cmd("hyprshot -m window"))
hl.bind("SHIFT + PRINT",         hl.dsp.exec_cmd("hyprshot -m region"))

hl.bind(mainMod .. " + P",       hl.dsp.window.pseudo())
hl.bind(mainMod .. " + F",       hl.dsp.window.fullscreen())
hl.bind(mainMod .. " + W",       hl.dsp.exec_cmd("hyprctl dispatch togglegroup"))

-- Move focus with mainMod + vim keys
hl.bind(mainMod .. " + H",       hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + L",       hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + K",       hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + J",       hl.dsp.focus({ direction = "down" }))

-- Switch workspaces with mainMod + [0-9]
hl.bind(mainMod .. " + 1",       hl.dsp.focus({ workspace = 1 }))
hl.bind(mainMod .. " + 2",       hl.dsp.focus({ workspace = 2 }))
hl.bind(mainMod .. " + 3",       hl.dsp.focus({ workspace = 3 }))
hl.bind(mainMod .. " + 4",       hl.dsp.focus({ workspace = 4 }))
hl.bind(mainMod .. " + 5",       hl.dsp.focus({ workspace = 5 }))
hl.bind(mainMod .. " + 6",       hl.dsp.focus({ workspace = 6 }))
hl.bind(mainMod .. " + 7",       hl.dsp.focus({ workspace = 7 }))
hl.bind(mainMod .. " + 8",       hl.dsp.focus({ workspace = 8 }))
hl.bind(mainMod .. " + 9",       hl.dsp.focus({ workspace = 9 }))
hl.bind(mainMod .. " + 0",       hl.dsp.focus({ workspace = 10 }))

-- Move active window to a workspace with mainMod + SHIFT + [0-9]
-- hl.bind(mainMod .. " + SHIFT + 1",  hl.dsp.window.move({ workspace = 1 }))
-- hl.bind(mainMod .. " + SHIFT + 2",  hl.dsp.window.move({ workspace = 2 }))
-- hl.bind(mainMod .. " + SHIFT + 3",  hl.dsp.window.move({ workspace = 3 }))
-- hl.bind(mainMod .. " + SHIFT + 4",  hl.dsp.window.move({ workspace = 4 }))
-- hl.bind(mainMod .. " + SHIFT + 5",  hl.dsp.window.move({ workspace = 5 }))
-- hl.bind(mainMod .. " + SHIFT + 6",  hl.dsp.window.move({ workspace = 6 }))
-- hl.bind(mainMod .. " + SHIFT + 7",  hl.dsp.window.move({ workspace = 7 }))
-- hl.bind(mainMod .. " + SHIFT + 8",  hl.dsp.window.move({ workspace = 8 }))
-- hl.bind(mainMod .. " + SHIFT + 9",  hl.dsp.window.move({ workspace = 9 }))
-- hl.bind(mainMod .. " + SHIFT + 0",  hl.dsp.window.move({ workspace = 10 }))

-- Special workspace (scratchpad)
hl.bind(mainMod .. " + S",             hl.dsp.workspace.toggle_special("magic"))
hl.bind(mainMod .. " + SHIFT + S",     hl.dsp.window.move({ workspace = "special:magic" }))

-- Scroll through existing workspaces with mainMod + scroll
hl.bind(mainMod .. " + mouse_down",    hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up",      hl.dsp.focus({ workspace = "e-1" }))

-- Move/resize windows with mainMod + LMB/RMB and dragging
hl.bind(mainMod .. " + mouse:272",     hl.dsp.window.drag(),   { mouse = true })
hl.bind(mainMod .. " + mouse:273",     hl.dsp.window.resize(), { mouse = true })

-- Custom binds
hl.bind(mainMod .. " + Z",             hl.dsp.exec_cmd(home .. "/.config/hypr/scripts/wallpaper.sh"))
hl.bind(mainMod .. " + TAB",           hl.dsp.focus({ workspace = "e+1" }))

-- Numeric keypad workspace switching (code:10 = 1 on numpad, etc.)
hl.bind(mainMod .. " + code:10",              hl.dsp.focus({ workspace = 1 }))
hl.bind(mainMod .. " + code:11",              hl.dsp.focus({ workspace = 2 }))
hl.bind(mainMod .. " + code:12",              hl.dsp.focus({ workspace = 3 }))
hl.bind(mainMod .. " + code:13",              hl.dsp.focus({ workspace = 4 }))
hl.bind(mainMod .. " + code:14",              hl.dsp.focus({ workspace = 5 }))

hl.bind(mainMod .. " + SHIFT + code:10",      hl.dsp.window.move({ workspace = 1 }))
hl.bind(mainMod .. " + SHIFT + code:11",      hl.dsp.window.move({ workspace = 2 }))
hl.bind(mainMod .. " + SHIFT + code:12",      hl.dsp.window.move({ workspace = 3 }))
hl.bind(mainMod .. " + SHIFT + code:13",      hl.dsp.window.move({ workspace = 4 }))
hl.bind(mainMod .. " + SHIFT + code:14",      hl.dsp.window.move({ workspace = 5 }))

-- Screen capture
hl.bind("PRINT",  hl.dsp.exec_cmd(home .. "/.config/hypr/scripts/captureAll.sh"))
