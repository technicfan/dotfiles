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
                    lualine_x = { "encoding", "o:fileformat", "filetype" }
                }
            })
        end
    }
}
