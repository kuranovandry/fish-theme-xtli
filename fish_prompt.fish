function fish_prompt
  # Cache exit status
  set -l last_status $status

  # Just calculate these once, to save a few cycles when displaying the prompt
  if not set -q __fish_prompt_hostname
    set -g __fish_prompt_hostname (hostname|cut -d . -f 1)
  end
  if not set -q __fish_prompt_char
    switch (id -u)
      case 0
        set -g __fish_prompt_char \u276f\u276f
      case '*'
        set -g __fish_prompt_char \$
    end
  end

  # Setup colors
  set -l normal (set_color normal)
  set -l cyan (set_color cyan)
  set -l yellow (set_color yellow)
  set -l bpurple (set_color -o purple)
  set -l bred (set_color -o red)
  set -l bcyan (set_color -o cyan)
  set -l bwhite (set_color -o white)

  # Color prompt char red for non-zero exit status
  set -l pcolor $bpurple
  if [ $last_status -ne 0 ]
    set pcolor $bred
  end

  # Configure __fish_git_prompt
  set -g __fish_git_prompt_show_informative_status true
  set -e __fish_git_prompt_showcolorhints

  # Top
  set fish_prompt_pwd_dir_length 0
  set -l prompt_columns (printf '%s%s at %s in %s%s' $CONDA_PROMPT_MODIFIER $USER $__fish_prompt_hostname (prompt_pwd) (__fish_git_prompt) | wc -c)
  if test $prompt_columns -lt $COLUMNS
    echo -n $cyan$USER$normal at $yellow$__fish_prompt_hostname$normal in $bred(prompt_pwd)$normal
    set -g __fish_git_prompt_showcolorhints true
    __fish_git_prompt
    echo
  else
    set fish_prompt_pwd_dir_length 1
    set -l prompt_columns (printf '%s%s at %s in %s%s' $CONDA_PROMPT_MODIFIER $USER $__fish_prompt_hostname (prompt_pwd) (__fish_git_prompt) | wc -c)
    if test $prompt_columns -lt $COLUMNS
      echo -n $cyan$USER$normal at $yellow$__fish_prompt_hostname$normal in $bred(prompt_pwd)$normal
      set -g __fish_git_prompt_showcolorhints true
      __fish_git_prompt
      echo
    else
      set -l prompt_columns (printf '%s%s%s' $CONDA_PROMPT_MODIFIER (prompt_pwd) (__fish_git_prompt) | wc -c)
      if test $prompt_columns -lt $COLUMNS
        echo -n $bred(prompt_pwd)$normal
        set -g __fish_git_prompt_showcolorhints true
        __fish_git_prompt
        echo
      end
    end
  end

  # Bottom
  if test "$fish_key_bindings" = "fish_vi_key_bindings"
    or test "$fish_key_bindings" = "fish_hybrid_key_bindings"
    switch $fish_bind_mode
      case default
        set_color --bold red
        echo -n '[N]'
      case insert
        set_color --bold green
        echo -n '[I]'
      case replace_one
        set_color --bold green
        echo -n '[R]'
      case visual
        set_color --bold brmagenta
        echo -n '[V]'
    end
      set_color normal
      echo -n $pcolor$__fish_prompt_char $normal
  else
    echo -n $pcolor$__fish_prompt_char $normal
  end
end
