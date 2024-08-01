return {
    'folke/neodev.nvim',
    {
        'nvim-telescope/telescope.nvim',
        config = function()
            local builtin = require('telescope.builtin')
            vim.keymap.set('n', '<leader>f', builtin.find_files, {})
            vim.keymap.set('n', '<C-p>', builtin.git_files, {})
            vim.keymap.set('n', '<leader>ps', function()
                builtin.grep_string({ search = vim.fn.input("Grep > ") })
            end)
            vim.keymap.set("n", "<leader>sr", builtin.oldfiles, {})
            vim.keymap.set("n", "<leader>ct", builtin.colorscheme, {})
        end
    },
    {
        'rebelot/kanagawa.nvim',
        name = 'kanagawa',
        config = function()
            require('kanagawa').setup({
                transparent = true,
                colors = {
                    theme = {
                        all = {
                            ui = {
                                bg_gutter = "none"
                            }
                        }
                    }
                }
            })
            vim.cmd("colorscheme kanagawa")
        end
    },
    'folke/tokyonight.nvim',
    {
        'catppuccin/nvim',
        name = 'catppuccin'
    },
    {
        'theprimeagen/harpoon',
        branch = 'harpoon2',
        config = function()
            local harpoon = require("harpoon")

            -- REQUIRED
            harpoon:setup({
                settings = {
                    save_on_toggle = true,
                },
            })
            -- REQUIRED

            vim.keymap.set("n", "<leader>a", function() harpoon:list():append() end)
            vim.keymap.set("n", "<C-e>", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)

            vim.keymap.set("n", "<C-h>", function() harpoon:list():select(1) end)
            vim.keymap.set("n", "<C-j>", function() harpoon:list():select(2) end)
            vim.keymap.set("n", "<C-k>", function() harpoon:list():select(3) end)
            vim.keymap.set("n", "<C-l>", function() harpoon:list():select(4) end)

            -- Toggle previous & next buffers stored within Harpoon list
            vim.keymap.set("n", "<C-S-P>", function() harpoon:list():prev() end)
            vim.keymap.set("n", "<C-S-N>", function() harpoon:list():next() end)
        end,
        dependencies = { "nvim-lua/plenary.nvim" }
    },
    {
        'folke/zen-mode.nvim',
        config = function()
            require("zen-mode").setup {
                window = {
                    width = 120,
                    options = {
                        number = true,
                        relativenumber = true,
                    }
                },
                plugins = {
                    options = {
                        enabled = true,
                        ruler = false,         -- disables the ruler text in the cmd line area
                        showcmd = false,       -- disables the command in the last line of the screen
                    },
                    tmux = { enabled = true }, -- disables the tmux statusline
                    twilight = { enabled = false },
                },
            }

            vim.keymap.set("n", "<leader>zz", function()
                require("zen-mode").toggle()
                vim.wo.wrap = false
            end)
        end
    },
    -- 'wakatime/vim-wakatime',
    {
        'numToStr/Comment.nvim',
        config = function()
            require('Comment').setup()
        end
    },
    {
        'nvim-treesitter/nvim-treesitter',
        build = ':TSUpdate',
        config = function()
            local configs = require("nvim-treesitter.configs")

            configs.setup({
                ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "elixir", "heex", "javascript", "html" },
                sync_install = false,
                highlight = { enable = true },
                indent = { enable = true },
            })
        end
    },
    'nvim-treesitter/nvim-treesitter-context',
    {
        "kdheepak/lazygit.nvim",
        -- optional for floating window border decoration
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
        config = function()
            vim.keymap.set("n", "<leader>gg", "<cmd>LazyGit<CR>");
            -- nnoremap <silent> <leader>gg :LazyGit<CR>
        end
    },
    {
        "nvim-tree/nvim-web-devicons",
        config = function()
            require("nvim-web-devicons").setup({
                override_by_extension = {
                    ["gleam"] = {
                        icon = "",
                        color = "#ffaff3",
                        name = "Gleam",
                    }
                }
            })
        end
    },
    {
        'stevearc/oil.nvim',
        config = function()
            require('oil').setup({
                default_file_explorer = true,
                view_options = {
                    show_hidden = true
                }
            })

            vim.keymap.set("n", "<leader>e", "<cmd>Oil<CR>")
        end,
        dependencies = { "nvim-tree/nvim-web-devicons" },
    }

    -- {
    --     "zbirenbaum/copilot.lua",
    --     event = "VimEnter",
    --     config = function()
    --         vim.defer_fn(function()
    --             require("copilot").setup({
    --                 suggestion = {
    --                     auto_trigger = true,
    --                     keymap = {
    --                         accept = "<Tab>",
    --                         next = "<M-]>",
    --                         prev = "<M-[>",
    --                         dismiss = "<C-]>",
    --                     },
    --                 },
    --             })
    --         end, 100)
    --     end,
    -- }
}
