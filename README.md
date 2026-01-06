# Neovim Configuration

Modern Lua-based Neovim configuration with LSP, autocompletion, treesitter, and extensive plugin ecosystem.

## Features

- 🎨 **Gruvbox Material** theme with auto light/dark switching based on macOS appearance
- 📦 **Lazy.nvim** plugin manager with lazy loading
- 🔍 **LSP** support for C++, Go, Python, Bash with auto-formatting
- ⚡ **Treesitter** for better syntax highlighting
- 🚀 **Fast navigation** with fuzzy finder, file tree, and jump lists
- 🔧 **Auto-format on save** with conform.nvim
- 🪟 **Seamless tmux integration** for window navigation
- 📝 **Smart search** with match counts and persistent highlights
- 🎯 **Floating windows** for LSP actions, quickfix, and rename

## Requirements

- Neovim 0.11.0+
- Node.js and npm (for some plugins)
- Tree-sitter CLI
- LSP servers (installed automatically via Mason)
- Formatters: clang-format, black, isort, gofumpt, prettier, stylua, rustfmt

## Leader Key

**Leader key:** `,` (comma)

## Directory Structure

```
~/.config/nvim/
├── init.lua                    # Entry point
├── lua/
│   ├── core/
│   │   ├── options.lua        # Vim options
│   │   ├── keymaps.lua        # Key mappings
│   │   └── lazy.lua           # Plugin manager setup
│   └── plugins/
│       ├── theme.lua          # Gruvbox-material theme
│       ├── lsp.lua            # LSP configuration
│       ├── completion.lua     # nvim-cmp + UltiSnips
│       ├── treesitter.lua     # Syntax highlighting
│       ├── fzf.lua            # Fuzzy finder
│       ├── ui.lua             # UI plugins (lualine, notify, etc.)
│       ├── editor.lua         # Editor enhancements
│       ├── formatting.lua     # Auto-formatting
│       ├── multicursor.lua    # Multi-cursor support
│       ├── tmux-navigator.lua # Tmux integration
│       ├── substitute.lua     # Text substitution
│       ├── dashboard.lua      # Start screen
│       ├── detour.lua         # Popup navigation
│       ├── fidget.lua         # LSP progress
│       ├── indent-blankline.lua # Indent guides
│       └── window-management.lua # Window utilities
```

## Keybindings

### Basic Editing

| Key | Mode | Action |
|-----|------|--------|
| `Tab` | N | Indent line |
| `Shift-Tab` | N | Dedent line |
| `Tab` | V | Indent selection (keeps selection) |
| `Shift-Tab` | V | Dedent selection (keeps selection) |
| `p` | V | Paste without yanking replaced text |
| `J` | V | Move selected text down |
| `K` | V | Move selected text up |
| `H` | N/V | Go to line start (^) |
| `L` | N/V | Go to line end (g_) |

### Window Management

| Key | Mode | Action |
|-----|------|--------|
| `Ctrl-h/j/k/l` | N | Navigate between windows (tmux-aware) |
| `Ctrl-Up/Down` | N | Resize window height |
| `Ctrl-Left/Right` | N | Resize window width |
| `,sv` | N | Split window vertically |
| `,sh` | N | Split window horizontally |
| `,se` | N | Make splits equal size |
| `,sx` | N | Close current split |
| `,so` | N | Close all other splits |
| `,sm` | N | Toggle maximize split |
| `,sH/sJ/sK/sL` | N | Move split to far left/bottom/top/right |
| `,sr` | N | Rotate splits downward |
| `,sR` | N | Rotate splits upward |
| `,sf` | N | Split and go to definition |
| `,sw` | N | Pick window by letter |
| `,ss` | N | Switch between C++ header/source |
| `q` | N | Close window |
| `Q` | N | Record macro |

### Buffer Management

| Key | Mode | Action |
|-----|------|--------|
| `[b` | N | Previous buffer |
| `]b` | N | Next buffer |
| `,bd` | N | Delete buffer |

### File Navigation

| Key | Mode | Action |
|-----|------|--------|
| `,e` | N | Toggle file tree |
| `,tr` | N | Find current file in tree |
| `,ff` | N | Find files |
| `,fg` | N | Live grep |
| `,fb` | N | Find buffers |
| `,fh` | N | Find help |
| `,fr` | N | Find recent files |
| `,fc` | N | Find commands |
| `,v` | N | Toggle Vista (symbol outline) |

