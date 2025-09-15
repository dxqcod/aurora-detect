#!/bin/bash
# Удаляем старые маркеры
find /media/pi/Transcend/time/ -name "marker*" -delete 

# Переходим в папку с кадрами
cd /media/pi/Transcend/time/timelaps

# Номер видео по месячно-дневному шаблону (mm-dd)
numvid=$(date +"%m-%d")

# Маркер времени для имени маркер-файла
marker_file=$(date +"%Y-%m-%d_%H%M%S")

# Собираем список всех JPG в файле stills.txt (используется mencoder)
ls /media/pi/Transcend/time/timelaps/*.jpg > /media/pi/Transcend/time/timelaps/stills.txt

# Кодируем видео из списка кадров, затем перемещаем результат в time_video,
# затем удаляем все JPG в текущей директории и создаём маркер окончания.
# ВНИМАНИЕ: команда выполняется в одной цепочке с && — при ошибке последующие части не выполнятся.
mencoder -nosound -ovc lavc -lavcopts vcodec=mpeg4:aspect=4/3:vbitrate=16000 -vf scale=1296:972 -o timelaps$numvid.avi -mf type=jpeg:fps=20 mf://@stills.txt && mv /media/pi/Transcend/time/timelaps/timelaps$numvid.avi /media/pi/Transcend/time/time_video/timelaps$numvid.avi && rm *.jpg && touch /media/pi/Transcend/time/marker_file_$marker_file

