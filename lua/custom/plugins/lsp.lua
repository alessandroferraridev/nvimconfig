-- LSP per React + TypeScript (e Lua per la configurazione di Neovim)
--
-- API moderna: vim.lsp.config() + vim.lsp.enable() (Neovim 0.11+)
-- I server vengono installati/abilitati automaticamente tramite Mason.
return {
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      { 'mason-org/mason.nvim', opts = {} },
      {
        'mason-org/mason-lspconfig.nvim',
        opts = {
          ensure_installed = {
            'ts_ls', -- TypeScript / JavaScript
            'eslint', -- lint JS/TS (solo in progetti con eslint)
            'html', -- HTML/JSX
            'cssls', -- CSS/SCSS/Less
            'jsonls', -- JSON
            'tailwindcss', -- classi Tailwind (solo in progetti con tailwind)
            'lua_ls', -- config di Neovim
            -- jdtls (Java) e' installato da lua/custom/java/jdtls.lua:
            -- la versione di Mason richiede Java 25
          },
          -- jdtls viene avviato da nvim-jdtls (ftplugin/java.lua)
          -- stylua e intelephense non sono server LSP da usare
          automatic_enable = { exclude = { 'jdtls', 'stylua', 'intelephense' } },
        },
      },
      {
        'WhoIsSethDaniel/mason-tool-installer.nvim',
        opts = {
          ensure_installed = {
            'stylua', -- formatter Lua
            'prettierd', -- formatter JS/TS/React/JSON/CSS/HTML
            'google-java-format', -- formatter Java
            'java-debug-adapter', -- bundle java-debug per il debugging Java
          },
        },
      },
      'saghen/blink.cmp',
      'mfussenegger/nvim-jdtls',
      'folke/lazydev.nvim',
    },
    config = function()
      local capabilities = require('blink.cmp').get_lsp_capabilities()

      -- Server attivi
      local servers = {
        -- TypeScript / JavaScript / React
        ts_ls = {
          settings = {
            typescript = {
              inlayHints = {
                includeInlayParameterNameHints = 'all',
                includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                includeInlayFunctionParameterTypeHints = true,
                includeInlayVariableTypeHints = false,
                includeInlayPropertyDeclarationTypeHints = true,
                includeInlayFunctionLikeReturnTypeHints = true,
              },
            },
            javascript = {
              inlayHints = {
                includeInlayParameterNameHints = 'all',
                includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                includeInlayFunctionParameterTypeHints = true,
                includeInlayVariableTypeHints = false,
                includeInlayPropertyDeclarationTypeHints = true,
                includeInlayFunctionLikeReturnTypeHints = true,
              },
            },
          },
        },

        -- Linting JS/TS (si attiva solo nei progetti con configurazione eslint)
        eslint = {
          settings = {
            -- La formattazione e' gestita da prettier (conform.nvim)
            format = false,
          },
        },

        -- HTML / CSS / JSON
        html = {},
        cssls = {},
        jsonls = {},

        -- Tailwind CSS (si attiva solo nei progetti con tailwind.config.*)
        tailwindcss = {},

        -- Lua (config di Neovim)
        lua_ls = {
          settings = {
            Lua = {
              completion = { callSnippet = 'Replace' },
              diagnostics = { disable = { 'missing-fields' } },
            },
          },
        },
      }

      for name, config in pairs(servers) do
        config.capabilities = vim.tbl_deep_extend('force', capabilities, config.capabilities or {})
        vim.lsp.config(name, config)
        vim.lsp.enable(name)
      end

      -- Keymap LSP (valgono solo nei buffer con un server attivo)
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('custom-lsp-attach', { clear = true }),
        callback = function(event)
          local function map(keys, func, desc, mode)
            vim.keymap.set(mode or 'n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
          end

          map('grn', vim.lsp.buf.rename, '[R]e[n]ame')
          map('gra', vim.lsp.buf.code_action, '[G]oto Code [A]ction', { 'n', 'x' })
          map('grr', vim.lsp.buf.references, '[G]oto [R]eferences')
          map('gri', vim.lsp.buf.implementation, '[G]oto [I]mplementation')
          map('grd', vim.lsp.buf.definition, '[G]oto [D]efinition')
          map('grD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
          map('gO', vim.lsp.buf.document_symbol, '[O]pen Document Symbols')
          map('gW', vim.lsp.buf.workspace_symbol, '[W]orkspace Symbols')
          map('grt', vim.lsp.buf.type_definition, '[G]oto [T]ype Definition')
          map('gK', vim.lsp.buf.signature_help, '[S]ignature [H]elp')

          map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame symbol')
          map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')
          map('<leader>lr', vim.lsp.buf.references, '[L]ookup [R]eferences')
          map('<leader>ld', vim.lsp.buf.definition, '[L]ookup [D]efinition')
          map('<leader>li', vim.lsp.buf.implementation, '[L]ookup [I]mplementation')

          map('<leader>th', function()
            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
          end, '[T]oggle Inlay [H]ints')

          -- Evidenzia il simbolo sotto il cursore
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf) then
            local group = vim.api.nvim_create_augroup('custom-lsp-highlight', { clear = false })
            vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
              buffer = event.buf,
              group = group,
              callback = vim.lsp.buf.document_highlight,
            })
            vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
              buffer = event.buf,
              group = group,
              callback = vim.lsp.buf.clear_references,
            })
          end
        end,
      })

      -- Diagnostica
      vim.diagnostic.config {
        severity_sort = true,
        float = { border = 'rounded', source = 'if_many' },
        underline = { severity = vim.diagnostic.severity.ERROR },
        signs = vim.g.have_nerd_font and {
          text = {
            [vim.diagnostic.severity.ERROR] = '󰅚 ',
            [vim.diagnostic.severity.WARN] = '󰀪 ',
            [vim.diagnostic.severity.INFO] = '󰋽 ',
            [vim.diagnostic.severity.HINT] = '󰌶 ',
          },
        } or {},
        -- Il testo virtuale viene tagliato dal bordo della finestra:
        -- sulla riga corrente il messaggio completo viene mostrato
        -- su una riga dedicata (virtual_lines).
        virtual_text = { source = 'if_many', spacing = 2, current_line = false },
        virtual_lines = { current_line = true, severity_sort = true },
      }
    end,
  },
}
