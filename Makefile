all: ptors setbr

ptors:
	cc -o ptors ptors.c

setbr:
	cc -o setbr setbr.c

clean:
	rm -f setbr ptors

