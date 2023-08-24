USING: kernel alien.c-types alien.syntax math classes.struct unix.time
unix.types ;
IN: unix.stat

STRUCT: stat
    { st_dev dev_t }
    { st_ino ino_t }
    { st_mode mode_t }
    { st_nlink nlink_t }
    { st_uid uid_t }
    { st_gid gid_t }
    { st_size off_t }
    { st_rdev dev_t }
    { st_blksize blksize_t }
    { st_atim timespec }
    { st_mtim timespec }
    { st_ctim timespec }
    { st_crtim timespec }
	{ st_type __uint32_t }
    { st_blocks blkcnt_t } ;

FUNCTION-ALIAS: stat-func int stat  ( c-string pathname, stat* buf )
FUNCTION: int lstat ( c-string pathname, stat* buf )
FUNCTION: int fstat ( int fd, stat* buf )
