return {
    'rmagatti/auto-session',
    lazy = false,
    keys = {
        { '<leader>ls', '<cmd>SessionSearch<CR>', desc = 'Session search' },
    },
    opts = {
        allowed_dirs = { "~/git-repos/*", "~/GitHub/*" },
        session_lens = {
            load_on_setup = true,
            previewer = false,
            mappings = {
                delete_session = { "i", "<C-D>" }
            },
            theme_conf = {
                borderchars = {
                    prompt = { '─', '│', ' ', '│', '┌', '┐', '┘', '└' },
                    results = { "─", "│", "─", "│", "├", "┤", '┘', '└' },
                    preview = { '─', '│', '─', '│', '┌', '┐', '┘', '└' },
                },
            }
        }
    }
}
