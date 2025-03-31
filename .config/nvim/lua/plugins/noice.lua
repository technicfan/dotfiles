return {
    "folke/noice.nvim",
    dependencies = {
        "MunifTanjim/nui.nvim",
    },
    event = "VeryLazy",
    opts = {
        views = {
            popupmenu = {
                border = {
                    style = "single"
                },
                position = { row = "35%", col = "50%" }
            },
            cmdline_popup = {
                border = {
                    style = "single"
                },
                position = { row = "35%", col = "50%" }
            },
            popup = {
                border = {
                    style = "single"
                },
                position = { row = "35%", col = "50%" }
            },
        },
        cmdline = {
            format = {
                search_down = {
                    view = "cmdline",
                },
                search_up = {
                    view = "cmdline",
                },
            },
        }
    }
}
