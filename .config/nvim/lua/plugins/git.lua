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
            vim.keymap.set("n", "<leader>ga", vgit.project_diff_preview, { desc = "Git stage files" })
            vim.keymap.set("n", "<leader>gc", vgit.project_commit_preview, { desc = "Git commit" })
            vim.keymap.set("n", "<leader>hp", vgit.buffer_hunk_preview, { desc = "Hunk preview" })
            vim.keymap.set("n", "<leader>gh", vgit.buffer_history_preview, { desc = "Buffer history" })
        end
    },
    {
        "lewis6991/gitsigns.nvim",
        config = function ()
            require("gitsigns").setup()
            vim.keymap.set("n", "<leader>hr", "<cmd>Gitsigns reset_hunk<CR>", { desc = "Reset current hunk" })
            vim.keymap.set("n", "<leader>hs", "<cmd>Gitsigns stage_hunk<CR>", { desc = "Toggle stage current hunk" })
            vim.keymap.set("n", "<leader>hd", "<cmd>Gitsigns nav_hunk next<CR>", { desc = "Next hunk" })
            vim.keymap.set("n", "<leader>hu", "<cmd>Gitsigns nav_hunk prev<CR>", { desc = "Previous hunk" })
            vim.keymap.set("n", "<leader>gb", "<cmd>Gitsigns toggle_current_line_blame<CR>", { desc = "Toggle line blame" })
            vim.keymap.set("n", "<leader>gs", function ()
                local status = vim.b.gitsigns_status_dict
                if status and not (status.added == 0 and status.changed == 0 and status.removed == 0) then
                    require("gitsigns").stage_buffer()
                else
                    require("gitsigns").reset_buffer_index()
                end
            end, { desc = "Toggle stage buffer" })
        end
    },
    {
        "echasnovski/mini-git",
        config = function ()
            require("mini.git").setup()

            vim.keymap.set("n", "<leader>gp", "<cmd>Git pull<CR>", { desc = "Git pull" })
            vim.keymap.set("n", "<leader>gP", "<cmd>Git push<CR>", { desc = "Git push" })
        end
    }
}
