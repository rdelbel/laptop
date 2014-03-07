#! /bin/bash -e
# install.vimrplugin.sh - A simple shell script to install vim-r-plugin (for debian/ubuntu only)
# Author - Eric Xihui Lin
# install tmux
if dpkg -s tmux; then
	echo 'tmux is already installed.'
else
	yes | sudo apt-get install tmux
fi

# install screen
dpkg -s screen && echo 'screen is already installed.' || yes | sudo apt-get install screen

# downlowad vim-r-plugin, and unzip the files to ~/.vim
wget http://www.vim.org/scripts/download_script.php?src_id=19802 -O /tmp/vim-r-plugin-0.9.9.3.zip
unzip -o /tmp/vim-r-plugin-0.9.9.3.zip -d $HOME/.vim

# download and install screen.vba
wget http://www.vim.org/scripts/download_script.php?src_id=16100 -O /tmp/screen.vba
vim /tmp/screen.vba +'so %' +q!

# install R pacakge vimcom and its dependence
dpkg -s libx11-dev && echo 'libx11-dev is already installed.' || yes | sudo apt-get install libx11-dev

Rscript -e 'if (!is.element("vimcom", installed.packages()[,1])) install.packages("vimcom",repos="http://probability.ca/cran/")'

# load library vimcom when an R interactive session is running
echo 'if(interactive()){
       library(vimcom)
   }' >> $HOME/.Rprofile

# add vim-r-plugin settings to .vimrc
echo 'let vimrplugin_objbr_place = "console,right"
" let vimrplugin_screenvsplit = 1  ## if you prefer a vertical split, uncommment this line
let g:ScreenImpl = "Tmux"
vmap <C-l> <Plug>RDSendSelection
nmap <C-l> <Plug>RDSendLine
imap <C-l> <plug>RDSendLine
map <F2> <Plug>RStart
imap <F2> <Plug>RStart
vmap <F2> <Plug>RStart
' >> $HOME/.vimrc
