#!/bin/bash

#=============== INSTALLING CHROME ===================
if ! [ -e google-chrome-stable_current_amd64.deb ]; then
	curl -LO https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
	sudo apt install ./google-chrome-stable_current_amd64.deb
fi

#=============== INSTALLING NEOVIM ===================
if ! [ -e nvim-linux64.deb ]; then
	curl -LO https://github.com/neovim/neovim/releases/download/stable/nvim-linux64.deb
	sudo apt install ./nvim-linux64.deb
else
	echo -e "vim is already installed!\n\tNothing to do.\n"
fi

#=============== PACKAGE INSTALLATION ================
packages=("zsh" "terminator" "unzip" "code" "neofetch" "xclip")

for package in "${packages[@]}"
do
	if dpkg -s "$package" >/dev/null 2>&1; then
		echo -e "$package is already installed!\n\tNothing to do.\n"
	else
		sudo apt install -y $package
	fi
done

#=============== INSTALLING OH-MY-ZSH ================
echo "Installing Oh-My-Zsh..."
if [ -d /home/sackra/.oh-my-zsh ]; then
        echo -e "Oh-My_Zsh is already installed!\n\tNothing to do.\n"
else
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

echo "Downloading JetBrainsMono Nerd Font..."
if [ -e JetBrainsMono.zip ]; then
        echo -e "JetBrainsMono was already download!\n\tNoting to do.\n"
else
        curl -LO https://github.com/ryanoasis/nerd-fonts/releases/download/v2.3.3/JetBrainsMono.zip
fi

echo "Installing font..."
if ! [ -d JetBrainsMono ]; then
        unzip JetBrainsMono -d JetBrainsMono
fi

if ! [ -d /usr/share/fonts/truetype/JetBrainsMono ]; then
        sudo mkdir /usr/share/fonts/truetype/JetBrainsMono
        sudo cp JetBrainsMono/*.ttf /usr/share/fonts/truetype/JetBrainsMono/
        echo "Refreshing the font cache..."
        fc-cache -f -v
fi

echo "Installing Spaceship Prompt into $ZSH/custom/themes as $(whoami)..."
if ! [ -d ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/themes/spaceship-prompt ]; then
	git clone https://github.com/spaceship-prompt/spaceship-prompt.git "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/themes/spaceship-prompt" --depth=1
	ln -s "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/themes/spaceship-prompt/spaceship.zsh-theme" "$ZSH/custom/themes/spaceship.zsh-theme"
else
	echo -e "Spaceship Prompt is already installed!\n\tNothing to do.\n"
fi

echo -e "Installing Oh-My-Zsh Plugins:\n"

echo "Installing Syntax Highlighting..."
if ! [ -d ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting ];then
	git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
else
	echo -e "Syntax Highlighting is already installed!\n\tNothing to do.\n"
fi

echo "Installing Auto Suggestions..."
if ! [ -d ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions ];then
	git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
else 
	echo -e "Auto Suggestions is already installed!\n\tNothing to do.\n"
fi

#============== RESTORING ZSH AND PROMPT CONFIGURATIONS =======================
cp .zshrc ~/
cp .spaceshiprc.zsh ~/

if ! sudo [ -e /root/.zshrc ]; then
	sudo ln -s ~/.zshrc /root/
	sudo ln -s ~/.spaceshiprc.zsh /root/
fi

#============== RESTORING NVIM AND TERMINATOR CONFIGURATIONS ====================
cp -r nvim ~/.config/
cp -r terminator ~/.config/

#============== RESTORING GIT CONFIGURATIONS ======================
cp .gitconfig ~/

#==================== INSTALLING IDEs =============================
if ! [ -e jetbrains-toolbox-1.27.3.14493.tar.gz ]; then
	curl -LO https://download-cdn.jetbrains.com/toolbox/jetbrains-toolbox-1.27.3.14493.tar.gz
	tar -xzvf jetbrains-toolbox-1.27.3.14493.tar.gz
	./jetbrains-toolbox-1.27.3.14493/jetbrains-toolbox
fi

#============== CREATING A NEW PERSONAL SSH KEY FOR GITHUB ===================
if ! [ -d ~/.ssh ]; then
	mkdir ~/.ssh
fi

if ! [ -e ~/.ssh/github ]; then
	ssh-keygen -t ed25519 -C "josnocpp@gmail.com" -f ~/.ssh/github
	if eval "$(ssh-agent -s)" >/dev/null; then
		ssh-add ~/.ssh/github
	fi
fi

echo "Do you want to add your ssh key to github? [y/N]"
read openGithub

if [ "$openGithub" = "y" ]; then
	cat ~/.ssh/github.pub | xclip -selection clipboard

	exec xdg-open "https://github.com/settings/keys"
fi
