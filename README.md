# Dotfiles


## Install

Clone the repo (Or fork it...):

    git clone git://github.com/minhtule/dotfiles.git

Install required gems:

    gem install bundler && bundle install

Run the bootstrap script:

    ./bootstrap.rb

#### Personalize

You can put other customizations in dotfiles appended with `.local`:

* `~/.aliases.local`
* `~/.gitconfig.local`
* `~/.tmux.conf.local`
* `~/.vimrc.local`
* `~/.zshenv.local`
* `~/.zshrc.local`

For example, your `~/.aliases.local` might look like this:

    # Productivity
    alias todo='$EDITOR ~/.todo'

    # Easy Folder access
    alias go='cd $HOME/Documents/workspace'

And so on...
