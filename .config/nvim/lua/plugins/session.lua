return {
    {
        "olimorris/persisted.nvim",
        lazy = false,
        keys = {
            { "<leader>ls", "<cmd>SessionSelect<CR>", desc = "Session search" },
        },
        opts ={
            use_git_branch = true,
            autoload = true,
            allowed_dirs = { "~/git-repos", "~/GitHub" }
        },
        config = function()
            local persisted = require("persisted")
            local utils = require("persisted.utils")
            local allowed_dirs = {
                "~/git-repos/*",
                "~/GitHub/*"
            }

            persisted.setup({
                should_save = function()
                    return utils.dirs_match(vim.fn.getcwd(), allowed_dirs)
                end,
            })
        end,
    },
    {
        "axkirillov/hbac.nvim",
        config = true,
    }
}
