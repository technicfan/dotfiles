return {
    {
        "lukas-reineke/indent-blankline.nvim",
        main = "ibl",
        config = function ()
            local opts = {}
            if vim.g.neovide then
                opts.scope = {
                    show_start = false,
                    show_end = false
                }
            end
            require("ibl").setup(opts)
        end
    },
    {
        "m4xshen/smartcolumn.nvim",
        opts = {
            colorcolumn = "128",
            disabled_filetypes = { "", "help", "text", "markdown", "lazy", "neo-tree", "alpha" }
        }
    },
}
