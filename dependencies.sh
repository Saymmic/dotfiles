#!/bin/bash
sudo apt update && sudo apt install -y \
	i3  \
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
	ack

# Install oh-my-zsh
wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | zsh
chsh -s `which zsh`

# Install powerlevel9k zsh theme along with fonts
git clone https://github.com/bhilburn/powerlevel9k.git ~/.oh-my-zsh/custom/themes/powerlevel9k

wget https://github.com/powerline/powerline/raw/develop/font/PowerlineSymbols.otf
wget https://github.com/powerline/powerline/raw/develop/font/10-powerline-symbols.conf

mkdir ~/.local/
mkdir ~/.local/share/
mkdir ~/.local/share/fonts/
mv PowerlineSymbols.otf ~/.local/share/fonts/
fc-cache -vf ~/.local/share/fonts/
mkdir ~/.config/fontconfig/
mkdir ~/.config/fontconfig/conf.d/
mv 10-powerline-symbols.conf ~/.config/fontconfig/conf.d/

# Install nerd-fonts
# git clone https://github.com/ryanoasis/nerd-fonts.git
# cd nerd-fonts
# sudo bash install.sh

# Install pywall
# sudo pip3 install pywal

# Install i3-gaps

#sudo apt install libxcb1-dev libxcb-keysyms1-dev libpango1.0-dev \
#libxcb-util0-dev libxcb-icccm4-dev libyajl-dev \
#libstartup-notification0-dev libxcb-randr0-dev \
#libev-dev libxcb-cursor-dev libxcb-xinerama0-dev \
#libxcb-xkb-dev libxkbcommon-dev libxkbcommon-x11-dev \
#autoconf libxcb-xrm0 libxcb-xrm-dev automake

#cd /path/where/you/want/the/repository

#git clone https://www.github.com/Airblader/i3 i3-gaps
#cd i3-gaps

#autoreconf --force --install
#rm -rf build/
#mkdir -p build && cd build/

#../configure --prefix=/usr --sysconfdir=/etc --disable-sanitizers
#make
#sudo make install

