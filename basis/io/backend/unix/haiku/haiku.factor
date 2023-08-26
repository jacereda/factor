USING: io.backend io.backend.unix system namespaces kernel accessors assocs continuations unix init io.backend.unix.multiplexers io.backend.unix.multiplexers.kqueue vocabs io.files.unix ;
! << "io.files.unix" require >> ! needed for deploy
IN: io.backend.unix.haiku

M: haiku init-io
   <kqueue-mx> mx set-global ;

haiku set-io-backend

STARTUP-HOOK: start-signal-pipe-thread
