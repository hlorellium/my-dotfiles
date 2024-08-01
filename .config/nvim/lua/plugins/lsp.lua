return {
    {
        'mrcjkb/haskell-tools.nvim',
        version = '^3', -- Recommended
        lazy = false, -- This plugin is already lazy
    },
    {
        'VonHeikemen/lsp-zero.nvim',
        branch = 'v3.x',
        lazy = true,
        config = false,
        init = function()
            -- Disable automatic setup, we are doing it manually
            vim.g.lsp_zero_extend_cmp = 0
            vim.g.lsp_zero_extend_lspconfig = 0
        end,
    },
    {
        'williamboman/mason.nvim',
        lazy = false,
        config = true,
    },

    -- Autocompletion
    {
        'hrsh7th/nvim-cmp',
        event = 'InsertEnter',
        dependencies = {
            { 'L3MON4D3/LuaSnip' },
        },
        config = function()
            -- Here is where you configure the autocompletion settings.
            local lsp_zero = require('lsp-zero')
            lsp_zero.extend_cmp()

            -- And you can configure cmp even more, if you want to.
            local cmp = require('cmp')
            local cmp_action = lsp_zero.cmp_action()

            cmp.setup({
                formatting = lsp_zero.cmp_format(),
                mapping = cmp.mapping.preset.insert({
                    ['<C-Space>'] = cmp.mapping.complete(),
                    ['<C-u>'] = cmp.mapping.scroll_docs(-4),
                    ['<C-d>'] = cmp.mapping.scroll_docs(4),
                    ['<C-f>'] = cmp_action.luasnip_jump_forward(),
                    ['<C-b>'] = cmp_action.luasnip_jump_backward(),
                })
            })
        end
    },

    -- LSP
    {
        'neovim/nvim-lspconfig',
        cmd = { 'LspInfo', 'LspInstall', 'LspStart' },
        event = { 'BufReadPre', 'BufNewFile' },
        dependencies = {
            { 'hrsh7th/cmp-nvim-lsp' },
            { 'williamboman/mason-lspconfig.nvim' },
        },
        config = function()
            -- This is where all the LSP shenanigans will live
            local lsp_zero = require('lsp-zero')
            lsp_zero.extend_lspconfig()

            --- if you want to know more about lsp-zero and mason.nvim
            --- read this: https://github.com/VonHeikemen/lsp-zero.nvim/blob/v3.x/doc/md/guides/integrate-with-mason-nvim.md
            lsp_zero.on_attach(function(client, bufnr)
                -- see :help lsp-zero-keybindings
                -- to learn the available actions
                lsp_zero.default_keymaps({ buffer = bufnr })
            end)

            require('mason-lspconfig').setup({
                ensure_installed = {
                    'tsserver',
                    'eslint',
                    'rust_analyzer',
                    'angularls',
                },
                handlers = {
                    lsp_zero.default_setup,
                    lua_ls = function()
                        -- (Optional) Configure lua language server for neovim
                        local lua_opts = lsp_zero.nvim_lua_ls()
                        require('lspconfig').lua_ls.setup(lua_opts)
                    end,
                }
            })


            -- copy paste
            local lsp = require("lsp-zero")
            local lspconfig = require("lspconfig")

            lspconfig.gleam.setup {
                -- cmd = { "glas", "--stdio" }
            }
            -- Fix Undefined global 'vim'
            lsp.configure('lua_ls', {
                settings = {
                    Lua = {
                        diagnostics = {
                            globals = { 'vim' }
                        }
                    }
                }
            })

            -- lspconfig.elixirls.setup({
            --     elixirLS = {
            --         dialyzerEnabled = true
            --     }
            -- })

            lspconfig.fsautocomplete.setup({
                on_attach = function(client, bufnr)
                    local opts = { buffer = bufnr, remap = false }
                end
            })

            local configs = require("lspconfig.configs")

            local lexical_config = {
                filetypes = { "elixir", "eelixir", "heex" },
                cmd = { "/Users/hlorella/.local/share/nvim/mason/bin/lexical" },
                settings = {},
            }

            if not configs.lexical then
                configs.lexical = {
                    default_config = {
                        filetypes = lexical_config.filetypes,
                        cmd = lexical_config.cmd,
                        root_dir = function(fname)
                            return lspconfig.util.root_pattern("mix.exs", ".git")(fname) or vim.loop.os_homedir()
                        end,
                        -- optional settings
                        settings = lexical_config.settings,
                    },
                }
            end

            lspconfig.lexical.setup({})

            lspconfig.ocamllsp.setup({})

            lspconfig.efm.setup({
                capabilities = capabilities,
                on_attach = on_attach,
                init_options = {
                    documentFormatting = true,
                    documentRangeFormatting = true,
                },
                filetypes = { 'typescript', 'javascript', 'typescriptreact', 'javascriptreact', 'css', 'scss', 'html',
                    'json',
                    'yaml', 'markdown', 'python' },
                settings = {
                    rootMarkers = { '.git/' },
                    languages = {
                        python = {
                            {
                                formatCommand = "black --quiet -",
                                formatStdin = true
                            }
                        },
                        typescript = {
                            -- require('efmls-configs.formatters.biome'),
                            require('efmls-configs.formatters.prettier_d'),
                            -- require('efmls-configs.linters.eslint'),
                        },
                        ocaml = {
                            {
                                formatCommand = "ocamlformat -",
                                formatStdin = true
                            }
                        },
                        typescriptreact = {
                            -- require('efmls-configs.formatters.biome'),
                            require('efmls-configs.formatters.prettier_d'),
                            -- require('efmls-configs.linters.eslint'),
                        },
                        javascriptreact = {
                            -- require('efmls-configs.formatters.biome'),
                            require('efmls-configs.formatters.prettier_d'),
                            -- require('efmls-configs.linters.eslint'),
                        },
                        javascript = {
                            require('efmls-configs.formatters.prettier_d'),
                        },
                        scss = {
                            require('efmls-configs.linters.stylelint'),
                            require('efmls-configs.formatters.prettier_d'),
                        },
                        css = {
                            require('efmls-configs.linters.stylelint'),
                            require('efmls-configs.formatters.prettier_d'),
                        },
                        html = {
                            require('efmls-configs.formatters.prettier_d'),
                        },
                    }
                }
            })

            -- angularls
            local util = require('lspconfig.util')

            lsp.configure('angularls', {
                root_dir = util.root_pattern('angular.json', 'project.json')
            })

            local cmp = require('cmp')
            local cmp_action = require('lsp-zero').cmp_action()
            cmp.setup({
                mapping = cmp.mapping.preset.insert({
                    -- `Enter` key to confirm completion
                    ['<CR>'] = cmp.mapping.confirm({ select = true }),

                    ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
                    ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),

                    -- Ctrl+Space to trigger completion menu
                    -- ['<C-Space>'] = cmp.mapping.complete(),

                    -- Navigate between snippet placeholder
                    ['<C-f>'] = cmp_action.luasnip_jump_forward(),
                    ['<C-b>'] = cmp_action.luasnip_jump_backward(),

                    -- Scroll up and down in the completion documentation
                    ['<C-u>'] = cmp.mapping.scroll_docs(-4),
                    ['<C-d>'] = cmp.mapping.scroll_docs(4),
                })
            })

            lsp.set_preferences({
                suggest_lsp_servers = true,
                sign_icons = {
                    error = 'E',
                    warn = 'W',
                    hint = 'H',
                    info = 'I'
                }
            })

            lsp.on_attach(function(client, bufnr)
                local opts = { buffer = bufnr, remap = false }

                --   if client.name == "eslint" then
                --       vim.cmd.LspStop('eslint')
                --       return
                --   end

                vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
                vim.keymap.set("n", "gt", vim.lsp.buf.type_definition, opts)
                vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
                vim.keymap.set("n", "<leader>vws", vim.lsp.buf.workspace_symbol, opts)
                vim.keymap.set("n", "gl", vim.diagnostic.open_float, opts)
                vim.keymap.set("n", "[d", vim.diagnostic.goto_next, opts)
                vim.keymap.set("n", "]d", vim.diagnostic.goto_prev, opts)
                vim.keymap.set("n", "<leader>la", vim.lsp.buf.code_action, opts)
                vim.keymap.set("n", "<leader>lr", vim.lsp.buf.references, opts)
                vim.keymap.set("n", "<leader>lR", vim.lsp.buf.rename, opts)
                vim.keymap.set("i", "<C-h>", vim.lsp.buf.signature_help, opts)
            end)

            lsp.setup()

            vim.diagnostic.config({
                virtual_text = true,
            })

            require('lspconfig').rust_analyzer.setup {
                -- Other Configs ...
                settings = {
                    ["rust-analyzer"] = {
                        cargo = {
                            allFeatures = true,
                            loadOutDirsFromCheck = true,
                            runBuildScripts = true,
                        },
                        -- Other Settings ...
                        checkOnSave = {
                            allFeatures = true,
                            command = "clippy",
                            extraArgs = { "--no-deps" },
                        },
                        procMacro = {
                            ignored = {
                                leptos_macro = {
                                    -- optional: --
                                    -- "component",
                                    "server",
                                },
                            },
                        },
                    },
                }
            }


            ---
            -- Setup haskell LSP
            ---
            local hls_lsp = require('lsp-zero').build_options('hls', {})

            vim.g.haskell_tools = {
                hls = {
                    capabilities = hls_lsp.capabilities,
                }
            }

            -- Autocmd that will actually be in charging of starting hls
            local hls_augroup = vim.api.nvim_create_augroup('haskell-lsp', { clear = true })
            vim.api.nvim_create_autocmd('FileType', {
                group = hls_augroup,
                pattern = { 'haskell' },
                callback = function()
                    ---
                    -- Suggested keymaps from the quick setup section:
                    -- https://github.com/mrcjkb/haskell-tools.nvim#quick-setup
                    ---

                    local ht = require('haskell-tools')
                    local bufnr = vim.api.nvim_get_current_buf()
                    local def_opts = { noremap = true, silent = true, buffer = bufnr, }
                    -- haskell-language-server relies heavily on codeLenses,
                    -- so auto-refresh (see advanced configuration) is enabled by default
                    vim.keymap.set('n', '<space>ca', vim.lsp.codelens.run, opts)
                    -- Hoogle search for the type signature of the definition under the cursor
                    vim.keymap.set('n', '<space>hs', ht.hoogle.hoogle_signature, opts)
                    -- Evaluate all code snippets
                    vim.keymap.set('n', '<space>ea', ht.lsp.buf_eval_all, opts)
                    -- Toggle a GHCi repl for the current package
                    vim.keymap.set('n', '<leader>rr', ht.repl.toggle, opts)
                    -- Toggle a GHCi repl for the current buffer
                    vim.keymap.set('n', '<leader>rf', function()
                        ht.repl.toggle(vim.api.nvim_buf_get_name(0))
                    end, def_opts)
                    vim.keymap.set('n', '<leader>rq', ht.repl.quit, opts)
                end
            })
        end
    },
    {
        'creativenull/efmls-configs-nvim',
        dependencies = { 'neovim/nvim-lspconfig' },
    }
}
