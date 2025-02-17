return {
    {
        "m4xshen/smartcolumn.nvim",
        opts = {
            colorcolumn = "128",
            disabled_filetypes = { "", "help", "text", "markdown", "lazy", "neo-tree", "alpha" }
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
}
