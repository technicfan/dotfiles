return {
    'AckslD/swenv.nvim',
    config = function()
        require("swenv").setup({
            venvs_path = vim.fn.expand('~/.venv'),
            post_set_venv = function ()
                if require("swenv.api").get_current_venv() then
                    vim.cmd("LspRestart")
                end
            end
        })
        vim.keymap.set("n", "<leader>lv", require("swenv.api").pick_venv)
    end
}
