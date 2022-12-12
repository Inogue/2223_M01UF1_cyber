#!/bin/bash
listen(){
MSG=`nc -l $PORT`
}

if [ "$1" == "-h" ]
then
SCRIPT=`basename $0`
echo "Ejemplo de uso"
echo "$SCRIPT 127.0.0.1"

exit 0
fi

IP_SERVER="localhost"
IP_LOCAL=`ip a | grep inet | grep enp0s3 | sed "s/^ *//g" | cut -d " " -f 2 | cut -d "/" -f 1`
PORT="4242"
MD5_IP=`echo $IP_LOCAL | md5sum | cut -d " " -f 1`


if [ "$1" != "" ]
then 
IP_SERVER=$1
echo $IP_SERVER
fi

echo "Cliente HMTP"

echo "(1) ENVIANDO EL SALUDO"

echo "GREEN_POWA $IP_LOCAL $MD5_IP" | nc $IP_SERVER $PORT 

echo "(2) RECIBIENDO CONFIRMACION"

listen

if [ "$MSG" != "OK_HMTP" ]
then 
	echo "ERROR 1:SALUDO MAL HECHO"
exit 1
fi

echo "(5) CONTANDO Y ENVIANDO CONTEO"
NUM_FILES=`ls meme/ | wc -l`
echo "NUM_FILES $NUM_FILES" | nc $IP_SERVER $PORT

echo "(6) ESCUCHANDO CONFIRMACION DE CONTEO"

listen

if [ "$MSG" != "OK_NUM_FILES" ]
then 
echo "ERROR 2: NUMERO ERRONEO"
exit 2
fi


echo " "
for ((i=0; i<=$NUM_FILES-1; i++))
do
FILE_NAME="ElonMusk$i.jpg"
echo "(9) ENVIANDO MENSAJE"
FILE_MD5=`echo $FILE_NAME | md5sum | cut -d " " -f 1`

echo "FILE_NAME $FILE_NAME $FILE_MD5" | nc $IP_SERVER $PORT

echo "(10) ESCUCHANDO"

listen
if [ "$MSG" != "OK_FILENAME" ]
then
	echo "ERROR 3: EL NOMBRE DEL ARCHIVO ES ERRONEO"
	echo "Mensaje de error: $MSG"
exit 3
fi

echo "(13) ENVIAMOS DATOS"

cat meme/$FILE_NAME | nc $IP_SERVER $PORT

DATA_MD5=`cat meme/$FILE_NAME | md5sum | cut -d " " -f 1`

echo "(14) ESCUCHAMOS RESPUESTA" 

listen

if [ "$MSG" != "OK_DATA_RCPT" ]
then
	echo "ERROR 4: DATOS INCORRECTOS"
	exit 4
fi

echo "(17) ENVIAMOS CONFIRMACION DE ARCHIVO"

echo $DATA_MD5 | nc $IP_SERVER $PORT

echo "(18) RECIBIMOS CONFIRMACION"

listen

if [ "$MSG" != "OK_DATA_MD5" ]
then
	echo "ERROR 5: DATOS FALSOS"
	echo "MENSAJE DE ERROR: $MSG"
 	exit 5
fi
echo " "
done

echo "DATOS ENVIADOS CORRECTAMENTE"

echo "FIN DEL ENVIO"
exit 0
