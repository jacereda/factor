! Copyright (C) 2022 Jorge Acereda
! See https://factorcode.org/license.txt for BSD license.
USING: alien.c-types alien.syntax byte-arrays grouping kernel
libc math sequences splitting strings system system-info
unix.sysctl unix.users ;
IN: system-info.haiku

CONSTANT: SYS_NMLN 32
CONSTANT: utsname-items 5

FUNCTION-ALIAS: (uname)
    int uname ( c-string buf )

: uname ( -- seq )
    256 <byte-array> [ (uname) io-error ] keep >string
	"\0" split harvest dup length 6 assert= ;

: sysname ( -- string ) 0 uname nth ;
: nodename ( -- string ) 1 uname nth ;
: release ( -- string ) 2 uname nth ;
: version ( -- string ) 3 uname nth ;
: machine ( -- string ) 4 uname nth ;

M: haiku os-version release ;
M: haiku cpus 16 ; ! XXX { 6 3 } sysctl-query-uint ;
M: haiku physical-mem 1024 1024 * 6 * ; ! XXX ;{ 6 5 } sysctl-query-ulonglong ;
M: haiku computer-name nodename ;
M: haiku username real-user-name ;

M: haiku cpu-mhz
    1000
! XXX    "dev.cpu.0.freq" sysctl-name-query-uint
    1000 1000 * * ;
