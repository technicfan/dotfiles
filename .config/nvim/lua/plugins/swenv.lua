return {
    'AckslD/swenv.nvim',
    config = function()
        require("swenv").setup({
            venvs_path = vim.fn.expand('~/.venv'),
        })
        vim.keymap.set("n", "<leader>lv", require("swenv.api").pick_venv)
    end
}
