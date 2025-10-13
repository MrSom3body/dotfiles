function highscore -d "See your most used fish commands"
    set options h/help
    set options $options c/count=
    set options $options s/subcommand=
    argparse $options -- $argv
    or return

    if set -ql _flag_help
        echo "highscore - see your most used fish commands"
        echo
        echo "usage:"
        echo "  $(status current-command) [flags]"
        echo
        echo "flags:"
        echo "  -h, --help        display this help message"
        echo "  -c, --count       the total count of commands to show (default: 10)"
        echo "  -s, --subcommand  get the count of a commands subcommands"
        return 0
    end

    set count 10
    if set -ql _flag_count
        set count $_flag_count
    end

    set field 1
    if set -ql _flag_subcommand
        set field 2
        set subcommand "$_flag_subcommand "
    end

    history | string match "$subcommand*" | cut -d ' ' -f $field | sort | uniq -c | sort -nr | head -n $count
end
