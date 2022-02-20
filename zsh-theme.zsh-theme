# zsh-theme zsh-theme
#
# Requires modules
# `duration-info`
# `git-info`
# `prompt-pwd`

_prompt_s1ck94_keymap_select() {
  zle reset-prompt
  zle -R
}
if autoload -Uz is-at-least && is-at-least 5.3; then
  autoload -Uz add-zle-hook-widget && \
      add-zle-hook-widget -Uz keymap-select _prompt_s1ck94_keymap_select
else
  zle -N zle-keymap-select _prompt_s1ck94_keymap_select
fi

if (( ! ${+USER_PROMPT_CHAR} )) typeset -g USER_PROMPT_CHAR=$
if (( ! ${+ROOT_PROMPT_CHAR} )) typeset -g ROOT_PROMPT_CHAR=#
if (( ! ${+ON_COLOR} )) typeset -g ON_COLOR=green
if (( ! ${+OFF_COLOR} )) typeset -g OFF_COLOR=default
if (( ! ${+ERR_COLOR} )) typeset -g ERR_COLOR=red

setopt nopromptbang prompt{cr,percent,sp,subst}

zstyle ':zim:duration-info' format '(%d) '
autoload -Uz add-zsh-hook
add-zsh-hook preexec duration-info-preexec
add-zsh-hook precmd duration-info-precmd

typeset -gA git_info
if (( ${+functions[git-info]} )); then
  zstyle ':zim:git-info:branch' format '%b'
  zstyle ':zim:git-info:commit' format '%c'
  zstyle ':zim:git-info:dirty' format '%F{${ERR_COLOR}}'
  zstyle ':zim:git-info:diverged' format '%F{${ERR_COLOR}}'
  zstyle ':zim:git-info:behind' format '%F{yellow}'
  zstyle ':zim:git-info:ahead' format '%F{${OFF_COLOR}}'
  zstyle ':zim:git-info:keys' format \
      'rprompt' ' $(coalesce %D %V %B %A %F{${ON_COLOR}})%b%c'

  autoload -Uz add-zsh-hook && add-zsh-hook precmd git-info
fi

if (( ${+functions[prompt-pwd]} )); then
  zstyle ':zim:prompt-pwd' git-root yes
  zstyle ':zim:prompt-pwd:fish-style' dir-length 1
  zstyle ':zim:prompt-pwd:separator' format '%F{244}/%f'
fi

local prompt_char="%(!.${ROOT_PROMPT_CHAR}.${USER_PROMPT_CHAR})"
local prompt_fmt=('%F{%(' '.${ON_COLOR}.' ')}${prompt_char}')
local stat_param=('0?' '${ERR_COLOR}' '')

PS1="${(@j::)prompt_fmt:^stat_param}%f "
RPS1='${duration_info}$(prompt-pwd)${(e)git_info[rprompt]}%f'

unset stat_param
