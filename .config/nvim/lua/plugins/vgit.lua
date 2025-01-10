return {
    "tanvirtin/vgit.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim"
    },
    config = function()
        local vgit = require("vgit")
        vgit.setup({
            settings = {
                live_blame = {
                    enabled = false
                }
            }
        })
        vim.keymap.set("n", "<leader>gg", vgit.buffer_diff_preview, {})
        vim.keymap.set("n", "<leader>gp", vgit.project_diff_preview, {})
        vim.keymap.set("n", "<leader>gh", vgit.toggle_live_gutter, {})
        vim.keymap.set("n", "<leader>gi", vgit.buffer_hunk_preview, {})
    end
}
