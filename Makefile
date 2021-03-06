CFLAGS ?= -g -O2 -fomit-frame-pointer -Wformat -pedantic
CFLAGS += --std=c99

PRLL_VERSION ?= 0.9999

CONFIGS = $(addprefix config_, keytype mallopt semun random)
PROGS = prll_qer prll_bfr

.PHONY: clean compile test version prll.1

compile: $(PROGS)

clean:
	rm -f $(PROGS) $(addsuffix .o, $(PROGS) mkrandom)
	rm -f config.h $(CONFIGS) $(addsuffix .log, $(CONFIGS))
	$(MAKE) -C tests clean

test: prll_qer prll_bfr
	$(MAKE) -C tests

mkrandom.o: mkrandom.h | config.h

prll_bfr.o prll_qer.o: mkrandom.h abrterr.h | config.h

prll_bfr prll_qer: mkrandom.o

prll.1: prll.txt
	LC_TIME=C txt2man -P prll -t prll -r prll-$(PRLL_VERSION) -s 1 \
	< prll.txt > prll.1

version: prll.1
	sed -i -e s/__PRLL_VERSION__/$(PRLL_VERSION)/ README prll.sh

config.h: $(addsuffix .c, $(CONFIGS))
	@echo
	@echo "--==CONFIGURING==--"
	@echo "// Automatically generated configuration for prll." > $@
	@$(foreach cfger,$^,\
	$(MAKE) $(cfger:.c=) 2>$(cfger:.c=.log) && ./$(cfger:.c=) >> $@ \
	|| true; )
	@echo "--==DONE CONFIGURING==--"
	@echo

# For emacs' flymake-mode
.PHONY: check-syntax
check-syntax:
	gcc --std=c99 -Wall -Wextra -Wundef -Wshadow -Wunsafe-loop-optimizations -Wsign-compare -fsyntax-only ${CHK_SOURCES}
