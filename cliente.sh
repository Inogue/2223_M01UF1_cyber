#!/bin/bash

echo "Cliente HMTP"

echo "(1) ENVIANDO EL SALUDO"
echo "GREEN_POWA 127.0.0.1" | nc localhost 4242 
echo "(2) RECIBIENDO CONFIRMACION"
nc -l 4242
if [ "$MSG" != "OK_HMTP" ]
then 
echo "ERROR 1:SALUDO MAL HECHO"
exit 1
fi
echo "SIGUE"
