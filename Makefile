CFLAGS ?= -g -O2 -fomit-frame-pointer -Wformat -pedantic
CFLAGS += --std=c99

.PHONY: clean compile test

compile: prll_qer prll_bfr

clean:
	rm -f prll_qer prll_bfr mkrandom.o
	rm -f $(foreach cfger, .h _keytype _mallopt, config$(cfger) \
		config$(cfger).log)
	$(MAKE) -C tests clean

test: prll_qer prll_bfr
	$(MAKE) -C tests

# For emacs' flymake-mode
.PHONY: check-syntax
check-syntax:
	gcc --std=c99 -Wall -Wextra -Wundef -Wshadow -Wunsafe-loop-optimizations -Wsign-compare -fsyntax-only ${CHK_SOURCES}

prll_bfr prll_qer: mkrandom.o mkrandom.h abrterr.h | config.h

config.h: config_keytype.c config_mallopt.c
	@echo "--==CONFIGURING==--"
	@echo "// Automatically generated configuration for prll." > $@
	@$(foreach cfger,$^,\
	$(MAKE) $(cfger:.c=) 2>$(cfger:.c=.log) && ./$(cfger:.c=) >> $@ \
	|| true; )
	@echo "--==DONE CONFIGURING==--"
