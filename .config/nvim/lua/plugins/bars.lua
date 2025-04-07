return {
    {
        'nvim-lualine/lualine.nvim',
        dependencies = { 'nvim-tree/nvim-web-devicons' },
        config = function()
            require("lualine").setup({
                options = {
                    component_separators = { left = "|", right = "|" },
                    section_separators = ""
                },
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
                    },
                    lualine_c = {},
                    lualine_x = { "encoding", "o:fileformat", "filetype" },
                }
            })
        end
    },
    {
        "echasnovski/mini.tabline",
        config = function ()
            require("mini.tabline").setup()
            vim.keymap.set("n", "<S-Tab>", "<cmd>bp<cr>", { desc = "Last buffer" })
            vim.keymap.set("n", "<Tab>", "<cmd>bn<cr>", { desc = "Next buffer" })
            vim.keymap.set("n", "<leader>bq", "<cmd>bd<cr>", { desc = "Delete buffer" })
            vim.keymap.set("n", "<leader>q", "<cmd>qa<cr>", { desc = "Quit all" })
        end
    }
}