### Search

| Key | Mode | Action |
|-----|------|--------|
| `/` | N | Search forward |
| `?` | N | Search backward |
| `n` | N | Next match (shows count at bottom) |
| `N` | N | Previous match (shows count at bottom) |
| `*` | N | Search word under cursor forward |
| `#` | N | Search word under cursor backward |
| `Esc` | N | Clear search highlights |

### LSP

| Key | Mode | Action |
|-----|------|--------|
| `gd` | N | Go to definition (in popup) |
| `gD` | N | Go to declaration (in popup) |
| `gr` | N | Show references |
| `gi` | N | Go to implementation |
| `gt` | N | Go to type definition |
| `K` | N | Hover documentation |
| `Ctrl-k` | N | Signature help |
| `,rn` | N | Rename symbol (popup near cursor) |
| `,ca` | N | Code action |
| `,d` | N | Show diagnostics |
| `[d` | N | Previous diagnostic |
| `]d` | N | Next diagnostic |
| `,f` | N/V | Format buffer or selection |

### Quickfix & Location List

| Key | Mode | Action |
|-----|------|--------|
| `,qa` | N | Open quickfix (floating popup) |
| `,qo` | N | Open quickfix (floating popup) |
| `,qc` | N | Close quickfix |
| `[q` | N | Previous quickfix item |
| `]q` | N | Next quickfix item |
| `[Q` | N | First quickfix item |
| `]Q` | N | Last quickfix item |
| `[l` | N | Previous location item |
| `]l` | N | Next location item |

### Jump List

| Key | Mode | Action |
|-----|------|--------|
| `Ctrl-o` | N | Jump back (closes popup if in popup) |
| `Ctrl-i` | N | Jump forward |

### Text Manipulation

| Key | Mode | Action |
|-----|------|--------|
| `s{motion}` | N | Substitute with motion |
| `ss` | N | Substitute line |
| `S` | N | Substitute to end of line |
| `s` | V | Substitute visual selection |
| `sx{motion}` | N | Exchange with motion |
| `sxx` | N | Exchange line |
| `X` | V | Exchange visual selection |
| `sxc` | N | Cancel exchange |

### Multi-cursor

| Key | Mode | Action |
|-----|------|--------|
| `Ctrl-n` | N/V | Add cursor/select next match |
| `Ctrl-Up` | N | Add cursor above |
| `Ctrl-Down` | N | Add cursor below |
| `Ctrl-Left` | N | Skip current match |

### Scrolling

| Key | Mode | Action |
|-----|------|--------|
| `Ctrl-d` | N | Scroll down (centered) |
| `Ctrl-u` | N | Scroll up (centered) |
| `j/k` | N | Move by display line |

### Miscellaneous

| Key | Mode | Action |
|-----|------|--------|
| `,w` | N | Save file |
| `,q` | N | Quit |
| `,Q` | N | Quit all |
| `,o` | N | Insert blank line below |
| `,O` | N | Insert blank line above |
| `,dt` | N | Open detour popup |
| `,dp` | N | Detour current window |
| `,un` | N | Dismiss notifications |

### Completion (Insert Mode)

| Key | Mode | Action |
|-----|------|--------|
| `Tab` | I | Next completion item |
| `Shift-Tab` | I | Previous completion item |
| `Ctrl-Space` | I | Trigger completion |
| `Ctrl-e` | I | Abort completion |
| `Enter` | I | Confirm completion |
| `Ctrl-j` | I | Expand snippet / Next placeholder |
| `Ctrl-k` | I | Previous snippet placeholder |

## Installed Plugins

### Core
- **lazy.nvim** - Plugin manager
- **gruvbox-material** - Color scheme with auto dark/light switching

### LSP & Completion
- **mason.nvim** - LSP server installer
- **mason-lspconfig.nvim** - Mason + LSP integration
- **nvim-cmp** - Autocompletion
- **cmp-nvim-lsp** - LSP completion source
- **cmp-buffer** - Buffer completion source
- **cmp-path** - Path completion source
- **ultisnips** - Snippet engine
- **cmp-nvim-ultisnips** - UltiSnips completion source
- **fidget.nvim** - LSP progress notifications

