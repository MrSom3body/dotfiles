function nedit -d "Edit a file actually managed by nix"
    argparse -s h/help -- $argv

    if set -ql _flag_help
        or not test -n "$argv"
        echo "nedit - edit a file actually managed by nix"
        echo
        echo "usage:"
        echo "  nedit [-h|--help] <file>"
        echo
        echo "flags:"
        echo "  -h, --help  display this help message"
        return 0
    end

    for file in $argv
        mv $file $file.nedit
        cp $file.nedit $file
        chmod u+w $file
        rm $file.nedit
        $EDITOR $file
    end
end
