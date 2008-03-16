USING: help.markup help.syntax kernel kernel.private
continuations.private parser vectors arrays namespaces
assocs words quotations ;
IN: continuations

ARTICLE: "errors-restartable" "Restartable errors"
"Support for restartable errors is built on top of the basic error handling facility. The following words signals recoverable errors:"
{ $subsection throw-restarts }
{ $subsection rethrow-restarts }
"The list of restarts from the most recently-thrown error is stored in a global variable:"
{ $subsection restarts }
"To invoke restarts, see " { $link "debugger" } "." ;

ARTICLE: "errors-post-mortem" "Post-mortem error inspection"
"The most recently thrown error, together with the continuation at that point, are stored in a pair of global variables:"
{ $subsection error }
{ $subsection error-continuation }
"Developer tools for inspecting these values are found in " { $link "debugger" } "." ;

ARTICLE: "errors" "Error handling"
"Support for handling exceptional situations such as bad user input, implementation bugs, and input/output errors is provided by a set of words built using continuations."
$nl
"Two words raise an error in the innermost error handler for the current dynamic extent:"
{ $subsection throw }
{ $subsection rethrow }
"Words for establishing an error handler:"
{ $subsection cleanup }
{ $subsection recover }
{ $subsection ignore-errors }
"Unhandled errors are reported in the listener and can be debugged using various tools. See " { $link "debugger" } "."
{ $subsection "errors-restartable" }
{ $subsection "errors-post-mortem" }
"When Factor encouters a critical error, it calls the following word:"
{ $subsection die } ;

ARTICLE: "continuations.private" "Continuation implementation details"
"A continuation is simply a tuple holding the contents of the five stacks:"
{ $subsection continuation }
{ $subsection >continuation< }
"The five stacks can be read and written:"
{ $subsection datastack }
{ $subsection set-datastack }
{ $subsection retainstack }
{ $subsection set-retainstack }
{ $subsection callstack }
{ $subsection set-callstack }
{ $subsection namestack }
{ $subsection set-namestack }
{ $subsection catchstack }
{ $subsection set-catchstack } ;

ARTICLE: "continuations" "Continuations"
"At any point in the execution of a program, the " { $emphasis "current continuation" } " represents the future of the computation."
$nl
"Words for working with continuations are found in the " { $vocab-link "continuations" } " vocabulary; implementation details are in " { $vocab-link "continuations.private" } "."
$nl
"Continuations can be reified with the following two words:"
{ $subsection callcc0 }
{ $subsection callcc1 }
"Another two words resume continuations:"
{ $subsection continue }
{ $subsection continue-with }
"Continuations serve as the building block for a number of higher-level abstractions."
{ $subsection "errors" }
{ $subsection "continuations.private" } ;

ABOUT: "continuations"

HELP: dispose
{ $values { "object" "a disposable object" } }
{ $contract "Releases operating system resources associated with a disposable object. No further operations can be performed on a disposable object after this call. Disposable objects include streams, memory mapped files, and so on." }
{ $notes "You must close disposable objects after you are finished working with them, to avoid leaking operating system resources. A convenient way to automate this is by using the " { $link with-disposal } " word." } ;

HELP: with-disposal
{ $values { "object" "a disposable object" } { "quot" "a quotation with stack effect " { $snippet "( object -- )" } } }
{ $description "Calls the quotation, disposing the object with " { $link dispose } " after the quotation returns or if it throws an error." } ;

HELP: catchstack*
{ $values { "catchstack" "a vector of continuations" } }
{ $description "Outputs the current catchstack." } ;

HELP: catchstack
{ $values { "catchstack" "a vector of continuations" } }
{ $description "Outputs a copy of the current catchstack." } ;

HELP: set-catchstack
{ $values { "catchstack" "a vector of continuations" } }
{ $description "Replaces the catchstack with a copy of the given vector." } ;

HELP: continuation
{ $values { "continuation" continuation } }
{ $description "Reifies the current continuation from the point immediately after which the caller returns." } ;

HELP: >continuation<
{ $values { "continuation" continuation } { "data" vector } { "retain" vector } { "call" vector } { "name" vector } { "catch" vector } }
{ $description "Takes a continuation apart into its constituents." } ;

HELP: ifcc
{ $values { "capture" "a quotation with stack effect " { $snippet "( continuation -- )" } } { "restore" quotation } }
{ $description "Reifies a continuation from the point immediately after which this word returns, and passes it to " { $snippet "capture" } ". When the continuation is restored, execution resumes and "{ $snippet "restore" } " is called." } ;

{ callcc0 continue callcc1 continue-with ifcc } related-words

HELP: callcc0
{ $values { "quot" "a quotation with stack effect " { $snippet "( continuation -- )" } } }
{ $description "Applies the quotation to the current continuation, which is reified from the point immediately after which the caller returns. The " { $link continue } " word resumes the continuation." } ;

