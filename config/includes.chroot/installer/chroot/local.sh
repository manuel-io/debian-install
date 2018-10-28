#!/bin/bash
user=$1

cat > "/home/${user}/build.sh" <<EOF
#!/bin/bash

mkdir -p /home/${user}/repos
cd /home/${user}

git clone https://github.com/manuel-io/dotfiles.git repos/dotfiles
git clone https://github.com/manuel-io/petridish.git repos/petridish

# Linuxbrew: The Homebrew package manager for Linux
curl -sSL https://raw.githubusercontent.com/Linuxbrew/install/master/install | ruby

# Ruby Version Manager
gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB
curl -sSL https://get.rvm.io | bash -s stable
/home/${user}/.rvm/bin/rvm install ruby --latest
/home/${user}/.rvm/bin/rvm use ruby --default
/home/${user}/.rvm/rubies/default/bin/gem install bundle

# Node Version Manager
curl -sSL https://raw.githubusercontent.com/creationix/nvm/v0.33.2/install.sh | bash
nvm install node
npm install -g coffeescript
npm install -g less
npm install -g heroku

# Oh My Zsh
curl -sSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh | sh

# Command Line Fuzzy Finder
/home/${user}/.linuxbrew/bin/brew install fzf
/home/${user}/.linuxbrew/opt/fzf/install

ln -s /home/${user}/repos/petridish/bin /home/${user}/bin
source /home/${user}/repos/dotfiles/bash/functions.sh
copy_dotfiles

echo "cd repos/dotfile"
echo "git remote set-url origin git@github.com:manuel-io/dotfiles.git"
echo "cd repos/petridish"
echo "git remote set-url origin git@github.com:manuel-io/petridish.git"
EOF

chown "${user}:${user}" /home/${user}/build.sh
chmod u+rwx /home/${user}/build.sh
