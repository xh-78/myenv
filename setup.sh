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
    for tool in $@
    do
        tool_installed "$tool"
        if [ $? -eq 1 ] ; then
            echo "$tool already installed"
        else
            echo "$tool not install, so installing ..."
            if [ "${os}" == 'RedHat' ]; then
                sudo yum install $tool -y
            elif [ "${os}" == 'Debian' ]; then
                sudo apt-get install $tool -y
            else
                echo "Please install $tool first"
                exit
            fi
        fi
    done
}

echo 'prepareing tool ...'
prepare_tool 'tmux' 'vim' 'git'

echo 'setup tmux ...'
if [ -f ~/.tmux.conf ]; then
    mv ~/.tmux.conf ~/.tmux.conf.bak
fi
cp ./tmux/tmux.conf ~/.tmux.conf

echo 'setup vim ...'
if [ -d ~/.vim ]; then
    mv ~/.vim ~/.vim.bak
fi
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
if [ -f ~/.vimrc ]; then
    mv ~/.vimrc ~/.vimrc.bak
fi
cp ./vim/vimrc ~/.vimrc
vim -c PluginInstall
