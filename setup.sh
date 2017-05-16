#!/bin/bash

if [ -f /etc/redhat-release ]; then
    os='RedHat'
elif [ -f /etc/debian_version ]; then
    os='Debian'
else
    os='Unknown'
fi

function tool_installed() {
    t=$(whereis $1|cut -d ':' -f 2)
    if [ -z "${t}" ]; then
        return 0
    else
        return 1
    fi
}

function prepare_tool() {
    tool_installed "$1"
    if [ $? -eq 1 ] ; then
        echo "$1 already installed"
    else
        echo "$1 not install, so installing ..."
        if [ "${os}" == 'RedHat' ]; then
            sudo yum install $1 -y
        elif [ "${os}" == 'Debian' ]; then
            sudo apt-get install $1 -y
        else
            echo "Please install $1 first"
            exit
        fi
    fi
}

echo 'setup tmux ...'
prepare_tool 'tmux'
prepare_tool 'xlip'
if [ -f ~/.tmux.conf ]; then
    mv ~/.tmux.conf ~/.tmux.conf.bak
fi
cp ./tmux/tmux.conf ~/.tmux.conf

echo 'setup vim ...'
prepare_tool 'vim'
prepare_tool 'git'
if [ -d ~/.vim ]; then
    mv ~/.vim ~/.vim.bak
fi
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
if [ -f ~/.vimrc ]; then
    mv ~/.vimrc ~/.vimrc.bak
fi
cp ./vim/vimrc ~/.vimrc
vim -c PluginInstall
