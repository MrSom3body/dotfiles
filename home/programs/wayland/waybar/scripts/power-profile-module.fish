#!/usr/bin/env fish

set power_profile (powerprofilesctl get)

if test "$argv[1]" = switch
    switch $power_profile
        case power-saver
            powerprofilesctl set balanced
        case balanced
            powerprofilesctl set performance
        case performance
            powerprofilesctl set power-saver
    end
else
    switch "$power_profile"
        case power-saver
            echo "{\"text\": \"\", \"alt\": \"\", \"tooltip\": \"Power Saver\", \"class\": \"power-saver\", \"percentage\": 0}"
        case balanced
            echo "{\"text\": \"\", \"alt\": \"\", \"tooltip\": \"Balanced\", \"class\": \"balanced\", \"percentage\": 50}"
        case performance
            echo "{\"text\": \"\", \"alt\": \"\", \"tooltip\": \"Performance\", \"class\": \"performance\", \"percentage\": 100}"
    end
end
