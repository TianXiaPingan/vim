# df -lh
# sudo fdisk -l

# get the UUID of each partition: sudo blkid or ls /dev/disk/by-uuid/ -alh

# ls -l /dev/disk/by-label/

# wake up "ctrl + z" programs: fg [1, 2 ..]

# determine the version and name of a linux system: cat /etc/*-release

# How to determine whether a given Linux is 32 bit or 64 bit?
# "uname -m" ==> "x86_64" ==> 64-bit kernel, "i686" ==> 32-bit kernel
# or "getconf LONG_BIT"

# /etc/apt/sources.list

# find . -iregex ".*hello.*" -exec ls -lh {} \;

# 环境变量
# linux PATH,CPLUS_INCLUDE_PATH, LIBRARY_PATH, LD_LIBRARY_PATH
# mac: PATH, CPLUS_INCLUDE_PATH, LIBRARY_PATH, DYLD_LIBRARY_PATH(better one: DYLD_FALLBACK_LIBRARY_PATH)
# In OSC server, the LIBRARY_PATH does not work for gcc-4.8 by default.
# In OSC server, when openning a terminal, the LD_LIBRARY_PATH does not work as we expected. Anyhow, We should ensure our paths to appear in the begin of these environment variables.

# gdb
# info source

# 查看include的文件的包含关系: g++ -M main.cpp

# port: https://guide.macports.org
# sudo port selfupdate
# port outdated
# sudo port upgrade outdated
# port installed inactive
# sudo port uninstall inactive
# sudo port uninstall leaves
# port echo leaves

# Update two folders:
# rsync -ravutz -e ssh source-dir/ summer@130.108.28.50:dest-dir
# If want to delete extraneous files in destination folder, add "--delete" option.
# Note, souce-dir must ends with "/", while dest-dir does not need to ends with "/".

# My personal cloud
# smb://wdmycloud.local
# ping wdmycloud.local
# If it is directly connected to my computer, then I have to set the IP
# manually, to let them be in the same subset.
# ssh summer@wdmycloud.local, password: common 
# ssh root@wdmycloud.local, password: common, from welc0me to common.
# On/|||: means it is on now.
# |||/Off: means it is off now.

# 在bash中单引号和双引号的区别：单引号不解释里面的变量。 
# export file="hello world"; export '$file' ---> $file
# export file="hello world"; export "$file" ---> hello world

# 至少mac下面，命令行的正则匹配：
# “." 匹配字面“.”。
# “?” 匹配任意一个字符。
# “*" 任意串

# rsync时，如果目标文件夹有空格时，这时候用"\"转义：
# _my_supdate . "summer@130.108.28.50:/media/inf/web\ services/robot\ reporter/library"

# unzip file.zip -d destination_folder

# How to set default finder view for all windows.
# sudo find / -name .DS_Store -delete; killall Finder

# Java path in mac: /System/Library/Frameworks/JavaVM.framework/Versions 

# Unlock files. "sudo chflags -R nouchg file-name"

# mdls: look up meta information a file.

# ditto: Copy Files & Directories Intelligently from the Mac Terminal url

# In mac： 'otool -L data_ext.so', while in linux: 'ldd'

# http://guide.macports.org/#using.port
# port -qv installed > myports.txt
# sudo port -f uninstall installed
# 
# port select --show python
# port select --list python 
# sudo port select --set python <the python version>
# sudo port select --set python python27
# port select --set pip pip27
# 
# sudo port uninstall inactive

###############################################################################
export CLICOLOR=1 
export LSCOLORS=ExFxCxDxBxegedabagacad

##
# Your previous ~/.profile file was backed up as ~/.profile.macports-saved_2015-04-01_at_14:05:36
##

# MacPorts Installer addition on 2015-04-01_at_14:05:36: adding an appropriate PATH variable for use with MacPorts.
export PATH="/opt/local/bin:/opt/local/sbin:$PATH"
# Finished adapting your PATH environment variable for use with MacPorts.

alias _my_create_cpp_project='cp "/Users/world/Desktop/test program/leetcode_template/"* .; cp ~/.gitignore .; git init;'

alias l='       ls -lhr'
alias ll='      ls -lhtr'
alias la='      ls -lhatr'
alias lld='     ls -lhtr | grep "^d"'

