USING: alien.c-types alien.syntax classes.struct unix.time
unix.types ;
IN: unix.ffi

CONSTANT: MAXPATHLEN 1024

CONSTANT: O_RDONLY   0x0000
CONSTANT: O_WRONLY   0x0001
CONSTANT: O_RDWR     0x0002
CONSTANT: O_NONBLOCK 0x0080
CONSTANT: O_EXCL     0x0100
CONSTANT: O_CREAT    0x0200
CONSTANT: O_TRUNC    0x0400
CONSTANT: O_NOCTTY   0x1000
CONSTANT: O_APPEND   0x0400

ALIAS: O_NDELAY O_NONBLOCK

CONSTANT: SOL_SOCKET -1

CONSTANT: FD_SETSIZE 1024

CONSTANT: SO_DEBUG 0x00000004
CONSTANT: SO_REUSEADDR 0x00000040
CONSTANT: SO_TYPE 0x40000008
CONSTANT: SO_ERROR 0x40000007
CONSTANT: SO_DONTROUTE 0x00000008
CONSTANT: SO_BROADCAST 0x00000002
CONSTANT: SO_SNDBUF 0x40000001
CONSTANT: SO_RCVBUF 0x40000004
CONSTANT: SO_KEEPALIVE 0x00000010
CONSTANT: SO_OOBINLINE 0x00000020
CONSTANT: SO_SNDTIMEO 0x40000003
CONSTANT: SO_RCVTIMEO 0x40000006

CONSTANT: F_SETFD 0x0004
CONSTANT: FD_CLOEXEC 1

CONSTANT: F_SETFL 0x0010

STRUCT: addrinfo
    { flags int }
    { family int }
    { socktype int }
    { protocol int }
    { addrlen socklen_t }
    { canonname c-string }
    { addr void* }
    { next addrinfo* } ;

STRUCT: sockaddr-in
    { len uint8_t }
    { family uint8_t }
    { port uint16_t }
    { addr in_addr_t }
    { zero int8_t[24] } ;

STRUCT: sockaddr-in6
    { len uint8_t }
    { family uint8_t }
    { port uint16_t }
    { flowinfo uint32_t }
    { addr uint8_t[16] }
    { spocepid uint32_t } ;

CONSTANT: max-un-path 126

STRUCT: sockaddr-un
    { len uint8_t }
    { family uint8_t }
    { path { char max-un-path } } ;

CONSTANT: SOCK_STREAM 1
CONSTANT: SOCK_DGRAM 2
CONSTANT: SOCK_RAW 3

CONSTANT: AF_UNSPEC 0
CONSTANT: AF_UNIX 9
CONSTANT: AF_INET 1
CONSTANT: AF_INET6 5

ALIAS: PF_UNSPEC AF_UNSPEC
ALIAS: PF_UNIX AF_UNIX
ALIAS: PF_INET AF_INET
ALIAS: PF_INET6 AF_INET6

CONSTANT: IPPROTO_TCP 6
CONSTANT: IPPROTO_UDP 17

CONSTANT: AI_NUMERICSERV                0x00000008


CONSTANT: SEEK_SET 0
CONSTANT: SEEK_CUR 1
CONSTANT: SEEK_END 2

STRUCT: passwd
    { pw_name c-string }
    { pw_passwd c-string }
    { pw_uid uid_t }
    { pw_gid gid_t }
    { pw_dir c-string }
    { pw_shell c-string }
    { pw_gecos c-string } ;

! dirent64
STRUCT: dirent
    { d_dev dev_t }
    { d_pdev dev_t }
    { d_ino ino_t }
    { d_pino ino_t }
    { d_reclen ushort }
    { d_name char[256] } ;

STRUCT: utmpx
    { ut_type short }
    { ut_tv timeval }
    { ut_id char[8] }
    { ut_pid pid_t }
    { ut_user char[32] }
    { ut_line char[16] }
    { ut_host char[128] }
    { __ut_reserved char[64] } ;
