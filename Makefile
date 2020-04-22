SHELL=/bin/bash
default: check

LD_LIBRARY_PATH=/usr/local/lib64
CFLAGS=-g -Wall -Wextra -Wpedantic -pipe
LDFLAGS=-L/usr/local/lib64
LDADD=-lpmem -lm -lpthread -ldl
CC=gcc

FULL_COPY_C=../pmdk/src/examples/libpmem/full_copy.c

# $@ : target label
# $< : the first prerequisite after the colon
# $^ : all of the prerequisite files
# $* : wildcard matched part

full-copy: $(FULL_COPY_C)
	$(CC) $(CFLAGS) $(LD_FLAGS) -o ./$@ $< $(LDADD)
	ls -l ./$@

check-full-copy: full-copy
	rm -f ./foo.txt ./bar.txt
	echo "YAY!" > ./foo.txt
	LD_LIBRARY_PATH='$(LD_LIBRARY_PATH)' ./full-copy ./foo.txt ./bar.txt
	diff -u ./foo.txt ./bar.txt

clean-full-copy:
	rm -fv ./full-copy ./foo.txt ./bar.txt

check: check-full-copy

clean: clean-full-copy
	rm -fv *.o *~

spotless:
	git clean -dffx
	git submodule foreach --recursive git clean -dffx
