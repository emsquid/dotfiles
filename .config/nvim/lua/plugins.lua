local ensure_packer = function()
    local fn = vim.fn
    local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
    if fn.empty(fn.glob(install_path)) > 0 then
        fn.system({ 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path })
        vim.cmd [[packadd packer.nvim]]
        return true
    end
    return false
end

local packer_bootstrap = ensure_packer()

return require('packer').startup(function(use)
    use { 'wbthomason/packer.nvim' }

    -- [[ Theme ]]
    use { 'folke/tokyonight.nvim', config = function()
        vim.cmd [[ colorscheme tokyonight-night ]]
    end, } --colorscheme
    use { 'kyazdani42/nvim-web-devicons' } --icons
    use { 'goolord/alpha-nvim' }

    -- [[ Dev ]]
    use { 'neovim/nvim-lspconfig' } --lsp
    use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdateSync' } --treesitter

    -- [[ Cmp ]]
    use({
        'hrsh7th/nvim-cmp',
        requires = {
            { 'hrsh7th/cmp-nvim-lsp' },
            { 'hrsh7th/cmp-nvim-lsp-signature-help' },
            { 'hrsh7th/cmp-nvim-lua' },
            { 'hrsh7th/cmp-cmdline' },
            { 'hrsh7th/cmp-buffer' },
            { 'hrsh7th/cmp-path' },
            -- snippets
            { 'L3MON4D3/LuaSnip' },
            { 'saadparwaiz1/cmp_luasnip' },
            -- utils
            { 'onsails/lspkind-nvim' },
        },
    })

    -- [[ Misc ]]
    use { --fuzzy-finder
        'nvim-telescope/telescope.nvim',
        requires = { 'nvim-lua/plenary.nvim' }
    }
    use { 'nvim-telescope/telescope-file-browser.nvim' }
    use { 'numToStr/FTerm.nvim' } --floating terminal
    use { 'lukas-reineke/indent-blankline.nvim' } --indent viewer
    use { 'windwp/nvim-autopairs' } --autopairs
    use { 'RRethy/vim-illuminate' } --highlights word under cursor
    use { 'lewis6991/gitsigns.nvim' } --git
    use { 'samjwill/nvim-unception' } --terminal unception

    -- [[ Mini ]]
    use { 'echasnovski/mini.nvim' } --mini bundle

    -- [[ Test ]]

    if packer_bootstrap then
        require('packer').sync()
    end
end)
