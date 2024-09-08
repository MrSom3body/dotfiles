function x -d "Extract (almost) every type of archive"
    for file in $argv
        if test -f $file
            switch $file
                case "*.tar.bz2"
                    tar xjf $file
                case "*.tar.gz"
                    tar xzf $file
                case "*.bz2"
                    bunzip2 $file
                case "*.rar"
                    unrar x $file
                case "*.gz"
                    gunzip $file
                case "*.tar"
                    tar xf $file
                case "*.tbz2"
                    tar xjf $file
                case "*.tgz"
                    tar xzf $file
                case "*.zip"
                    unzip $file
                case "*.Z"
                    uncompress $file
                case "*.7z"
                    7z x $file
                case "*"
                    echo "x: failed to extract $file: no extractor implemented"
            end
        else
            echo "x: $file is not a file"
            return 1
        end
    end
end
