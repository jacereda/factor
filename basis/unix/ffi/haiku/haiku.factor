USING: alien.c-types alien.syntax classes.struct unix.types unix.ffi.bsd ;
IN: unix.ffi

CONSTANT: AF_INET 2
ALIAS: PF_INET AF_INET
CONSTANT: AF_INET6 28
ALIAS: PF_INET6 AF_INET6

CONSTANT: FD_SETSIZE 1024

STRUCT: sockaddr
    { sa_len uchar }
    { sa_family __uint8_t }
    { sa_data char[30] } ;

STRUCT: addrinfo
    { flags int }
    { family int }
    { socktype int }
    { protocol int }
    { addrlen socklen_t }
    { canonname c-string }
    { addr void* }
    { next addrinfo* } ;

STRUCT: dirent
    { d_dev dev_t }
	{ d_pdev dev_t }
	{ d_ino ino_t }
	{ d_pino ino_t }
    { d_reclen __uint16_t }
    { d_name char[256] } ;

CONSTANT: SOL_SOCKET -1
CONSTANT: SO_DEBUG 0x4
CONSTANT: SO_ACCEPTCONN 0x1
CONSTANT: SO_REUSEADDR 0x40
CONSTANT: SO_KEEPALIVE 0x10
CONSTANT: SO_DONTROUTE 0x8
CONSTANT: SO_BROADCAST 0x2
CONSTANT: SO_OOBINLINE 0x20
CONSTANT: SO_SNDBUF 0x40000001
CONSTANT: SO_RCVBUF 0x40000004
CONSTANT: SO_SNDLOWAT 0x40000002
CONSTANT: SO_RCVLOWAT 0x40000005
CONSTANT: SO_SNDTIMEO 0x40000003
CONSTANT: SO_RCVTIMEO 0x40000006
CONSTANT: SO_ERROR 0x40000007
CONSTANT: SO_TYPE 0x40000008
