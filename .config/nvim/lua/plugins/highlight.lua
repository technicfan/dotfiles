return {
    {
        "m4xshen/smartcolumn.nvim",
        opts = {
            colorcolumn = "100",
            disabled_filetypes = { "", "help", "text", "markdown", "lazy", "neo-tree", "mason", "oil", "snacks_dashboard" }
        }
    },
    {
        "wurli/visimatch.nvim",
        opts = {
            hl_group = "Visual",
            chars_lower_limit = 1
        }
    },
    {
        "MeanderingProgrammer/render-markdown.nvim",
        opts = {}
    },
    {
        "sontungexpt/url-open",
        event = "VeryLazy",
        cmd = "URLOpenUnderCursor",
        config = function()
            local status_ok, url_open = pcall(require, "url-open")
            if not status_ok then
                return
            end
            url_open.setup({
                highlight_url = {
                    cursor_move = {
                        fg = "text"
                    }
                }
            })
            vim.keymap.set("n", "<leader>x", "<cmd>URLOpenUnderCursor<cr>")
        end,
    }
}
