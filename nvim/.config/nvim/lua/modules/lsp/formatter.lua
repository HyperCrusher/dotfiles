return {
    {
        "stevearc/conform.nvim",
        config = function()
            require("conform").setup({
                formatters_by_ft = {
                    asm = {"asmfmt"},
                    sh = {"shfmt"},
                    c = {"uncrustify"},
                    cs = {"csharpier"},
                    go = {"goimports", "golines", "gofmt"},
                    gdscript = {"gdformat"},
                    haskell = {"ormolu"},
                    java = {"uncrustify"},
                    json = {"fixjson"},
                    kotlin = {"ktfmt"},
                    lua = {"lua-format"},
                    python = {"isort"},
                    rust = {"rustfmt"},
                    typescript = {"deno"},
                    typst = {"typstyle"},
                    yaml = {"yq"},
                    zig = {"zigfmt"}
                },
                format_on_save = {timeout_ms = 500, lsp_format = "fallback"}
            })
        end
    }
}
