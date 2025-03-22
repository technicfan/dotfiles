return {
    {
        "nvim-treesitter/nvim-treesitter-context",
        config = function ()
            require("treesitter-context").setup({
                mode = "topline"
            })
        end
    },
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        config = function()
            local config = require("nvim-treesitter.configs")
            config.setup({
                ensure_installed = {"lua", "javascript", "python", "html", "htmldjango", "css", "bash", "latex"},
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