HELP: callcc1
{ $values { "quot" "a quotation with stack effect " { $snippet "( continuation -- )" } } { "obj" "an object provided when resuming the continuation" } }
{ $description "Applies the quotation to the current continuation, which is reified from the point immediately after which the caller returns. The " { $link continue-with } " word resumes the continuation, passing a value back to the original execution context." } ;

HELP: continue
{ $values { "continuation" continuation } }
{ $description "Resumes a continuation reified by " { $link callcc0 } "." } ;

HELP: continue-with
{ $values { "obj" "an object to pass to the continuation's execution context" } { "continuation" continuation } }
{ $description "Resumes a continuation reified by " { $link callcc1 } ". The object will be placed on the data stack when the continuation resumes." } ;

HELP: error
{ $description "Global variable holding most recently thrown error." }
{ $notes "Only updated by " { $link throw } ", not " { $link rethrow } "." } ;

HELP: error-continuation
{ $description "Global variable holding current continuation of most recently thrown error." }
{ $notes "Only updated by " { $link throw } ", not " { $link rethrow } "." } ;

HELP: restarts
{ $var-description "Global variable holding the set of possible restarts for the most recently thrown error." }
{ $notes "Only updated by " { $link throw } ", not " { $link rethrow } "." } ;

HELP: >c
{ $values { "continuation" continuation } }
{ $description "Pushes an exception handler continuation on the catch stack. The continuation must have been reified by " { $link callcc1 } "." } ;

HELP: c>
{ $values { "continuation" continuation } }
{ $description "Pops an exception handler continuation from the catch stack." } ;

HELP: throw
{ $values { "error" object } }
{ $description "Saves the current continuation in the " { $link error-continuation } " global variable and throws an error. Execution does not continue at the point after the " { $link throw } " call. Rather, the innermost catch block is invoked, and execution continues at that point." } ;

{ cleanup recover } related-words

HELP: cleanup
{ $values { "try" quotation } { "cleanup-always" quotation } { "cleanup-error" quotation } }
{ $description "Calls the " { $snippet "try" } " quotation. If no error is thrown, calls " { $snippet "cleanup-always" } " without restoring the data stack. If an error is thrown, restores the data stack, calls " { $snippet "cleanup-always" } " followed by " { $snippet "cleanup-error" } ", and rethrows the error." } ;

HELP: recover
{ $values { "try" quotation } { "recovery" "a quotation with stack effect " { $snippet "( error -- )" } } }
{ $description "Calls the " { $snippet "try" } " quotation. If an exception is thrown in the dynamic extent of the " { $snippet "try" } " quotation, restores the data stack and calls the " { $snippet "recovery" } " quotation to handle the error." } ;

HELP: ignore-errors
{ $values { "quot" quotation } }
{ $description "Calls the quotation. If an exception is thrown in the dynamic extent of the quotation, restores the data stack and returns." } ;

HELP: rethrow
{ $values { "error" object } }
{ $description "Throws an error without saving the current continuation in the " { $link error-continuation } " global variable. This is done so that inspecting the error stacks sheds light on the original cause of the exception, rather than the point where it was rethrown." }
{ $notes
    "This word is intended to be used in conjunction with " { $link recover } " to implement error handlers which perform an action and pass the error to the next outermost error handler."
}
{ $examples
    "The " { $link with-parser } " catches errors, annotates them with file name and line number information, and rethrows them:"
    { $see with-parser }
} ;

HELP: throw-restarts
{ $values { "error" object } { "restarts" "a sequence of " { $snippet "{ string object }" } " pairs" } { "restart" object } }
{ $description "Throws a restartable error using " { $link throw } ". The " { $snippet "restarts" } " parameter is a sequence of pairs where the first element in each pair is a human-readable description and the second is an arbitrary object. If the error reaches the top-level error handler, the user will be presented with the list of possible restarts, and upon invoking one, execution will continue after the call to " { $link throw-restarts } " with the object associated to the chosen restart on the stack." }
{ $examples
    "Try invoking one of the two restarts which are offered after the below code throws an error:"
    { $code
        ": restart-test"
        "    \"Oops!\" { { \"One\" 1 } { \"Two\" 2 } } condition"
        "    \"You restarted: \" write . ;"
        "restart-test"
    }
} ;

HELP: rethrow-restarts
{ $values { "error" object } { "restarts" "a sequence of " { $snippet "{ string object }" } " pairs" } { "restart" object } }
{ $description "Throws a restartable error using " { $link rethrow } ". Otherwise, this word is identical to " { $link throw-restarts } "." } ;

{ throw rethrow throw-restarts rethrow-restarts } related-words

HELP: compute-restarts
{ $values { "error" object } { "seq" "a sequence" } }
{ $description "Outputs a sequence of triples, where each triple consists of a human-readable string, an object, and a continuation. Resuming a continuation with the corresponding object restarts execution immediately after the corresponding call to " { $link condition } "."
$nl
"This word recursively travels up the delegation chain to collate restarts from nested and wrapped conditions." } ;

HELP: save-error
{ $values { "error" "an error" } }
{ $description "Called by the error handler to set the " { $link error } " and " { $link restarts } " global variables after an error was thrown." }
$low-level-note ;
