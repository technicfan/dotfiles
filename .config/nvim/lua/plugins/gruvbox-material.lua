return {
    'sainnhe/gruvbox-material',
    lazy = false,
    priority = 1000,
    config = function()
        vim.g.gruvbox_material_enable_italic = true
        vim.cmd.colorscheme('gruvbox-material')
        vim.api.nvim_set_hl(0, 'FloatBorder', { link = 'Normal' })
    end
}

