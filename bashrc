alias l='       ls -lhtr       '
alias ll='      ls -lhtr      '
alias la='      ls -lhatr     '
alias lld='     ls -lhtr | grep "^d"'

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
alias _my_server_wife="ssh ma@192.168.1.139"

alias _my_beyond_compare='wine "/Users/world/.wine/drive_c/Program Files/Beyond Compare 3/BCompare.exe"'

export PATH=/Users/world/inf/study/bin:$PATH

export CPLUS_INCLUDE_PATH=/Users/world/inf/study/include:$CPLUS_INCLUDE_PATH
export CPLUS_INCLUDE_PATH=/opt/local/include:$CPLUS_INCLUDE_PATH
export CPLUS_INCLUDE_PATH=/opt/local/Library/Frameworks/Python.framework/Versions/2.7/Headers:$CPLUS_INCLUDE_PATH
export CPLUS_INCLUDE_PATH=/Users/world/Installed/boost_1_54_0:$CPLUS_INCLUDE_PATH
# for installing python library: json
export CPLUS_INCLUDE_PATH=/System/Library/Frameworks/JavaVM.framework/Versions/A/Headers:$CPLUS_INCLUDE_PATH
# for google test 1.7.0
export CPLUS_INCLUDE_PATH=/Users/world/Installed/gtest-1.7.0.summer/include:$CPLUS_INCLUDE_PATH


export LIBRARY_PATH=/opt/local/Library/Frameworks/Python.framework/Versions/2.7/lib:$LIBRARY_PATH
export LIBRARY_PATH=/Users/world/Installed/boost_1_54_0/stage/lib:$LIBRARY_PATH
export LIBRARY_PATH=/opt/local/lib:$LIBRARY_PATH
# for google test 1.7.0
export LIBRARY_PATH=/Users/world/Installed/gtest-1.7.0.summer/lib/:$LIBRARY_PATH

export DYLD_FALLBACK_LIBRARY_PATH=/opt/local/Library/Frameworks/Python.framework/Versions/2.7/lib:$DYLD_FALLBACK_LIBRARY_PATH
export DYLD_FALLBACK_LIBRARY_PATH=/Users/world/Installed/boost_1_54_0/stage/lib:$DYLD_FALLBACK_LIBRARY_PATH
export DYLD_FALLBACK_LIBRARY_PATH=/opt/local/lib:$DYLD_FALLBACK_LIBRARY_PATH

export PYTHONPATH=/Users/world/include:$PYTHONPATH
export PYTHONPATH=/Users/world/bin:$PYTHONPATH

#export PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME%%.*}: ${PWD/#$HOME/~}\007"'

# Activate ctrl+s in vim.
stty stop undef

export PYTHONIOENCODING=utf8

echo "a healthy of disregarding of impossible"
