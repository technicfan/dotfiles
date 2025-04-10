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
        }
    },
    {
        "axkirillov/hbac.nvim",
        config = true,
    }
}
