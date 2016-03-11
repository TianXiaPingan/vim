# gprof (not working in mac)
# 1. Add -g in both compiling and linking of g++.
# 2. run and generate gmon.out.
# 3. gprof test > prof.text

# How to add a new library in Java.
# 1. export CLASSPATH=library-path:./:$CLASSPATH
#    Note, we have to add "./" to it.
# 2. Setting in eclim:
#    Add a newline in .classpath:
#    <classpathentry kind="lib" path="library-path"/>
#    Make sure you put all sources and classes in the same directory, then in 
#    JDB source files could be conveniently found.
# 3. In JDB, when running, you could input "classpath" to see all library paths.

# Python debugger: ipdb

# Python Library    
# import pip
# installed_packages = pip.get_installed_distributions()
# installed_packages_list = sorted(["%s==%s" % (i.key, i.version) for i in installed_packages])
# print(installed_packages_list)

# cvxmod: lingo-like programming pack 
# cvxopt: python software for convex optimization
# gensim: Python framework for fast Vector Space Modelling
# matplotlib: a mature and popular plotting package, that provides publication-quality 2d plotting as well as rudimentary 3d plotting
# nltk: a libray for NLP. 
# numpy: the fundamental package for numerical computation. it defines the numerical array and matrix types and basic operations on them.
# pandas: powerful python data analysis toolkit, including time series analysis.
# pybrain: a modular machine learning library for Reinforcement Learning, Artificial Intelligence and Neural Network.
# scipy: scientific computation. 
# seaborn: statistical data visualization
# shogun-octave: large scale machine learning toolbox
# shogun-python: 大规模机器学习工具箱。
# sklearn: scikit-learn machine learning package.
# sklearn_pandas: this module provides a bridge between scikit-learn's machine learning methods and pandas-style data frames.
# sympy: a symbolic manipulation package, written in pure python



# Set project with assertion mode.
# :ProjectSettings or (:EclimSettings)
# org.eclim.java.run.jvmargs=[-ea]

# Debug java in a GUI jdb.
# 1) mvim --servername debug *.java
# 2) _my_jdb_server.py 
# Note, I did not use vim, instead macvim, as console vim does not support client server mode.
# Though, I could complile vim with X11, but that would ruin the system global clipboard.

# Support python, cscope
# vim --version, check if python is supported.
# port variant vim
# port installed | grep vim
# sudo port install vim +python27 +cscope +huge (for mac at least)
# sudo port install vim +python27 +cscope +huge +x11 (for mac at least)
# sudo port activate vim version.

# port often fail in installing macvim.
# sudo chmod -R g-w $(xcode-select -p)/Library/PrivateFrameworks/CoreSimulator.framework/Versions/A/XPCServices/com.apple.CoreSimulator.CoreSimulatorService.xpc
# sudo chown -R root:wheel $(xcode-select -p)/Library/PrivateFrameworks/CoreSimulator.framework/Versions/A/XPCServices/com.apple.CoreSimulator.CoreSimulatorService.xpc
# https://trac.macports.org/wiki/ProblemHotlist#xcode7.2

# Compile java with debug information: javac -g *.java

# find java installed location: /usr/libexec/java_home -v 1.7 

# How to let jdb support up/down/left/right
# 1. sudo port install jline
# 2. java -classpath /opt/local/share/java/jline.jar:/Library/Java/JavaVirtualMachines/jdk1.7.0_45.jdk/Contents/Home/lib/tools.jar jline.ConsoleRunner com.sun.tools.example.debug.tty.TTY your-main-class 
# Check content in a jar package: vim *.jar

# 挂载iso文件：mount -t iso9660 -o loop xxx.iso /path
# 拷贝光盘：cp /dev/cdrom xxx.iso 

# 正则表达式grep，是perl语法的一个子集，但正则表达式要加双引号。
# ls | grep ".*\.c[a-z]?"

# 使用awk提取短语表src、tgt命令：
# cat phrase.table | awk -F" \|\|\| " '{print $1}' 或者 awk -F" \|\|\| " '{print $1}' phrase.table

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

# -H in grep means outputting filenames.
# find . -iregex ".*java" -exec grep -iH main {} \;

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
# Look up install location of port: port content [jline]

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

