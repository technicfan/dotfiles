return {
    {
        "m4xshen/smartcolumn.nvim",
        opts = {
            colorcolumn = "128",
            disabled_filetypes = { "", "help", "text", "markdown", "lazy", "neo-tree", "alpha", "mason" }
        }
    },
    {
        "shellRaining/hlchunk.nvim",
        event = { "BufReadPre", "BufNewFile" },
        config = function()
            require("hlchunk").setup({
                chunk = {
                    enable = true,
                    style = { "#928374" ,"#ea6962" },
                    chars = {
                        left_top = "┌",
                        left_bottom = "└",
                        right_arrow = "─"
                    },
                    duration = 0,
                    delay = 0,
                },
                indent = { enable = true }
            })
        end
    },
    {
        "RRethy/vim-illuminate",
        dependencies = {
            "nvim-treesitter/nvim-treesitter"
        },
        config = function ()
            vim.cmd('hi IlluminatedWordText gui=underline')
            vim.cmd('hi IlluminatedWordRead gui=underline')
            vim.cmd('hi IlluminatedWordWrite gui=underline')

            vim.api.nvim_create_autocmd({ "BufRead" }, {
                callback = function ()
                    local config = {}
                    if require("nvim-treesitter.parsers").has_parser(vim.bo.filetype) then
                        config.providers = { "treesitter" }
                    else
                        config.providers = { "regex" }
                    end
                    require("illuminate").configure(config)
                end
            })
        end
    }
}
