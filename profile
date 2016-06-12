# vim repository
# git clone git@52.68.137.96:"/home/git/Tian Xia/personal/vim"

# Debug scala with jdb
# compile: scalac -g:vars [source]
# set breakpoint: stop in HelloWorld$.main
#
# Another usuage is 
# run and it should ouput a port: 
#   env JAVA_OPTS="-agentlib:jdwp=transport=dt_socket,server=y,suspend=n" scala [class]
# attach to the port
#   jdb -attach [port]
# disassembles class file to assist set breakpoints
#   javap [class]

# Install gcc4.9 and python in CentOS 6.5
# cd /etc/yum.repos.d; sudo wget http://linuxsoft.cern.ch/cern/scl/slc6-scl.repo; sudo yum -y --nogpgcheck install devtoolset-3-gcc devtoolset-3-gcc-c++
# /opt/rh/devtoolset-3/root/usr/bin/gcc --version
# sudo yum -y update  
# sudo yum groupinstall -y 'development tools'  
# sudo yum install -y zlib-devel bzip2-devel openssl-devel xz-libs wget  

# SSH without password
# 1. ssh-keygen -t rsa
#   生成的过程中提示输入，直接回车，接受默认值就行了。
#   其中公共密钥保存在 ~/.ssh/id_rsa.pub， 私有密钥保存在 ~/.ssh/id_rsa
# 2. 然后改一下 .ssh 目录的权限，使用命令 "chmod 755 ~/.ssh"
# 3. 之后把这个密钥对中的公共密钥复制到你要访问的机器上去，并保存为~/.ssh/authorized_keys.
# 4. 设置权限: chmod 644 ~/.ssh/authorized_keys

# Maven for Java 
# Create a maven project [[http://www.mkyong.com/maven/how-to-create-a-java-project-with-maven/]]
#   mvn archetype:generate -DgroupId={package-name}  -DartifactId={foldername} -DarchetypeArtifactId=maven-archetype-quickstart -DinteractiveMode=false
#
# Common commands:
#   1. mvn clean
#   2. mvn compile
#   3. mvn package
#   4. mvn clean install
# 
# Download packages:
#   <dependency>
#     <groupId>org.apache.commons</groupId>
#     <artifactId>commons-lang3</artifactId>
#     <version>3.4</version>
#   </dependency>
#
# Or download packages directly:
#   mvn -DgroupId=commons-io -DartifactId=commons-io -Dversion=1.4 dependency:get
# 
# Download sources: 
#   1. mvn dependency:sources
#   2. mvn dependency:resolve -Dclassifier=javadoc
# 
#   The first command will attempt to download source code for each of the dependencies in your pom file.
#   The second command will attempt to download the Javadocs.
#
# Converted for Eclipse IDE
#   mvn eclipse:eclipse
#   To import the project into Eclipse IDE, select "File -> Import… -> General->Existing Projects into Workspace"

# Eclim for Java
# How to add a new library in Java.
# 1. export CLASSPATH=library-path:./:$CLASSPATH
#    Note, we have to add "./" to it.
# 2. Setting in eclim:
#    Add a newline in .classpath:
#    <classpathentry kind="lib" path="library-path"/>
#    Make sure you put all sources and classes in the same directory, then in 
#    JDB source files could be conveniently found.
# 3. In JDB, when running, you could input "classpath" to see all library paths.
# 
# Set project with assertion mode.
# :ProjectSettings or (:EclimSettings)
# org.eclim.java.run.jvmargs=[-ea]

# GPU related
# cat /proc/driver/nvidia/gpus/0000\:0f\:00.0/information
# lspci -vnn | grep -i VGA -A 12
# nvidia-smi
# THEANO_FLAGS=mode=FAST_RUN,device=gpu,floatX=float32 python code.py

# Python debugger.
# vim /opt/local/Library/Frameworks/Python.framework/Versions/2.7/lib/python2.7/cmd.py
# use_rawinput = 1
#   set to
# use_rawinput = 0
# 
# But this method seems to permit the command history.
# We could define my own pdb.py version.

