vim.cmd("noremap <Up> <Nop>")
vim.cmd("noremap <Down> <Nop>")
vim.cmd("noremap <Left> <Nop>")
vim.cmd("noremap <Right> <Nop>")
vim.cmd("nnoremap ß $")
vim.cmd("nnoremap X vX")
vim.cmd("vnoremap ß $")
vim.cmd("vnoremap > >gv")
vim.cmd("vnoremap < <gv")
vim.cmd("vnoremap <Tab> >gv")
vim.cmd("vnoremap <S-Tab> <gv")
vim.cmd("tnoremap <Esc> <C-\\><C-n>")
vim.cmd("vmap <CS-c> \"+y")
vim.cmd("nmap <CS-v> \"+p")
vim.cmd("inoremap <CS-v> <C-r>+")
vim.cmd("cnoremap <CS-v> <C-r>+")
vim.cmd("inoremap <C-r> <C-v>")
vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.api.nvim_set_keymap("n", "<S-Tab>", "<cmd>bp<cr>", { desc = "Last buffer" })
vim.api.nvim_set_keymap("n", "<Tab>", "<cmd>bn<cr>", { desc = "Next buffer" })
vim.api.nvim_set_keymap("n", "<leader>bq", "<cmd>bd<cr>", { desc = "Delete buffer" })
vim.api.nvim_set_keymap("n", "<leader>q", "<cmd>qa<cr>", { desc = "Quit all" })
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.autoread = true
vim.opt.number = true
vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4

vim.filetype.add({
    pattern = {
        [".*/templates/.*%.html"] = "htmldjango"
    }
})

-- neovide
vim.o.guifont = "VictorMono Nerd Font:h11"
if vim.g.neovide then
    vim.g.neovide_padding_top = 6
    vim.g.neovide_padding_bottom = 6
    vim.g.neovide_padding_right = 6
    vim.g.neovide_padding_left = 6
    vim.g.neovide_hide_mouse_when_typing = true
    vim.g.neovide_cursor_animation_length = 0
    vim.g.neovide_cursor_trail_size = 0
    vim.g.neovide_cursor_animate_command_line = false
    vim.g.neovide_scroll_animation_length = 0
    vim.g.neovide_floating_blur_amount_x = 0
    vim.g.neovide_floating_blur_amount_y = 0
    vim.g.neovide_cursor_unfocused_outline_width = 0.075
    vim.g.neovide_floating_shadow = false
end

-- kitty
vim.api.nvim_create_autocmd({ "VimEnter", "VimResume" }, {
    group = vim.api.nvim_create_augroup("KittySetVarVimEnter", { clear = true }),
    callback = function()
        io.stdout:write("\x1b]1337;SetUserVar=in_editor=MQo\007")
    end,
})

vim.api.nvim_create_autocmd({ "VimLeave", "VimSuspend" }, {
    group = vim.api.nvim_create_augroup("KittyUnsetVarVimLeave", { clear = true }),
    callback = function()
        io.stdout:write("\x1b]1337;SetUserVar=in_editor\007")
    end,
})
