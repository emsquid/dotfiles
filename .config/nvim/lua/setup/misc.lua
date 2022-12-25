local telescope = require('telescope')
telescope.setup {
    defaults = {
        mappings = {
            i = {
                ['<esc>'] = require('telescope.actions').close
            }
        }
    },
    pickers = {
        buffers = {
            mappings = {
                n = {
                    ['<c-d>'] = require('telescope.actions').delete_buffer
                },
                i = {
                    ['<c-d>'] = require('telescope.actions').delete_buffer
                }
            }
        }
    }
}
telescope.load_extension('file_browser')

require('FTerm').setup({
    border     = 'rounded',
    hl         = 'NormalFloat',
    dimensions = {
        height = 0.7,
        width = 0.6,
    },
})

vim.api.nvim_create_autocmd(
    "User",
    {
        pattern = "UnceptionEditRequestReceived",
        callback = function()
            require('FTerm').toggle()
        end
    }
)

require('illuminate').configure {
    providers = {
        'treesitter',
        'lsp'
    }
}

require('indent_blankline').setup {
    space_char_blankline = " ",
}

require('nvim-autopairs').setup()

require('cmp').event:on(
    'confirm_done',
    require('nvim-autopairs.completion.cmp').on_confirm_done()
)

require('gitsigns').setup()
