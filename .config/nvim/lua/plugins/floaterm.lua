return {
    "voldikss/vim-floaterm",
    config = function ()
        vim.cmd("let g:floaterm_width=0.85")
        vim.cmd("let g:floaterm_height=0.85")
        vim.cmd("let g:floaterm_title='term[$1/$2]'")
        vim.cmd("let g:floaterm_titleposition='center'")
        vim.keymap.set({ 't' }, '<C-n>', "<cmd>FloatermNew<cr>", { silent = true })
        vim.keymap.set({ 'n', 't' }, '<C-CR>', "<cmd>FloatermToggle<cr>", { silent = true })
        vim.keymap.set({ 't' }, '<C-l>', "<cmd>FloatermNext<cr>", { silent = true })
        vim.keymap.set({ 't' }, '<C-h>', "<cmd>FloatermPrev<cr>", { silent = true })
    end
}
