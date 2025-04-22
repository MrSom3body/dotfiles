function chat -d "Wrapper for ollama"
    function print_help
        echo "Usage: chat [options] [prompt]"
        echo "Options:"
        echo "-h, --help             Display this help message"
        echo "-m, --model            The model to use (default: llama3.2)"
        echo "-n, --notify           Send notification with response"
        echo "-f, --from-clipboard   Use clipboard as input"
        echo "-c, --copy             Copy output to clipboard"
        echo "-s, --simple           Give a simple response"
        echo "-v, --verbose          Run ollama with verbose mode"
    end

    set options h/help
    set options $options m/model=
    set options $options n/notify
    set options $options f/from-clipboard
    set options $options c/copy
    set options $options s/simple
    argparse -s -x copy,notify $options -- $argv
    or return

    if set -ql _flag_h
        print_help
        return
    end

    set pre_prompt "The input will start with \"Prompt:\" followed by a prompt, and there may be a \"Text:\" section. If \"Text:\" is present, use it to guide your response, treating it as more reliable than your learned knowledge. Do not mention the existence of the \"Text:\" in your answer. Respond in the same language as the prompt. Furthermore only answer do not add \"Text:\" or \"Prompt:\"."
    set ollama_cmd ollama run --keepalive 1m

    if set -ql _flag_s
        set pre_prompt "$pre_prompt Ensure that your answer is extremely concise—short, direct, and devoid of unnecessary details. Full sentences are not required."
    end

    if set -ql _flag_v
        set ollama_cmd $ollama_cmd --verbose
    end

    if set -ql _flag_m
        set ollama_cmd $ollama_cmd $_flag_model
    else
        set ollama_cmd $ollama_cmd llama3.2:3b-instruct-q4_K_M
    end

    if set -ql _flag_f
        if test (wl-paste) != "Nothing is copied"
            set ollama_output "$($ollama_cmd "$pre_prompt Prompt: $(wl-paste)") Text: $(cat ~/.chat.txt 2> /dev/null)"
        else
            echo "Your clipboard is empty" 1>&2
            return 1
        end
    else if test -n "$argv"
        set ollama_output "$($ollama_cmd "$pre_prompt Prompt: $argv Text: $(cat ~/.chat.txt 2> /dev/null)")"
    else
        if set -ql _flag_n
            echo "You can not use -n/--notify without a prompt" 1>&2
            return 1
        end
        $ollama_cmd
        return
    end

    if set -ql _flag_n
        notify-send ollama "$ollama_output"
    else if set -ql _flag_c
        echo $ollama_output | wl-copy
    else
        echo $ollama_output | glow
    end
end
