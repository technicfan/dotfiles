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

            vim.keymap.set("n", "<leader>ga", vgit.project_diff_preview, {})
            vim.keymap.set("n", "<leader>gc", vgit.project_commit_preview, {})
            vim.keymap.set("n", "<leader>gl", vgit.project_logs_preview, {})
            vim.keymap.set("n", "<leader>hp", vgit.buffer_hunk_preview, {})
            vim.keymap.set("n", "<leader>gh", vgit.buffer_history_preview, {})
            vim.keymap.set("n", "<leader>lp", vgit.buffer_blame_preview, {})
        end
    },
    {
        "chrisgrieser/nvim-tinygit",
        dependencies = "stevearc/dressing.nvim",
        config = function ()
            require("tinygit").setup()
            vim.keymap.set("n", "<leader>gp", require("tinygit").push)
        end
    },
    {
        "lewis6991/gitsigns.nvim",
        config = function ()
            require("gitsigns").setup()
            vim.keymap.set("n", "<leader>hr", "<cmd>Gitsigns reset_hunk<CR>", {})
            vim.keymap.set("n", "<leader>hs", "<cmd>Gitsigns stage_hunk<CR>", {})
            vim.keymap.set("n", "<leader>ll", "<cmd>Gitsigns toggle_current_line_blame<CR>", {})
            vim.keymap.set("n", "<leader>gs", function ()
                local status = vim.b.gitsigns_status_dict
                if status and not (status.added == 0 and status.changed == 0 and status.removed == 0) then
                    require("gitsigns").stage_buffer()
                else
                    require("gitsigns").reset_buffer_index()
                end
            end)
        end
    }
}
