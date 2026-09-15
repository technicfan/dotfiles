return {
    {
        "nvim-treesitter/nvim-treesitter",
        branch = "main",
        build = ":TSUpdate",
        config = function()
            vim.api.nvim_create_autocmd('FileType', {
                callback = function()
                    pcall(vim.treesitter.start)
                    if vim.treesitter.query.get(vim.bo.filetype, "indents") then
                        vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
                    end
                end,
            })
            local ensure_installed = {"lua", "javascript", "python", "html", "htmldjango", "css", "bash", "markdown", "java", "rust", "go", "typst", "c", "qmljs"}
            local already_installed = require('nvim-treesitter.config').get_installed()
            local missing = vim.iter(ensure_installed)
                :filter(function(parser)
                    return not vim.tbl_contains(already_installed, parser)
                end)
                :totable()
            require('nvim-treesitter').install(missing)
        end
    },
    {
        "echasnovski/mini.ai",
        config = function ()
            require("mini.ai").setup()
        end
    }
}
