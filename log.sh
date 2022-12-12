#!/bin/bash
mapeo(){
RESULTADO=`echo $1 | grep -i keylogger | grep -i create`
if [ "$1" == "" ]
    then
	        echo "Hace falta un parametro" 
			    fi				
				if [ "$RESULTADO" != "" ]
				then 
				echo "MARTI TE PILLAMOS WEY" | cowsay
				fi

}
inotifywait -mrq -e create,delete /home/enti/Proyectis/2223_M01UF1_cyber/ . | tee -a ../loslogs.txt | while read LINEA
do

mapeo $LINEA
mapeo
done

