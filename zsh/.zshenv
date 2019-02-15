# DESCRIPTION:
#   * h highlights with color specified keywords when you invoke it via pipe
#   * h is just a tiny wrapper around the powerful 'ack' (or 'ack-grep'). you need 'ack' installed to use h. ack website: http://beyondgrep.com/
# INSTALL:
#   * put something like this in your .bashrc:
#     . /path/to/h.sh
#   * or just copy and paste the function in your .bashrc
# TEST ME:
#   * try to invoke:
#     echo "abcdefghijklmnopqrstuvxywz" | h   a b c d e f g h i j k l
# CONFIGURATION:
#   * you can alter the color and style of the highlighted tokens setting values to these 2 environment values following "Perl's Term::ANSIColor" supported syntax
#   * ex.
#     export H_COLORS_FG="bold black on_rgb520","bold red on_rgb025"
#     export H_COLORS_BG="underline bold rgb520","underline bold rgb025"
#     echo abcdefghi | h   a b c d
# GITHUB
#   * https://github.com/paoloantinori/hhighlighter
h() {

    _usage() {
        echo "usage: YOUR_COMMAND | h [-idn] args...
    -i : ignore case
    -d : disable regexp
    -n : invert colors"
    }

    local _OPTS

    # detect pipe or tty
    if [[ -t 0 ]]; then
        _usage
        return
    fi

    # manage flags
    while getopts ":idnQ" opt; do
        case $opt in
            i) _OPTS+=" -i " ;;
            d)  _OPTS+=" -Q " ;;
            n) n_flag=true ;;
            Q)  _OPTS+=" -Q " ;;
                # let's keep hidden compatibility with -Q for original ack users
            \?) _usage
                return ;;
        esac
    done

    shift $(($OPTIND - 1))

    # set zsh compatibility
    [[ -n $ZSH_VERSION ]] && setopt localoptions && setopt ksharrays && setopt ignorebraces

    local _i=0

    if [[ -n $H_COLORS_FG ]]; then
        local _CSV="$H_COLORS_FG"
        local OLD_IFS="$IFS"
        IFS=','
        local _COLORS_FG=()
        for entry in $_CSV; do
          _COLORS_FG=("${_COLORS_FG[@]}" "$entry")
        done
        IFS="$OLD_IFS"
    else
        _COLORS_FG=(
                "underline bold red" \
                "underline bold green" \
                "underline bold yellow" \
                "underline bold blue" \
                "underline bold magenta" \
                "underline bold cyan"
                )
    fi

    if [[ -n $H_COLORS_BG ]]; then
        local _CSV="$H_COLORS_BG"
        local OLD_IFS="$IFS"
        IFS=','
        local _COLORS_BG=()
        for entry in $_CSV; do
          _COLORS_BG=("${_COLORS_BG[@]}" "$entry")
        done
        IFS="$OLD_IFS"
    else
        _COLORS_BG=(
                "bold on_red" \
                "bold on_green" \
                "bold black on_yellow" \
                "bold on_blue" \
                "bold on_magenta" \
                "bold on_cyan" \
                "bold black on_white"
                )
    fi

    if [[ -z $n_flag ]]; then
        #inverted-colors-last scheme
        _COLORS=("${_COLORS_FG[@]}" "${_COLORS_BG[@]}")
    else
        #inverted-colors-first scheme
        _COLORS=("${_COLORS_BG[@]}" "${_COLORS_FG[@]}")
    fi

    if [[ "$#" -gt ${#_COLORS[@]} ]]; then
        echo "You have passed to hhighlighter more keywords to search than the number of configured colors.
Check the content of your H_COLORS_FG and H_COLORS_BG environment variables or unset them to use default 12 defined colors."
        return 1
    fi

    if [ -n "$ZSH_VERSION" ]; then
       local WHICH="whence"
    else [ -n "$BASH_VERSION" ]
       local WHICH="type -P"
    fi

    if ! ACKGREP_LOC="$($WHICH ack-grep)" || [ -z "$ACKGREP_LOC" ]; then
        if ! ACK_LOC="$($WHICH ack)" || [ -z "$ACK_LOC" ]; then
            echo "ERROR: Could not find the ack or ack-grep commands"
            return 1
        else
            local ACK=$($WHICH ack)
        fi
    else
        local ACK=$($WHICH ack-grep)
    fi

    # build the filtering command
    for keyword in "$@"
    do
        local _COMMAND=$_COMMAND"$ACK $_OPTS --noenv --flush --passthru --color --color-match=\"${_COLORS[$_i]}\" '$keyword' |"
        _i=$_i+1
    done
    #trim ending pipe
    _COMMAND=${_COMMAND%?}
    #echo "$_COMMAND"
    cat - | eval $_COMMAND

}

alias i3conf="vim ~/.config/i3/config"
alias i3in="vim ~/.config/i3/dmenu.personal"
alias m="./manage.py"
alias xclipc='xclip -selection c'
alias zshrc="vim ~/.zshrc"

# docker
alias dc="docker-compose"
alias dk="docker"
alias dksa="docker stop \$(docker ps -aq)"
alias dcu="docker-compose up -d"
alias dcl="docker-compose logs --tail 3000 -f | lh"

# git
function grho {
        git reset --hard origin/$(current_branch)
}

# projects aliases work
PROJECTS_PATH='/home/saymmic/PycharmProjects'
alias pp="cd $PROJECTS_PATH"
alias sok="cd $PROJECTS_PATH/sok"
alias cm="cd $PROJECTS_PATH/call-manager"
alias ecmf="cd $PROJECTS_PATH/ember-call-manager-framework"
alias lm="cd $PROJECTS_PATH/lead-manager"
alias aw="cd $PROJECTS_PATH/lead-manager/action-workflow"
alias lg="cd $PROJECTS_PATH/lead-manager/lead-generator"
alias ling="cd $PROJECTS_PATH/lingfluent"
alias mega="cd $PROJECTS_PATH/megadictionary"
alias rtfn="cd $PROJECTS_PATH/rtfn"

function agrt {
    ag $1 $PROJECTS_PATH/rtfn
}

# Bash
alias cmbb="(cd $PROJECTS_PATH/call-manager;docker-compose exec backend /bin/bash)"
alias sokbb="(cd $PROJECTS_PATH/sok;docker-compose exec backend /bin/bash)"
alias cmfb="(cd $PROJECTS_PATH/call-manager;docker-compose exec frontend /bin/bash)"

# Shell
alias cmshell="(cd $PROJECTS_PATH/call-manager;docker-compose exec backend /bin/bash -c 'cd backend; ./manage.py shell_plus --print-sql')"
alias sokshell="(cd $PROJECTS_PATH/sok;docker-compose exec backend /bin/bash -c 'cd center; ./manage.py shell_plus --print-sql')"

# Test
function cmtest {
(cd $PROJECTS_PATH/call-manager;docker-compose exec backend /bin/bash -c "cd backend; python manage.py test --db-template ./scripts/test_db_template.sql ${1}") | toh
}
function cmftest {
(cd $PROJECTS_PATH/call-manager;docker-compose exec backend /bin/bash -c "cd backend/call_manager_framework; python manage.py test --db-template ./scripts/test_db_template.sql ${1}") | toh
}
function soktest {
(cd $PROJECTS_PATH/call-manager;docker-compose exec backend /bin/bash -c 'cd backend; python manage.py test --db-template ./scripts/test_db_template.sql ${1}') | toh
}

alias soklog="(cd $PROJECTS_PATH/sok;docker-compose logs -f --tail 1000 backend | lh)"
alias cmlog="(cd $PROJECTS_PATH/call-manager;docker-compose logs -f --tail 1000 backend | lh)"

# functions
function replace { ag -0 -l "$1" | AGR_FROM="$1" AGR_TO="$2" xargs -r0 perl -pi -e 's/$ENV{AGR_FROM}/$ENV{AGR_TO}/g'; }
