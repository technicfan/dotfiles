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
                            icon = "",
                            function ()
                                local venv = require("venv-selector").venv()
                                if venv then
                                    return string.gsub(venv, ".*/", "")
                                else
                                    return ""
                                end
                            end,
                            cond = function()
                                return vim.bo.filetype == "python"
                            end
                        },
                        "diff",
                        "diagnostics"
                    },
                    lualine_x = {
                        "encoding",
                        "o:fileformat",
                        "filetype",

                    }
                }
            })
        end
    }
}
