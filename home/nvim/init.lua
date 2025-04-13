-- opts
vim.opt.clipboard = "unnamedplus"
vim.opt.mouse = "a"
vim.opt.undofile = true
vim.opt.signcolumn = "yes"
vim.opt.inccommand = "split"
vim.opt.list = true
vim.opt.showmode = false
vim.opt.number = true
vim.opt.scrolloff = 8
vim.opt.splitbelow = true
vim.opt.splitright = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.autoindent = true
vim.opt.smartindent = true

vim.opt.hlsearch = false
vim.opt.incsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.background = "dark"
vim.opt.termguicolors = true

-- language-specific options
vim.api.nvim_create_autocmd("FileType", {
    pattern = "nix",
    callback = function()
        vim.opt_local.tabstop = 2
        vim.opt_local.softtabstop = 2
        vim.opt_local.shiftwidth = 2
    end
})

-- keymaps
vim.g.mapleader = " "
vim.g.maplocalleader = " "

local opts = { noremap = true, silent = true }

vim.keymap.set("n", "<leader>r", "<cmd>w<CR><cmd>luafile %<CR>", opts)
vim.keymap.set("n", "<C-h>", "<C-w><C-h>", opts)
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", opts)
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", opts)
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", opts)

vim.keymap.set("v", "<", "<gv", opts)
vim.keymap.set("v", ">", ">gv", opts)

-- diagnostics
vim.keymap.set("n", "<leader>do", "<cmd>lua vim.diagnostic.open_float()<CR>", opts)
vim.keymap.set("n", "<leader>d]", "<cmd>lua vim.diagnostic.goto_next()<CR>", opts)
vim.keymap.set("n", "<leader>d[", "<cmd>lua vim.diagnostic.goto_prev()<CR>", opts)
vim.keymap.set("n", "<leader>dd", "<cmd>lua vim.diagnostic.setloclist()<CR>", opts)
vim.diagnostic.config({ virtual_text = true })

-- yank highlight
vim.api.nvim_create_autocmd("TextYankPost", {
    callback = function()
        vim.highlight.on_yank()
    end
})

-- colorscheme
vim.cmd.colorscheme("quiet")

-- lsp
local lspconfig = require("lspconfig")

lspconfig.nixd.setup({})
lspconfig.hls.setup({})
lspconfig.lua_ls.setup({
    settings = {
        Lua = {
            diagnostics = {
                globals = { "vim" }
            }
        }
    }
})

-- lualine
require("lualine").setup({
    options = {
        icons_enabled = false,
        component_separators = "|",
        section_separators = ""
    }
})
