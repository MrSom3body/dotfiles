function keyboard-color -d "Change the color of the keyboard backlight"
	echo $argv | sudo tee /sys/devices/platform/hp-wmi/rgb_zones/zone00 /sys/devices/platform/hp-wmi/rgb_zones/zone01 /sys/devices/platform/hp-wmi/rgb_zones/zone02 /sys/devices/platform/hp-wmi/rgb_zones/zone03
end
