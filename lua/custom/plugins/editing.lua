-- Editing essentials: which-key, gitsigns, neo-tree, todo-comments, mini.nvim, blink.cmp
return {
  {
    'folke/which-key.nvim',
    event = 'VimEnter',
    opts = {
      delay = 0,
      icons = {
        mappings = vim.g.have_nerd_font,
        keys = vim.g.have_nerd_font and {} or {
          Up = '<Up> ',
          Down = '<Down> ',
          Left = '<Left> ',
          Right = '<Right> ',
          C = '<C-…> ',
          M = '<M-…> ',
          D = '<D-…> ',
          S = '<S-…> ',
          CR = '<CR> ',
          Esc = '<Esc> ',
          ScrollWheelDown = '<ScrollWheelDown> ',
          ScrollWheelUp = '<ScrollWheelUp> ',
          NL = '<NL> ',
          BS = '<BS> ',
          Space = '<Space> ',
          Tab = '<Tab> ',
          F1 = '<F1>',
          F2 = '<F2>',
          F3 = '<F3>',
          F4 = '<F4>',
          F5 = '<F5>',
          F6 = '<F6>',
          F7 = '<F7>',
          F8 = '<F8>',
          F9 = '<F9>',
          F10 = '<F10>',
          F11 = '<F11>',
          F12 = '<F12>',
        },
      },
      spec = {
        { '<leader>s', group = '[S]earch' },
        { '<leader>t', group = '[T]oggle' },
        { '<leader>h', group = 'Git [H]unk' },
        { '<leader>f', group = '[F]ormat' },
        { '<leader>b', group = '[B]reakpoint' },
        { '<leader>d', group = '[D]ebug' },
        { '<leader>w', group = '[W]indow' },
      },
    },
  },

  {
    'lewis6991/gitsigns.nvim',
    opts = {
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
    },
    keys = {
      {
        ']c',
        function()
          vim.cmd 'normal! ]c'
        end,
        desc = 'Next git change',
      },
      {
        '[c',
        function()
          vim.cmd 'normal! [c'
        end,
        desc = 'Previous git change',
      },
      { '<leader>hs', ':GitSigns stage_hunk<CR>', desc = 'Git stage hunk' },
      { '<leader>hr', ':GitSigns reset_hunk<CR>', desc = 'Git reset hunk' },
      { '<leader>hS', ':GitSigns stage_buffer<CR>', desc = 'Git stage buffer' },
      { '<leader>hu', ':GitSigns undo_stage_hunk<CR>', desc = 'Git undo stage hunk' },
      { '<leader>hR', ':GitSigns reset_buffer<CR>', desc = 'Git reset buffer' },
      { '<leader>hp', ':GitSigns preview_hunk<CR>', desc = 'Git preview hunk' },
      { '<leader>hb', ':GitSigns blame_line<CR>', desc = 'Git blame line' },
      { '<leader>hd', ':GitSigns diffthis<CR>', desc = 'Git diff against index' },
      { '<leader>hD', ':GitSigns diffthis<CR><C-w>p', desc = 'Git diff against last commit' },
      { '<leader>tb', ':GitSigns toggle_current_line_blame<CR>', desc = 'Toggle git blame line' },
      { '<leader>tD', ':GitSigns toggle_deleted<CR>', desc = 'Toggle git show deleted' },
    },
  },

  {
    'nvim-neo-tree/neo-tree.nvim',
    event = 'VeryLazy',
    opts = {
      filesystem = {
        hijack_netrw_behavior = 'open_current',
        use_libuv_file_watcher = true,
      },
      source_selector = {
        winbar = true,
        statusline = false,
      },
    },
    keys = {
      { '\\', '<cmd>Neotree toggle<CR>', desc = 'NeoTree toggle' },
      { '<leader>e', '<cmd>Neotree focus<CR>', desc = 'NeoTree focus' },
    },
  },

  {
    'folke/todo-comments.nvim',
    event = 'VimEnter',
    dependencies = { 'nvim-lua/plenary.nvim' },
    opts = { signs = false },
  },

  {
    'echasnovski/mini.nvim',
    event = 'VimEnter',
    config = function()
      -- Text objects: va), yinq, ci' ...
      require('mini.ai').setup { n_lines = 500 }

      -- Surround: sai w), sd', sr)' ...
      require('mini.surround').setup()

      -- Statusline
      local statusline = require 'mini.statusline'
      statusline.setup { use_icons = vim.g.have_nerd_font }
      statusline.section_location = function()
        return '%2l:%-2v'
      end
    end,
  },

  {
    'saghen/blink.cmp',
    event = 'VimEnter',
    version = '1.*',
    dependencies = {
      {
        'L3MON4D3/LuaSnip',
        version = '2.*',
        build = (function()
          -- Il build richiede `make`, non disponibile su Windows
          if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then
            return
          end
          return 'make install_jsregexp'
        end)(),
        opts = {},
      },
      'folke/lazydev.nvim',
    },
    --- @type blink.cmp.Config
    opts = {
      keymap = {
        preset = 'default',
      },
      appearance = {
        nerd_font_variant = 'mono',
      },
      completion = {
        documentation = { auto_show = false, auto_show_delay_ms = 500 },
      },
      sources = {
        default = { 'lsp', 'path', 'snippets', 'lazydev' },
        providers = {
          lazydev = { module = 'lazydev.integrations.blink', score_offset = 100 },
        },
      },
      snippets = { preset = 'luasnip' },
      fuzzy = { implementation = 'lua' },
      signature = { enabled = true },
    },
  },
}
