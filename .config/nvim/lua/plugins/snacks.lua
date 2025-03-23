return {
    "folke/snacks.nvim",
    priority=1000,
    lazy = false,
    opts = {
        image = { enabled = true },
        lazygit = {
            enabled = true,
            config = {
                gui = {
                    border = "single"
                }
            }
        },
        notifier = {
            enabled = true,
        },
        styles = {
            notification = {
                border = "single"
            },
            notification_history = {
                border = "single"
            }
        },
        indent = {
            enabled = true,
            animate = { enabled = false },
            scope = { hl = "CursorLineNr" },
            chunk = {
                enabled = true,
                char = {
                    arrow = "─"
                },
                hl = "CursorLineNr"
            }
        },
        picker = {
            enabled = true,
            layout = "telescope",
            layouts = {
                telescope = {
                    reverse = true,
                    layout = {
                        box = "horizontal",
                        backdrop = false,
                        width = 0.8,
                        height = 0.86,
                        row = 2,
                        border = "none",
                        {
                            box = "vertical",
                            { win = "list", title = " Results ", title_pos = "center", border = "single" },
                            { win = "input", height = 1, border = "single", title = "{title} {live} {flags}", title_pos = "center" },
                        },
                        {
                            win = "preview",
                            title = "{preview:Preview}",
                            width = 0.45,
                            border = "single",
                            title_pos = "center",
                        },
                    },
                },
                select = { layout = { border = "single" } }
            }
        }
    },
    keys = {
        { "<leader>lg", function() Snacks.lazygit() end, desc = "LazyGit" },
        { "<c-p>", function() Snacks.picker.files({ hidden = true }) end, desc = "Find Files" },
        { "<leader>pp", function() Snacks.picker.grep({ hidden = true }) end, desc = "Grep" },
        { "<leader><space>", function() Snacks.picker.buffers({ hidden = true }) end, desc = "Buffers" },
    }
}
