return {
    {
        "nvim-telescope/telescope.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
        config = function()
            require("telescope").setup({
                defaults = {
                    borderchars = { '─', '│', '─', '│', '┌', '┐', '┘', '└' }
                }
            })
        end
    },
    {
        "AckslD/nvim-neoclip.lua",
        dependencies = {
            "nvim-telescope/telescope.nvim"
        },
        config = function()
            require("neoclip").setup()
            vim.keymap.set("n", "<leader>lc", "<cmd>Telescope neoclip<CR>")
        end
    }
}
