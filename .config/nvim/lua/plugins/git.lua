return {
    {
        "tanvirtin/vgit.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-web-devicons",
            "lewis6991/gitsigns.nvim"
        },
        event = 'VimEnter',
        config = function()
            local vgit = require("vgit")
            vgit.setup({
                settings = {
                    live_blame = {
                        enabled = false
                    },
                    live_gutter = {
                        enabled = false
                    }
                }
            })

            vim.keymap.set("n", "<leader>gl", vgit.project_logs_preview, { desc = "Git logs" })
            vim.keymap.set("n", "<leader>ghp", vgit.buffer_hunk_preview, { desc = "Hunk preview" })
            vim.keymap.set("n", "<leader>gbh", vgit.buffer_history_preview, { desc = "Buffer history" })
        end
    },
    {
        "lewis6991/gitsigns.nvim",
        config = function ()
            require("gitsigns").setup()
            vim.keymap.set("n", "<leader>ghr", "<cmd>Gitsigns reset_hunk<CR>", { desc = "Reset current hunk" })
            vim.keymap.set("n", "<leader>ghs", "<cmd>Gitsigns stage_hunk<CR>", { desc = "Toggle stage current hunk" })
            vim.keymap.set("n", "<leader>gj", "<cmd>Gitsigns nav_hunk next<CR>", { desc = "Next hunk" })
            vim.keymap.set("n", "<leader>gk", "<cmd>Gitsigns nav_hunk prev<CR>", { desc = "Previous hunk" })
            vim.keymap.set("n", "<leader>gbb", "<cmd>Gitsigns toggle_current_line_blame<CR>", { desc = "Toggle line blame" })
            vim.keymap.set("n", "<leader>gbs", function ()
                local status = vim.b.gitsigns_status_dict
                if status and not (status.added == 0 and status.changed == 0 and status.removed == 0) then
                    require("gitsigns").stage_buffer()
                else
                    require("gitsigns").reset_buffer_index()
                end
            end, { desc = "Toggle stage buffer" })
        end
    }
}
