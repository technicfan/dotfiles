return {
    {
        "linux-cultist/venv-selector.nvim",
        dependencies = {
            "neovim/nvim-lspconfig",
        },
        lazy = false,
        branch = "regexp",
        keys = {
            { "<leader>lv", "<cmd>VenvSelect<cr>" },
        },
        opts = {
            search = {
                my_venvs = {
                    command = "fd '/bin/python$' ~/.venv --full-path",
                }
            }
        },
    }
}
