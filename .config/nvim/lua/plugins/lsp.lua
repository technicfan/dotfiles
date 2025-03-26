return {
    {
        "williamboman/mason.nvim",
        config = function()
            require("mason").setup()
        end
    },
    {
        "neovim/nvim-lspconfig"
    },
    {
        "williamboman/mason-lspconfig.nvim",
        dependencies = {
            "saghen/blink.cmp",
            "neovim/nvim-lspconfig"
        },
        config = function()
            require("mason-lspconfig").setup({
                ensure_installed = {
                    "lua_ls",
                    "bashls",
                    "clangd",
                    "cssls",
                    "ts_ls",
                    "html",
                    "pylsp",
                    "marksman"
                }
            })

            require("mason-lspconfig").setup_handlers({
                function (server)
                    local config = {}
                    config.capabilities = require("blink.cmp").get_lsp_capabilities()
                    if server == "html" then
                        config.filetypes = { "html", "htmldjango" }
                    elseif server == "pylsp" then
                        config.settings = {
                            pylsp = {
                                plugins = {
                                    pycodestyle = {
                                        maxLineLength = 128
                                    }
                                }
                            }
                        }
                    end
                    require("lspconfig")[server].setup(config)
                end
            })

            vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Lsp hover" })
            vim.keymap.set("n", "<leader>cd", vim.lsp.buf.definition, { desc = "Lsp to definition" })
            vim.keymap.set("n", "<leader>cr", vim.lsp.buf.rename, { desc = "Lsp rename" })
            vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, { desc = "Lsp code action" })
        end
    }
}
