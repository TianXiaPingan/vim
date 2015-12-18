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
alias _my_java_eclimd="/Applications/EclipseJava.app/Contents/Eclipse/eclimd"

alias _my_beyond_compare='wine "~/.wine/drive_c/Program Files/Beyond Compare 3/BCompare.exe"'

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
