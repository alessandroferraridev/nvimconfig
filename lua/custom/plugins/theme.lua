-- Tema: Tokyo Night (sempre attivo, vedi init.lua per il lock sul colorscheme)
return {
  'folke/tokyonight.nvim',
  priority = 1000,
  lazy = false,
  config = function()
    vim.o.background = 'dark'

    require('tokyonight').setup {
      style = 'night', -- 'night' | 'storm' | 'moon' | 'day'
      transparent = true, -- sfondo trasparente
      styles = {
        comments = { italic = false },
        sidebars = 'transparent', -- neo-tree, telescope, dap-ui
        floats = 'transparent', -- finestre flottanti
      },
      dim_inactive = { enabled = false },
      lualine_bold = true,
      on_highlights = function(hl, c)
        -- Statusline, tab line e popup menu trasparenti
        hl.StatusLine = { fg = c.fg_sidebar, bg = c.none }
        hl.StatusLineNC = { fg = c.fg_gutter, bg = c.none }
        hl.TabLine = { bg = c.none, fg = c.fg_gutter }
        hl.TabLineFill = { bg = c.none }
        hl.TabLineSel = { bg = c.bg_highlight, fg = c.fg }
        hl.ColorColumn = { bg = c.none }
        hl.FoldColumn = { bg = c.none, fg = c.comment }
        hl.Pmenu = { bg = c.none, fg = c.fg }
        hl.PmenuSel = { bg = c.blue, fg = c.none }
        hl.PmenuSbar = { bg = c.bg_highlight }
        hl.PmenuThumb = { bg = c.blue }
        hl.PmenuKind = { bg = c.none, fg = c.blue }
        hl.PmenuExtra = { bg = c.none, fg = c.cyan }
        hl.PmenuMatch = { bg = c.none, fg = c.blue, bold = true }
        hl.PmenuMatchSel = { bg = c.blue, fg = c.none, bold = true }
        hl.WinSeparator = { fg = c.border, bg = c.none }
        hl.VertSplit = { fg = c.border, bg = c.none }
      end,
    }

    vim.cmd.colorscheme 'tokyonight-night'
  end,
}
