CC=gcc
CFLAGS=-std=c11
as-flavor=intel
name=prog

${name}-c:
	$(CC) ${CFLAGS} $(name).c -o $(name)-c

${name}-mod:
	${CC} -c ${name}-mod.S -o ${name}-mod.o
	${CC} ${name}-mod.o -o ${name}-mod

${name}-orig:
	${CC} -c ${name}-orig.S -o ${name}-orig.o
	${CC} ${name}-orig.o -o ${name}-orig

all: ${name}-c ${name}-mod ${name}-orig
.PHONY : ${name}-c ${name}-mod ${name}-orig clean all
.DEFAULT_GOAL := all

clean:
	rm -f *.o
	rm -f $(name)-c
	rm -f $(name)-mod
	rm -f ${name}-orig