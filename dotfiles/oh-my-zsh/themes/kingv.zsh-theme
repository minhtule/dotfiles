local ret_status="%(?::%{$fg[yellow]%}✗ %s)"
PROMPT='$(virtualenv_prompt_info)$(rvm_propmt_info)$(nvm_prompt_info)${ret_status}%{$fg[green]%}$(sexy_dir)$(parse_git_dirty)$(git_prompt_info) %{$fg[red]%}\$ %{$reset_color%}'

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

# Cache the default version because `rvm list` is kind of slow.
# Also strip off newline characters.
export RVM_RUBY_DEFAULT_VERSION=`echo $(~/.rvm/bin/rvm list default string) | tr -d "\n"`

function rvm_propmt_info() {
  [ -f $HOME/.rvm/bin/rvm-prompt ] || return 1

  # `$rvm_ruby_string` is set by rvm in ENV vars.
  if [[ ! -z $rvm_ruby_string && $rvm_ruby_string != $RVM_RUBY_DEFAULT_VERSION ]]; then
    ruby_version=$rvm_ruby_string
  else
    ruby_version=''
  fi

  gemset_version=$(~/.rvm/bin/rvm-prompt g)
  info=$ruby_version$gemset_version
  if [ ! -z $info ]; then
    info="($info) "
  fi

  echo $info
}

function nvm_prompt_info() {
  # Check if nvm is installed
  [[ -f "$NVM_DIR/nvm.sh" ]] || return

  local nvm_prompt
  nvm_prompt=$(node -v 2>/dev/null)
  [ -z $nvm_prompt ] && return

  # If it is using the default version, do not display the prompt.
  # The default version should be exported in .zshrc.
  [[ $nvm_prompt == $NVM_NODE_DEFAULT_VERSION ]] && return

  # Strip the "v" prefix
  nvm_prompt=${nvm_prompt:1}
  echo "⬡ ${nvm_prompt} "
}

ZSH_THEME_GIT_PROMPT_PREFIX=" ["
ZSH_THEME_GIT_PROMPT_SUFFIX="]%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[yellow]%}"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[blue]%}"

ZSH_THEME_VIRTUALENV_PREFIX="("
ZSH_THEME_VIRTUALENV_SUFFIX=") "
