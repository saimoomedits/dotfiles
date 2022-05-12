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
    user_symbol='%F{4}%f'     # arrow
fi

# Return code prompt.
non_zero_return_value="%(0?..%F{1}%f)"

# Background prompt.
background_jobs="%(1j.%F{2}%f.)"

# Current working directory prompt, use '%0~' to show full path.
dir_path="%F{237}%K{237}%F{004} %K{237} %F{252}%2~%{%k%}%F{237}%f"

# Use bold input.
zle_highlight=(default:normal)

# L/R prompt.
PROMPT='${NEWLINE} ${dir_path} ${user_symbol} '
RPROMPT=' ${background_jobs} ${non_zero_return_value} $(git_prompt_info)'

# GIT prompt.
ZSH_THEME_GIT_PROMPT_PREFIX="%F{237}%K{237}%F{4} %K{238} %F{252}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{%k%}%F{238}%f"
ZSH_THEME_GIT_PROMPT_DIRTY="%F{1}*%f"
ZSH_THEME_GIT_PROMPT_CLEAN=''

