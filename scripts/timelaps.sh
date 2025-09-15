#!/bin/bash
# ��������, ��� ���������� ������������ �������� bash

#������ � ����� ������� ���� ����� �������� -10000 (���������� i) 
#���������� "�" �������� ����� � ���� �� 1 �� 5
#br ���������� ������
k=1
bright=99
for ((i=1; i<1000000; i++))
do

#������� �� ����� "�"
echo "k= -$k-  "

#������� �� ����� "i"
echo "i= -$i-  "



#������ ���������� ������
raspistill -o /media/pi/Transcend/time/bright.jpg -n 

# opredelyaem yrkost kartinki (chast utility imagemagick)
br=$(identify -verbose /media/pi/Transcend/time/bright.jpg  | grep exif:BrightnessValue: | awk '{b=$2}END{printf (b)}')
bright=$(echo $br | cut -d/ -f1)
echo -n "  bright= $bright   "

# ��������� �������� ���� � ������� 2018-07-12_101219- - -1
DATE=$(date +"%Y-%m-%d_%H%M%S---$k")
TIMESREEN=$(date +"%H:%M")
DATESREEN=$(date +"%m-%d")

# ������� �� ����� �������� ����
echo -n $DATE


# ������ ������ � ��������� ��� � ����� timelaps
# ���� ������ ������ �� �������� �����, ���� ������� �� ����
if [[ "$bright" -le 10 ]]
then
raspistill -ex auto -ss 2000000 -ISO 800  -o /media/pi/Transcend/time/timelaps/$DATE.jpg -n #--annotate  $DATESREEN -ae +35+35  -ex auto -ss 2900000 
echo -n "     night     "

else
raspistill -co 20 -sa 10 -o /media/pi/Transcend/time/timelaps/$DATE.jpg -n 
echo -n "     day     "

#sleep 20s
fi


#schityvaem temperaturu s datchika
temp=$(cat /sys/bus/w1/devices/10-000802816d5c/w1_slave | sed -n 's/^.*\(t=[^ ]*\).*/\1/p' | sed 's/t=//' | awk '{x=$1}END{printf ("%.1f", (x/1000))}')





#echo ������������ ����
#echo -n $DATE
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
# ������� ��������� ���� ��� ������� color.sh
echo "$DATE"  > /media/pi/Transcend/time/color_detect/foto_ready.txt
echo "$bright" > /media/pi/Transcend/time/color_detect/foto_bright.txt

# ������ ���� ��� ����� ���������� "�" �� 1 �� 5
# ��� ����� ��� timelaps � ������ ���������
if [[ "$k" -ge 5 ]]
then 
k=0
fi
echo " -ok"
k=$((k+1))

# ����� 30 ������
#sleep 30s
done