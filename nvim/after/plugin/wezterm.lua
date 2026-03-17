vim.api.nvim_create_user_command("WeztermSplitVertical",
  function()
    local oil_cwd = require("oil").get_current_dir()
    require("wezterm").split_pane.vertical({ cwd = oil_cwd })
  end, {})

vim.api.nvim_create_user_command("WeztermSplitHorizontal",
  function()
    local oil_cwd = require("oil").get_current_dir()
    require("wezterm").split_pane.horizontal({ cwd = oil_cwd })
  end, {})
