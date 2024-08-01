-- This file can be loaded by calling `lua require('plugins')` from your init.vim
--

-- local fn = vim.fn

-- Automatically install packer
-- local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
-- if fn.empty(fn.glob(install_path)) > 0 then
-- 	PACKER_BOOTSTRAP = fn.system({
-- 		"git",
-- 		"clone",
-- 		"--depth",
-- 		"1",
-- 		"https://github.com/wbthomason/packer.nvim",
-- 		install_path,
-- 	})
-- 	print("Installing packer close and reopen Neovim...")
-- 	vim.cmd([[packadd packer.nvim]])
-- end

-- Use a protected call so we don't error out on first use
local status_ok, packer = pcall(require, "packer")
if not status_ok then
    return
end

return packer.startup(function(use)
    -- Packer can manage itself
    use 'wbthomason/packer.nvim'

    use {
        'nvim-telescope/telescope.nvim', tag = '0.1.4',
        -- or                            , branch = '0.1.x',
        requires = { { 'nvim-lua/plenary.nvim' } }
    }

    -- use({
    --     'rose-pine/neovim',
    --     as = 'rose-pine',
    --     config = function()
    --         vim.cmd('colorscheme rose-pine')
    --     end
    -- })

    use({ 'rebelot/kanagawa.nvim', as = 'kanagawa' })

    use { 'catppuccin/nvim', as = 'catppuccin' };

    use 'folke/tokyonight.nvim'

    use({ 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' })
    -- use 'nvim-treesitter/nvim-treesitter-context'
    use('nvim-treesitter/playground')
    use('theprimeagen/harpoon')
    use('mbbill/undotree')
    use('tpope/vim-fugitive')

    use {
        'VonHeikemen/lsp-zero.nvim',
        requires = {
            -- LSP Support
            { 'neovim/nvim-lspconfig' },
            { 'williamboman/mason.nvim' },
            { 'williamboman/mason-lspconfig.nvim' },

            -- Autocompletion
            { 'hrsh7th/nvim-cmp' },
            { 'hrsh7th/cmp-buffer' },
            { 'hrsh7th/cmp-path' },
            { 'saadparwaiz1/cmp_luasnip' },
            { 'hrsh7th/cmp-nvim-lsp' },
            { 'hrsh7th/cmp-nvim-lua' },

            -- Snippets
            { 'L3MON4D3/LuaSnip' },
            { 'rafamadriz/friendly-snippets' },
        }
    }

    use("folke/zen-mode.nvim")
    use("folke/twilight.nvim")

    use('wakatime/vim-wakatime')

    use({
        'rose-pine/neovim',
        as = 'rose-pine',
    })

    use { 'lewis6991/gitsigns.nvim' }

    use {
        'numToStr/Comment.nvim',
        config = function()
            require('Comment').setup()
        end
    }

    -- use null ls for formatting using prettier

    --    use({
    --        "jose-elias-alvarez/null-ls.nvim",
    --        requires = {
    --            "nvim-lua/plenary.nvim",
    --            "neovim/nvim-lspconfig",
    --        },
    --    })
    --

    use('adelarsq/neofsharp.vim')

    use {
        'mrcjkb/haskell-tools.nvim',
        dependencies = {
            'nvim-lua/plenary.nvim',
        },
        branch = '2.x.x', -- Recommended
        ft = { 'haskell', 'lhaskell', 'cabal', 'cabalproject' },
    }

    use("projekt0n/github-nvim-theme")

    use {
        'creativenull/efmls-configs-nvim',
        tag = 'v1.*', -- tag is optional, but recommended
        requires = { 'neovim/nvim-lspconfig' },
    }

    use { "elixir-tools/elixir-tools.nvim", requires = { "nvim-lua/plenary.nvim" } }

    use { "morhetz/gruvbox" }
    -- use('ja-ford/delaytrain.nvim')

    use({
        'NTBBloodbath/doom-one.nvim',
        setup = function()
            -- Add color to cursor
            vim.g.doom_one_cursor_coloring = false
            -- Set :terminal colors
            vim.g.doom_one_terminal_colors = true
            -- Enable italic comments
            vim.g.doom_one_italic_comments = false
            -- Enable TS support
            vim.g.doom_one_enable_treesitter = true
            -- Color whole diagnostic text or only underline
            vim.g.doom_one_diagnostics_text_color = false
            -- Enable transparent background
            vim.g.doom_one_transparent_background = false

            -- Pumblend transparency
            vim.g.doom_one_pumblend_enable = false
            vim.g.doom_one_pumblend_transparency = 20

            -- Plugins integration
            vim.g.doom_one_plugin_neorg = true
            vim.g.doom_one_plugin_barbar = false
            vim.g.doom_one_plugin_telescope = false
            vim.g.doom_one_plugin_neogit = true
            vim.g.doom_one_plugin_nvim_tree = true
            vim.g.doom_one_plugin_dashboard = true
            vim.g.doom_one_plugin_startify = true
            vim.g.doom_one_plugin_whichkey = true
            vim.g.doom_one_plugin_indent_blankline = true
            vim.g.doom_one_plugin_vim_illuminate = true
            vim.g.doom_one_plugin_lspsaga = false
        end,
        config = function()
            vim.cmd("colorscheme doom-one")
        end,
    })

    use({
        "zbirenbaum/copilot.lua",
        event = "VimEnter",
        config = function()
            vim.defer_fn(function()
                require("copilot").setup({
                    suggestion = {
                        auto_trigger = true,
                        keymap = {
                            accept = "<Tab>",
                            next = "<M-]>",
                            prev = "<M-[>",
                            dismiss = "<C-]>",
                        },
                    },
                })
            end, 100)
        end,
    })
end)
