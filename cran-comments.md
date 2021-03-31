## Test Environments
* local OSX 10.15.7 R 4.0.2 64 Bit
* ubuntu 18.04 (on github-actions), R 3.3, 3.4, 3.5, oldrel, release, devel
* windows latest (on github), R 4.0, release
* windows server (devel and release, on rhub)
* windows server (oldrel, on rhub)
* solaris-x86-patched-ods (on rhub)


## Problem from previous submission
The package was removed from CRAN as there were problems on the i386 solaris
and windows oldrel build. 
The algorithm I use, uses bit testing to determine rotation.
For reasons I don't understand the c++ compiler on these systems treats these 
differently.
The consequence is that my test-cases fail, but the results are fine, 
they are just mirrored. 

