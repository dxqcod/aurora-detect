#!/bin/bash
# сообщаем, что собираемся использовать оболочку bash

# задаём в цикле сколько фото хотим получить – 1000000 (переменная i) 
# переменная "k" добавляет номер к фото от 1 до 5
# bright – переменная яркости
k=1
bright=99
for ((i=1; i<1000000; i++))
do

    # выводим на экран "k"
    echo "k= -$k-  "

    # выводим на экран "i"
    echo "i= -$i-  "

    # делаем контрольный снимок
    raspistill -o /media/pi/Transcend/time/bright.jpg -n 

    # определяем яркость картинки (часть утилиты ImageMagick)
    br=$(identify -verbose /media/pi/Transcend/time/bright.jpg  | grep exif:BrightnessValue: | awk '{b=$2}END{printf (b)}')
    bright=$(echo $br | cut -d/ -f1)
    echo -n "  bright= $bright   "

    # формируем переменные даты и времени, пример: 2018-07-12_101219---1
    DATE=$(date +"%Y-%m-%d_%H%M%S---$k")
    TIMESREEN=$(date +"%H:%M")
    DATESREEN=$(date +"%m-%d")

    # выводим на экран имя файла
    echo -n $DATE

    # делаем снимок и сохраняем его в папку timelaps
    # если яркость меньше порога – снимаем ночью, иначе днём
    if [[ "$bright" -le 10 ]]
    then
        raspistill -ex auto -ss 2000000 -ISO 800  -o /media/pi/Transcend/time/timelaps/$DATE.jpg -n 
        echo -n "     night     "
    else
        raspistill -co 20 -sa 10 -o /media/pi/Transcend/time/timelaps/$DATE.jpg -n 
        echo -n "     day     "
        #sleep 20s
    fi

    # считываем температуру с датчика
    temp=$(cat /sys/bus/w1/devices/10-000802816d5c/w1_slave | sed -n 's/^.*\(t=[^ ]*\).*/\1/p' | sed 's/t=//' | awk '{x=$1}END{printf ("%.1f", (x/1000))}')

    # добавляем watermark и подписи
    convert -composite /media/pi/Transcend/time/timelaps/$DATE.jpg \
        /media/pi/Transcend/time/5.png  -geometry +3100+10 \
        -fill white \
        -font Helvetica-Bold -pointsize 40 \
        -annotate +3030+2350 "time - " \
        -annotate +3150+2350 "$TIMESREEN" \
        -annotate +3030+2400 "date - " \
        -annotate +3150+2400 "$DATESREEN" \
        -annotate +3030+2300 "temp=" \
        -annotate +3150+2300 "$temp" \
        /media/pi/Transcend/time/timelaps/$DATE.jpg

    # создаём маркерные файлы для скрипта color.sh
    echo "$DATE"  > /media/pi/Transcend/time/color_detect/foto_ready.txt
    echo "$bright" > /media/pi/Transcend/time/color_detect/foto_bright.txt

    # цикл увеличения переменной "k" от 1 до 5
    # чтобы имя для timelaps повторялось каждые 5 кадров
    if [[ "$k" -ge 5 ]]
    then 
        k=0
    fi
    echo " -ok"
    k=$((k+1))

    # пауза 30 секунд между кадрами
    #sleep 30s
done
