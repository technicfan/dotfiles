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
            vim.keymap.set("n", "<leader>hn", "<cmd>Gitsigns nav_hunk next<CR>", {})
            vim.keymap.set("n", "<leader>hN", "<cmd>Gitsigns nav_hunk prev<CR>", {})
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
    },
    {
        "kdheepak/lazygit.nvim",
        lazy = true,
        cmd = {
            "LazyGit",
            "LazyGitConfig",
            "LazyGitCurrentFile",
            "LazyGitFilter",
            "LazyGitFilterCurrentFile",
        },
        keys = {
            { "<leader>lg", "<cmd>LazyGit<cr>", desc = "LazyGit" }
        },
        config = function ()
            vim.g.lazygit_floating_window_border_chars = {'┌','─', '┐', '│', '┘','─', '└', '│'}
            vim.g.lazygit_use_custom_config_file_path = 1
            vim.g.lazygit_config_file_path = "$HOME/.config/nvim/lazygit/config.yml"
        end
    }
}
