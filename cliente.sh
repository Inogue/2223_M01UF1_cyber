#!/bin/bash

IP_SERVER="localhost"
IP_LOCAL="127.0.0.1"
PORT="4242"
MD5_IP=`echo $IP_LOCAL | md5sum | cut -d " " -f 1`

echo "Cliente HMTP"

echo "(1) ENVIANDO EL SALUDO"

echo "GREEN_POWA $IP_LOCAL $MD5_IP" | nc $IP_SERVER $PORT 

echo "(2) RECIBIENDO CONFIRMACION"
MSG=`nc -l $PORT`

if [ "$MSG" != "OK_HMTP" ]
then 
	echo "ERROR 1:SALUDO MAL HECHO"
exit 1
fi

FILE_NAME="ElonMusk.jpg"
echo "(5) ENVIANDO MENSAJE"
FILE_MD5=`echo $FILE_NAME | md5sum | cut -d " " -f 1`

echo "FILE_NAME $FILE_NAME $FILE_MD5" | nc $IP_SERVER $PORT

echo "(6) ESCUCHANDO"

MSG=`nc -l $PORT`
if [ "$MSG" != "OK_FILENAME" ]
then
	echo "ERROR 2: EL NOMBRE DEL ARCHIVO ES ERRONEO"
	echo "Mensaje de error: $MSG"
exit 2
fi

echo "(9) ENVIAMOS DATOS"

cat meme/$FILE_NAME | nc $IP_SERVER $PORT

DATA_MD5=`cat meme/$FILE_NAME | md5sum | cut -d " " -f 1`

echo "(10) ESCUCHAMOS RESPUESTA" 

MSG=`nc -l $PORT`

if [ "$MSG" != "OK_DATA_RCPT" ]
then
	echo "ERROR 3: DATOS INCORRECTOS"
	exit 3
fi

echo "(13) ENVIAMOS CONFIRMACION DE ARCHIVO"

echo $DATA_MD5 | nc $IP_SERVER $PORT

echo "(14) RECIBIMOS CONFIRMACION"

MSG=`nc -l $PORT`

if [ "$MSG" != "OK_DATA_MD5" ]
then
	echo "ERROR 4: DATOS FALSOS"
	echo "MENSAJE DE ERROR: $MSG"
 	exit 4
fi

echo "DATOS ENVIADOS CORRECTAMENTE"

echo "FIN DEL ENVIO"
exit 0
