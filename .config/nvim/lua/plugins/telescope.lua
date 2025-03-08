return {
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
                borderchars = { '─', '│', '─', '│', '┌', '┐', '┘', '└' },
                preview = {
                    mime_hook = function(filepath, bufnr, opts)
                        local is_image = function(filepath)
                            local process = io.popen(string.format("file -b --mime-type '%s'", filepath))
                            local output = process:read("*a")
                            process:close()
                            return string.gmatch(output, "image/.*")
                        end
                        if is_image(filepath) then
                            local term = vim.api.nvim_open_term(bufnr, {})
                            local function send_output(_, data, _ )
                                for _, d in ipairs(data) do
                                    vim.api.nvim_chan_send(term, d..'\r\n')
                                end
                            end
                            vim.fn.jobstart(
                                {
                                    "catimg", filepath
                                },
                                {on_stdout=send_output, stdout_buffered=true, pty=true})
                        else
                            require("telescope.previewers.utils").set_preview_message(bufnr, opts.winid, "Binary cannot be previewed")
                        end
                    end
                }
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
}
