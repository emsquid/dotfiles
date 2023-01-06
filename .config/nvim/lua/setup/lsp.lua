local lsp = require("lspconfig")

local function config(_config)
    return vim.tbl_deep_extend("force", {
        capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities()),
        on_attach = on_attach,
    }, _config or {})
end

vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(
    vim.lsp.handlers.hover, {
    border = 'rounded',
}
)

-- C++
lsp.clangd.setup(config())

-- Python
lsp.pylsp.setup(config(
    {
        settings = {
            pylsp = {
                plugins = {
                    pycodestyle = {
                        ignore = { 'E501' },
                    }
                }
            }
        }
    }
))

-- Lua
lsp.sumneko_lua.setup(config({
    settings = {
        Lua = {
            diagnostics = { globals = { 'vim' } },
            runtime = { version = "LuaJIT" },
            -- workspace = { library = vim.api.nvim_get_runtime_file("", true) },
            telemetry = { enable = false },
        },
    },
})
)

-- Rust
-- lsp.rust_analyzer.setup(config({
    -- cmd = { "rustup", "run", "nightly", "rust-analyzer" },
-- }))

-- LaTeX
lsp.texlab.setup(config())

-- bash
lsp.bashls.setup(config())
lsp.efm.setup(config({
    filetypes = { 'sh' }
}))

-- PHP
lsp.intelephense.setup(config())

-- HTML
lsp.html.setup(config())

-- CSS
lsp.cssls.setup(config())
