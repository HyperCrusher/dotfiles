-- Easier to define keymaps
local keymap = function(mode, keys, action, opt)
    local default_opts = {silent = true, buffer = true}
    opt = opt or {}
    for k, v in pairs(default_opts) do if opt[k] == nil then opt[k] = v end end
    vim.keymap.set(mode, keys, action, opt)
end

-- On attach that all lsp's get piped to
local function onAttach(client, buffer)
    require("lsp_signature").on_attach({}, buffer)
    require("workspace-diagnostics").populate_workspace_diagnostics(client,
                                                                    buffer)
    local tinyAction = require("tiny-code-action")

    keymap("n", "R",
           function() return ":IncRename " .. vim.fn.expand("<cword>") end,
           {expr = true})

    keymap("n", "K", vim.lsp.buf.hover)
    keymap("n", "gd", ":Telescope lsp_definitions initial_mode=normal<CR>")
    keymap("n", "gi", ":Telescope lsp_implementations initial_mode=normal<CR>")
    keymap("n", "gt", ":Telescope lsp_type_definitions initial_mode=normal<CR>")
    keymap("n", "gD", vim.lsp.buf.declaration)
    keymap("n", "gr", ":Telescope lsp_references initial_mode=normal<CR>")
    keymap("n", "<leader>ca", tinyAction.code_action)
end

return {
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            "ray-x/lsp_signature.nvim", "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",
            "artemave/workspace-diagnostics.nvim", "hrsh7th/nvim-cmp",
            "rachartier/tiny-code-action.nvim",
            "rachartier/tiny-inline-diagnostic.nvim"
        },
        opts = {
            diagnostics = {update_in_insert = true, virtual_text = false},
            servers = {
                "asm_lsp", "clangd", "dockerls", "gdscript", "glslls", "gopls",
                "hls", "kotlin_language_server", "lua_ls", "nil_ls",
                "omnisharp", "pyright", "ruff", "rust_analyzer", "statix",
                "taplo", "ts_ls", "zls"
            }
        },
        config = function(_, opts)
            local lspconfig = require("lspconfig")
            for _, v in pairs(opts.servers) do -- Makes every server use onAttach, and cmp
                local config = {
                    capabilities = require("cmp_nvim_lsp").default_capabilities(),
                    on_attach = onAttach
                }
                lspconfig[v].setup(config)
            end
            vim.diagnostic.config(opts.diagnostics or {})
        end
    }, {"ray-x/lsp_signature.nvim", opts = {}},
    {"williamboman/mason.nvim", opts = {}}, {
        "williamboman/mason-lspconfig.nvim",
        dependencies = {"williamboman/mason.nvim"},
        opts = {automatic_installation = not Nixos}
    }, {"j-hui/fidget.nvim", opts = {notification = {window = {winblend = 0}}}},
    {"rachartier/tiny-code-action.nvim", event = "LspAttach", opts = {}},
    {"rachartier/tiny-inline-diagnostic.nvim", event = "VeryLazy", opts = {}},
    {"artemave/workspace-diagnostics.nvim"}, {"VidocqH/lsp-lens.nvim"}, {
        "smjonas/inc-rename.nvim",
        dependencies = {"stevearc/dressing.nvim"},
        config = true
    }
}
