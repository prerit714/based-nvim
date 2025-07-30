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

vim.keymap.set("i", "jk", "<esc>", { silent = true })
vim.keymap.set("i", "jk", "<esc>", { silent = true })

vim.pack.add({
  { src = "https://github.com/vague2k/vague.nvim" },
  { src = "https://github.com/stevearc/oil.nvim" },
  { src = "https://github.com/neovim/nvim-lspconfig" },
  { src = "https://github.com/hrsh7th/cmp-nvim-lsp" },
  { src = "https://github.com/hrsh7th/cmp-buffer" },
  { src = "https://github.com/hrsh7th/cmp-path" },
  { src = "https://github.com/hrsh7th/cmp-cmdline" },
  { src = "https://github.com/hrsh7th/nvim-cmp" },
  { src = "https://github.com/tpope/vim-fugitive" },
  { src = "https://github.com/MagicDuck/grug-far.nvim" },
  { src = "https://github.com/echasnovski/mini.pairs" },
  { src = "https://github.com/echasnovski/mini.pick" },
  { src = "https://github.com/echasnovski/mini.extra" },
  { src = "https://github.com/echasnovski/mini.comment" },
  { src = "https://github.com/cbochs/grapple.nvim" },
  { src = "https://github.com/zbirenbaum/copilot.lua" },
  {
    src = "https://github.com/prerit714/copilot-cmp",
    version = "dev-1"
  },
  { src = "https://github.com/mason-org/mason.nvim" },
  {
    src = "https://github.com/nvim-treesitter/nvim-treesitter",

  },
  {
    src = "https://github.com/nvim-treesitter/nvim-treesitter-context",
  },
  {
    src = "https://github.com/lukas-reineke/indent-blankline.nvim",
  }
})


-- Load the vague theme
require("vague").setup({})
vim.cmd("colorscheme vague")

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
  "vtsls",
  "gopls",
  "pylyzer",
  "clangd",
})

local format_local_buffer = function()
  print("Formatting buffer ... Ok")
  vim.lsp.buf.format()
end
vim.keymap.set("n", "<leader>bf", format_local_buffer)

-- Setting up snippet engine and LSP
local cmp = require("cmp")
cmp.setup({
  snippet = {
    expand = function(args)
      vim.snippet.expand(args.body)
    end
  },
  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered()
  },
  mapping = cmp.mapping.preset.insert({
    ["<C-space"] = cmp.mapping.complete(),
    ["<C-e>"] = cmp.mapping.abort(),
    ["<C-y>"] = cmp.mapping.confirm({ select = true }),
    ["<C-j>"] = cmp.mapping.scroll_docs(4),
    ["<C-k>"] = cmp.mapping.scroll_docs(-4),
  }),
  sources = cmp.config.sources({
    { name = "copilot" },
    { name = "nvim_lsp" },
  })
}, {
  { name = "buffer" }
})

-- Setup more LSP based stuff
vim.keymap.set("n", "gd", vim.lsp.buf.definition, { silent = true })
vim.keymap.set("n", "gi", vim.lsp.buf.implementation, { silent = true })
vim.keymap.set("n", "gr", vim.lsp.buf.references, { silent = true })
vim.keymap.set("n", "gh", vim.lsp.buf.hover, { silent = true })
vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { silent = true })
vim.keymap.set("n", "gR", vim.lsp.buf.rename, { silent = true })
vim.keymap.set("n", "ga", vim.lsp.buf.code_action, { silent = true })
vim.keymap.set("n", "gl", vim.lsp.codelens.run, { silent = true })
vim.keymap.set("n", "gL", vim.lsp.codelens.refresh, { silent = true })
vim.keymap.set("n", "g=", vim.lsp.buf.format, { silent = true })


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

local mini_pairs = require("mini.pairs")
mini_pairs.setup()

local mini_pick = require("mini.pick")
mini_pick.setup()

local mini_extra = require("mini.extra")
mini_extra.setup()

vim.keymap.set("n", "<esc>", "<cmd>nohlsearch<cr>", { silent = true })
vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, { silent = true })

vim.keymap.set("n", "<leader>sf", "<cmd>Pick files tool='git'<cr>", { silent = true })
vim.keymap.set("n", "<leader>sg", "<cmd>Pick grep_live<cr>", { silent = true })
vim.keymap.set("n", "<leader>sb", "<cmd>Pick buffers<cr>", { silent = true })
vim.keymap.set("n", "<leader>sd", "<cmd>Pick diagnostic<cr>", { silent = true })

local grapple = require("grapple")
grapple.setup({
  icons = false
})

