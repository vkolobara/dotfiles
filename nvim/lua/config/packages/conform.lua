vim.pack.add({
  "https://github.com/stevearc/conform.nvim",
})

require("conform").setup({
  formatters_by_ft = {
    python = { "isort", "black" },
    cs = { "csharpier" },
    go = { "gofmt" },
    elixir = { "mix", args = "format", "--stdin", "$FILENAME" },
    sql = { "sql_formatter" },
  },
  default_format_opts = {
    lsp_format = "fallback",
  },
})

vim.keymap.set("n", "<leader>f", function()
  require("conform").format({ async = true })
end, { desc = "Format code" })
