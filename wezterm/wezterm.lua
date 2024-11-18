local wezterm = require("wezterm")
local sessionizer = require("sessionizer")

local config = wezterm.config_builder()

config.disable_default_key_bindings = true

config.font = wezterm.font("Hack Nerd Font")
config.hide_tab_bar_if_only_one_tab = true
config.color_scheme = 'kanagawabones'

config.use_fancy_tab_bar = true
config.tab_max_width = 32
config.tab_bar_at_bottom = true
config.window_padding = {
    left = 0,
    right = 0,
    top = 0,
    bottom = 0,
}

local act = wezterm.action
wezterm.on('update-right-status', function(window, pane)
    window:set_right_status(window:active_workspace())
end)

config.leader = { key = "b", mods = "CTRL" }

config.keys = {
    {
        key = "t",
        mods = "LEADER",
        action = wezterm.action_callback(sessionizer.toggle)
    },
    {
        key = "T",
        mods = "LEADER",
        action = act.ShowLauncherArgs {
            flags = 'FUZZY|WORKSPACES'
        }
    },
    {
        key = 'w',
        mods = 'LEADER',
        action = act.ShowTabNavigator
    },
    {
        key = 'i',
        mods = 'LEADER',
        action = act.PromptInputLine {
            description = wezterm.format {
                { Attribute = { Intensity = 'Bold' } },
                { Text = "Enter name for the new workspace: " },
            },
            action = wezterm.action_callback(function(window, pane, line)
                if line then
                    window:perform_action(act.SwitchToWorkspace {
                        name = line,
                    }, pane)
                end
            end)
        }
    },
    {
        key = ',',
        mods = 'LEADER',
        action = act.PromptInputLine {
            description = wezterm.format {
                { Attribute = { Intensity = 'Bold' } },
                { Text = "Enter name for the current tab: " },
            },
            action = wezterm.action_callback(function(window, pane, line)
                if line then
                    window:active_tab():set_title(line)
                end
            end)
        }
    },
    {
        key = "&",
        mods = "LEADER",
        action = act.CloseCurrentTab { confirm = true },

    },
    {
        key = 'n', mods = 'LEADER', action = act.SwitchWorkspaceRelative(1)
    },
    {
        key = 'p', mods = 'LEADER', action = act.SwitchWorkspaceRelative(-1)
    },
    {
        key = '\\',
        mods = 'LEADER',
        action = act.SplitHorizontal { domain = 'CurrentPaneDomain' }
    },
    {
        key = '-',
        mods = 'LEADER',
        action = act.SplitVertical { domain = 'CurrentPaneDomain' }
    },
    {
        key = "j",
        mods = "LEADER",
        action = act.ActivatePaneDirection 'Down'
    },
    {
        key = "k",
        mods = "LEADER",
        action = act.ActivatePaneDirection 'Up'
    },
    {
        key = "h",
        mods = "LEADER",
        action = act.ActivatePaneDirection 'Left'
    },
    {
        key = "l",
        mods = "LEADER",
        action = act.ActivatePaneDirection 'Right'
    },
    {
        key = "c",
        mods = "LEADER",
        action = act.SpawnTab 'CurrentPaneDomain'
    },
    {
        key= "1",
        mods = "LEADER",
        action = act.ActivateTab (0)
    },
    {
        key= "2",
        mods = "LEADER",
        action = act.ActivateTab (1)
    },
    {
        key= "3",
        mods = "LEADER",
        action = act.ActivateTab (2)
    },
    {
        key= "4",
        mods = "LEADER",
        action = act.ActivateTab (3)
    },
    {
        key= "5",
        mods = "LEADER",
        action = act.ActivateTab (4)
    },
    {
        key= "6",
        mods = "LEADER",
        action = act.ActivateTab (5)
    },
    {
        key= "7",
        mods = "LEADER",
        action = act.ActivateTab (6)
    },
    {
        key= "8",
        mods = "LEADER",
        action = act.ActivateTab (7)
    },
    {
        key= "9",
        mods = "LEADER",
        action = act.ActivateTab (8)
    },
    {
        key = "J",
        mods = "LEADER",
        action = act.AdjustPaneSize { 'Down', 5 }
    },
    {
        key = "K",
        mods = "LEADER",
        action = act.AdjustPaneSize { 'Up', 5 }
    },
    {
        key = "H",
        mods = "LEADER",
        action = act.AdjustPaneSize { 'Left', 5 }
    },
    {
        key = "L",
        mods = "LEADER",
        action = act.AdjustPaneSize { 'Right', 5 }
    },
    {
        key = "x",
        mods = "LEADER",
        action = act.CloseCurrentPane { confirm = true }
    },
    {
        key = "c",
        mods = "LEADER",
        action = act.SpawnTab 'CurrentPaneDomain'
    },
    {
        key = '[',
        mods = 'LEADER',
        action = act.ActivateCopyMode
    },
    {
        key = 'f',
        mods = 'ALT',
        action = act.TogglePaneZoomState

    },
    {
        key = "=",
        mods = "CTRL",
        action = act.IncreaseFontSize
    },
    {
        key = "-",
        mods = "CTRL",
        action = act.DecreaseFontSize
    },
    {
        key = "L", mods = 'CTRL', action = act.ShowDebugOverlay
    }
}

return config
