-- Neovim configuration
-- Stack: React + TypeScript  /  Java
-- Theme: Tokyo Night (always)
--
-- Struttura:
--   init.lua                      -> opzioni, keymap base, avvio lazy.nvim
--   lua/custom/plugins/*.lua      -> configurazione dei plugin (modulare)
--   ftplugin/*.lua                -> impostazioni per linguaggio

-- Leader key
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Netrw disabilitato: si usa Telescope come file explorer.
-- Deve essere impostato prima che i plugin del runtime vengano caricati.
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Imposta a true se usi un Nerd Font nel terminale (icone nei segni/UI)
vim.g.have_nerd_font = false

-- ------------------------------------------------------------------
-- Opzioni
-- ------------------------------------------------------------------
vim.o.number = true
vim.o.mouse = 'a'
vim.o.showmode = false
vim.o.breakindent = true
vim.o.undofile = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.signcolumn = 'yes'
vim.o.updatetime = 250
vim.o.timeoutlen = 300
vim.o.splitright = true
vim.o.splitbelow = true
vim.o.list = true
vim.o.inccommand = 'split'
vim.o.cursorline = true
vim.o.scrolloff = 10
vim.o.confirm = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }
vim.opt.completeopt = { 'menu', 'menuone', 'noselect' }

-- Clipboard: valorizzato dopo l'avvio per non rallentarlo
vim.schedule(function()
  vim.o.clipboard = 'unnamedplus'
end)

-- Indentazione di default (2 spazi). Java/override per linguaggio in ftplugin/
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true

-- Toolchain per la compilazione dei parser treesitter su Windows.
-- Richiede MinGW-w64 (gcc) nel PATH; in alternativa va impostato a mano.
if vim.fn.has 'win32' == 1 then
  if vim.fn.executable 'gcc' == 0 then
    local localappdata = vim.env.LOCALAPPDATA or vim.fn.expand '~'
    local candidates = vim.fn.glob(vim.fs.joinpath(localappdata, 'Microsoft', 'WinGet', 'Packages', 'BrechtSanders.WinLibs*', 'mingw64', 'bin'), true, true)
    if candidates[1] then
      vim.env.PATH = candidates[1] .. ';' .. vim.env.PATH
    end
  end
  if vim.env.CC == nil or vim.env.CC == '' then
    vim.env.CC = 'gcc'
    vim.env.CXX = 'g++'
  end
end

-- ------------------------------------------------------------------
-- Keymap base
-- ------------------------------------------------------------------
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>', { desc = 'Clear search highlight' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Diagnostic [Q]uickfix list' })
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Focus left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Focus right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Focus lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Focus upper window' })

-- ------------------------------------------------------------------
-- Autocommands
-- ------------------------------------------------------------------
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('custom-highlight-yank', { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})

-- Con netrw disabilitato, l'apertura di una directory apre Telescope
vim.api.nvim_create_autocmd('BufEnter', {
  desc = 'Open Telescope when entering a directory',
  group = vim.api.nvim_create_augroup('custom-directory-picker', { clear = true }),
  callback = function(event)
    if vim.bo[event.buf].buftype ~= '' then
      return
    end
    local name = vim.api.nvim_buf_get_name(event.buf)
    local stat = vim.uv.fs_stat(name)
    if not stat or stat.type ~= 'directory' then
      return
    end
    vim.schedule(function()
      if not vim.api.nvim_buf_is_valid(event.buf) or vim.api.nvim_get_current_buf() ~= event.buf then
        return
      end
      vim.cmd 'bd!'
      require('telescope.builtin').find_files {
        cwd = name,
        prompt_title = 'Find files (' .. vim.fn.fnamemodify(name, ':t') .. ')',
      }
    end)
  end,
})

-- ------------------------------------------------------------------
-- lazy.nvim
-- ------------------------------------------------------------------
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
  if vim.v.shell_error ~= 0 then
    error('Error cloning lazy.nvim:\n' .. out)
  end
end

vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
  {
    'NMAC427/guess-indent.nvim', -- Rileva tabstop/shiftwidth automaticamente
  },
  { import = 'custom.plugins' },
}, {
  ui = {
    icons = vim.g.have_nerd_font and {} or {
      cmd = '⌘',
      config = '🛠',
      event = '📅',
      ft = '📂',
      init = '⚙',
      keys = '🗝',
      plugin = '🔌',
      runtime = '💻',
      require = '🌙',
      source = '📄',
      start = '🚀',
      task = '📌',
      lazy = '💤 ',
    },
  },
})

-- ------------------------------------------------------------------
-- Tokyo Night sempre
-- Se un altro plugin cambia il colorscheme, viene ripristinato.
-- Escape: `let g:disable_tokyonight = 1`
-- ------------------------------------------------------------------
local tokyonight_lock = {
  applying = false,
}

vim.api.nvim_create_autocmd('ColorScheme', {
  group = vim.api.nvim_create_augroup('custom-tokyonight-lock', { clear = true }),
  pattern = '*',
  callback = function()
    if tokyonight_lock.applying or vim.g.disable_tokyonight then
      return
    end
    tokyonight_lock.applying = true
    vim.cmd.colorscheme 'tokyonight-night'
    tokyonight_lock.applying = false
  end,
})

-- vim: ts=2 sts=2 sw=2 et
