local ret_status="%(?::%{$fg[yellow]%}✗ %s)"
PROMPT='${ret_status}%{$fg[green]%}$(sexy_dir)$(git_prompt_info) %{$fg[red]%}\$ %{$reset_color%}'   

function sexy_dir {
  full_dir=`pwd | sed -e "s:$HOME:~:"`;
  if [[ "$full_dir" = '~' || "$full_dir" = '/' ]]; then
    echo $full_dir;
    exit;
  fi

  base_dir=`dirname "$full_dir" | sed "s:\([^/]\)[^/]*/:\1/:g"`;
  if [ "$base_dir" = '/' ]; then
    base_dir="";
  fi
  base_folder=`basename "$full_dir"`;
  echo "$base_dir/$base_folder";
}

function git_prompt_info() {
  local ref
  if [[ "$(git config --get oh-my-zsh.hide-status 2> /dev/null)" != "1" ]]; then
    ref=$(git symbolic-ref HEAD 2> /dev/null) || \
    ref=$(git rev-parse --short HEAD 2> /dev/null) || return 0
    echo " $(parse_git_dirty)$ZSH_THEME_GIT_PROMPT_PREFIX${ref#refs/heads/}$(parse_git_dirty)$ZSH_THEME_GIT_PROMPT_SUFFIX"
  fi
}

ZSH_THEME_GIT_PROMPT_PREFIX="["
ZSH_THEME_GIT_PROMPT_SUFFIX="]%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[yellow]%}"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[blue]%}"
