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
            vim.keymap.set("n", "<leader>gp", vgit.project_diff_preview, {})
            vim.keymap.set("n", "<leader>gl", vgit.project_logs_preview, {})
            vim.keymap.set("n", "<leader>gh", vgit.buffer_hunk_preview, {})
        end
    }
}
