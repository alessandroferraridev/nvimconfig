# nvim-config

Configurazione Neovim per lo sviluppo **React + TypeScript** e **Java**.
Tema: **Tokyo Night** (sempre attivo).

Base: [kickstart.nvim](https://github.com/0xLazyCat/kickstart.nvim), riorganizzata in moduli.

---

## Struttura

```
init.lua                    opzioni, keymap base, avvio lazy.nvim
lua/custom/plugins/         configurazione dei plugin (un file per area)
  theme.lua                 Tokyo Night
  editing.lua               which-key, gitsigns, neo-tree, mini.nvim, blink.cmp
  telescope.lua             fuzzy finder
  treesitter.lua            parser e highlighting
  conform.lua               formattazione al salvataggio
  lsp.lua                   server LSP per React/TypeScript + keymap
  java.lua                  nvim-jdtls, keymap e comandi Java
  dap.lua                   nvim-dap + nvim-dap-ui
lua/custom/dap/js_debug.lua adapter DAP per JS/TS (vscode-js-debug)
lua/custom/java/jdtls.lua   installazione di eclipse.jdt.ls
ftplugin/                   impostazioni per linguaggio
```

## Requisiti

| Componente | Perche | Note |
|---|---|---|
| Neovim >= 0.11 | API `vim.lsp.config` / `vim.lsp.enable` | testato su 0.12 |
| Node.js + npm | `ts_ls`, `eslint`, prettier | |
| Java 21+ | eclipse.jdt.ls | la versione 1.59 richiede Java 21 |
| Python 3.9+ | launcher di eclipse.jdt.ls | |
| MinGW-w64 (`gcc`) | compilazione dei parser treesitter | solo Windows |
| `tree-sitter` CLI | compilazione dei parser treesitter | `npm i -g tree-sitter-cli` |

I server LSP, i formatter e il bundle `java-debug` vengono installati
automaticamente da [Mason](https://github.com/mason-org/mason.nvim) al primo avvio.

## Server LSP

| Server | Linguaggi | Note |
|---|---|---|
| `ts_ls` | TypeScript, JavaScript, React | completamento, refactoring, inlay hints |
| `eslint` | JS / TS | si attiva solo nei progetti con configurazione eslint |
| `html` | HTML, JSX | |
| `cssls` | CSS, SCSS, Less | |
| `jsonls` | JSON | |
| `tailwindcss` | HTML/CSS/JS/TS | si attiva solo nei progetti Tailwind |
| `lua_ls` | Lua | configurazione di Neovim |
| `jdtls` | Java | eclipse.jdt.ls + nvim-jdtls |

## Formattatori (conform.nvim)

| Tipo | Formatter |
|---|---|
| JS / TS / TSX / JSX / JSON / CSS / HTML / Markdown | `prettierd` (fallback `prettier`) |
| Java | `google-java-format` |
| Lua | `stylua` |

La formattazione avviene al salvataggio; `<leader>f` formatta il buffer.

## Debug

- **Java**: adapter registrato da `nvim-jdtls` (richiede il bundle `java-debug`).
- **React / TypeScript**: `vscode-js-debug`, scaricato automaticamente alla prima
  sessione di debug (nessuna compilazione richiesta).

## Tokyo Night sempre attivo

Il colorscheme viene riportato a Tokyo Night se un altro plugin lo cambia.
Per disattivare il lock: `let g:disable_tokyonight = 1`.

Lo sfondo e' trasparente (`transparent = true`, sidebar e float inclusi), quindi
il tema si vede bene solo se anche il terminale ha uno sfondo trasparente.

## Netrw disabilitato

`netrw` e' disattivato: il file explorer e' Telescope.

- `<leader>sa` ricerca i file in tutto il progetto
- `<leader>sc` ricerca i file nella directory del file corrente
- aprire una directory (`nvim .`) apre direttamente Telescope su quella cartella

## Comandi utili

| Comando | Descrizione |
|---|---|
| `:Lazy` | stato dei plugin |
| `:Mason` | server LSP / formatter installati |
| `:LspInfo` | diagnostica dei language server |
| `:ConformInfo` | formatter disponibili |
| `:checkhealth` | diagnostica di Neovim |

L'elenco completo dei tasti e' in [CUSTOM.md](CUSTOM.md).
