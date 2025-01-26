return {
  "AckslD/nvim-neoclip.lua",
  dependencies = {
    {'nvim-telescope/telescope.nvim'},
  },
  config = function()
    require("neoclip").setup()
    vim.keymap.set("n", "<leader>cc", function () vim.cmd("Telescope neoclip") end)
  end,
}
