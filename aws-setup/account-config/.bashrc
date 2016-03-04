# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

# Enable proper completion, including git completion
if [ -f $(brew --prefix)/etc/bash_completion ]; then
    . $(brew --prefix)/etc/bash_completion
fi

# User specific aliases and functions
source ~/.alias


# Set up Dryad database as the default for postgres
PGDATABASE=dryad_repo
PGUSER=dryad_app

export M2_HOME=/Applications/apache-maven-3.1.1
export TEMP=/tmp
export TMP=/tmp
export EDITOR=nano
export PATH=$HOME/bin:/Library/PostgreSQL/9.0/bin:$ANT_HOME/bin:$HOME/maven/bin:/usr/local/bin:/usr/bin::/usr/local/opt/coreutils/libexec/gnubin:$M2_HOME/bin:$PATH:.
export CLASSPATH=$ANT_HOME/lib:$ANT_HOME/lib/ant.jar:$ANT_HOME/lib/ant-launcher.jar
export CVS_RSH=ssh
unset USERNAME 

# Make Git work even better
export GIT_PS1_SHOWDIRTYSTATE=1
export GIT_PS1_SHOWSTASHSTATE=1
export GIT_PS1_SHOWUNTRACKEDFILES=1
export GIT_PS1_SHOWUPSTREAM="auto"

# Make the prompt fancy
export PROMPT_COMMAND='DIR=`pwd|sed -e "s!$HOME!~!"`; if [ ${#DIR} -gt 30 ]; then CurDir=${DIR:0:12}...${DIR:${#DIR}-15}; else CurDir=$DIR; fi'
export PS1='\h:$CurDir$(__git_ps1 "(%s)")->'

export JAVA_HOME="$(/usr/libexec/java_home)"

