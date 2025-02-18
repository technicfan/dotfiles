return {
    "stevearc/oil.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    lazy = false,
    config = function ()
        require("oil").setup({
            keymaps = {
                ["<Esc>"] = { "actions.close", mode = "n" },
            }
        })
        vim.keymap.set("n", "-", "<cmd>Oil<CR>", { desc = "Open parent directory" })
    end
}
