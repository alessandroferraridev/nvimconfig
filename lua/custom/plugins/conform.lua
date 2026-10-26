-- conform.nvim: formattazione automatica al salvataggio
-- Formatter: prettier (JS/TS/React/JSON/HTML/CSS/MD), google-java-format (Java), stylua (Lua)
return {
  {
    'stevearc/conform.nvim',
    event = { 'BufWritePre' },
    cmd = { 'ConformInfo' },
    keys = {
      {
        '<leader>f',
        function()
          require('conform').format { async = true, lsp_format = false }
        end,
        mode = '',
        desc = '[F]ormat buffer',
      },
    },
    opts = {
      notify_on_error = false,
      format_on_save = function(bufnr)
        -- Nessun formatter "lsp_fallback" per i linguaggi senza standard definito
        local disable_filetypes = { c = true, cpp = true }
        if disable_filetypes[vim.bo[bufnr].filetype] then
          return nil
        end
        return {
          timeout_ms = 3000,
          lsp_format = false,
        }
      end,
      formatters_by_ft = {
        -- React / TypeScript / JavaScript
        javascript = { 'prettierd', 'prettier', stop_after_first = true },
        javascriptreact = { 'prettierd', 'prettier', stop_after_first = true },
        typescript = { 'prettierd', 'prettier', stop_after_first = true },
        typescriptreact = { 'prettierd', 'prettier', stop_after_first = true },
        json = { 'prettierd', 'prettier', stop_after_first = true },
        jsonc = { 'prettierd', 'prettier', stop_after_first = true },
        css = { 'prettierd', 'prettier', stop_after_first = true },
        scss = { 'prettierd', 'prettier', stop_after_first = true },
        html = { 'prettierd', 'prettier', stop_after_first = true },
        markdown = { 'prettierd', 'prettier', stop_after_first = true },

        -- Java
        java = { 'google-java-format' },

        -- Lua
        lua = { 'stylua' },
      },
      formatters = {
        prettier = {
          prepend_args = { '--tab-width', '2', '--use-tabs', 'false' },
        },
        stylua = {
          prepend_args = { '--indent-type', 'Spaces', '--indent-width', '2' },
        },
      },
    },
  },
}
