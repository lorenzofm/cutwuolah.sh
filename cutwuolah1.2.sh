#!/bin/bash

# cutwuolah.sh Versión 1.2 29-01-2024 
# Lorenzo Fernández Megías ©
# Reportar fallos y sugerencias a este e-mail:
# lorenzo.f.m@um.es

#///////////////////////////////////////////////////////////////
#////////////////////// MODO DE USO ////////////////////////////
#///////////////////////////////////////////////////////////////
# Cambia el nombre de los ficheros que empiecen por
# "wuolah-free-nombre" por "nombre" en los directorios
# indicados como parámetros, si no, en el directorio actual. 
#///////////////////////////////////////////////////////////////

#///////////////////////////////////////////////////////////////
#////////////////////// ADVERTENCIA ////////////////////////////
#///////////////////////////////////////////////////////////////
# Si en un directorio existe un fichero con un nombre idéntico
# al de otro fichero después de recortarle 'wuolah-free-'. El
# PRIMERO sería MACHACADO con el contenido del SEGUNDO. 
# Para estos casos se pide al usuario que decida.
#///////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////

verbose=0

while getopts "v" opt; do
  case ${opt} in
    v)
      verbose=1
      ;;
    \?)
      echo "ERROR. Opciones disponibles: -v (Modo verboso)" >&2
      exit 1
      ;;
  esac
done
shift $((OPTIND -1))	# "getopts" incrementa OPTIND (var. de bash) por cada argumento procesado
			# "shift" elimina el número de argumentos indicado como parámetro "$((OPTIND -1))".

for d in $@	# Para cada directorio de los parámetros
do
	if test ! -d $d
	then
		echo "El parametro ’$d’ debe ser el nombre de un directorio" >&2
		echo "USO: $0 <directorio>..." >&2
		exit 2
	fi

	if test ! -w $d
	then
		echo "El directorio ’$d’ debe tener permiso de escritura" >&2
		echo "USO: $0 <directorio>..." >&2
		exit 3
	fi
	
	if test ! -x $d
	then
		echo "El directorio ’$d’ debe tener permiso de ejecución" >&2
		echo "USO: $0 <directorio>..." >&2
		exit 4
	fi
done

if test $# -lt 1	# Sin parámetros
then
	nombreAntiguo=$(find . -type f -iname "wuolah-free-*" -printf "%p\n")
	for fichero in $nombreAntiguo
	do
		nombreNuevo=$(find . -type f -wholename "$fichero" -printf "%f\n" | cut -f 3- -d'-')
		ruta=$(find . -type f -wholename "$fichero" -printf "%h\n")
		nombreRutaFinal="$ruta/$nombreNuevo"
		
		if test -e $nombreRutaFinal	# Si ya hay un fichero con ese nombre
		then 
			echo "ADVERTENCIA: '$nombreRutaFinal' ya existe."
			read -p "Desea sobrescribir su contenido (S, N): " machacar	
			
			if test S = $machacar
			then
				[ $verbose -eq 1 ] && echo "Cambiando '$fichero' por '$nombreNuevo'"
				mv $fichero $nombreRutaFinal
			else
				echo "El fichero '$nombreRutaFinal', NO ha sido sobrescrito."
			fi
		else
			[ $verbose -eq 1 ] && echo "Cambiando '$fichero' por '$nombreNuevo'"
			mv $fichero $nombreRutaFinal
		fi
	done
else
	for directorio in $@
	do
		nombreAntiguo=$(find $directorio -type f -iname "wuolah-free-*" -printf "%p\n")
		for fichero in $nombreAntiguo
		do
			nombreNuevo=$(find $directorio -type f -wholename "$fichero" -printf "%f\n" | cut -f 3- -d'-')
			ruta=$(find $directorio -type f -wholename "$fichero" -printf "%h\n")
			nombreRutaFinal="$ruta/$nombreNuevo"
			if test -e $nombreRutaFinal	# Si ya hay un fichero con ese nombre
			then 
				echo "ADVERTENCIA: '$nombreRutaFinal' ya existe."
				read -p "Desea sobrescribir su contenido (S, N): " machacar	
				
				if test S = $machacar
				then
					[ $verbose -eq 1 ] && echo "Cambiando '$fichero' por '$nombreNuevo'"
					mv $fichero $nombreRutaFinal
				else
					echo "El fichero '$nombreRutaFinal', NO ha sido sobrescrito."
				fi
			else
				[ $verbose -eq 1 ] && echo "Cambiando '$fichero' por '$nombreNuevo'"
				mv $fichero $nombreRutaFinal
			fi
		done
	done
fi

