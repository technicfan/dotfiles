return {
    {
        "williamboman/mason.nvim",
        config = function()
            require("mason").setup()
        end
    },
    {
        "williamboman/mason-lspconfig.nvim",
        config = function()
            require("mason-lspconfig").setup({
                ensure_installed = { "lua_ls", "bashls", "clangd", "cssls", "ts_ls", "pylsp",  "html", "jinja_lsp", "pylsp" }
            })
        end
    },
    {
        "neovim/nvim-lspconfig",
        config = function()
            local capabilities = require('cmp_nvim_lsp').default_capabilities()

            local lspconfig = require('lspconfig')
            lspconfig.lua_ls.setup({
                capabilities = capabilities
            })
            lspconfig.bashls.setup({
                capabilities = capabilities
            })
            lspconfig.clangd.setup({
                capabilities = capabilities
            })
            lspconfig.cssls.setup({
                capabilities = capabilities
            })
            lspconfig.ts_ls.setup({
                capabilities = capabilities
            })
            lspconfig.pylsp.setup({
                capabilities = capabilities,
                settings = {
                    pylsp = {
                        plugins = {
                            pycodestyle = {
                                maxLineLength = nil
                            }
                        }
                    }
                }
            })
            lspconfig.jinja_lsp.setup({
                capabilities = capabilities
            })
            lspconfig.html.setup({
                capabilities = capabilities,
                filetypes = { "html", "htmldjango" }
            })

            vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
            vim.keymap.set("n", "gd", vim.lsp.buf.definition, {})
            vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, {})
        end
    },
    {
        "nvim-telescope/telescope-ui-select.nvim",
        config = function()
            require("telescope").setup({
                extensions = {
                    ["ui-select"] = {
                        require("telescope.themes").get_dropdown {
                        }
                    }
                }
            })
            require("telescope").load_extension("ui-select")
        end
    }
}
