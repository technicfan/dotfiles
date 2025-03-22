return {
    {
        "echasnovski/mini.pairs",
        config = function ()
            require("mini.pairs").setup()
        end
    },
    {
        "windwp/nvim-ts-autotag",
        config = function ()
            require("nvim-ts-autotag").setup({
                opts = {
                    enable_close = true,
                    enable_rename = true,
                    enable_close_on_slash = true
                }
            })
        end
    },
    {
        'vidocqh/auto-indent.nvim',
        opts = {}
    },
}
