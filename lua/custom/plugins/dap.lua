-- Debug: nvim-dap + nvim-dap-ui
--   Java  -> adapter registrato automaticamente da nvim-jdtls
--   React -> vscode-js-debug (scaricato al volo, vedi lua/custom/dap/js_debug.lua)
return {
  {
    'mfussenegger/nvim-dap',
    cmd = { 'DapContinue', 'DapToggleBreakpoint', 'DapToggleRepl', 'DapToggleUI' },
    config = function()
      local dap = require 'dap'
      local js_debug = require 'custom.dap.js_debug'

      -- Adapter JavaScript / TypeScript / React
      for _, id in ipairs { 'pwa-node', 'pwa-chrome', 'pwa-msedge' } do
        dap.adapters[id] = js_debug.adapter(id)
      end

      -- Configurazioni di debug per React / TypeScript
      local function javascript_configurations()
        return {
          {
            type = 'pwa-node',
            request = 'launch',
            name = 'Launch file (Node)',
            program = '${file}',
            cwd = '${workspaceFolder}',
            skipFiles = { '<node_internals>/**' },
            sourceMaps = true,
          },
          {
            type = 'pwa-node',
            request = 'launch',
            name = 'Debug current file (Node)',
            program = '${file}',
            cwd = '${workspaceFolder}',
            skipFiles = { '<node_internals>/**' },
          },
          {
            type = 'pwa-node',
            request = 'launch',
            name = 'Debug npm script',
            cwd = '${workspaceFolder}',
            runtimeExecutable = 'npm',
            runtimeArgs = { 'run', 'debug' },
            skipFiles = { '<node_internals>/**' },
          },
          {
            type = 'pwa-chrome',
            request = 'launch',
            name = 'Launch Chrome (localhost)',
            url = 'http://localhost:3000',
            webRoot = '${workspaceFolder}/src',
            sourceMaps = true,
          },
          {
            type = 'pwa-msedge',
            request = 'launch',
            name = 'Launch Edge (localhost)',
            url = 'http://localhost:3000',
            webRoot = '${workspaceFolder}/src',
            sourceMaps = true,
          },
          {
            type = 'pwa-node',
            request = 'attach',
            name = 'Attach to Node',
            processId = require('dap.utils').pick_process,
            cwd = '${workspaceFolder}',
            skipFiles = { '<node_internals>/**' },
          },
        }
      end

      for _, filetype in ipairs { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact' } do
        dap.configurations[filetype] = javascript_configurations()
      end

      -- Segnaposto: la configurazione Java viene aggiunta da nvim-jdtls
      dap.configurations.java = dap.configurations.java or {}

      -- Keymap
      local map = function(keys, fn, desc)
        vim.keymap.set('n', keys, fn, { desc = desc })
      end

      map('<F5>', dap.continue, '[D]ebug: Start/Continue')
      map('<F10>', dap.step_over, '[D]ebug: Step Over')
      map('<F11>', dap.step_into, '[D]ebug: Step Into')
      map('<F12>', dap.step_out, '[D]ebug: Step Out')
      map('<leader>b', dap.toggle_breakpoint, '[B]reakpoint')
      map('<leader>B', function()
        dap.set_breakpoint(vim.fn.input 'Breakpoint condition: ')
      end, '[B]reakpoint (condition)')
      map('<leader>du', function()
        require('dapui').toggle()
      end, '[D]ebug [U]I')
      map('<leader>dr', dap.repl.open, '[D]ebug [R]epl')
    end,
  },

  {
    'rcarriga/nvim-dap-ui',
    dependencies = {
      'mfussenegger/nvim-dap',
      'nvim-neotest/nvim-nio',
    },
    config = function()
      require('dapui').setup {
        layouts = {
          {
            elements = {
              { id = 'scopes', size = 0.33 },
              { id = 'breakpoints', size = 0.17 },
              { id = 'stacks', size = 0.25 },
              { id = 'watches', size = 0.25 },
            },
            position = 'right',
            size = 40,
          },
          {
            elements = {
              { id = 'repl', size = 0.45 },
              { id = 'console', size = 0.55 },
            },
            position = 'bottom',
            size = 10,
          },
        },
        floating = {
          max_height = 0.9,
          max_width = 0.5,
          border = 'rounded',
          mappings = {
            close = { 'q', '<Esc>' },
          },
        },
      }
    end,
  },
}
