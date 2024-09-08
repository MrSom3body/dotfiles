#!/bin/fish

if not test -z $argv
  switch $(string split -f2 " " $argv)
    case "Lock"
      hyprlock
    case "Suspend"
      systemctl suspend
    case "Reboot"
      systemctl reboot
    case "Poweroff"
      systemctl poweroff
  end
  exit 0
end

echo " Lock"
echo " Suspend"
echo " Reboot"
echo " Poweroff"
