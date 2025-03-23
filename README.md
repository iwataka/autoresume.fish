# autoresume.fish

Fish-shell plugin which provides Zsh's AUTO_RESUME feature as described below.

https://zsh.sourceforge.io/Doc/Release/Options.html#index-AUTORESUME
> Treat single word simple commands without redirection as candidates for resumption of an existing job.

## Installation

I recommend [Fisher](https://github.com/jorgebucaran/fisher) to install this plugin.

```fish
fisher install iwataka/autoresume.fish
```

## Usage

Just install this plugin and now you can AUTO_RESUME.

For example:

```sh
nvim
# Press Ctrl+Z to bring the Neovim job to background.
nvim
# Then the background Neovim job will be resumed.
```

## License

[MIT](LICENSE)
