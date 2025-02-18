return {
    {
        'nvim-telescope/telescope.nvim',
        dependencies = {
            'nvim-lua/plenary.nvim',
            "nvim-telescope/telescope-ui-select.nvim"
        },
        config = function()
            local vimgrep_arguments = require("telescope.config").values.vimgrep_arguments

            table.insert(vimgrep_arguments, "--hidden")
            table.insert(vimgrep_arguments, "--glob")
            table.insert(vimgrep_arguments, "!**/.git/*")

            require("telescope").setup({
                defaults = {
                    vimgrep_arguments = vimgrep_arguments,
                    borderchars = { '─', '│', '─', '│', '┌', '┐', '┘', '└' }
                },
                pickers = {
                    find_files = {
                        find_command = { "rg", "--files", "--hidden", "--glob", "!**/.git/*" },
                    }
                },
                extensions = {
                    ["ui-select"] = {
                        require("telescope.themes").get_dropdown({
                            borderchars = {
                                prompt = { '─', '│', ' ', '│', '┌', '┐', '┘', '└' },
                                results = { "─", "│", "─", "│", "├", "┤", '┘', '└' },
                                preview = { '─', '│', '─', '│', '┌', '┐', '┘', '└' },
                            },
                        })
                    }
                }
            })

            require("telescope").load_extension("ui-select")

            local builtin = require("telescope.builtin")
            vim.keymap.set('n', '<C-p>', builtin.find_files, {})
            vim.keymap.set('n', '<leader>pp', builtin.live_grep, {})
            vim.keymap.set("n", "<leader><leader>", builtin.buffers, {})
        end
    },
}
