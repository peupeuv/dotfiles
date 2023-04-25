# My Dotfiles

This repository contains my personal configuration files, scripts, and settings for various tools and applications, used to streamline and synchronize the setup of my development environment across multiple machines.

## Installation

1. Clone the repository to your home directory:

  git clone https://github.com/peupeuv/dotfiles.git ~/dotfiles

2. Create symbolic links for the configuration files:

  ln -s ~/dotfiles/starship.toml ~/.config/starship.toml

  ln -s ~/dotfiles/vim/.vimrc ~/.vimrc

  ln -s ~/dotfiles/tmux/.tmux.conf ~/.tmux.conf

  Repeat this process for other configuration files as needed.

3. Install and configure the tools (Starship, Vim, Tmux, etc.) using your preferred method (manual installation, package manager, or an automation tool like Ansible).

4. Restart your shell or reload the configuration files for the changes to take effect.

## Updating

To update the dotfiles, pull the latest changes from the repository and re-run the installation steps:

cd ~/dotfiles

git pull

## Customization

Feel free to customize the configuration files to match your personal preferences and requirements. If you make any changes, remember to commit and push them back to your repository to keep it up to date.

## Contributing

If you have any suggestions or improvements, feel free to fork the repository, make your changes, and submit a pull request. I'm always open to new ideas and contributions.

## License

This repository is licensed under the [MIT License](LICENSE).
