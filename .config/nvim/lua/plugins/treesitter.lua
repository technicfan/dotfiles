return {
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        config = function()
            local config = require("nvim-treesitter.configs")
            config.setup({
                ensure_installed = {"lua", "javascript", "python", "html", "htmldjango", "css", "bash"},
                highlight = { enable = true },
                indent = { enable = true },
            })
        end
    },
    {
        "echasnovski/mini.ai",
        config = function ()
            require("mini.ai").setup()
        end
    }
}