# mount GPT disk
# sudo parted /dev/sda print
# mount some parition in it.

# gprof (not working in mac)
# 1. Add -g in both compiling and linking of g++.
# 2. run and generate gmon.out.
# 3. gprof test > prof.text

# Python debugger: ipdb

# Python Library    
# import pip
# installed_packages = pip.get_installed_distributions()
# installed_packages_list = sorted(["%s==%s" % (i.key, i.version) for i in installed_packages])
# print(installed_packages_list)
#
# PIL image-rendering commands
# cvxmod: lingo-like programming pack 
# cvxopt: python software for convex optimization
# gensim, a topic modeling package containing our LDA model. https://rstudio-pubs-static.s3.amazonaws.com/79360_850b2a69980c4488b1db95987a24867a.html
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
# theano: Theano is a python library that makes writing deep learning models easy, and gives the option of training them on a GPU


# Debug java in a GUI jdb.
# 1) mvim --servername debug *.java
# 2) _jdb_server.py 
# Note, I did not use vim, instead macvim, as console vim does not support client server mode.
# Though, I could complile vim with X11, but that would ruin the system global clipboard.

# Compile java with debug information: javac -g *.java

# find java installed location: /usr/libexec/java_home -v 1.7 

# How to let jdb support up/down/left/right
# 1. sudo port install jline
# 2. java -classpath /opt/local/share/java/jline.jar:/Library/Java/JavaVirtualMachines/jdk1.7.0_45.jdk/Contents/Home/lib/tools.jar jline.ConsoleRunner com.sun.tools.example.debug.tty.TTY your-main-class 
# Check content in a jar package: vim *.jar

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

# 在bash中单引号和双引号的区别：单引号不解释里面的变量。 
# export file="hello world"; export '$file' ---> $file
# export file="hello world"; export "$file" ---> hello world

# 至少mac下面，命令行的正则匹配：
# “." 匹配字面“.”。
# “?” 匹配任意一个字符。
# “*" 任意串

# rsync时，如果目标文件夹有空格时，这时候用"\"转义：
# _supdate . "summer@130.108.28.50:/media/inf/web\ services/robot\ reporter/library"

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

alias _create_cpp_project='cp "/Users/world/Desktop/test program/leetcode template/"* .; cp ~/.gitignore .; git init;'
alias _create_java_project='cp "/Users/world/Desktop/test program/java template/"* .; cp ~/.gitignore .; git init;'
alias _create_python_project='cp "/Users/world/Desktop/test program/python template/"* .; cp ~/.gitignore .; git init;'

alias l='       ls -lhr'
alias ll='      ls -lhtr'
alias la='      ls -lhatr'
alias lld='     ls -lhtr | grep "^d"'

#[[http://hadoop.apache.org/docs/current/hadoop-project-dist/hadoop-common/FileSystemShell.html]]
alias hls='hadoop fs -ls -h'
alias hlsr='hadoop fs -ls -h -R'
alias hcat='hadoop fs -cat'
alias hcp='hadoop fs -cp'
alias hmkdir='hadoop fs -mkdir'
alias hrm='hadoop fs -rm'

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

alias du1='clear; du -h -d 1'
alias du2='clear; du -h --max-depth 1'
alias gvim='/Applications/MacPorts/MacVim.app/Contents/MacOS/Vim -g'

# e.g. rsync --size-only -ravutz -e ssh source-dir/ summer@130.108.28.50:dest-dir/
alias _supdate='rsync -ravutzh --progress -e ssh'

alias _server_nimbus='echo password: shaojunwang; ssh w004txx@nimbus.cs.wright.edu '
alias _server_knoesis='echo password: commonSummer; ssh xia@knoesis1.wright.edu '
# in wsj server: account: wsj, password: wsj
alias _server_wsj='echo password: summer; ssh summer@130.108.28.50'
alias _server_new='echo shaojunwang; ssh swang@130.108.87.251'
alias _server_amazon_tokyo="ssh ubuntu@52.68.137.96"
alias _server_wife="ssh ma@192.168.1.115"
alias _server_wd="ssh summer@192.168.1.100"

