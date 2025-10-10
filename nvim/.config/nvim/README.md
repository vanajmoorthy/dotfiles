# 🚀 Guide to Vanaj's Neovim

A modern neovim setup with LSP, autocompletion, and navigation.

## 📋 Table of Contents

- [Installation](#installation)
- [Core Keybindings](#core-keybindings)
- [Plugin Reference](#plugin-reference)
- [LSP Features](#lsp-features)
- [File Navigation](#file-navigation)
- [Text Editing](#text-editing)
- [Diagnostics & Errors](#diagnostics--errors)
- [Tips & Tricks](#tips--tricks)

---

## 🛠️ Installation

### Prerequisites

```bash
# macOS
brew install neovim node python3 git ripgrep fd

# Ubuntu/Debian
sudo apt install neovim nodejs python3 python3-pip ripgrep fd-find

# Install formatters (optional)
npm install -g prettier
pip install black
brew install stylua  # or: cargo install stylua
```

### Setup

1. Clone this config to `~/.config/nvim/`
2. Open Neovim: `nvim`
3. Plugins will auto-install via lazy.nvim
4. Install LSP servers: `:MasonInstall lua_ls ts_ls pyright html cssls`
5. Restart Neovim

---

## ⌨️ Core Keybindings

**Leader Key:** `<Space>`

### Essential

| Keymap    | Mode   | Action                                    |
| --------- | ------ | ----------------------------------------- |
| `<Space>` | Normal | Leader key (triggers all shortcuts below) |

---

## 📦 Plugin Reference

### 🗂️ File Explorer (nvim-tree)

| Keymap                | Action                      |
| --------------------- | --------------------------- |
| `<C-n>`               | Toggle file explorer        |
| **Inside nvim-tree:** |                             |
| `<CR>`                | Open file in current buffer |
| `o`                   | Open file in new tab        |
| `a`                   | Create new file/folder      |
| `d`                   | Delete file/folder          |
| `r`                   | Rename file/folder          |
| `x`                   | Cut file                    |
| `c`                   | Copy file                   |
| `p`                   | Paste file                  |
| `R`                   | Refresh tree                |
| `H`                   | Toggle hidden files         |
| `q`                   | Close tree                  |

---

### 🔍 Fuzzy Finder (Snacks Picker)

| Keymap             | Action                      |
| ------------------ | --------------------------- |
| `<leader>ff`       | Find files                  |
| `<leader>fg`       | Live grep (search in files) |
| `<leader>fw`       | Grep word under cursor      |
| `<leader>fb`       | Find buffers                |
| `<leader>fh`       | Search help tags            |
| **Inside picker:** |                             |
| `<CR>`             | Open in current buffer      |
| `<C-v>`            | Open in vertical split      |
| `<C-x>`            | Open in horizontal split    |
| `<Esc>` or `<C-c>` | Close picker                |

---

### 📍 Quick Navigation (Harpoon 2)

Mark and jump to frequently used files.

| Keymap       | Action                      |
| ------------ | --------------------------- |
| `<leader>ha` | Add current file to Harpoon |
| `<leader>hh` | Open Harpoon quick menu     |
| `<leader>h1` | Jump to file 1              |
| `<leader>h2` | Jump to file 2              |
| `<leader>h3` | Jump to file 3              |
| `<leader>h4` | Jump to file 4              |
| `<leader>h5` | Jump to file 5              |

**Workflow:**

1. Open a file you use often
2. Press `<leader>ha` to add it
3. Use `<leader>h1-5` to instantly jump back

---

### ⚡ Flash Navigation

Jump to any visible text in 2-3 keystrokes.

| Keymap | Mode          | Action                                  |
| ------ | ------------- | --------------------------------------- |
| `s`    | Normal/Visual | Flash jump (type 2 chars to jump)       |
| `S`    | Normal/Visual | Treesitter flash (jump to syntax nodes) |

**Example:**

1. Press `s`
2. Type `fu` (first 2 letters of your target)
3. Type the highlighted letter to jump

---

### 🎯 Surround Text (mini.surround)

Add, delete, or change surrounding characters.

| Keymap             | Action           | Example                          |
| ------------------ | ---------------- | -------------------------------- |
| `sa{motion}{char}` | Add surround     | `saiw"` → surround word with `"` |
| `sd{char}`         | Delete surround  | `sd"` → remove `"` around cursor |
| `sr{old}{new}`     | Replace surround | `sr"'` → change `"` to `'`       |

**Common Examples:**

```
Original: hello
saiw"  → "hello"     (surround word with ")
saiw)  → (hello)     (surround word with ())
saiw]  → [hello]     (surround word with [])
saiw}  → {hello}     (surround word with {})
Original: "hello"
sd"    → hello       (delete ")
sr"'   → 'hello'     (replace " with ')
```

**Visual Mode:**

1. Select text: `viw` (select word)
2. Press `sa"`
3. Result: `"word"`

---

### 🔄 Move Lines/Blocks (mini.move)

| Keymap  | Mode          | Action                   |
| ------- | ------------- | ------------------------ |
| `<A-j>` | Normal/Visual | Move line/selection down |
| `<A-k>` | Normal/Visual | Move line/selection up   |
| `<A-h>` | Visual        | Move selection left      |
| `<A-l>` | Visual        | Move selection right     |

**Note:** `<A-j>` means `Alt+j` (or `Option+j` on Mac)
**macOS users:** Add `macos-option-as-alt = true` to your Ghostty config (`~/.config/ghostty/config`) for these keymaps to work.

**Examples:**

```
Normal mode:
- Put cursor on line, press <A-j> to move down
- Press <A-k> to move up

Visual mode:
- Select multiple lines with V
- Press <A-j> to move all lines down
- Press <A-k> to move all lines up
```

---

### 📋 Buffers & Tabs

| Keymap       | Action               |
| ------------ | -------------------- |
| `<Tab>`      | Next buffer          |
| `<S-Tab>`    | Previous buffer      |
| `<leader>x`  | Close current buffer |
| `<leader>tc` | Create new tab       |
| `<leader>td` | Close current tab    |
| `<leader>tn` | Go to next tab       |
| `<leader>tp` | Go to previous tab   |

---

### 🧭 Window Navigation

| Keymap      | Action                 |
| ----------- | ---------------------- |
| `<C-h>`     | Move to left window    |
| `<C-j>`     | Move to bottom window  |
| `<C-k>`     | Move to top window     |
| `<C-l>`     | Move to right window   |
| `<C-Up>`    | Increase window height |
| `<C-Down>`  | Decrease window height |
| `<C-Left>`  | Decrease window width  |
| `<C-Right>` | Increase window width  |

---

## 🔧 LSP Features

### Code Navigation

| Keymap       | Action                               |
| ------------ | ------------------------------------ |
| `gd`         | Go to definition                     |
| `gD`         | Go to declaration                    |
| `gi`         | Go to implementation                 |
| `gr`         | Show references                      |
| `K`          | Show hover documentation             |
| `<C-k>`      | Show signature help (in insert mode) |
| `<leader>ca` | Code actions (auto-fix)              |
| `<leader>rn` | Rename file                          |

### Auto-completion

| Keymap            | Mode   | Action                                               |
| ----------------- | ------ | ---------------------------------------------------- |
| `<Tab>`           | Insert | Next completion / Jump to next snippet field         |
| `<S-Tab>`         | Insert | Previous completion / Jump to previous snippet field |
| `<CR>`            | Insert | Confirm completion                                   |
| `<C-Space>`       | Insert | Trigger completion manually                          |
| `<C-e>`           | Insert | Close completion menu                                |
| `<C-b>` / `<C-f>` | Insert | Scroll docs up/down                                  |

**Snippet Example:**

```javascript
// Type "fn" and press Tab
function name(params) {
  // Press Tab to jump to next field
}
```

### Formatting

| Keymap       | Action                           |
| ------------ | -------------------------------- |
| `<leader>fm` | Format file or selection         |
| Auto-format  | On save (if formatter available) |

---

## 🐛 Diagnostics & Errors

### Trouble (Error Panel)

| Keymap       | Action                            |
| ------------ | --------------------------------- |
| `<leader>xx` | Toggle diagnostics (all files)    |
| `<leader>xX` | Toggle diagnostics (current file) |
| `<leader>cs` | Show document symbols             |
| `<leader>cl` | Show LSP definitions/references   |

**Inside Trouble:**

- `j/k` - Navigate up/down
- `<CR>` - Jump to error
- `<Tab>` - Jump but keep Trouble open
- `q` - Close Trouble
- `r` - Refresh

### Quick Diagnostic Navigation

| Keymap      | Action                               |
| ----------- | ------------------------------------ |
| `[d`        | Go to previous diagnostic            |
| `]d`        | Go to next diagnostic                |
| `<leader>e` | Show diagnostic under cursor (float) |
| `<leader>q` | Add diagnostics to location list     |

### Workflow

```
1. See red squiggles in your code
2. Press <leader>xx to open Trouble panel
3. Navigate with j/k to the error you want
4. Press <CR> to jump to it
5. Press <leader>ca to see available fixes
6. Fix the issue
7. Press <leader>xx again to verify it's fixed
```

---

## 🎨 UI Features

### Which-Key

Automatically shows available keybindings when you pause after pressing `<Space>`.

**Usage:**

1. Press `<Space>` (leader)
2. Wait 300ms
3. See popup showing all available shortcuts

### Zen Mode

| Keymap      | Action                       |
| ----------- | ---------------------------- |
| `<leader>z` | Toggle distraction-free mode |

### Dashboard (Mini.Starter)

Automatically opens when you run `nvim` with no file.

**Features:**

- Quick access to recent files
- Built-in actions (new file, quit, etc.)
- Navigate with `j/k`, select with `<CR>`

---

## 💡 Tips & Tricks

### Bracket Navigation (mini.bracketed)

Jump between various items:

| Keymap      | Action                      |
| ----------- | --------------------------- |
| `[b` / `]b` | Previous/Next buffer        |
| `[c` / `]c` | Previous/Next comment       |
| `[d` / `]d` | Previous/Next diagnostic    |
| `[q` / `]q` | Previous/Next quickfix item |
| `[t` / `]t` | Previous/Next TODO comment  |

### Smooth Scrolling

`<C-d>` and `<C-u>` (half-page up/down) are animated for better orientation.

### LSP Signature Help

Function signatures automatically appear as you type. Shows:

- Parameter types
- Current parameter highlighted
- Function documentation

### Git Integration (via nvim-tree)

File explorer shows git status:

- `✗` - Modified
- `✓` - Staged
- `★` - Untracked
- `` - Deleted

---

## 🔥 Common Workflows

### Workflow 1: Exploring a New Codebase

```
1. nvim (opens dashboard)
2. <leader>ff (find files)
3. Navigate to main file
4. gd to jump to definitions
5. <leader>ha to add important files to Harpoon
6. Use <leader>h1-5 to switch between key files
```

### Workflow 2: Fixing Errors

```
1. <leader>xx (open Trouble)
2. j/k to navigate errors
3. <CR> to jump to error
4. <leader>ca for quick fixes
5. <leader>fm to format if needed
6. [d / ]d to cycle through remaining errors
```

### Workflow 3: Refactoring

```
1. Place cursor on symbol to rename
2. <leader>rn (rename symbol)
3. Type new name
4. Press <CR> (updates all references)
5. gr to see all reference locations
```

### Workflow 4: Quick Edits

```
1. s + 2 chars (flash jump to location)
2. ciw (change word)
3. <C-s> (save)
4. <leader>bd (close buffer)
```

---

## 🎯 Installed Plugins

- **lazy.nvim** - Plugin manager
- **nvim-lspconfig** - LSP configuration
- **mason.nvim** - LSP/formatter installer
- **nvim-cmp** - Autocompletion
- **LuaSnip** - Snippet engine
- **conform.nvim** - Formatting
- **nvim-lint** - Linting
- **trouble.nvim** - Diagnostic panel
- **lsp_signature.nvim** - Function signatures
- **flash.nvim** - Quick navigation
- **harpoon** - File bookmarks
- **snacks.nvim** - Picker, zen mode, rename
- **nvim-tree** - File explorer
- **bufferline.nvim** - Buffer tabs
- **scope.nvim** - Tab-scoped buffers
- **which-key.nvim** - Keybinding hints
- **mini.nvim** - Collection of utilities:
  - mini.animate - Smooth scrolling
  - mini.surround - Surround operations
  - mini.move - Move lines/blocks
  - mini.bracketed - Bracket motions
  - mini.statusline - Status bar
  - mini.map - Minimap
  - mini.starter - Dashboard
- **indent-blankline** - Indent guides
- **marks.nvim** - Enhanced marks

---

## 🚨 Troubleshooting

### LSP not working?

```vim
:LspInfo          " Check LSP status
:Mason            " Install missing servers
:checkhealth      " Run health check
```

### Formatter not working?

```vim
:ConformInfo      " Check formatter status
:MasonInstall prettier stylua black
```

### Keybinding not working?

```vim
:WhichKey <Space> " See all leader shortcuts
:verbose map <key> " Check what a key is mapped to
```

---

## 📝 Customization

### Change Leader Key

Edit `init.lua`:

```lua
vim.g.mapleader = ","  -- Change to comma
```

### Add Custom Keybindings

Edit `config/keymaps.lua`:

```lua
vim.keymap.set("n", "<leader>custom", ":echo 'Hello'<CR>")
```

### Add LSP Servers

Edit `plugins/lsp.lua`:

```lua
ensure_installed = { "lua_ls", "ts_ls", "rust_analyzer" }
```

---

## 🤝 Contributing

Feel free to fork and steal this config! Key files:

- `init.lua` - Entry point
- `lua/config/options.lua` - Vim options
- `lua/config/keymaps.lua` - Custom keybindings
- `lua/plugins/*.lua` - Plugin configurations

---

## 📚 Learning Resources

- [Neovim Docs](https://neovim.io/doc/)
- [LazyVim](https://www.lazyvim.org/) - Inspiration
- [Mason Registry](https://mason-registry.dev/) - Available LSP servers
- `:help <keyword>` - Built-in help system

---

**Alhamdulillah and Godspeed 🫡**
