local wezterm = require("wezterm")
local sessionizer = require("sessionizer")

local config = wezterm.config_builder()

config.disable_default_key_bindings = true
config.enable_wayland = false
config.adjust_window_size_when_changing_font_size = false

config.font = wezterm.font("FiraCode Nerd Font")
config.hide_tab_bar_if_only_one_tab = true
config.color_scheme = 'Moonfly'
config.color_scheme = 'nord'
config.color_scheme = 'tokyonight'

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
        key = '/',
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
        action = act.AdjustPaneSize { 'Down', 10 }
    },
    {
        key = "K",
        mods = "LEADER",
        action = act.AdjustPaneSize { 'Up', 10 }
    },
    {
        key = "H",
        mods = "LEADER",
        action = act.AdjustPaneSize { 'Left', 10 }
    },
    {
        key = "L",
        mods = "LEADER",
        action = act.AdjustPaneSize { 'Right', 10 }
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
wezterm.on('user-var-changed', function(window, pane, name, value)
    local overrides = window:get_config_overrides() or {}
    if name == "ZEN_MODE" then
        local incremental = value:find("+")
        local number_value = tonumber(value)
        if incremental ~= nil then
            while (number_value > 0) do
                window:perform_action(wezterm.action.IncreaseFontSize, pane)
                number_value = number_value - 1
            end
            overrides.enable_tab_bar = false
        elseif number_value < 0 then
            window:perform_action(wezterm.action.ResetFontSize, pane)
            overrides.font_size = nil
            overrides.enable_tab_bar = true
        else
            overrides.font_size = number_value
            overrides.enable_tab_bar = false
        end
    end
    window:set_config_overrides(overrides)
end)

return config
