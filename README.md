# Vanaj's Dotfiles

Config for macOS, managed with [GNU Stow](https://www.gnu.org/software/stow/).

## What's Included

- `nvim` - Neovim with LSP, completion, Claude Code integration
- `zsh` - Shell configuration and aliases
- `tmux` - Terminal multiplexer config
- `ghostty` - Ghostty terminal settings
- `starship` - Prompt theme

## Installation

```bash
# Prerequisites
brew install stow neovim tmux starship
brew install --cask ghostty

# Clone and install
git clone https://github.com/vanajmoorthy/dotfiles.git ~/dotfiles
cd ~/dotfiles
stow nvim zsh tmux ghostty starship
```

## Notes

- Neovim plugins should auto install on first launch
- See `nvim/.config/nvim/README.md` for keybindings
