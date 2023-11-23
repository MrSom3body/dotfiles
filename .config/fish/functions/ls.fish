function ls --wraps='exa --group-directories-first' --wraps='exa -g --group-directories-first' --wraps='eza -g --group-directories-first' --description 'alias ls=eza -g --group-directories-first'
  eza -g --group-directories-first $argv
        
end
