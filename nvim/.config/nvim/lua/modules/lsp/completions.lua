local kindIcons = {
    Text = "󰉿 ",
    Method = "  ",
    Function = "  ",
    Constructor = "  ",
    Field = "  ",
    Variable = "  ",
    Class = "  ",
    Interface = "  ",
    Module = "  ",
    Property = "  ",
    Unit = "  ",
    Value = "󰎠 ",
    Enum = "  ",
    Keyword = "  ",
    Snippet = " ",
    Color = "  ",
    File = "  ",
    Reference = "  ",
    Folder = "  ",
    EnumMember = "  ",
    Constant = "  ",
    Struct = "  ",
    Event = "  ",
    Operator = "  ",
    TypeParameter = "  "
}

local function configCmp()
    local cmp = require('cmp')

    local wordsBefore = function()
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and
                   vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(
                       col, col):match('%s') == nil
    end
    local luasnip = require('luasnip')

    local sources = {
        {name = "nvim_lsp"}, {name = "luasnip"}, {name = "treesitter"},
        {name = "path"}, {name = "buffer"}
    }
    if vim.o.ft == "markdown" or vim.o.ft == "txt" or vim.o.ft == "html" or
        vim.o.ft == "gitcommit" or vim.o.ft == "org" then
        table.insert(sources, {name = 'latex_symbols'})
        table.insert(sources, {name = 'emoji'})
    end

    if vim.o.ft == "lua" then
        table.insert(sources {name = "lazydev", group_index = 0})
    end
    local compare = require("cmp.config.compare")

    cmp.setup({
        enabled = function()
            local context = require("cmp.config.context")
            if vim.api.nvim_get_mode().mode == "c" then
                return true
            else
                return not context.in_treesitter_capture("comment") and
                           not context.in_syntax_group("Comment")
            end
        end,
        snippet = {
            expand = function(args)
                require("luasnip").lsp_expand(args.body)
            end
        },
        completion = {
            completeopt = "menu,menuone,noinset",
            autocomplete = {require("cmp.types").cmp.TriggerEvent.TextChanged}
        },
        formatting = {
            fields = {"kind", "abbr", "menu"},
            expandable_indicator = false,
            format = function(_, vim_item)
                local icon = kindIcons[vim_item.kind]
                local kind = vim_item.kind
                vim_item.kind = icon
                if not (kind == "Text") then
                    vim_item.menu = " (" .. kind .. ") "
                end
                return vim_item
            end
        },
        window = {
            completion = {border = "rounded"},
            documentation = {border = "rounded"}
        },
        mapping = cmp.mapping.preset.insert({
            ["<Tab>"] = cmp.mapping(function(fallback)
                if cmp.visible() then
                    cmp.confirm({select = true})
                elseif luasnip.expand_or_locally_jumpable() then
                    luasnip.expand_or_jump()
                elseif wordsBefore() then
                    cmp.complete()
                else
                    fallback()
                end
            end),
            ["<C-n>"] = cmp.mapping.select_next_item({
                behavior = cmp.SelectBehavior.Select
            }),
            ["<C-p>"] = cmp.mapping.select_prev_item({
                behavior = cmp.SelectBehavior.Select
            })
        }),
        sources = sources,

        matching = {disallow_prefix_unmatching = true},
        performance = {max_view_entries = 12},

        cmp.setup.cmdline(":", {
            mapping = cmp.mapping.preset.cmdline({
                ["<Tab>"] = cmp.mapping.confirm({select = true})
            }),
            sources = cmp.config.sources({{name = "path"}}, {
                {name = "cmdline", option = {ignore_cmds = {"Man", "!"}}}
            })
        }),
        cmp.setup.cmdline("/", {
            mapping = cmp.mapping.preset.cmdline(),
            sources = {{name = "buffer"}}
        }),
        view = {docs = {auto_open = true}},
        sorting = {
            priority_weight = 2,
            comparators = {
                compare.offset, compare.exact, compare.score,
                compare.recently_used, compare.locality,
                require("cmp-under-comparator").under, compare.kind,
                compare.sort_text, compare.order
            }
        }
    })
end

return {
    {
        "hrsh7th/nvim-cmp",
        dependencies = {
            "hrsh7th/cmp-nvim-lsp", "hrsh7th/cmp-nvim-lsp-signature-help",
            "hrsh7th/cmp-buffer", "hrsh7th/cmp-cmdline",
            "dmitmel/cmp-cmdline-history", "lukas-reineke/cmp-under-comparator",
            "ray-x/cmp-treesitter", "hrsh7th/cmp-emoji", "folke/lazydev.nvim",
            "hrsh7th/cmp-path", "kdheepak/cmp-latex-symbols", {
                "saadparwaiz1/cmp_luasnip",
                dependencies = {
                    {
                        "L3MON4D3/LuaSnip",
                        init = function()
                            require("luasnip.loaders.from_vscode").lazy_load()
                        end,
                        dependencies = {"rafamadriz/friendly-snippets"}
                    }
                }
            }
        },
        lazy = false,
        config = function() configCmp() end
    }
}
