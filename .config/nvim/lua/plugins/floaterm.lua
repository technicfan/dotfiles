return {
    "voldikss/vim-floaterm",
    config = function ()
        vim.g.floaterm_width = 0.85
        vim.g.floaterm_height = 0.85
        vim.g.floaterm_title = "term[$1/$2]"
        vim.g.floaterm_titleposition = "center"
        vim.keymap.set({ 't' }, '<C-t>', "<cmd>FloatermNew<cr>", { silent = true })
        vim.keymap.set({ 'n', 't' }, '<c-cr>', "<cmd>FloatermToggle<cr>", { silent = true })
        vim.keymap.set({ 't' }, '<C-n>', "<cmd>FloatermNext<cr>", { silent = true })
        vim.keymap.set({ 't' }, '<C-l>', "<cmd>FloatermPrev<cr>", { silent = true })
    end
}
