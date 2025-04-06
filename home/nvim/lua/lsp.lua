local lspconfig = require("lspconfig")
lspconfig.nixd.setup({ })
lspconfig.lua_ls.setup({
    settings = {
        Lua = {
            diagnostics = {
                globals = { "vim" }
            }
        }
    }
})