### Syntax & Highlighting
- **nvim-treesitter** - Better syntax highlighting
- **indent-blankline.nvim** - Indent guides

### Navigation & Search
- **fzf-lua** - Fuzzy finder
- **nvim-tree.lua** - File explorer
- **nvim-hlslens** - Search match counter
- **vista.vim** - Symbol outline viewer
- **detour.nvim** - Popup navigation for definitions

### UI Enhancements
- **lualine.nvim** - Status line
- **nvim-notify** - Notification manager
- **which-key.nvim** - Keybinding hints
- **nvim-bqf** - Better quickfix
- **dashboard-nvim** - Start screen
- **nvim-web-devicons** - Icons

### Editing
- **nvim-autopairs** - Auto-close brackets
- **vim-commentary** - Comment toggling
- **vim-sandwich** - Surround text objects
- **multicursor.nvim** - Multi-cursor editing
- **substitute.nvim** - Text substitution/exchange
- **better-escape.vim** - Fast escape from insert mode
- **conform.nvim** - Auto-formatting
- **fastspell.nvim** - Spell checking in comments

### Git & External Tools
- **vim-tmux-navigator** - Seamless tmux/vim navigation
- **asyncrun.vim** - Async command execution
- **vim-mundo** - Undo tree visualizer

### Markdown
- **render-markdown.nvim** - Markdown preview

### Window Management
- **vim-maximizer** - Toggle maximize splits
- **focus.nvim** - Auto-resize windows
- **nvim-window** - Quick window picker

## Configuration Highlights

### Auto-formatting
Format on save is enabled by default for:
- **C/C++**: clang-format (uses .clang-format if present)
- **Python**: black + isort
- **Go**: gofumpt + goimports
- **Shell**: shfmt
- **JavaScript/TypeScript**: prettier
- **Lua**: stylua
- **Rust**: rustfmt

Toggle format on save: `:FormatToggle`

### LSP Servers
Automatically installed and configured:
- **clangd** - C/C++
- **gopls** - Go
- **pyright** - Python
- **bashls** - Bash

### Theme
Gruvbox-material with automatic light/dark switching based on macOS system appearance. Checks every 5 seconds and updates theme automatically.

### Floating Windows
All popup windows (quickfix, rename, detour) appear as centered floating windows with rounded borders for a modern UI experience.

### Search Behavior
- Highlights persist while navigating code
- Match count shows in command line (e.g., `[3/10]`)
- Press `Esc` to clear highlights
- Case-insensitive with smart case

### Window Navigation
Seamless navigation between Neovim splits and tmux panes using `Ctrl-hjkl`.

## Customization

### Changing Leader Key
Edit `init.lua`:
```lua
vim.g.mapleader = ","  -- Change to your preferred key
```

### Adding More LSP Servers
Edit `lua/plugins/lsp.lua` and add to `ensure_installed`:
```lua
ensure_installed = {
  "clangd",
  "gopls",
  "your_server_here",
}
```

### Modifying Theme
Edit `lua/plugins/theme.lua` to change theme or disable auto-switching.

### Adding Custom Keybindings
Add to `lua/core/keymaps.lua`:
```lua
keymap("n", "<your-key>", "<your-command>", { desc = "Description" })
```

## Troubleshooting

### LSP not working
1. Check LSP log: `:lua vim.cmd('edit ' .. vim.lsp.get_log_path())`
2. Install language servers: `:Mason`
3. Restart LSP: `:LspRestart`

### Treesitter errors
1. Update parsers: `:TSUpdate`
2. Check installation: `:checkhealth nvim-treesitter`

### Plugin issues
1. Update plugins: `:Lazy sync`
2. Clean and reinstall: `:Lazy clean` then `:Lazy sync`

### Performance issues
1. Check startup time: `nvim --startuptime startup.log`
2. Disable expensive plugins temporarily

## Credits

Configuration inspired by modern Neovim setups and optimized for software development workflows.

## TODO

1. Better quickfix window
2. Better inlined windows while gd, gr.
3. Tab buffers
4. Ctrl +hjkl inside tabs

## License

MIT License - Feel free to use and modify as needed.
