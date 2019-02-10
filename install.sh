#!/bin/bash
sudo apt update && sudo apt install -y \
	i3  \
	i3blocks \
	redshift redshift-gtk \
	scrot \
	ranger \
	rofi \
	feh \
	git \
	pavucontrol \
	zsh \
	arandr \
	xdotool \
	git \
	stow \
	compton \
	neofetch \
	autoconf \
	automake \
	libtool \
	python3-dev \
	python3-pip \
	copyq \
	ack \
	vim \
	tig \
	fonts-font-awesome\
	xclip \
	python3-pyqt5 

# Install oh-my-zsh
wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | zsh
chsh -s `which zsh`

# Install powerlevel9k zsh theme along with fonts
git clone https://github.com/bhilburn/powerlevel9k.git ~/.oh-my-zsh/custom/themes/powerlevel9k

wget https://github.com/powerline/powerline/raw/develop/font/PowerlineSymbols.otf
wget https://github.com/powerline/powerline/raw/develop/font/10-powerline-symbols.conf
wget "https://use.fontawesome.com/releases/v5.0.13/fontawesome-free-5.0.13.zip"

mkdir ~/.local/
mkdir ~/.local/share/
mkdir ~/.local/share/fonts/

unzip fontawesome-free-5.0.13.zip
sudo cp fontawesome-free-5.0.13/use-on-desktop/* /usr/local/share/fonts/
fc-cache -f -v

mv PowerlineSymbols.otf ~/.local/share/fonts/
fc-cache -vf ~/.local/share/fonts/
mkdir ~/.config/fontconfig/
mkdir ~/.config/fontconfig/conf.d/
mv 10-powerline-symbols.conf ~/.config/fontconfig/conf.d/

git clone https://github.com/SuperPrower/i3lock-fancier.git
cd i3lock-fancier
sudo make install
