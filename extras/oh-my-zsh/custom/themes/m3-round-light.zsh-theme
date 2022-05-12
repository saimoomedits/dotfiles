# Material 3 round zsh theme
# main: https://github.com/owl4ce/dotfiles

NEWLINE='
'

# User's left prompt symbol.
if [ "${EUID:-$(id -u)}" -eq 0 ]; then
   #user_symbol='%F{1}%Bλ%b%f' # lambda
    user_symbol='%F{1}%f'     # arrow
else
   #user_symbol='%F{5}%Bλ%b%f' # lambda
    user_symbol='%F{5}%f'     # arrow
fi

# Return code prompt.
non_zero_return_value="%(0?..%F{1}%f)"

# Background prompt.
background_jobs="%(1j.%F{2}%f.)"

# Current working directory prompt, use '%0~' to show full path.
dir_path="%F{253}%K{253}%F{235}%2~ %K{253} %F{5}%{%k%}%F{253}%f"

# Use bold input.
zle_highlight=(default:normal)

# L/R prompt.
PROMPT='${NEWLINE} $(git_prompt_info) ${user_symbol} '
RPROMPT=' ${background_jobs} ${non_zero_return_value} ${dir_path}'

# GIT prompt.
ZSH_THEME_GIT_PROMPT_PREFIX="%F{253}%K{253}%F{4} %K{253} %F{235}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{%k%}%F{253}%f"
ZSH_THEME_GIT_PROMPT_DIRTY="%F{1}*%f"
ZSH_THEME_GIT_PROMPT_CLEAN=''

