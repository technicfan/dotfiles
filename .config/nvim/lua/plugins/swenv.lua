return {
    'AckslD/swenv.nvim',
    config = function()
        require("swenv").setup({
            venvs_path = vim.fn.expand('~/.venv'),
        })
        vim.keymap.set("n", "<leader>vs", require("swenv.api").pick_venv)
    end
}
