## Test Environments
* local OSX 10.15.7 R 4.0.2 64 Bit
* ubuntu 18.04 (on github-actions), R 3.3, 3.4, 3.5, oldrel, release, devel
* windows latest (on github), R 4.0, release
* windows server (devel and release, on rhub)
* solaris-x86-patched-ods (on rhub)

## Problems from last submission
There was an error on i386-pc-solaris2.10 (32-bit) from calling a C function.

> call of overloaded ‘log(int&)’ is ambiguous

I changed all calls to log(...) to log((long)...) to ensure the long version
of log is called.
