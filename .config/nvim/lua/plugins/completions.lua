return {
    {
        "L3MON4D3/LuaSnip",
        dependencies = { "rafamadriz/friendly-snippets" },
        build = "make install_jsregexp",
        config = function ()
            require("luasnip.loaders.from_vscode").lazy_load()
        end
    },
    {
        "xzbdmw/colorful-menu.nvim",
        config = function ()
            require("colorful-menu").setup()
        end
    },
    {
        "saghen/blink.cmp", version = "*",
        dependencies = {
            "xzbdmw/colorful-menu.nvim"
        },
        opts = {
            completion = {
                documentation = {
                    auto_show = true,
                    auto_show_delay_ms = 500,
                    window = {
                        border = "single",
                        winhighlight = "FloatBorder:Normal,NormalFloat:Normal"
                    }
                },
                menu = {
                    border = "single",
                    winhighlight = "FloatBorder:Normal,NormalFloat:Normal",
                    draw = {
                        columns = { { "kind_icon" }, { "label", gap = 1 } },
                        components = {
                            label = {
                                text = function(ctx)
                                    return require("colorful-menu").blink_components_text(ctx)
                                end,
                                highlight = function(ctx)
                                    return require("colorful-menu").blink_components_highlight(ctx)
                                end,
                            },
                        },
                    },
                },
                list = { selection = { preselect = true, auto_insert = false } },
            },
            keymap = { preset = "enter" },
            snippets = { preset = "luasnip" }
        },
    }
}
