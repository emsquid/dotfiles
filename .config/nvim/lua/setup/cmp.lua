local cmp = require('cmp')
local lspkind = require('lspkind')

cmp.setup({
    snippet = {
        expand = function(args)
            require('luasnip').lsp_expand(args.body)
        end
    },
    mapping = {
        ['<Down>'] = cmp.mapping(cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }), { 'i', 'c' }),
        ['<Up>'] = cmp.mapping(cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }), { 'i', 'c' }),
        ['<Tab>'] = cmp.mapping(function(fallback)
            local col = vim.fn.col('.') - 1

            if cmp.visible() then
                cmp.select_next_item(select_opts)
            elseif col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') then
                fallback()
            else
                cmp.complete()
            end
        end, { 'i', 's' }),
        ['<CR>'] = cmp.mapping(function(fallback)
            if cmp.visible() and cmp.get_selected_entry() ~= nil then
                cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true })
            elseif cmp.visible() then
                cmp.close()
            else
                fallback()
            end
        end,
            { 'i', 'c' }
        ),
    },
    completion = {
        keyword_length = 1,
    },
    sources = {
        { name = 'nvim_lsp_signature_help' },
        { name = 'nvim_lsp' },
        { name = 'luasnip' },
        {
            name = 'buffer',
            option = {
                get_bufnrs = function()
                    local bufs = {}
                    for _, win in ipairs(vim.api.nvim_list_wins()) do
                        bufs[vim.api.nvim_win_get_buf(win)] = true
                    end
                    return vim.tbl_keys(bufs)
                end,
            },
        },
        { name = 'look', keyword_length = 3, option = { convert_case = true, loud = true } },
        { name = 'path' },
        { name = 'nvim_lua' },
    },
    sorting = { priority_weight = 2 },
    window = {
        completion = cmp.config.window.bordered { winhighlight = 'FloatBorder:TelescopeBorder,CursorLine:Visual,Search:None' },
        documentation = cmp.config.window.bordered { winhighlight = 'FloatBorder:TelescopeBorder,CursorLine:Visual,Search:None' }
    },
    formatting = {
        format = function(entry, vim_item)
            if vim.tbl_contains({ 'path' }, entry.source.name) then
                local icon, hl_group = require('nvim-web-devicons').get_icon(entry:get_completion_item().label)
                if icon then
                    vim_item.kind = icon
                    vim_item.kind_hl_group = hl_group
                    return vim_item
                end
            end
            return lspkind.cmp_format({ with_text = true })(entry, vim_item)
        end
    },
    experimental = {
        ghost_text = true,
    },
})

cmp.setup.cmdline({ '/', '?' }, {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
        { name = 'buffer' }
    }
})

cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
        { name = 'cmdline' },
        { name = 'path' }
    }
})
