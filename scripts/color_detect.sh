#!/bin/bash
# сообщаем, что собираемся использовать оболочку bash

while true
do

    # проверяем, готов ли файл с фото
    if test -f /media/pi/Transcend/time/color_detect/foto_ready.txt
    then
        number_foto=$(cat /media/pi/Transcend/time/color_detect/foto_ready.txt)

        echo " $number_foto "
        # обрезаем изображение, целевые цвета делаем чёрными, остальные — белыми
        convert /media/pi/Transcend/time/timelaps/$number_foto.jpg -crop 3200x1500+0 -gravity North -fuzz 7% -fill black -opaque "#416742" -opaque "#29452f" -opaque "#305241" -threshold 0% /media/pi/Transcend/time/color_detect/black+whight.jpg   
        convert /media/pi/Transcend/time/timelaps/$number_foto.jpg -crop 3200x1500+0 -gravity North -fuzz 10% -fill black -opaque "#444444" -opaque "#40373a" -threshold 0% /media/pi/Transcend/time/color_detect/black+whight_rad.jpg

        # определяем состав цветов, вычисляем процент
        convert /media/pi/Transcend/time/color_detect/black+whight.jpg -format %c histogram:info: > /media/pi/Transcend/time/color_detect/histogramm.txt
        convert /media/pi/Transcend/time/color_detect/black+whight_rad.jpg -format %c histogram:info: > /media/pi/Transcend/time/color_detect/histogramm_rad.txt

        chern=$(cat /media/pi/Transcend/time/color_detect/histogramm.txt | grep 000000 | cut -d: -f1)
        chern_rad=$(cat /media/pi/Transcend/time/color_detect/histogramm_rad.txt | grep 000000 | cut -d: -f1)


        # если чёрного цвета нет, присвоим переменной chern значение 1, чтобы не было ошибок при вычислении процентов
        if [ -z "$chern" ]
        then chern=1 
        fi
        echo " chern= " $chern

        if [ -z "$chern_rad" ]
        then chern_rad=1 
        fi
        echo " chern_rad= " $chern_rad

        belyi=$(cat /media/pi/Transcend/time/color_detect/histogramm.txt | grep FFFFFF | cut -d: -f1)
        belyi_rad=$(cat /media/pi/Transcend/time/color_detect/histogramm_rad.txt | grep FFFFFF | cut -d: -f1)
        echo " belyi= " $belyi
        echo " belyi_rad= " $belyi_rad

        procent=$((($chern * 100) / ($chern + $belyi)))
        echo "Uroven - $procent %"

        procent_rad=$((($chern_rad * 100) / ($chern_rad + $belyi_rad)))
        echo "Uroven rad - $procent_rad %"

        bright=$(cat /media/pi/Transcend/time/color_detect/foto_bright.txt)
        echo " bright= " $bright

        rm /media/pi/Transcend/time/color_detect/foto_ready.txt

        if [[ "$procent" -ge 1 ]]
        then
            if [[ "$procent_rad" -le 1 ]]
            then
                if [[ "$bright" -le 100 ]]
                then
                    echo " detect! "
                    echo "$number_foto.jpg    Uroven - $procent % " >> /media/pi/Transcend/time/color_detect/detect.txt
                    echo " chern= " $chern >> /media/pi/Transcend/time/color_detect/detect.txt
                    echo " chern_rad= " $chern_rad >> /media/pi/Transcend/time/color_detect/detect.txt
                    echo " belyi= " $belyi >> /media/pi/Transcend/time/color_detect/detect.txt
                    echo " belyi_rad= " $belyi_rad >> /media/pi/Transcend/time/color_detect/detect.txt
                    echo " bright= " $bright >> /media/pi/Transcend/time/color_detect/detect.txt
                    cp /media/pi/Transcend/time/timelaps/$number_foto.jpg /media/pi/Transcend/time/color_detect/$number_foto.jpg
                fi
            fi
        fi

    else
        echo "foto not ready"
    fi

    sleep 5

done