alias _git_reset='git reset'
alias _git_init='git init'
alias _git_add='git add .'
alias _git_status='git status'
alias _git_difftool='git difftool'
alias _git_difftool_name='git difftool --name-status'  # old-commit new-commit
alias _git_commit='git commit -a'
alias _git_commit_amend='git commit -a --amend'
alias _git_branch='git branch'
alias _git_checkout='git checkout'
alias _git_log='git log'

alias du='clear; du -h -d 1'
alias du1='clear; du -h -d 1'
alias gvim='/Applications/MacPorts/MacVim.app/Contents/MacOS/Vim -g'

# e.g. rsync --size-only -ravutz -e ssh source-dir/ summer@130.108.28.50:dest-dir/
alias _my_supdate='rsync -ravutzh --progress -e ssh'

alias _my_server_nimbus='echo password: shaojunwang; ssh w004txx@nimbus.cs.wright.edu '
alias _my_server_knoesis='echo password: commonSummer; ssh xia@knoesis1.wright.edu '
# in wsj server: account: wsj, password: wsj
alias _my_server_wsj='echo password: common; ssh summer@130.108.28.50'
alias _my_server_osc='echo password Y36fsk-eag04Y or commonSummer; ssh wsu0215@glenn.osc.edu' 
alias _my_server_osc2='echo password G402790G; ssh wsu0170@glenn.osc.edu' 
#alias _my_server_osc='echo password X37fsk-eug14T; ssh wsu0215@oakley.osc.edul'
alias _my_server_new='echo shaojunwang; ssh swang@130.108.87.251'
alias _my_server_amazon_tokyo="ssh ubuntu@52.68.137.96"
alias _my_server_wife="ssh ma@192.168.1.149"
alias _my_server_wd="echo common; ssh summer@wdmycloud.local"
alias _my_java_eclimd="/Users/world/Installed/EclipseJava.app/Contents/Eclipse/eclimd"

export PATH=~/inf/study/bin:$PATH

export CPLUS_INCLUDE_PATH=~/inf/study/include:$CPLUS_INCLUDE_PATH
export CPLUS_INCLUDE_PATH=/opt/local/include:$CPLUS_INCLUDE_PATH
export CPLUS_INCLUDE_PATH=/opt/local/Library/Frameworks/Python.framework/Versions/2.7/Headers:$CPLUS_INCLUDE_PATH
export CPLUS_INCLUDE_PATH=~/Installed/boost_1_54_0:$CPLUS_INCLUDE_PATH
# for installing python library: json
export CPLUS_INCLUDE_PATH=/System/Library/Frameworks/JavaVM.framework/Versions/A/Headers:$CPLUS_INCLUDE_PATH
# for google test 1.7.0
export CPLUS_INCLUDE_PATH=~/Installed/gtest-1.7.0.summer/include:$CPLUS_INCLUDE_PATH

export LIBRARY_PATH=/opt/local/Library/Frameworks/Python.framework/Versions/2.7/lib:$LIBRARY_PATH
export LIBRARY_PATH=~/Installed/boost_1_54_0/stage/lib:$LIBRARY_PATH
export LIBRARY_PATH=/opt/local/lib:$LIBRARY_PATH
# for google test 1.7.0
export LIBRARY_PATH=~/Installed/gtest-1.7.0.summer/lib/:$LIBRARY_PATH

export DYLD_FALLBACK_LIBRARY_PATH=/opt/local/Library/Frameworks/Python.framework/Versions/2.7/lib:$DYLD_FALLBACK_LIBRARY_PATH
export DYLD_FALLBACK_LIBRARY_PATH=~/Installed/boost_1_54_0/stage/lib:$DYLD_FALLBACK_LIBRARY_PATH
export DYLD_FALLBACK_LIBRARY_PATH=/opt/local/lib:$DYLD_FALLBACK_LIBRARY_PATH

export PYTHONPATH=~/include:$PYTHONPATH
export PYTHONPATH=~/bin:$PYTHONPATH

#export PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME%%.*}: ${PWD/#$HOME/~}\007"'

# Activate ctrl+s in vim.
stty stop undef

export PYTHONIOENCODING=utf8

export PROMPT_COMMAND='echo -ne "\033]0;$PWD\007"'
export PS1='\u@\W\$ '

echo "a healthy of disregarding of impossible"
