# prll
version __PRLL_VERSION__

`prll` (pronounced "parallel") is a utility for use with POSIX and
(mostly) compatible shells, such as `bash`, `zsh` and `dash`. It provides a
convenient interface for parallelizing the execution of a single task
over multiple data files, or actually any kind of data that you can
pass as a shell function argument. It is meant to make it simple to
fully utilize a multicore/multiprocessor machine.

Homepage: https://github.com/exzombie/prll


Contents of this file:

  1. Description
  2. Requirements
  3. Installation
  4. Licensing information


# 1 DESCRIPTION

`prll` is designed to be used not just in shell scripts, but especially
in interactive shells. To make the latter convenient, it is
implemented as a shell function. This means that it inherits the whole
environment of your current shell. Shells are not much good at
automatic job management; see
[further discussion](http://prll.sourceforge.net/shell_parallel.html).
Therefore, `prll` uses helper programs, written in C. To prevent race
conditions, System V Message Queues and Semaphores are used to signal
job completion. It also features full output buffering to prevent
mangling of data because of concurrent output.

The idea behind implementing `prll` as a shell function is that it
should have access to the current working environment: it should be
able to read variables and run shell functions. Many shell users like
having customized environments with lots of utility functions. For
such a user, `prll` will come in very handy.


# 2 REQUIREMENTS

- `sh`-like shell, such as `bash`, `zsh` or `dash`
- C compiler, such as `gcc`
- GNU `make`
- OS support for System V Message Queues and Semaphores
- device files `/dev/urandom` or `/dev/random`
- the `cat` utility
- optional tests require utilites `tr`, `grep`, `sort`, `split`, `diff` and `uname`
- optional rebuilding of the man page requires [txt2man](http://mvertes.free.fr/)

Systems tested: GNU/Linux, FreeBSD, OpenBSD, MacOS X

These requirements should be satisfied by your system by default,
excepting perhaps the compiler and its toolchain, which are not
installed by default on systems such as Ubuntu Linux. Refer to your
system's documentation on how to install missing programs. If you can
find prebuilt packages for your system (some are listed on `prll`
homepage) you need neither `make` nor the compiler.

`prll` also looks for the `/proc/cpuinfo` file. It uses it to
automatically determine the number of processors. Non-Linux systems
may lack this file or have a different syntax. Setting the number of
parallel processes manually renders the cpuinfo file unnecessary (see
usage instructions below).

Linux systems that were tested had much larger Message Queue size than
non-Linux systems. Queue size dictates the maximum number of jobs that
can be run in parallel. A rule of thumb: a BSD system can run about 20
jobs, depending on the number of existing queues, while a Linux system
can run over 500 jobs; at that point, the shell's job table becomes
saturated.


# 3 INSTALLATION

Compile the helper programs. You can use the included `Makefile`. If you
have `gcc`, you can simply run
```
make
```

On non-GNU systems, replace that with 'gmake'.
If you have `gcc` and want different compiler options, do
```
CFLAGS=whatever make
```
  
If you have a different compiler, you may want to completely override
compiler options, like so
```
make CFLAGS=whatever
```

You may wish to run `make test` at this point. It will do some simple
tests to verify that `prll` produces correct results. The test suite is
not comprehensive, however, and is itself not well tested, so you
should try `prll` on real-world data before coming to any
conclusions. Failure is not necessarily meaningful, either. For
example, if there are already several message queues being used on
your system, you may be running out of IPC memory. That would cause
some tests to fail or hang (in fact, some are disabled on non-Linux
systems for this reason), while it wouldn't interfere with normal
operation as long as you don't run too many parallel jobs. Also, be
aware that full testing requires several hundred megabytes of disk
space.

When `prll` is built, copy the `prll_qer` and `prll_bfr` executables to a
directory you have in your `PATH`. For example, to do a system-wide
installation, run as root
```
chown root:root prll_qer prll_bfr
cp prll_qer prll_bfr /usr/local/bin/
```

To have access to the documentation, copy the manpage to the
appropriate location for the man utility to find it. For example:
```
chown root:root prll.1
cp prll.1 /usr/local/share/man/man1/
```

File `prll.sh` contains the shell function. The shell that will use it
needs to source it. That means that:

- if you wish to use `prll` in a shell script, simply copy it in there;
- if you wish to use `prll` in an interactive shell, source it.

The latter means that you need to put the function somewhere where
your shell will find it. If you are installing it for yourself, put it
in your shell startup file, such as `.bashrc` or `.zshrc`. If you are
installing it system-wide, put it in `/etc/profile`. However, if your
system has the `/etc/profile.d` directory, use that. For example
```
chown root:root prll.sh
cp prll.sh /etc/profile.d/
```

The function should now be automatically sourced by login shells. To
have every shell source it instead of only login shells, insert
```
. /etc/profile
```

into your `.bashrc` or `.zshrc` or whichever startup file your shell
uses.


# 4 LICENSING INFORMATION

The `prll` package is provided under the GNU General Public
License, version 3 or later. See COPYING for more information.

Copyright 2009-2013 Jure Varlec
