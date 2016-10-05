#!/usr/bin/env bash

__job_control() {
    [ -n "`jobs -p`" ] && echo -n '[\[\e[35m\]\j\[\e[0m\]]';
}

__custom_hour() {
    hours=$(date +%H);
    minutes=$(date +%M);
    seconds=$(date +%S);
    echo -n "[\[\e[0;34m\]$hours:";
    [ $minutes == 42 ] && echo -n '\[\e[1m\]';
    echo -n $minutes;
    echo -n "\[\e[0;34m\]:"
    [ $seconds == 42 ] && echo -n '\[\e[1m\]';
    echo -n $seconds;
    echo -n "\[\e[0m\]]"
}

__prompt_git() {
    [ "`git status 2>&-`" ] && {
	echo -n '[';
	branch=$(git symbolic-ref --short --quiet HEAD);
	[ $? != 0 ] && {
	    echo -n '\[\e[0;36m\]*';
	    branch='detached';
	}
	echo -n "\[\e[0;35m\]$branch\[\e[0m\]";
	[ "`git status -s`" != "" ] && echo -n '\[\e[0;33m\]*\[\e[0m\]';
	[ "`git log HEAD..origin/$branch 2>&-`" ] && echo -n '\[\e[1;33m\]*\[\e[0m\]';
	echo -n '] ';
    }
}

__last_command() {
    echo -n '\[\e[1;3';
    case $1 in
	0)
	    echo -n '2';;
	148)
	    echo -n '3';;
	*)
	    echo -n '1'
    esac
    echo -n 'm\]>\[\e[0m\]';
}

__generate_prompt() {
    lastcommand=$?;
    PS1="`__job_control`";
    PS1+="`__custom_hour`";
    PS1+='\[\e[33m\]\u\[\e[0m\]@\[\e[32m\]\h\[\e[0m\]:\[\e[31m\]\w\[\e[0m\] ';
    PS1+="`__prompt_git`";
    PS1+='\[\e[36m\]\#\[\e[0m\]';
    PS1+="`__last_command $lastcommand`";
    unset lastcommand;
}

export EDITOR='emacs -nw'
export HISTSIZE=10000
export SAVEHIST=10000
export MANPAGER='most'
export PAGER='less'
export MYSQL_PS1=$(echo -e "\e[1;33m\u\e[0m@\e[1;31mMariaDB\e[0m:\e[1;32m\d\e[0m\n    -> ")
export PATH="$PATH:~/bin"
export PROMPT_COMMAND=__generate_prompt
export TERM=xterm-256color

mc() { mkdir -p $1 && cd $1;}

alias gitl="git log --graph --pretty=format:'%Cred%h%Creset-%C(yellow)%d%Creset%s%Cgreen(%cr)%C(blue)<%an>%Creset'"
gitpa() {
    for remote in `git remote`
    do
	git push $remote
    done
}

transfer() {
    mkdir -p '/tmp/transfer';
    for i in $@
    do
	__file=$(basename $i);
	curl --progress-bar --upload-file $i https://transfer.sh/$__file > /tmp/transfer/$__file;
	cat /tmp/transfer/$__file;
    done
}

alias ne='emacs -nw'

alias -- -='cd -'
alias ..='cd ..'
alias ...='cd ../..'
alias ~='cd ~'

alias gcc='gcc -fdiagnostics-color=always'
alias g++='g++ -fdiagnostics-color=always'
alias tree='tree -C'
alias grep='grep --color -n'

[ -n "$TERMINOLOGY" ] && alias ls='tyls' || {
	which exa >&- 2>&- && alias ls='exa' || alias ls='ls --color'
    }
alias la='ls -a'
which exa >&- 2>&- && {
    alias ll='exa -l --git'
    alias l='exa -la --git'
    alias lc='exa -al *.c 2>&-'
} || {
    alias ll='ls -l'
    alias l='ls -la'
    alias lc='ls -al *.c 2>&-'
}

alias gitacp='git add -A; git commit; git pull; gitpa'

bind -x '"\el":"clean"'
bind -x '"\eg":"gitacp"'
bind -x '"\eM":"time make re"'
bind -x '"\ej":"jobs"'

shopt -s autocd
shopt -s cmdhist
shopt -s extglob
shopt -s mailwarn
shopt -s globstar
shopt -s progcomp

complete -f -X '*.@(so|o)' ec ne vi vim
complete -f -X '!*.cpp' g++
complete -f -X '!*.c' cc gcc

complete -A helptopic help
complete -A shopt shopt
complete -A setopt set
complete -c whereis which
complete -d cd pushd rmdir
complete -j -P '"%' -S '"' bg disown fg jobs
complete -u passwd su
