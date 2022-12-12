#!/bin/bash
if [ -f "$1" ]
then
echo El archivo $1 exite
elif [ -d "$1" ]
then
echo El archivo $1 es un directorio
fi
