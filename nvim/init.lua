-- GUI launches do not necessarily inherit interactive shell activation.
local shims = (vim.env.MISE_DATA_DIR or ((vim.env.XDG_DATA_HOME or (vim.env.HOME .. "/.local/share")) .. "/mise")) .. "/shims"
vim.env.PATH = shims .. ":" .. (vim.env.PATH or "")
require("config")