alias _my_create_cpp_project='cp "/Users/world/Desktop/test program/leetcode template/"* .; cp ~/.gitignore .; git init;'
alias _my_create_java_project='cp "/Users/world/Desktop/test program/java template/"* .; cp ~/.gitignore .; git init;'
alias _my_create_python_project='cp "/Users/world/Desktop/test program/python template/"* .; cp ~/.gitignore .; git init;'
alias _my_jdb='java -classpath /opt/local/share/java/jline.jar:/Library/Java/JavaVirtualMachines/jdk1.8.0_71.jdk/Contents/Home/lib/tools.jar jline.ConsoleRunner com.sun.tools.example.debug.tty.TTY'

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
alias _my_server_wsj='echo password: summer; ssh summer@130.108.28.50'
alias _my_server_osc='echo password Y36fsk-eag04Y or commonRain; ssh wsu0215@glenn.osc.edu' 
alias _my_server_osc2='echo password G402790G; ssh wsu0170@glenn.osc.edu' 
#alias _my_server_osc='echo password X37fsk-eug14T; ssh wsu0215@oakley.osc.edul'
alias _my_server_new='echo shaojunwang; ssh swang@130.108.87.251'
alias _my_server_amazon_tokyo="ssh ubuntu@52.68.137.96"
alias _my_server_wife="ssh ma@192.168.1.130"
alias _my_server_wd="ssh summer@192.168.1.116"
alias _my_java_eclimd="/Users/world/Installed/EclipseJava.app/Contents/Eclipse/eclimd"

export PATH=~/inf/study/bin:/Users/world/.vim/bin:$PATH

export CPLUS_INCLUDE_PATH=~/inf/study/include:$CPLUS_INCLUDE_PATH
export CPLUS_INCLUDE_PATH=/opt/local/include:$CPLUS_INCLUDE_PATH
export CPLUS_INCLUDE_PATH=/opt/local/Library/Frameworks/Python.framework/Versions/2.7/Headers:$CPLUS_INCLUDE_PATH
export CPLUS_INCLUDE_PATH=~/Installed/boost_1_60_0:$CPLUS_INCLUDE_PATH
# for installing python library: json
export CPLUS_INCLUDE_PATH=/System/Library/Frameworks/JavaVM.framework/Versions/A/Headers:$CPLUS_INCLUDE_PATH
# for google test 1.7.0
export CPLUS_INCLUDE_PATH=~/Installed/gtest-1.7.0.summer/include:$CPLUS_INCLUDE_PATH

export LIBRARY_PATH=/opt/local/Library/Frameworks/Python.framework/Versions/2.7/lib:$LIBRARY_PATH
export LIBRARY_PATH=~/Installed/boost_1_60_0/stage/lib:$LIBRARY_PATH
export LIBRARY_PATH=/opt/local/lib:$LIBRARY_PATH
# for google test 1.7.0
export LIBRARY_PATH=~/Installed/gtest-1.7.0.summer/lib/:$LIBRARY_PATH

export DYLD_FALLBACK_LIBRARY_PATH=/opt/local/Library/Frameworks/Python.framework/Versions/2.7/lib:$DYLD_FALLBACK_LIBRARY_PATH
export DYLD_FALLBACK_LIBRARY_PATH=~/Installed/boost_1_60_0/stage/lib:$DYLD_FALLBACK_LIBRARY_PATH
export DYLD_FALLBACK_LIBRARY_PATH=/opt/local/lib:$DYLD_FALLBACK_LIBRARY_PATH

export PYTHONPATH=~/include:$PYTHONPATH
export PYTHONPATH=~/bin:$PYTHONPATH

#export PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME%%.*}: ${PWD/#$HOME/~}\007"'

# Activate ctrl+s in vim.
stty stop undef

# activate ctrl-q, which is occupied in stty.
stty -ixon > /dev/null 2>/dev/null

export PYTHONIOENCODING=utf8

export PROMPT_COMMAND='echo -ne "\033]0;$PWD\007"'
export PS1='\u@\W\$ '

export CLASSPATH=/Users/world/Installed/commons-lang3-3.4-src/src/main/java:./:$CLASSPATH

echo "a healthy of disregarding of impossible"