alias _server_dev1="ssh txia@g1dlfinddev01.dev.glbt1.gdg"
alias _server_dev2="ssh txia@g1dlfinddev02.dev.glbt1.gdg"
alias _server_dev3="ssh txia@g1dlfinddev03.dev.glbt1.gdg"
alias _server_dev4="ssh txia@g1dlfinddev04.dev.glbt1.gdg"
alias _server_dev5="ssh txia@g1dlfinddev05.dev.glbt1.gdg"
alias _server_hadoop="ssh txia@p3plpashl01.prod.phx3.gdg"
alias _server_spark="ssh txia@g1dlemllab01-02.dev.glbt1.gdg"

alias _java_eclimd="~/Installed/EclipseJava.app/Contents/Eclipse/eclimd"

export PATH=/opt/local/bin:$PATH
export PATH=/opt/local/sbin:$PATH
export PATH=~/bin:$PATH
export PATH=/opt/rh/devtoolset-3/root/usr/bin:$PATH

export CPLUS_INCLUDE_PATH=~/include:$CPLUS_INCLUDE_PATH
export CPLUS_INCLUDE_PATH=/opt/local/include:$CPLUS_INCLUDE_PATH
export CPLUS_INCLUDE_PATH=/opt/local/Library/Frameworks/Python.framework/Versions/2.7/Headers:$CPLUS_INCLUDE_PATH
export CPLUS_INCLUDE_PATH=~/Installed/boost_1_60_0:$CPLUS_INCLUDE_PATH
# for installing python library: json
export CPLUS_INCLUDE_PATH=/System/Library/Frameworks/JavaVM.framework/Versions/A/Headers:$CPLUS_INCLUDE_PATH
# for google test 1.7.0
export CPLUS_INCLUDE_PATH=~/Installed/gtest-1.7.0.summer/include:$CPLUS_INCLUDE_PATH

export LIBRARY_PATH=/opt/local/Library/Frameworks/Python.framework/Versions/2.7/lib:$LIBRARY_PATH
export LIBRARY_PATH=/opt/local/lib:$LIBRARY_PATH
export LIBRARY_PATH=/usr/local/lib:$LIBRARY_PATH

export DYLD_FALLBACK_LIBRARY_PATH=/opt/local/Library/Frameworks/Python.framework/Versions/2.7/lib:$DYLD_FALLBACK_LIBRARY_PATH
export DYLD_FALLBACK_LIBRARY_PATH=~/Installed/boost_1_60_0/stage/lib:$DYLD_FALLBACK_LIBRARY_PATH
export DYLD_FALLBACK_LIBRARY_PATH=/opt/local/lib:$DYLD_FALLBACK_LIBRARY_PATH

export PYTHONPATH=~/include:$PYTHONPATH
export PYTHONPATH=~/bin:$PYTHONPATH

export CLASSPATH=~/.m2/repository/org/scala-lang/scala-library/2.11.7/scala-library-2.11.7.jar:$CLASSPATH
export CLASSPATH=/opt/local/share/java/jline.jar:$CLASSPATH
export CLASSPATH=/Library/Java/JavaVirtualMachines/jdk1.8.0_91.jdk/Contents/Home/lib/tools.jar:$CLASSPATH
#export CLASSPATH=~/include/java/bin:$CLASSPATH

#export PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME%%.*}: ${PWD/#$HOME/~}\007"'

# Activate ctrl+s in vim.
stty stop undef

# activate ctrl-q, which is occupied in stty.
stty -ixon > /dev/null 2>/dev/null

export PYTHONIOENCODING=utf8

export PROMPT_COMMAND='echo -ne "\033]0;$PWD\007"'
export PS1='\u@\W\$ '

