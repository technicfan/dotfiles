return {
    {
        "echasnovski/mini.pairs",
        config = function ()
            require("mini.pairs").setup()
        end
    },
    {
        "echasnovski/mini.surround",
        config = function ()
            require("mini.surround").setup()
        end
    },
    {
        "windwp/nvim-ts-autotag",
        config = function ()
            require("nvim-ts-autotag").setup({
                opts = {
                    enable_close = false,
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
