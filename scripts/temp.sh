#!/bin/bash

# Чтение температуры с датчика 1-wire (DS18B20)
temp=$(cat /sys/bus/w1/devices/10-000802816d5c/w1_slave | sed -n 's/^.*\(t=[^ ]*\).*/\1/p' | sed 's/t=//' | awk '{x=$1}END{printf ("%.1f", (x/1000))}')

echo "Температура на момент включения терминала: $temp"
echo " "

# Пауза 30 сек для установки сети (при необходимости)
#echo "Пауза 30 сек для установки сети"
#sleep 30

echo "Синхронизируем время"
ntpdate -q pool.ntp.org
echo " "

echo "Проверяем запуск скрипта timelaps.sh"
ps -A | grep timelaps
echo " "

# Количество фото готовых для кодирования (опционально)
#echo "Количество фото готовых для кодирования"
#find /media/pi/Transcend/time/timelaps -type f | wc -l

echo "Проверяем наличие сгенерированного видео:"
#marker_file=$(date +"%Y-%m-%d")
#if test -f /media/pi/Transcend/time/marker_file_$marker_file; then echo -e "\n-Маркерный файл в наличии\n"; fi

find /media/pi/Transcend/time/time_video -name "timelaps$numvid.avi" && echo -e "-Видео в наличии и готово к загрузке\n"

