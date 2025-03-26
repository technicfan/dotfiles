return {
    {
        'nvim-lualine/lualine.nvim',
        dependencies = { 'nvim-tree/nvim-web-devicons' },
        config = function()
            require("lualine").setup({
                sections = {
                    lualine_b = {
                        "branch",
                        {
                            "swenv",
                            cond = function()
                                return vim.bo.filetype == "python"
                            end
                        },
                        "diff",
                        "diagnostics"
                    }
                }
            })
        end
    },
    {
        "echasnovski/mini.tabline",
        config = function ()
            require("mini.tabline").setup()
            vim.keymap.set("n", "<A-0>", "<cmd>bf<cr>", { desc = "First buffer" })
            vim.keymap.set("n", "<A-ß>", "<cmd>bl<cr>", { desc = "Last buffer" })
            vim.keymap.set("n", "<A-1>", "<cmd>bp<cr>", { desc = "Last buffer" })
            vim.keymap.set("n", "<A-2>", "<cmd>bn<cr>", { desc = "Last buffer" })
            vim.keymap.set("n", "<A-q>", "<cmd>bd<cr>", { desc = "Delete buffer" })
        end
    }
}
