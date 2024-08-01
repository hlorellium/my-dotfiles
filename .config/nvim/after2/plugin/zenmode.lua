require("zen-mode").setup {
    window = {
        width = 120,
        options = {
            number = true,
            relativenumber = true,
        }
    },
     plugins = {
    options = {
      enabled = true,
      ruler = false, -- disables the ruler text in the cmd line area
      showcmd = false, -- disables the command in the last line of the screen
    },
    tmux = { enabled = true }, -- disables the tmux statusline
    twilight = { enabled = false },
  },
}

vim.keymap.set("n", "<leader>zz", function()
    require("zen-mode").toggle()
    vim.wo.wrap = false
end)

require("twilight").setup({
    dimming = {
        alpha = 0.35, -- amount of dimming
        color = { "Normal", "#ffffff" }, -- can be a hex color, or a highlight group, or a list of either
        inactive = true, -- also dim inactive windows
    },
    context = 20, -- amount of lines to keep above/below the cursor
    treesitter = true,
    expand = { -- for treesitter, we we always try to expand to the top-most ancestor with these types
    "function",
    "method",
    "table",
    "if_statement",
    "method_definition"
  },
})

vim.keymap.set("n", "<leader>zt", function()
    require("twilight").toggle()
end)
