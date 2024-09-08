function repeat -d "Repeat a command certain amount of times"
    argparse -s h/help "t/times=?" i/infinity -- $argv

    if set -ql _flag_help
        or not test -n "$argv"
        echo "repeat - repeats a command multiple times"
        echo
        echo "usage:"
        echo "  repeat [-h|--help] [-t|--times=TIMES] [-i|--infinity] <command>"
        echo
        echo "options:"
        echo "  -t, --times=TIMES         the number of times the command should be repeated (default 3)"
        echo "  -i, --infinity            repeat a command indefinitely, if both -t and -i are passed the -i will be used"
        return 0
    end

    if test -n "$_flag_infinity"
        set times -1
    else if test -n "$_flag_times"
        set times $_flag_times
    else
        set times 3
    end

    while test $times -ne 0
        $argv
        set times (math $times-1)
    end
end
