#!/bin/fish

brightnessctl --save
set b (math floor\((brightnessctl get) / 255 x 100\))
for i in (seq 100)
    sleep 0.1
    brightnessctl set 1%-
end
