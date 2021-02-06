nombreProyecto=$1
mainFileName=$nombreProyecto

#IF THERE IS JUST ONE ARGUMENT, THE MAINFILE NAME WILL THE SAME AS THE PROYECT NAME
if [ $# -ne 1 ]
  then
    mainFileName=$2
fi


#MAIN FOLDER IS CREATED
mkdir $nombreProyecto


#MAIN FILE IS CREATED
echo program $mainFileName>> $nombreProyecto/$mainFileName.f95
echo -e '\t'use precision>> $nombreProyecto/$mainFileName.f95
echo -e '\t'implicit none>> $nombreProyecto/$mainFileName.f95
echo >> $nombreProyecto/$mainFileName.f95
echo end program $mainFileName>> $nombreProyecto/$mainFileName.f95


#LOOP OVER ARGUMENTS, CREATING FILES
arguments=("$@")
nargin=${#arguments[*]} #Number of arguments
#A file with the name of each file is created
for (( i=2; i<$nargin; i++))
do
	echo >> $nombreProyecto/${arguments[i]}.f95
	echo -e '\t'use precision>> $nombreProyecto/${arguments[i]}.f95
	echo -e '\t'implicit none>> $nombreProyecto/${arguments[i]}.f95
	echo >> $nombreProyecto/${arguments[i]}.f95
	echo end  ${arguments[i]}.f95>> $nombreProyecto/${arguments[i]}.f95
done


#INPUT DATA .DAT FILE IS CREATED
echo >> $nombreProyecto/$mainFileName.dat

#PRECISION MOD .F95 FILE IS CREATED
echo module precision >> $nombreProyecto/precision.f95
echo -e '\t'implicit none>> $nombreProyecto/precision.f95
echo -e '\t'integer, parameter:: pr=8>> $nombreProyecto/precision.f95
echo end module >> $nombreProyecto/precision.f95


#MAKEFILE IS CREATED
echo '#'Fortran Makefile >> $nombreProyecto/makefile
echo CC=gfortran >> $nombreProyecto/makefile

echo OUTPUT = $mainFileName >> $nombreProyecto/makefile

echo SRCS =  '$(wildcard *.f95)' >> $nombreProyecto/makefile

echo 'OBJS = $(SRCS:.f95=.o)' >> $nombreProyecto/makefile

echo 'ejecutar: $(OUTPUT) clean txt' >> $nombreProyecto/makefile
echo -e '\t''@echo "Compilación finaliza. Comienza la ejecutación."' >> $nombreProyecto/makefile
echo -e '\t''@echo ''' >> $nombreProyecto/makefile
echo -e '\t''./$< < ./$<.dat > ./$<.txt' >> $nombreProyecto/makefile

echo '$(OUTPUT): $(OBJS)' >> $nombreProyecto/makefile
echo -e '\t''$(CC) -o $(OUTPUT) $(OBJS)' >> $nombreProyecto/makefile

echo '%.o: %.f95' >> $nombreProyecto/makefile
echo -e '\t''$(CC) -c $<' >> $nombreProyecto/makefile

echo 'cleanall: clean' >> $nombreProyecto/makefile
echo -e '\t''rm -f $(OUTPUT)' >> $nombreProyecto/makefile

echo 'clean:' >> $nombreProyecto/makefile
echo -e '\t''rm -f *.o *~' >> $nombreProyecto/makefile

echo 'txt:' >> $nombreProyecto/makefile
echo -e '\t''@echo > $(OUTPUT).txt' >> $nombreProyecto/makefile

cd $nombreProyecto