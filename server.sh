#!/bin/bash
PORT="4242"
listen(){
MSG=`nc -l $PORT`
}

echo "Servidor HMTP" 

echo "(0) LEVANTANDO EL SERVIDOR"

SERVER_IP=`ip a | grep inet | grep enp0s3 | sed "s/^ *//g" | cut -d " " -f 2 |  cut -d "/" -f 1`

echo "LA IP DEL SERVIDOR ES $SERVER_IP"

listen
SALUDO=`echo $MSG | cut -d " " -f 1`
IP_CLIENTE=`echo $MSG | cut -d " " -f 2`
MD5_CLIENTE=`echo $MSG | cut -d " " -f 3`
MD5_IP=`echo $IP_CLIENTE | md5sum | cut -d " " -f 1`

echo "(3) ENVIANDO CONFIRMACION"
if [ "$MD5_IP" != "$MD5_CLIENTE" ]
then
echo "ERROR 1: IP MALA" 
exit 1
fi

if [ "$SALUDO" != "GREEN_POWA" ]
then
	echo "KO_HMTP" | nc $IP_CLIENTE $PORT
	exit 1
fi

echo "OK_HMTP" | nc $IP_CLIENTE $PORT

echo "(4) ESCUCHANDO"

listen

NUM_FILES=`echo $MSG | cut -d " " -f 2`
PREFIX=`echo $MSG | cut -d " " -f 1`

if [ "$PREFIX" != "NUM_FILES" ]
then
echo "KO_NUM_FILES" | nc $IP_CLIENTE $PORT
exit 2
fi
echo "OK_NUM_FILES" | nc $IP_CLIENTE $PORT
echo ""

echo "(7) ENVIANDO CONFIRMACION DE CONTEO"

for ((i=0; i<=$NUM_FILES-1; i++))
do
echo "(8) ESCUCHANDO"

listen

PREFIX=`echo $MSG | cut -d " " -f 1`
FILE_NAME=`echo $MSG | cut -d " " -f 2`
FILE_MD5=`echo $MSG | cut -d " " -f 3`

echo "(11) ENVIANDO CONFIRMACION"
if [ "$PREFIX" != "FILE_NAME" ]
then
	echo "KO_FILENAME" | nc $IP_CLIENTE $PORT
	exit 3
fi


MD5SUM=`echo $FILE_NAME | md5sum | cut -d " " -f 1`

if [ "$MD5SUM" != "$FILE_MD5" ]
then
	echo "KO_FILE_MD5" | nc $IP_CLIENTE $PORT
	exit 4
fi

echo "OK_FILENAME" | nc $IP_CLIENTE $PORT

echo "(12) ESCUCHAMOS ARCHIVO"

nc -l $PORT > inbox/$FILE_NAME

DATA_MD5=`cat inbox/$FILE_NAME | md5sum | cut -d " " -f 1`
echo "(15) ENVIAR CONFIRMCION" 

echo "OK_DATA_RCPT" | nc $IP_CLIENTE $PORT

echo "(16) ESCUCHANDO CONFIRMACION DE ARCHIVO"

listen

if [ "$MSG" != "$DATA_MD5" ]
then
	echo "KO_DATA_MD5" | nc $IP_CLIENTE $PORT
	exit 5
fi
echo "OK_DATA_MD5" | nc $IP_CLIENTE $PORT
echo " "
done

		COUNT=`ls inbox/ | wc -l`

if [ "$COUNT" != "$FILE_COUNT" ]
then
echo "DATOS PERDIDOS, SE HAN RECIBIDO UN TOTAL DE $COUNT ARCHIVOS"
exit 6
fi

echo "DATOS RECIBIDOS CORRECTAMENTE"

echo "FIN DE LA RECEPCION"

exit 0
