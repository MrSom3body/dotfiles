function ls --wraps='eza -g --group-directories-first' --description 'alias ls=eza -g --group-directories-first'
  eza -g --group-directories-first $argv
        
end
