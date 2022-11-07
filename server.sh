#!/bin/bash
echo "Servidor HMTP" 

echo "(0) LEVANTANDO EL SERVIDOR"
MSG=`nc -l 4242`

SALUDO=`echo $MSG | cut -d " " -f 1`
IP_CLIENTE=`echo $MSG | cut -d " " -f 2`
echo "(3) ENVIANDO CONFIRMACION"
if [ "$SALUDO" != "GREEN_POWA" ]
then
	echo "KO_HMTP" | nc $IP_CLIENTE 4242
	exit 1
fi
	echo "OK_HTMP" | nc $IP_CLIENTE 4242
	echo "(4) ESCUCHANDO"
	nc -l 4242

	exit 0
