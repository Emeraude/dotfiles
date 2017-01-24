alias ne='emacs -nw'
alias ip='ip -c'
alias efm='enlightenment_filemanager'

set -x TERM xterm-256color
set -x EDITOR 'emacs -nw'
set -x PAGER less
set -x MANPAGER most
set -gx PATH $PATH ~/.gem/ruby/2.3.0/bin ~/.rbenv/bin ~/.nodenv/bin
set -x MYSQL_PS1 (echo -e "\e[1;33m\u\e[0m@\e[1;31mMariaDB\e[0m:\e[1;32m\d\e[0m") '\n    -> '

xset -b