vim.keymap.set("n", "<leader>m", "<cmd>Grapple toggle<cr>", { silent = true })
vim.keymap.set("n", "<leader>M", "<cmd>Grapple toggle_tags<cr>", { silent = true })
vim.keymap.set("n", "H", "<cmd>Grapple cycle_tags prev<cr>", { silent = true })
vim.keymap.set("n", "L", "<cmd>Grapple cycle_tags next<cr>", { silent = true })

local mini_comment = require("mini.comment")
mini_comment.setup()

local copilot = require("copilot")
copilot.setup()

-- This is the best way to use copilot
local copilot_cmp = require("copilot_cmp")
copilot_cmp.setup()

-- Setup mason
local mason = require("mason")
mason.setup()

-- Setup treesitter
local treesitter = require("nvim-treesitter.configs")
treesitter.setup({
  ensure_installed = {
    "lua",
    "javascript",
    "typescript",
    "html",
    "css",
    "json",
    "python",
    "go",
    "rust",
    "c",
    "cpp",
    "java",
    "kotlin",
    "templ",
  },
  highlight = {
    enable = true,
  },
  indent = {
    enable = true,
  },
  incremental_selection = {
    enable = true,
  },
})

local treesitter_context = require("treesitter-context")
treesitter_context.setup()

local ibl = require("ibl")
ibl.setup({
  exclude = {
    filetypes = {
      "oil",
      "lazy",
      "help",
      "go"
    }
  }
})

-- Create an autocommand group for filetype indentation
local indent_group = vim.api.nvim_create_augroup(
  "FileTypeIndent",
  { clear = true }
)

-- My filetype settings
local filetype_settings = {
  -- Web development (2 spaces)
  javascript = { expandtab = true, shiftwidth = 2, tabstop = 2, softtabstop = 2 },
  typescript = { expandtab = true, shiftwidth = 2, tabstop = 2, softtabstop = 2 },
  html = { expandtab = true, shiftwidth = 2, tabstop = 2, softtabstop = 2 },
  css = { expandtab = true, shiftwidth = 2, tabstop = 2, softtabstop = 2 },
  scss = { expandtab = true, shiftwidth = 2, tabstop = 2, softtabstop = 2 },
  json = { expandtab = true, shiftwidth = 2, tabstop = 2, softtabstop = 2 },
  yaml = { expandtab = true, shiftwidth = 2, tabstop = 2, softtabstop = 2 },
  vue = { expandtab = true, shiftwidth = 2, tabstop = 2, softtabstop = 2 },
  svelte = { expandtab = true, shiftwidth = 2, tabstop = 2, softtabstop = 2 },

  -- Python (4 spaces, PEP 8)
  python = { expandtab = true, shiftwidth = 4, tabstop = 4, softtabstop = 4 },

  -- Lua (2 spaces)
  lua = { expandtab = true, shiftwidth = 2, tabstop = 2, softtabstop = 2 },

  -- Go (tabs)
  go = { expandtab = false, shiftwidth = 4, tabstop = 4, softtabstop = 4 },

  -- C/C++ (4 spaces or tabs, depending on preference)
  c = { expandtab = true, shiftwidth = 4, tabstop = 4, softtabstop = 4 },
  cpp = { expandtab = true, shiftwidth = 4, tabstop = 4, softtabstop = 4 },

  -- Rust (4 spaces)
  rust = { expandtab = true, shiftwidth = 4, tabstop = 4, softtabstop = 4 },

  -- Java (4 spaces)
  java = { expandtab = true, shiftwidth = 4, tabstop = 4, softtabstop = 4 },

  -- Shell scripts (2 spaces)
  sh = { expandtab = true, shiftwidth = 2, tabstop = 2, softtabstop = 2 },
  bash = { expandtab = true, shiftwidth = 2, tabstop = 2, softtabstop = 2 },
  zsh = { expandtab = true, shiftwidth = 2, tabstop = 2, softtabstop = 2 },

  -- Ruby (2 spaces)
  ruby = { expandtab = true, shiftwidth = 2, tabstop = 2, softtabstop = 2 },

  -- PHP (4 spaces)
  php = { expandtab = true, shiftwidth = 4, tabstop = 4, softtabstop = 4 },

  -- Markdown (4 spaces)
  markdown = { expandtab = true, shiftwidth = 4, tabstop = 4, softtabstop = 4 },

  -- Make files (must use tabs)
  make = { expandtab = false, shiftwidth = 4, tabstop = 4, softtabstop = 0 },
}

-- Function to apply indentation settings
local function set_indent_settings(settings)
  for option, value in pairs(settings) do
    vim.opt_local[option] = value
  end
end

-- Create autocommands for each filetype
for filetype, settings in pairs(filetype_settings) do
  vim.api.nvim_create_autocmd("FileType", {
    group = indent_group,
    pattern = filetype,
    callback = function()
      set_indent_settings(settings)
    end,
    desc = string.format("Set indentation for %s files", filetype)
  })
end
