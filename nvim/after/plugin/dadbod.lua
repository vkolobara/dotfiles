require("cmp").setup.filetype({ "sql", "plsql", "mysql" }, {
    sources = {
        { name = "vim-dadbod-completion" },
        { name = "buffer" },
    },
})
