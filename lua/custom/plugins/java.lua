-- Sviluppo Java: eclipse.jdt.ls (jdtls) con nvim-jdtls
--
-- - LSP: completimento, refactoring, code action, gerarchia dei tipi
-- - Comandi: JdtCompile, JdtUpdateConfig, JdtBytecode, JdtJshell, ...
-- - Supporto a jdt:// e ai file .class (decompilazione)
-- - Debug: registrato automaticamente dall'adapter `java` di nvim-dap
return {
  {
    'mfussenegger/nvim-jdtls',
    dependencies = { 'mfussenegger/nvim-dap' },
    build = false,
    config = function()
      local jdtls = require 'custom.java.jdtls'

      -- Runtime Java utilizzato dal progetto (per compilare con il JDK giusto)
      local function java_runtime()
        local java_home = vim.env.JAVA_HOME
        if not java_home or java_home == '' or vim.fn.isdirectory(java_home) ~= 1 then
          return nil
        end
        local ok, result = pcall(function()
          local exe = vim.fs.joinpath(java_home, 'bin', 'java')
          if vim.fn.executable(exe) ~= 1 then
            exe = 'java'
          end
          local out = vim.system({ exe, '-version' }):wait()
          return (out.stderr or ''):match 'version "([%d]+)'
        end)
        if not ok or not result then
          return nil
        end
        return { name = 'JavaSE-' .. result, path = java_home .. '/', default = true }
      end

      -- Bundle "java-debug": abilita il debugging Java (comandi vscode.java.*)
      local function java_debug_bundles()
        local root = vim.fs.joinpath(vim.fn.stdpath 'data', 'mason', 'packages', 'java-debug-adapter')
        if vim.fn.isdirectory(root) == 0 then
          return {}
        end
        local jars = vim.fn.glob(vim.fs.joinpath(root, '**', 'com.microsoft.java.debug.plugin-*.jar'), true, true)
        return jars
      end

      local settings = {
        java = {
          configuration = {
            runtimes = {},
          },
        },
      }
      local runtime = java_runtime()
      if runtime then
        settings.java.configuration.runtimes = { runtime }
      end

      -- Code action kinds aggiuntivi di eclipse.jdt.ls
      local code_action_kinds =
        vim.deepcopy(vim.lsp.protocol.make_client_capabilities().textDocument.codeAction.codeActionLiteralSupport.codeActionKind.valueSet)
      for _, kind in ipairs { 'source.generate.toString', 'source.generate.hashCodeEquals' } do
        table.insert(code_action_kinds, kind)
      end

      vim.lsp.config('jdtls', {
        -- Workspace persistente (indicizzazione eclipse.jdt.ls)
        cmd = function(dispatchers, config)
          if not jdtls.installed() then
            jdtls.install()
          end
          local cmd = jdtls.cmd()
          if not cmd then
            error "jdtls non e' installato"
          end
          local root = config.root_dir or vim.fn.getcwd()
          local name = vim.fn.fnamemodify(root, ':t')
          local data_dir = vim.fs.joinpath(vim.fn.stdpath 'cache', 'jdtls', 'workspace', name)
          vim.fn.mkdir(data_dir, 'p')
          return vim.lsp.rpc.start(vim.list_extend(cmd, { '-data', data_dir }), dispatchers, {
            cwd = config.cmd_cwd,
            env = config.cmd_env,
            detached = config.detached,
          })
        end,
        init_options = {
          extendedClientCapabilities = require 'jdtls.capabilities',
          bundles = java_debug_bundles(),
        },
        settings = settings,
        -- Rileva il bundle java-debug al momento dell'avvio del server
        -- (utile se viene installato dopo l'avvio di Neovim)
        before_init = function(_, config)
          config.init_options = config.init_options or {}
          config.init_options.bundles = java_debug_bundles()
        end,
        capabilities = vim.tbl_deep_extend('force', require('blink.cmp').get_lsp_capabilities(), {
          textDocument = {
            codeAction = {
              codeActionLiteralSupport = {
                codeActionKind = {
                  valueSet = code_action_kinds,
                },
              },
            },
          },
        }),
      })

      vim.lsp.enable 'jdtls'

      -- Keymap Java
      vim.keymap.set('n', '<A-o>', function()
        require('jdtls').organize_imports()
      end, { desc = 'Java [O]rganize imports' })

      vim.keymap.set('n', 'crv', function()
        require('jdtls').extract_variable()
      end, { desc = 'Java extract [V]ariable' })

      vim.keymap.set('v', 'crv', function()
        require('jdtls').extract_variable { visual = true }
      end, { desc = 'Java extract [V]ariable' })

      vim.keymap.set('n', 'crc', function()
        require('jdtls').extract_constant()
      end, { desc = 'Java extract [C]onstant' })

      vim.keymap.set('n', 'crm', function()
        require('jdtls').extract_method()
      end, { desc = 'Java extract [M]ethod' })

      vim.keymap.set('n', '<leader>dc', '<cmd>JdtCompile<CR>', { desc = 'Java [C]ompile workspace' })
      vim.keymap.set('n', '<leader>du', '<cmd>JdtUpdateConfig<CR>', { desc = 'Java [U]pdate project config' })
      vim.keymap.set('n', '<leader>db', '<cmd>JdtBytecode<CR>', { desc = 'Java [B]ytecode (javap)' })
      vim.keymap.set('n', '<leader>dj', '<cmd>JdtJshell<CR>', { desc = 'Java [J]shell' })

      vim.keymap.set('n', '<leader>dt', function()
        require('jdtls.dap').test_class()
      end, { desc = 'Debug [T]est class' })

      vim.keymap.set('n', '<leader>dn', function()
        require('jdtls.dap').test_nearest_method()
      end, { desc = 'Debug [N]earest test method' })
    end,
  },
}
