USING: accessors alien.c-types alien.data alien.strings arrays
calendar.unix classes.struct combinators grouping
io.encodings.utf8 io.files io.files.info io.files.info.unix
io.files.unix libc kernel math sequences specialized-arrays
system unix unix.statvfs.haiku ;
IN: io.files.info.unix.haiku

M: haiku file-systems
    { } ;

M: haiku file-system-statvfs
    \ statvfs new [ statvfs-func io-error ] keep ;

M: haiku statvfs>file-system-info
    {
        [ f_bsize>> >>block-size ]
        [ f_frsize>> >>preferred-block-size ]
        [ f_blocks>> >>blocks ]
        [ f_bfree>> >>blocks-free ]
        [ f_bavail>> >>blocks-available ]
        [ f_files>> >>files ]
        [ f_ffree>> >>files-free ]
        [ f_favail>> >>files-available ]
        [ f_namemax>> >>name-max ]
        [ f_flag>> >>flags ]
        [ f_fsid>>> >>id ]
    } cleave ;
