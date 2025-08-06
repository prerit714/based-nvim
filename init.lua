vim.opt.winborder = "rounded"

vim.o.signcolumn = "yes"
vim.o.number = true
vim.o.relativenumber = true
vim.o.wrap = false
vim.o.swapfile = false
vim.g.mapleader = " "
vim.o.clipboard = "unnamedplus"
vim.o.backup = false
vim.o.writebackup = false
vim.o.undofile = true
vim.o.hidden = true
vim.o.list = true
vim.o.colorcolumn = "80"
vim.o.expandtab = true
vim.o.incsearch = true

-- Render special characters
vim.opt.listchars = {
  tab = "▸ ",
  trail = "·",
  extends = "›",
  precedes = "‹",
  nbsp = "␣",
}

vim.api.nvim_create_autocmd("FileType", {
  pattern = {
    "go",
    "rust",
    "python",
    "c",
    "cpp",
    "java",
    "kotlin",
    "php",
    "html",
    "xml",
  },
  callback = function()
    vim.opt_local.tabstop = 4
    vim.opt_local.softtabstop = 4
    vim.opt_local.shiftwidth = 4
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = {
    "lua",
    "typescript",
    "javascript",
    "typescriptreact",
    "javascriptreact",
    "css",
    "scss",
    "txt"
  },
  callback = function()
    vim.opt_local.tabstop = 2
    vim.opt_local.softtabstop = 2
    vim.opt_local.shiftwidth = 2
  end,
})

vim.keymap.set("i", "jk", "<esc>", { silent = true })
vim.keymap.set("i", "jk", "<esc>", { silent = true })

vim.pack.add({
  { src = "https://github.com/rktjmp/lush.nvim" },
  { src = "https://github.com/zenbones-theme/zenbones.nvim" },
  { src = "https://github.com/stevearc/oil.nvim" },
  { src = "https://github.com/nmac427/guess-indent.nvim" },
  { src = "https://github.com/neovim/nvim-lspconfig" },
  { src = "https://github.com/tpope/vim-fugitive" },
  { src = "https://github.com/MagicDuck/grug-far.nvim" },
  { src = "https://github.com/cbochs/grapple.nvim" },
})

vim.g.zenbones_darken_comments = 80
vim.g.zenbones_transparent_background = true
vim.cmd("colorscheme kanagawabones")

-- Additional transparency settings (if needed)
vim.cmd [[
  highlight Normal guibg=NONE ctermbg=NONE
  highlight NonText guibg=NONE ctermbg=NONE
  highlight SignColumn guibg=NONE ctermbg=NONE
  highlight NormalFloat guibg=NONE ctermbg=NONE
  highlight FloatBorder guibg=NONE ctermbg=NONE
]]

local oil = require("oil")
oil.setup({
  default_file_explorer = true,
  view_options = {
    show_hidden = true
  }
})
vim.keymap.set("n", "<leader>o", "<cmd>Oil<cr>")

vim.lsp.enable({
  "lua_ls",
  "denols",
  "gopls",
})

-- Custom formatter
local format_local_buffer = function()
  print("Formatting buffer ... Ok")
  vim.lsp.buf.format()
end
vim.keymap.set("n", "<leader>bf", format_local_buffer)

-- Resize buffers when I am using more than 1
vim.api.nvim_create_autocmd("VimResized", {
  pattern = "*",
  callback = function()
    vim.cmd "wincmd ="
  end,
})

-- Window navigation remaps
vim.keymap.set("n", "<C-h>", "<C-w>h")
vim.keymap.set("n", "<C-j>", "<C-w>j")
vim.keymap.set("n", "<C-k>", "<C-w>k")
vim.keymap.set("n", "<C-l>", "<C-w>l")

vim.keymap.set("n", "<esc>", "<cmd>nohlsearch<cr>", { silent = true })
vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, { silent = true })

-- Mini setup
vim.keymap.set("n", "<leader>sf", "<cmd>Pick files tool='git'<cr>", { silent = true })
vim.keymap.set("n", "<leader>sg", "<cmd>Pick grep_live<cr>", { silent = true })
vim.keymap.set("n", "<leader>sb", "<cmd>Pick buffers<cr>", { silent = true })
vim.keymap.set("n", "<leader>sd", "<cmd>Pick diagnostic<cr>", { silent = true })

-- Grapple setup
local grapple = require("grapple")
grapple.setup({
  icons = false
})

vim.keymap.set("n", "<leader>m", "<cmd>Grapple toggle<cr>", { silent = true })
vim.keymap.set("n", "<leader>M", "<cmd>Grapple toggle_tags<cr>", { silent = true })
vim.keymap.set("n", "H", "<cmd>Grapple cycle_tags prev<cr>", { silent = true })
vim.keymap.set("n", "L", "<cmd>Grapple cycle_tags next<cr>", { silent = true })
