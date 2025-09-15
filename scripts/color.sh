#!/bin/bash
# сообщаем, что собираемся использовать оболочку bash

# обрезаем, целевые цвета делаем чёрными, остальные — белыми
#convert /home/pi/IMG_1631.JPG -gravity North -fuzz 7% -fill black -opaque "#416742" -opaque "#29452f" -opaque "#305241" -threshold 0% black+whight31.jpg   #-crop 3200x1500+0

# определяем состав цветов, вычисляем процент
#convert /home/pi/black+whight31.jpg -format %c histogram:info: > /home/pi/color31.txt
chern=$(cat /home/pi/color31.txt | grep 000000 | cut -d: -f1)
belyi=$(cat /home/pi/color31.txt | grep FFFFFF | cut -d: -f1)
procent=$((($chern * 100) / ($chern + $belyi)))
echo "31 Uroven - $procent %"
if [[ "$procent" -ge 1 ]]
then
  echo " detect! "
fi

