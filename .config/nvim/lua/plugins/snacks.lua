return {
    "folke/snacks.nvim",
    priority=1000,
    lazy = false,
    opts = {
        image = { enabled = true, math = { enabled = false } },
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
            icons = {
                error = "",
                warn = "",
                info = "",
                debug = "",
                trace = ""
            }
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
        },
        dashboard = {
            preset = {
                header = [[
                                                                     
       ████ ██████           █████      ██                     
      ███████████             █████                             
      █████████ ███████████████████ ███   ███████████   
     █████████  ███    █████████████ █████ ██████████████   
    █████████ ██████████ █████████ █████ █████ ████ █████   
  ███████████ ███    ███ █████████ █████ █████ ████ █████  
 ██████  █████████████████████ ████ █████ █████ ████ ██████ 
                                                                       ]],
                keys = {
                    { icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
                    { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
                    { icon = " ", key = "g", desc = "Find Text", action = ":lua Snacks.dashboard.pick('live_grep')" },
                    { icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
                    { icon = " ", key = "c", desc = "Config", action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})" },
                    { icon = " ", key = "s", desc = "Restore Session", section = "session" },
                    { icon = "󰒲 ", key = "l", desc = "Lazy", action = ":Lazy" },
                    { icon = " ", key = "q", desc = "Quit", action = ":qa" },
                },
            },
            sections = {
                { section = "header" },
                { section = "keys", gap = 1, padding = 2 },
                { pane = 1, icon = " ", title = "Recent Files", section = "recent_files", indent = 2, padding = 1 },
                { pane = 1, icon = " ", title = "Projects", section = "projects", indent = 2, padding = 1 },
                { section = "startup" },
            },
        },
    },
    keys = {
        { "<leader>lg", function() Snacks.lazygit() end, desc = "LazyGit" },
        { "<c-p>", function() Snacks.picker.files({ hidden = true }) end, desc = "Find Files" },
        { "<leader>pp", function() Snacks.picker.grep({ hidden = true }) end, desc = "Grep" },
        { "<leader><space>", function() Snacks.picker.buffers({ hidden = true }) end, desc = "Buffers" },
    }
}
