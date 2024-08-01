local lsp = require("lsp-zero")
local lspconfig = require("lspconfig")

lsp.preset("recommended")

lsp.skip_server_setup({ 'hls' })
-- lsp.skip_server_setup({ 'hls', 'elixir_ls', 'elixirls' })

lsp.ensure_installed({
    'tsserver',
    'eslint',
    'rust_analyzer',
    'angularls',
    'fsautocomplete',
})

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

lspconfig.fsautocomplete.setup({
    on_attach = function(client, bufnr)
        local opts = { buffer = bufnr, remap = false }
    end
})

lspconfig.efm.setup({
    capabilities = capabilities,
    on_attach = on_attach,
    init_options = {
        documentFormatting = true,
        documentRangeFormatting = true,
    },
    filetypes = { 'typescript', 'javascript', 'typescriptreact', 'javascriptreact', 'css', 'scss', 'html', 'json',
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
local cmp_select = { behavior = cmp.SelectBehavior.Select }
local cmp_mappings = lsp.defaults.cmp_mappings({
    ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
    ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
    ['<C-y>'] = cmp.mapping.confirm({ select = true }),
    ["<S-Space>"] = cmp.mapping.complete(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }),

})

-- disable completion with tab
-- this helps with copilot setup
cmp_mappings['<Tab>'] = nil
cmp_mappings['<S-Tab>'] = nil

lsp.setup_nvim_cmp({
    mapping = cmp_mappings
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
    vim.keymap.set("n", "<leader>vd", vim.diagnostic.open_float, opts)
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

-- local elixir = require("elixir")
-- local elixirls = require("elixir.elixirls")
-- local elixir_on_attach = function(client, bufnr)
--     local opts = { buffer = true, noremap = true }
--
--     on_attach(client, bufnr)
--     vim.keymap.set("n", "<leader>lfp", ":ElixirFromPipe<CR>", opts)
--     vim.keymap.set("n", "<leader>tp", ":ElixirToPipe<CR>", opts)
--     vim.keymap.set("v", "<leader>em", ":ElixirExpandMacro<CR>", opts)
-- end
--
-- elixir.setup({
--     nextls = {
--         enable = true,
--         cmd = "/Users/Petr_Anokhin/.local/share/nvim/mason/bin/nextls",
--         on_attach = elixir_on_attach,
--         init_options = {
--             experimental = {
--                 completions = { enable = true },
--             },
--         },
--     },
--     credo = {
--         enable = true,
--     },
--     elixirls = {
--         cmd = "/Users/Petr_Anokhin/.local/share/nvim/mason/bin/elixir-ls",
--         enable = true, -- this needs to be enabled until `nextls` works with all the features that this does.
--         settings = elixirls.settings({
--             fecthDeps = true,
--             dialyzerEnabled = true,
--             enableTestLenses = false,
--         }),
--         on_attach = elixir_on_attach,
--     },
-- })
