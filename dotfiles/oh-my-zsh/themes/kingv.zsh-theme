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

# Cache the default version because `rvm list` is kind of slow. 
# Also strip off newline characters.
export RVM_RUBY_DEFAULT_VERSION=`echo $(~/.rvm/bin/rvm list default string) | tr -d "\n"`

function my_rvm_propmt_info() {
  [ -f $HOME/.rvm/bin/rvm-prompt ] || return 1

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

ZSH_THEME_GIT_PROMPT_PREFIX="["
ZSH_THEME_GIT_PROMPT_SUFFIX="]%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[yellow]%}"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[blue]%}"
