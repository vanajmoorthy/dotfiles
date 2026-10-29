# Vanaj's Dotfiles

Config for macOS, managed with [GNU Stow](https://www.gnu.org/software/stow/).

## What's Included

- `nvim` - Neovim with LSP, completion, Claude Code integration
- `zsh` - Shell configuration and aliases
- `tmux` - Terminal multiplexer config
- `ghostty` - Ghostty terminal settings
- `rex` - Rex tmux-style keybindings, plus `rx save` / `rx restore` to snapshot and rebuild sessions
- `starship` - Prompt theme
- `claude` - Claude Code statusline and skills. `settings.json` lives here too, but is gitignored as it holds machine- and work-specific config

## Installation

```bash
# Prerequisites
brew install stow neovim tmux starship
brew install --cask ghostty

# Clone and install
git clone https://github.com/vanajmoorthy/dotfiles.git ~/dotfiles
cd ~/dotfiles
stow nvim zsh tmux ghostty starship claude rex
```

## Rex app settings

Rex keeps its appearance settings in app preferences, not `init.lua`. To match Ghostty:

```bash
defaults write com.superlogical.rex Workspace.terminalFontName -string "JetBrains Mono"
defaults write com.superlogical.rex Workspace.terminalFontPointSize -string 13
defaults write com.superlogical.rex Workspace.terminalUsesDisplayP3 -bool false
defaults write com.superlogical.rex Workspace.terminalUseThemePalette -bool false
defaults write com.superlogical.rex Workspace.terminalImproveTextContrast -bool false
defaults write com.superlogical.rex Workspace.terminalAllowsLigatures -bool false
```

Then quit and reopen Rex, and import the Gruvbox Dark theme from Ghostty in its settings.

## Notes

- Neovim plugins should auto install on first launch
- See `nvim/.config/nvim/README.md` for keybindings
