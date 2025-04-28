-- opts
vim.opt.clipboard = "unnamedplus"
vim.opt.confirm = true
vim.opt.mouse = "a"
vim.opt.undofile = true
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.scrolloff = 6
vim.opt.guicursor = "n-v-c-sm:block,i-ci-ve-t:ver25,r-cr-o:hor20"

vim.opt.signcolumn = "yes"
vim.opt.number = true
vim.opt.list = true
vim.opt.showtabline = 2
vim.opt.showmode = true

vim.opt.wrap = true
vim.opt.linebreak = true
vim.opt.breakindent = true
vim.opt.showbreak = "> "
vim.opt.smoothscroll = true

vim.opt.tabstop = 4
vim.opt.shiftwidth = 0
vim.opt.softtabstop = -1
vim.opt.expandtab = true
vim.opt.smarttab = true
vim.opt.autoindent = true
vim.opt.smartindent = true

vim.opt.hlsearch = false
vim.opt.incsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.inccommand = "split"
vim.opt.virtualedit = "block"

vim.opt.background = "dark"
vim.opt.termguicolors = true

-- language-specific options
vim.api.nvim_create_autocmd("FileType", {
    pattern = { "*.nix", "*.html", "*.css" },
    callback = function()
        vim.opt_local.tabstop = 2
        vim.opt.expandtab = true
    end
})

-- keymaps
vim.g.mapleader = " "
vim.g.maplocalleader = " "

local opts = {
    noremap = true,
    silent = true
}

setmetatable(opts, {
    __concat = function(t1, t2)
        local final = {}
        for k, v in pairs(t1) do
            final[k] = v
        end
        for k, v in pairs(t2) do
            final[k] = v
        end
        return final
    end
})

vim.keymap.set("n", "<leader>r", "<cmd>luafile %<CR>", opts)
vim.keymap.set("v", "<leader>r", ":lua<CR>", opts)

-- motion
vim.keymap.set("n", "j", "gj", opts)
vim.keymap.set("n", "k", "gk", opts)
vim.keymap.set("n", "<C-h>", "<C-w>h", opts)
vim.keymap.set("n", "<C-l>", "<C-w>l", opts)
vim.keymap.set("n", "<C-j>", "<C-w>j", opts)
vim.keymap.set("n", "<C-k>", "<C-w>k", opts)

vim.keymap.set("v", "<", "<gv", opts)
vim.keymap.set("v", ">", ">gv", opts)

-- tabs
vim.keymap.set("n", "<leader>dt", "<cmd>tabclose<CR>", opts .. { desc = "[D]elete [T]ab" })
for i = 1, 9 do
    vim.keymap.set("n", "<M-" .. i .. ">", i .. "gt", opts)
end

-- buffers
vim.keymap.set("n", "gb", "<cmd>bnext<CR>", opts)
vim.keymap.set("n", "gB", "<cmd>bprev<CR>", opts)
vim.keymap.set("n", "<leader>db", "<cmd>bdel<CR>", opts .. { desc = "[D]elete [B]uffer" })

-- quickfix
vim.keymap.set({ "n", "i" }, "<M-j>", "<cmd>cnexf<CR>", opts)
vim.keymap.set({ "n", "i" }, "<M-k>", "<cmd>cprev<CR>", opts)

--lsp
vim.keymap.set("n", "grd", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts)
vim.keymap.set("n", "grf", "<cmd>lua vim.lsp.buf.format()<CR>", opts)

-- diagnostics
vim.keymap.set("n", "gd", "<cmd>lua vim.diagnostic.jump({ count = 1, float = true })<CR>", opts)
vim.keymap.set("n", "gD", "<cmd>lua vim.diagnostic.jump({ count = -1, float = true })<CR>", opts)
vim.keymap.set("n", "<leader>cd", "<cmd>lua vim.diagnostic.setloclist()<CR>",
    opts .. { desc = "Qui[c]kfix [D]iagnostics" })
vim.diagnostic.config({ virtual_text = true })

-- yank highlight
vim.api.nvim_create_autocmd("TextYankPost", {
    group = vim.api.nvim_create_augroup("yank-highlight", { clear = true }),
    callback = function()
        vim.highlight.on_yank()
    end
})

-- colorscheme
vim.cmd.colorscheme("retrobox")

-- lsp
local lspconfig = require("lspconfig")
lspconfig.nixd.setup({})
lspconfig.hls.setup({})
lspconfig.lua_ls.setup({
    settings = { Lua = { diagnostics = { globals = { "vim" } } } }
})

require("nvim-autopairs").setup()

-- floating terminal
local fterm = {
    win = -1,
    buf = -1
}

vim.api.nvim_set_hl(0, "FTerm", { link = "Normal" })
vim.api.nvim_set_hl(0, "FTermBorder", { fg = "#83a598" })

function fterm:create_win()
    local width = math.floor(vim.o.columns * 0.6)
    local height = math.floor(vim.o.lines * 0.6)
    self.win = vim.api.nvim_open_win(self.buf, true, {
        relative = "editor",
        width = width,
        height = height,
        col = (vim.o.columns - width) / 2,
        row = (vim.o.lines - height) / 2,
        style = "minimal",
        border = "rounded" -- none | single | double | rounded | solid | shadow
    })
    vim.api.nvim_set_option_value("winhl", "Normal:FTerm,FloatBorder:FTermBorder", { win = self.win })
end

function fterm:create_buf()
    self.buf = vim.api.nvim_create_buf(false, true)
end

function fterm:toggle()
    if not vim.api.nvim_buf_is_valid(self.buf) then
        self:create_buf()
    end
    if not vim.api.nvim_win_is_valid(self.win) then
        self:create_win()
        if vim.bo[self.buf].buftype ~= "terminal" then
            vim.cmd.term()
        end
        vim.cmd("startinsert")
    else
        vim.api.nvim_win_hide(self.win)
    end
end

vim.api.nvim_create_user_command("FTerm", function() fterm:toggle() end, {})
vim.keymap.set("n", "<leader>t", "<cmd>FTerm<CR>", opts .. { desc = "[T]erminal Toggle" })
vim.keymap.set("t", "<esc>", "<C-\\><C-n>", opts)
