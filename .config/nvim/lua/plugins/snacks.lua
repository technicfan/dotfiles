return {
    "folke/snacks.nvim",
    priority=1000,
    opts = {
        image = { enabled = true },
        lazygit = {
            enabled = true,
            config = {
                gui = {
                    border = "single"
                }
            }
        }
    },
    keys = {
        { "<leader>lg", "<cmd>lua Snacks.lazygit()<cr>", desc = "LazyGit" }
    },
}
