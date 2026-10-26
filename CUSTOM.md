# CUSTOM.md — Tutti gli shortcut di Neovim

> Leader predefinito: `<SPACE>`
> Tema: Tokyo Night (sempre attivo)

---

## Indice
1. [Generali / Built-in](#1-generali--built-in)
2. [Telescope](#2-telescope)
3. [LSP](#3-lsp)
4. [Conform (Format)](#4-conform-format)
5. [blink.cmp (Autocompletion)](#5-blinkcmp-autocompletion)
6. [mini.nvim (Text objects / Surround)](#6-mininvim-text-objects--surround)
7. [gitsigns.nvim](#7-gitsigns)
8. [neo-tree.nvim](#8-neo-tree)
9. [Java](#9-java)
10. [Debug (nvim-dap)](#10-debug-nvim-dap)
11. [Telescope / generici](#11-generici)

---

## 1. Generali / Built-in

| Tasto | Azione | Modalita' |
|---|---|---|
| `<Esc>` | Toglie l'highlight della ricerca | Normale |
| `<leader>q` | Apre la quickfix list con i diagnostic | Normale |
| `<C-W>d` | Mostra il messaggio completo del diagnostic in un float | Normale |
| `<Esc><Esc>` | Esce dalla modalita' terminale | Terminale |
| `<C-h>` | Focus finestra a sinistra | Normale |
| `<C-l>` | Focus finestra a destra | Normale |
| `<C-j>` | Focus finestra in basso | Normale |
| `<C-k>` | Focus finestra in alto | Normale |

## 2. Telescope

| Tasto | Descrizione |
|---|---|
| `<leader>sh` | [S]earch [H]elp |
| `<leader>sk` | [S]earch [K]eymaps |
| `<leader>sf` | [S]earch [F]iles (solo git) |
| `<leader>sa` | [S]earch [A]ll files |
| `<leader>sc` | [S]earch files in [C]urrent directory |
| `<leader>ss` | [S]earch [S]elect Telescope |
| `<leader>sw` | [S]earch current [W]ord |
| `<leader>sg` | [S]earch by [G]rep |
| `<leader>sd` | [S]earch [D]iagnostics |
| `<leader>sr` | [S]earch [R]esume |
| `<leader>s.` | [S]earch Recent Files |
| `<leader><leader>` | Trova buffer esistenti |
| `<leader>/` | Fuzzily search nel buffer corrente |
| `<leader>s/` | Live Grep nei file aperti |
| `<leader>sn` | [S]earch [N]eovim files |

## 3. LSP

| Tasto | Descrizione | Modalita' |
|---|---|---|
| `grn` | [R]e[n]ame | Normale |
| `gra` | [G]oto Code [A]ction | Normale, Visuale |
| `grr` | [G]oto [R]eferences | Normale |
| `gri` | [G]oto [I]mplementation | Normale |
| `grd` | [G]oto [D]efinition | Normale |
| `grD` | [G]oto [D]eclaration | Normale |
| `gO` | Document Symbols | Normale |
| `gW` | Workspace Symbols | Normale |
| `grt` | [G]oto [T]ype Definition | Normale |
| `gK` | Signature Help | Normale |
| `<leader>rn` | [R]e[n]ame symbol | Normale |
| `<leader>ca` | [C]ode [A]ction | Normale |
| `<leader>lr` | [L]ookup [R]eferences | Normale |
| `<leader>ld` | [L]ookup [D]efinition | Normale |
| `<leader>li` | [L]ookup [I]mplementation | Normale |
| `<leader>th` | [T]oggle Inlay [H]ints | Normale |

## 4. Conform (Format)

| Tasto | Descrizione |
|---|---|
| `<leader>f` | [F]ormatta il buffer |
| `BufWritePre` | Auto-format al salvataggio |

Formatter: `prettierd` (JS/TS/React/JSON/CSS/HTML/MD), `google-java-format` (Java), `stylua` (Lua).

## 5. blink.cmp (Autocompletion)

| Tasto | Descrizione |
|---|---|
| `<Tab>` / `<S-Tab>` | Muove avanti/indietro nello snippet |
| `<C-Space>` | Apre menu completamento / docs |
| `<C-n>` / `<C-p>` (su/giu) | Seleziona prossimo/precedente item |
| `<C-e>` | Chiude il menu |
| `<C-k>` | Toggle signature help |

## 6. mini.nvim (Text objects / Surround)

| Tasto | Descrizione |
|---|---|
| `va)` | [V]isual [A]round parentesi |
| `yinq` | [Y]ank [I]nside [N]ext [Q]uote |
| `ci'` | [C]hange [I]nside apostrofi |
| `saiw)` | [S]urround [A]dd [I]nner [W]ord con `)` |
| `sd'` | [S]urround [D]elete apostrofi |
| `sr)'` | [S]urround [R]eplace `)` con `'` |

## 7. gitsigns

| Tasto | Descrizione | Modalita' |
|---|---|---|
| `]c` | Jump to next git [c]hange | Normale |
| `[c` | Jump to previous git [c]hange | Normale |
| `<leader>hs` | git [s]tage hunk | Normale, Visuale |
| `<leader>hr` | git [r]eset hunk | Normale, Visuale |
| `<leader>hS` | git [S]tage buffer | Normale |
| `<leader>hu` | git [u]ndo stage hunk | Normale |
| `<leader>hR` | git [R]eset buffer | Normale |
| `<leader>hp` | git [p]review hunk | Normale |
| `<leader>hb` | git [b]lame line | Normale |
| `<leader>hd` | git [d]iff against index | Normale |
| `<leader>hD` | git [D]iff against last commit | Normale |
| `<leader>tb` | [T]oggle git show [b]lame line | Normale |
| `<leader>tD` | [T]oggle git show [D]eleted | Normale |

## 8. neo-tree

| Tasto | Descrizione |
|---|---|
| `\` | Apre NeoTree (toggle) |
| `<leader>e` | NeoTree (focus) |

## 9. Java

| Tasto / Comando | Descrizione |
|---|---|
| `<A-o>` | Java [O]rganize imports |
| `crv` | Java extract [V]ariable (normale e visuale) |
| `crc` | Java extract [C]onstant |
| `crm` | Java extract [M]ethod |
| `<leader>dc` | [C]ompile del workspace (`:JdtCompile`) |
| `<leader>du` | [U]pdate configurazione progetto (`:JdtUpdateConfig`) |
| `<leader>db` | [B]ytecode con javap (`:JdtBytecode`) |
| `<leader>dj` | [J]shell (`:JdtJshell`) |
| `<leader>dt` | Debug [T]est class |
| `<leader>dn` | Debug [N]earest test method |
| `:JdtShowLogs` | Log del server Java |
| `:JdtWipeDataAndRestart` | Azzera l'indicizzazione del progetto |

## 10. Debug (nvim-dap)

| Tasto | Descrizione |
|---|---|
| `<F5>` | Debug: Start/Continue |
| `<F10>` | Debug: Step Over |
| `<F11>` | Debug: Step Into |
| `<F12>` | Debug: Step Out |
| `<leader>b` | [B]reakpoint |
| `<leader>B` | [B]reakpoint con condizione |
| `<leader>du` | [D]ebug [U]I (dapui) |
| `<leader>dr` | [D]ebug [R]epl |

Configurazioni disponibili per JS/TS/React: Node (file corrente, npm script),
Chrome, Edge, attach a un processo Node.

## 11. Generici

| Tasto | Descrizione |
|---|---|
| `<leader>s` | Gruppo [S]earch |
| `<leader>t` | Gruppo [T]oggle |
| `<leader>h` | Gruppo Git [H]unk |
| `<leader>f` | Gruppo [F]ormat |
| `<leader>b` | Gruppo [B]reakpoint |
| `<leader>d` | Gruppo [D]ebug |
| `<leader>w` | Gruppo [W]indow |
