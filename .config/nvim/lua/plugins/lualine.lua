return {
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
}
