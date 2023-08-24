USING: alien.libraries.finder arrays assocs
combinators.short-circuit io io.encodings.utf8 io.files
io.files.info io.launcher kernel sequences sets splitting system
unicode ;
IN: alien.libraries.finder.haiku

M: haiku find-library*
    "/system/lib/lib" prepend  ".so" append ;
