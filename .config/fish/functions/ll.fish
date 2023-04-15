function ll --wraps='exa --group-directories-first -la' --description 'alias ll=exa --group-directories-first -la'
  exa --group-directories-first -la $argv
        
end
