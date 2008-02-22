
USING: kernel namespaces sequences splitting system combinators continuations
       parser io io.files io.launcher io.sockets prettyprint threads
       bootstrap.image benchmark vars bake smtp builder.util accessors
       builder.common
       builder.benchmark
       builder.release ;

IN: builder

! !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

: prepare-build-machine ( -- )
  builds make-directory
  builds cd
  { "git" "clone" "git://factorcode.org/git/factor.git" } run-process drop ;

! !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

: builds-check ( -- ) builds exists? not [ prepare-build-machine ] when ;

! !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

: git-clone ( -- desc ) { "git" "clone" "../factor" } ;

! !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

: enter-build-dir ( -- )
  datestamp >stamp
  builds cd
  stamp> make-directory
  stamp> cd ;

! !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

: git-id ( -- id )
  { "git" "show" } <process-stream> [ readln ] with-stream " " split second ;

: record-git-id ( -- ) git-id "../git-id" [ . ] with-file-writer ;

: make-clean ( -- desc ) { "make" "clean" } ;

! !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

: target ( -- target ) { os [ cpu "." split ] } to-strings "-" join ;

: make-vm ( -- desc )
  <process*>
    { "make" target } to-strings >>arguments
    "../compile-log"             >>stdout
    +stdout+                     >>stderr
  >desc ;

! !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

: copy-image ( -- )
  "../../factor/" my-boot-image-name append
  "../"           my-boot-image-name append
  copy-file

  "../../factor/" my-boot-image-name append
                  my-boot-image-name
  copy-file ;

! !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

: factor-binary ( -- name )
  os
  { { "macosx" [ "./Factor.app/Contents/MacOS/factor" ] }
    { "winnt"  [ "./factor-nt.exe" ] }
    [ drop       "./factor" ] }
  case ;

: bootstrap-cmd ( -- cmd )
  { factor-binary { "-i=" my-boot-image-name } "-no-user-init" } to-strings ;

: bootstrap ( -- desc )
  <process*>
    bootstrap-cmd >>arguments
    +closed+      >>stdin
    "../boot-log" >>stdout
    +stdout+      >>stderr
    20 minutes>ms >>timeout
  >desc ;

: builder-test-cmd ( -- cmd )
  { factor-binary "-run=builder.test" } to-strings ;

: builder-test ( -- desc )
  <process*>
    builder-test-cmd >>arguments
    +closed+         >>stdin
    "../test-log"    >>stdout
    +stdout+         >>stderr
    45 minutes>ms    >>timeout
  >desc ;

! !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

SYMBOL: build-status

: (build) ( -- )

  builds-check  

  build-status off

  enter-build-dir

  "report" [

    "Build machine:   " write host-name print
    "CPU:             " write cpu       print
    "OS:              " write os        print
    "Build directory: " write cwd       print nl

    git-clone [ "git clone failed" print ] run-or-bail

    "factor" cd

    record-git-id

    make-clean run-process drop

    make-vm [ "vm compile error" print "../compile-log" cat ] run-or-bail

    copy-image

    bootstrap [ "Bootstrap error" print "../boot-log" cat ] run-or-bail

    builder-test [ "Test error" print "../test-log" 100 cat-n ] run-or-bail

    "../test-log" delete-file

    "Boot time: " write "../boot-time" eval-file milli-seconds>time print
    "Load time: " write "../load-time" eval-file milli-seconds>time print
    "Test time: " write "../test-time" eval-file milli-seconds>time print nl

    "Did not pass load-everything: " print "../load-everything-vocabs" cat
    "Did not pass test-all: "        print "../test-all-vocabs"        cat

    "Benchmarks: " print
    "../benchmarks" [ stdio get contents eval ] with-file-reader benchmarks.

    nl
    
    show-benchmark-deltas

    "../benchmarks" "../../benchmarks" copy-file    

  ] with-file-writer

  build-status on ;

! !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

SYMBOL: builder-from

SYMBOL: builder-recipients

: tag-subject ( str -- str ) { "builder@" host-name* ": " , } bake to-string ;

: subject ( -- str ) build-status get [ "report" ] [ "error" ] if tag-subject ;

: send-builder-email ( -- )
  <email>
    builder-from get        >>from
    builder-recipients get  >>to
    subject                 >>subject
    "../report" file>string >>body
  send ;

! !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

: compress-image ( -- )
  { "bzip2" my-boot-image-name } to-strings run-process drop ;

: build ( -- )
  [ (build) ] [ drop ] recover
  [ send-builder-email ] [ drop "not sending mail" . ] recover
  ".." cd { "rm" "-rf" "factor" } run-process drop
  [ compress-image ] [ drop ] recover ;

! !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

USE: bootstrap.image.download

: git-pull ( -- desc )
  {
    "git"
    "pull"
    "--no-summary"
    "git://factorcode.org/git/factor.git"
    "master"
  } ;

: updates-available? ( -- ? )
  git-id
  git-pull run-process drop
  git-id
  = not ;

: new-image-available? ( -- ? )
  my-boot-image-name need-new-image?
    [ download-my-image t ]
    [ f ]
  if ;

: build-loop ( -- )
  builds-check
  [
    builds "/factor" append cd
    updates-available? new-image-available? or
      [ build ]
    when
  ]
  [ drop ]
  recover
  5 minutes>ms sleep
  build-loop ;

! !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

MAIN: build-loop