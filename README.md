# autoresume.fish

Fish-shell plugin which provides Zsh's autoresume feature.

This plugin brings the background job to foreground automatically when you execute the command same as it.

## Installation

I recommend [Fisher](https://github.com/jorgebucaran/fisher) to install this plugin.

```fish
fisher install iwataka/autoresume.fish
```

## Usage

Just install this plugin and now you can `autoresume`.

For example:

```sh
nvim
# Press Ctrl+Z to bring the Neovim job to background.
nvim
# Then the previous executed Neovim job will be brought to foreground.
```
