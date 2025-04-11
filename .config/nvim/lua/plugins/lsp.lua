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
                    "pyright",
                    "marksman"
                }
            })

            require("mason-lspconfig").setup_handlers({
                function(server)
                    local config = {}
                    config.capabilities = require("blink.cmp").get_lsp_capabilities()
                    if server == "html" then
                        config.filetypes = { "html", "htmldjango" }
                    end
                    require("lspconfig")[server].setup(config)
                end
            })

            vim.diagnostic.config({
                virtual_text = true
            })

            vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, { desc = "Show line diagnostics" })
            vim.keymap.set("n", "<leader>fm", vim.lsp.buf.format, { desc = "Lsp format" })
            vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Lsp hover" })
            vim.keymap.set("n", "<leader>cd", vim.lsp.buf.definition, { desc = "Lsp to definition" })
            vim.keymap.set("n", "<leader>cr", vim.lsp.buf.rename, { desc = "Lsp rename" })
            vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, { desc = "Lsp code action" })
        end
    },
    {
        "nvimtools/none-ls.nvim",
        dependencies = {
            "nvimtools/none-ls-extras.nvim",
            "jayp0521/mason-null-ls.nvim"
        },
        config = function()
            require('mason-null-ls').setup {
                ensure_installed = {
                    "ruff"
                },
                automatic_installation = true
            }

            local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
            require("null-ls").setup({
                sources = {
                    require("none-ls.formatting.ruff").with { extra_args = { "--extend-select", "I" } },
                    require("none-ls.formatting.ruff_format")
                },
                on_attach = function(client, bufnr)
                    if client.supports_method("textDocument/formatting") then
                        vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
                        vim.api.nvim_create_autocmd("BufWritePre", {
                            group = augroup,
                            buffer = bufnr,
                            callback = function()
                                vim.lsp.buf.format({ async = false })
                            end,
                        })
                    end
                end,
            })
        end
    }
}
