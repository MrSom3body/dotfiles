function dots --wraps='git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME' --description 'alias dots=git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
    git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME $argv

end
