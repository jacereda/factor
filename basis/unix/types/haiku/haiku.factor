USING: alien.syntax alien.c-types ;
IN: unix.types

TYPEDEF: ushort   __uint16_t
TYPEDEF: uint     __uint32_t
TYPEDEF: int      __int32_t
TYPEDEF: longlong __int64_t

TYPEDEF: __int32_t dev_t
TYPEDEF: __int64_t ino_t
TYPEDEF: __uint32_t mode_t
TYPEDEF: __int32_t nlink_t
TYPEDEF: __uint32_t uid_t
TYPEDEF: __uint32_t gid_t
TYPEDEF: __int64_t  off_t
TYPEDEF: __int64_t  blkcnt_t
TYPEDEF: __int32_t  blksize_t
TYPEDEF: __uint32_t fflags_t
TYPEDEF: long       ssize_t
TYPEDEF: __int32_t pid_t
TYPEDEF: __int64_t fsblkcnt_t
TYPEDEF: __int64_t fsfilcnt_t

TYPEDEF: void* posix_spawn_file_actions_t
TYPEDEF: void* posix_spawnattr_t
TYPEDEF: __uint64_t sigset_t
