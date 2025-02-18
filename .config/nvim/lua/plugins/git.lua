return {
    -- {
    --     "tanvirtin/vgit.nvim",
    --     dependencies = {
    --         "nvim-lua/plenary.nvim",
    --         "nvim-tree/nvim-web-devicons"
    --     },
    --     event = 'VimEnter',
    --     config = function()
    --         local vgit = require("vgit")
    --         vgit.setup({
    --             settings = {
    --                 live_blame = {
    --                     enabled = false
    --                 }
    --             }
    --         })
    --
    --         -- faster live blame
    --         vim.o.updatetime = 300
    --
    --         vim.keymap.set("n", "<leader>gp", vgit.project_diff_preview, {})
    --         vim.keymap.set("n", "<leader>gl", vgit.project_logs_preview, {})
    --         vim.keymap.set("n", "<leader>gd", vgit.buffer_hunk_preview, {})
    --         vim.keymap.set("n", "<leader>hr", vgit.buffer_hunk_reset, {})
    --         vim.keymap.set("n", "<leader>gh", vgit.buffer_history_preview, {})
    --         vim.keymap.set("n", "<leader>ll", vgit.toggle_live_blame, {})
    --         vim.keymap.set("n", "<leader>lp", vgit.buffer_blame_preview, {})
    --     end
    -- }
    {
        "chrisgrieser/nvim-tinygit",
        tag = "v0.9",
        dependencies = "stevearc/dressing.nvim",
        config = function ()
            require("tinygit").setup({
                stage = {
                    telescopeOpts = {
                        layout_strategy = "horizontal",
                        layout_config = {
                            horizontal = {
                                preview_width = 0.65,
                                height = { 0.7, min = 20 },
                            },
                        },
                        winhighlight = "FloatBorder:Normal,NormalFloat:Normal"
                    },
                },
                commit = {
                    preview = true
                }
            })
            vim.keymap.set("n", "<leader>ga", function() require("tinygit").interactiveStaging() end, { desc = "git add" })
            vim.keymap.set("n", "<leader>gc", function() require("tinygit").smartCommit() end, { desc = "git commit" })
            vim.keymap.set("n", "<leader>gp", function() require("tinygit").push() end, { desc = "git push" })
        end
    },
}
