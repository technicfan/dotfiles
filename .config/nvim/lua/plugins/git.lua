return {
    {
        "tanvirtin/vgit.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-web-devicons"
        },
        event = 'VimEnter',
        config = function()
            local vgit = require("vgit")
            vgit.setup({
                settings = {
                    live_blame = {
                        enabled = false
                    }
                }
            })

            -- faster live blame
            vim.o.updatetime = 300

            vim.keymap.set("n", "<leader>gp", vgit.project_diff_preview, {})
            vim.keymap.set("n", "<leader>gl", vgit.project_logs_preview, {})
            vim.keymap.set("n", "<leader>gd", vgit.buffer_hunk_preview, {})
            vim.keymap.set("n", "<leader>hr", vgit.buffer_hunk_reset, {})
            vim.keymap.set("n", "<leader>gh", vgit.buffer_history_preview, {})
            vim.keymap.set("n", "<leader>ll", vgit.toggle_live_blame, {})
            vim.keymap.set("n", "<leader>lp", vgit.buffer_blame_preview, {})
        end
    }
}
